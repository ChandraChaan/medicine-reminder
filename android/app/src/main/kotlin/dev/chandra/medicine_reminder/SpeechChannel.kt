package dev.chandra.medicine_reminder

import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.speech.ModelDownloadListener
import android.speech.RecognitionListener
import android.speech.RecognitionSupport
import android.speech.RecognitionSupportCallback
import android.speech.RecognizerIntent
import android.speech.SpeechRecognizer
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.Executors

/**
 * Android's own speech recognition, kept on the phone whenever it can be.
 *
 * - On Android 12+ with an on-device recogniser, listening uses
 *   [SpeechRecognizer.createOnDeviceSpeechRecognizer]: audio never leaves the
 *   phone.
 * - Otherwise the normal recogniser (usually the Google app's) is used only
 *   when the family allowed online recognition; it may send audio to the
 *   recogniser's servers.
 *
 * Methods: `status`, `download`, `listen`, `cancel`. While listening, partial
 * text is sent back with `onPartial`.
 */
class SpeechChannel(private val context: Context, private val channel: MethodChannel) :
    MethodChannel.MethodCallHandler {

    private val main = Handler(Looper.getMainLooper())
    private var recognizer: SpeechRecognizer? = null
    private var pending: MethodChannel.Result? = null

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "status" -> status(call.argument<String>("locale")!!, result)
            "download" -> download(call.argument<String>("locale")!!, result)
            "listen" -> listen(
                call.argument<String>("locale")!!,
                call.argument<Boolean>("allowOnline") ?: false,
                result,
            )
            "cancel" -> {
                finish(mapOf("cancelled" to true))
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    private fun onDeviceAvailable(): Boolean =
        Build.VERSION.SDK_INT >= Build.VERSION_CODES.S &&
            SpeechRecognizer.isOnDeviceRecognitionAvailable(context)

    /**
     * `onDevice`: an on-device recogniser exists. `anyRecognizer`: some
     * recogniser exists. `offline`: for [locale], one of installed,
     * downloading, downloadable, unsupported or unknown (unknown below
     * Android 13, which can't be asked).
     */
    private fun status(locale: String, result: MethodChannel.Result) {
        val base = mapOf(
            "onDevice" to onDeviceAvailable(),
            "anyRecognizer" to SpeechRecognizer.isRecognitionAvailable(context),
        )
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU || !onDeviceAvailable()) {
            result.success(base + ("offline" to if (onDeviceAvailable()) "unknown" else "unsupported"))
            return
        }
        val checker = SpeechRecognizer.createOnDeviceSpeechRecognizer(context)
        var answered = false
        fun answer(offline: String) {
            main.post {
                if (answered) return@post
                answered = true
                checker.destroy()
                result.success(base + ("offline" to offline))
            }
        }
        // Some phones never call back; don't leave the Dart side waiting.
        main.postDelayed({ answer("unknown") }, 4000)
        checker.checkRecognitionSupport(
            recognizerIntent(locale),
            Executors.newSingleThreadExecutor(),
            object : RecognitionSupportCallback {
                override fun onSupportResult(support: RecognitionSupport) {
                    answer(
                        when {
                            matches(support.installedOnDeviceLanguages, locale) -> "installed"
                            matches(support.pendingOnDeviceLanguages, locale) -> "downloading"
                            matches(support.supportedOnDeviceLanguages, locale) -> "downloadable"
                            else -> "unsupported"
                        },
                    )
                }

                override fun onError(error: Int) = answer("unknown")
            },
        )
    }

    /** Starts Google's one-time download of the offline model (Android 13+). */
    private fun download(locale: String, result: MethodChannel.Result) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU || !onDeviceAvailable()) {
            result.success(false)
            return
        }
        val downloader = SpeechRecognizer.createOnDeviceSpeechRecognizer(context)
        if (Build.VERSION.SDK_INT >= 34) {
            downloader.triggerModelDownload(
                recognizerIntent(locale),
                Executors.newSingleThreadExecutor(),
                object : ModelDownloadListener {
                    override fun onProgress(completedPercent: Int) {}
                    override fun onSuccess() { main.post { downloader.destroy() } }
                    override fun onScheduled() { main.post { downloader.destroy() } }
                    override fun onError(error: Int) { main.post { downloader.destroy() } }
                },
            )
        } else {
            downloader.triggerModelDownload(recognizerIntent(locale))
            main.postDelayed({ downloader.destroy() }, 2000)
        }
        result.success(true)
    }

    private fun listen(locale: String, allowOnline: Boolean, result: MethodChannel.Result) {
        finish(mapOf("cancelled" to true))
        val useOnDevice = onDeviceAvailable()
        if (!useOnDevice && !allowOnline) {
            result.success(mapOf("error" to "needs_online"))
            return
        }
        if (!useOnDevice && !SpeechRecognizer.isRecognitionAvailable(context)) {
            result.success(mapOf("error" to "unavailable"))
            return
        }
        val created = if (useOnDevice) {
            SpeechRecognizer.createOnDeviceSpeechRecognizer(context)
        } else {
            SpeechRecognizer.createSpeechRecognizer(context)
        }
        recognizer = created
        pending = result
        created.setRecognitionListener(Listener(useOnDevice, allowOnline, locale))
        created.startListening(recognizerIntent(locale).apply {
            putExtra(RecognizerIntent.EXTRA_PARTIAL_RESULTS, true)
            putExtra(RecognizerIntent.EXTRA_MAX_RESULTS, 5)
            if (!useOnDevice) putExtra(RecognizerIntent.EXTRA_PREFER_OFFLINE, true)
        })
    }

    private inner class Listener(
        private val onDevice: Boolean,
        private val allowOnline: Boolean,
        private val locale: String,
    ) : RecognitionListener {
        override fun onResults(results: Bundle?) {
            val words = results
                ?.getStringArrayList(SpeechRecognizer.RESULTS_RECOGNITION)
                .orEmpty()
                .filter { it.isNotBlank() }
            finish(if (words.isEmpty()) mapOf("error" to "no_match") else mapOf("words" to words))
        }

        override fun onPartialResults(partial: Bundle?) {
            val text = partial
                ?.getStringArrayList(SpeechRecognizer.RESULTS_RECOGNITION)
                ?.firstOrNull()
            if (!text.isNullOrBlank()) channel.invokeMethod("onPartial", text)
        }

        override fun onError(error: Int) {
            // The on-device recogniser lacks this language: fall back to the
            // normal one, but only if the family allowed online recognition.
            val missingLanguage = error == SpeechRecognizer.ERROR_LANGUAGE_NOT_SUPPORTED ||
                error == SpeechRecognizer.ERROR_LANGUAGE_UNAVAILABLE
            if (onDevice && missingLanguage && allowOnline &&
                SpeechRecognizer.isRecognitionAvailable(context)
            ) {
                val result = pending
                pending = null
                recognizer?.destroy()
                recognizer = SpeechRecognizer.createSpeechRecognizer(context).also {
                    pending = result
                    it.setRecognitionListener(Listener(false, allowOnline, locale))
                    it.startListening(recognizerIntent(locale).apply {
                        putExtra(RecognizerIntent.EXTRA_PARTIAL_RESULTS, true)
                        putExtra(RecognizerIntent.EXTRA_MAX_RESULTS, 5)
                    })
                }
                return
            }
            finish(mapOf("error" to errorName(error)))
        }

        override fun onReadyForSpeech(params: Bundle?) {}
        override fun onBeginningOfSpeech() {}
        override fun onRmsChanged(rmsdB: Float) {}
        override fun onBufferReceived(buffer: ByteArray?) {}
        override fun onEndOfSpeech() {}
        override fun onEvent(eventType: Int, params: Bundle?) {}
    }

    private fun finish(answer: Map<String, Any>) {
        recognizer?.let {
            it.cancel()
            it.destroy()
        }
        recognizer = null
        pending?.success(answer)
        pending = null
    }

    fun dispose() = finish(mapOf("cancelled" to true))

    private fun recognizerIntent(locale: String) =
        Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH).apply {
            putExtra(RecognizerIntent.EXTRA_LANGUAGE_MODEL, RecognizerIntent.LANGUAGE_MODEL_FREE_FORM)
            putExtra(RecognizerIntent.EXTRA_LANGUAGE, locale)
            putExtra(RecognizerIntent.EXTRA_CALLING_PACKAGE, context.packageName)
        }

    private fun matches(languages: List<String>, locale: String): Boolean {
        val wanted = locale.lowercase().replace('_', '-')
        val language = wanted.substringBefore('-')
        return languages.any {
            val tag = it.lowercase().replace('_', '-')
            tag == wanted || tag == language
        }
    }

    private fun errorName(error: Int): String = when (error) {
        SpeechRecognizer.ERROR_NO_MATCH, SpeechRecognizer.ERROR_SPEECH_TIMEOUT -> "no_match"
        SpeechRecognizer.ERROR_INSUFFICIENT_PERMISSIONS -> "permission"
        SpeechRecognizer.ERROR_NETWORK, SpeechRecognizer.ERROR_NETWORK_TIMEOUT,
        SpeechRecognizer.ERROR_SERVER, SpeechRecognizer.ERROR_SERVER_DISCONNECTED -> "network"
        SpeechRecognizer.ERROR_LANGUAGE_NOT_SUPPORTED,
        SpeechRecognizer.ERROR_LANGUAGE_UNAVAILABLE -> "language_missing"
        SpeechRecognizer.ERROR_RECOGNIZER_BUSY, SpeechRecognizer.ERROR_TOO_MANY_REQUESTS -> "busy"
        else -> "other"
    }
}
