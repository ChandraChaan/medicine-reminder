package dev.chandra.medicine_reminder.alarm

import android.Manifest
import android.app.Notification
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.telephony.SmsManager
import android.util.Log
import dev.chandra.medicine_reminder.R

/**
 * Tells family that doses were not marked Taken. Dart only plans these
 * checks after the setup person turned the family check on, added numbers
 * and (for SMS) agreed. Without the SMS permission, or with WhatsApp chosen,
 * nothing is sent automatically: a notification opens a ready message and a
 * person presses Send.
 */
object FamilyAlert {
    private const val TAG = "FamilyAlert"
    private const val NOTICE_ID = 8100

    fun send(context: Context, entry: AlarmEntry) {
        val extra = entry.extra ?: return
        val phones = extra.optJSONArray("phones") ?: return
        val numbers = (0 until phones.length()).map { phones.getString(it) }
        val message = extra.optString("message")
        if (numbers.isEmpty() || message.isEmpty()) return

        val viaSms = extra.optString("channel") == "sms"
        if (viaSms && canSendSms(context) && sendSms(context, numbers, message)) {
            notice(
                context,
                extra.optString("sentTitle"),
                extra.optString("sentBody"),
                null,
            )
            return
        }
        val open = if (viaSms) smsIntent(numbers, message) else whatsAppIntent(numbers.first(), message)
        notice(
            context,
            extra.optString("shareTitle"),
            extra.optString("shareBody"),
            PendingIntent.getActivity(
                context,
                NOTICE_ID,
                open.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK),
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
            ),
        )
    }

    fun canSendSms(context: Context) =
        context.checkSelfPermission(Manifest.permission.SEND_SMS) ==
            PackageManager.PERMISSION_GRANTED

    /** Sends [message] to every number; true if all were handed to the modem. */
    fun sendSms(context: Context, numbers: List<String>, message: String): Boolean {
        if (!canSendSms(context)) return false
        val manager = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            context.getSystemService(SmsManager::class.java)
        } else {
            @Suppress("DEPRECATION")
            SmsManager.getDefault()
        } ?: return false
        var ok = true
        for (number in numbers) {
            try {
                // Telugu and Hindi texts need several parts.
                val parts = manager.divideMessage(message)
                manager.sendMultipartTextMessage(number, null, parts, null, null)
            } catch (e: Exception) {
                Log.e(TAG, "SMS to a family number failed", e)
                ok = false
            }
        }
        return ok
    }

    fun whatsAppIntent(number: String, message: String): Intent = Intent(
        Intent.ACTION_VIEW,
        Uri.parse("https://wa.me/${number.trimStart('+')}?text=${Uri.encode(message)}"),
    )

    private fun smsIntent(numbers: List<String>, message: String): Intent =
        Intent(Intent.ACTION_SENDTO, Uri.parse("smsto:${numbers.joinToString(";")}"))
            .putExtra("sms_body", message)

    private fun notice(context: Context, title: String, body: String, open: PendingIntent?) {
        val (alarmName, noticeName) = AlarmScheduler.channelNames(context)
        AlarmNotifications.ensureChannels(context, alarmName, noticeName)
        val notification = Notification.Builder(context, AlarmNotifications.NOTICE_CHANNEL)
            .setSmallIcon(R.drawable.ic_stat_pill)
            .setContentTitle(title)
            .setContentText(body)
            .setStyle(Notification.BigTextStyle().bigText(body))
            .setContentIntent(open ?: AlarmNotifications.openAppIntent(context, fromAlarm = false))
            .setAutoCancel(true)
            .build()
        context.getSystemService(NotificationManager::class.java).notify(NOTICE_ID, notification)
    }
}
