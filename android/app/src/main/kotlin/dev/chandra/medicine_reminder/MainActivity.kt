package dev.chandra.medicine_reminder

import android.app.NotificationManager
import android.content.ActivityNotFoundException
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import android.view.WindowManager
import dev.chandra.medicine_reminder.alarm.AlarmEntry
import dev.chandra.medicine_reminder.alarm.AlarmNotifications
import dev.chandra.medicine_reminder.alarm.AlarmScheduler
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private var channel: MethodChannel? = null
    private var launchedFromAlarm = false

    override fun onCreate(savedInstanceState: Bundle?) {
        if (isAlarmIntent(intent)) {
            launchedFromAlarm = true
            showOverLockScreen(true)
        }
        super.onCreate(savedInstanceState)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        if (isAlarmIntent(intent)) {
            showOverLockScreen(true)
            channel?.invokeMethod("alarmFired", null)
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        channel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "dev.chandra.medicine_reminder/alarms",
        ).apply {
            setMethodCallHandler { call, result ->
                when (call.method) {
                    "scheduleAll" -> {
                        val entries = call.argument<List<Map<*, *>>>("entries")
                            .orEmpty()
                            .map(AlarmEntry::fromMap)
                        AlarmScheduler.replaceAll(
                            this@MainActivity,
                            entries,
                            call.argument<String>("alarmChannel") ?: "",
                            call.argument<String>("noticeChannel") ?: "",
                        )
                        result.success(null)
                    }
                    "permissions" -> result.success(permissions())
                    "openExactAlarmSettings" -> {
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                            openSettings(Settings.ACTION_REQUEST_SCHEDULE_EXACT_ALARM)
                        }
                        result.success(null)
                    }
                    "openFullScreenSettings" -> {
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
                            openSettings(Settings.ACTION_MANAGE_APP_USE_FULL_SCREEN_INTENT)
                        }
                        result.success(null)
                    }
                    "openNotificationSettings" -> {
                        val intent = Intent(Settings.ACTION_APP_NOTIFICATION_SETTINGS)
                            .putExtra(Settings.EXTRA_APP_PACKAGE, packageName)
                        startSafely(intent)
                        result.success(null)
                    }
                    "takeLaunchAlarm" -> {
                        result.success(launchedFromAlarm)
                        launchedFromAlarm = false
                    }
                    "stopRinging" -> {
                        AlarmNotifications.stopRinging(this@MainActivity)
                        result.success(null)
                    }
                    "alarmDone" -> {
                        showOverLockScreen(false)
                        result.success(null)
                    }
                    "showNotice" -> {
                        AlarmNotifications.showNotice(
                            this@MainActivity,
                            call.argument<Int>("id") ?: 0,
                            call.argument<String>("title") ?: "",
                            call.argument<String>("body") ?: "",
                        )
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
        }
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        channel?.setMethodCallHandler(null)
        channel = null
        super.cleanUpFlutterEngine(flutterEngine)
    }

    private fun isAlarmIntent(intent: Intent?) =
        intent?.getBooleanExtra(AlarmNotifications.EXTRA_FROM_ALARM, false) == true

    private fun permissions(): Map<String, Boolean> {
        val notifications = getSystemService(NotificationManager::class.java)
        val fullScreen = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            notifications.canUseFullScreenIntent()
        } else {
            true
        }
        return mapOf(
            "exactAlarms" to AlarmScheduler.canScheduleExact(this),
            "fullScreen" to fullScreen,
            "notifications" to notifications.areNotificationsEnabled(),
        )
    }

    /** Lets the alarm screen show over the lock screen and turn the screen on. */
    private fun showOverLockScreen(show: Boolean) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
            setShowWhenLocked(show)
            setTurnScreenOn(show)
        } else {
            @Suppress("DEPRECATION")
            val flags = WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
                WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON
            if (show) window.addFlags(flags) else window.clearFlags(flags)
        }
        if (show) {
            window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
        } else {
            window.clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
        }
    }

    private fun openSettings(action: String) {
        startSafely(Intent(action, Uri.parse("package:$packageName")))
    }

    private fun startSafely(intent: Intent) {
        try {
            startActivity(intent)
        } catch (e: ActivityNotFoundException) {
            startActivity(
                Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS, Uri.parse("package:$packageName")),
            )
        }
    }
}
