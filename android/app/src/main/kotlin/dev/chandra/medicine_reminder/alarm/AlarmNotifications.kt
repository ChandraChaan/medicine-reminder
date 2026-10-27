package dev.chandra.medicine_reminder.alarm

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.media.AudioAttributes
import android.media.RingtoneManager
import dev.chandra.medicine_reminder.MainActivity
import dev.chandra.medicine_reminder.R

object AlarmNotifications {
    const val ALARM_CHANNEL = "dose_alarms"
    const val NOTICE_CHANNEL = "notices"
    const val RINGING_ID = 7001
    const val EXTRA_FROM_ALARM = "from_alarm"

    /** Ringing stops by itself after this long if nobody opens the alarm. */
    private const val RING_TIMEOUT_MS = 15 * 60 * 1000L

    fun ensureChannels(context: Context, alarmName: String?, noticeName: String?) {
        val manager = context.getSystemService(NotificationManager::class.java)
        val alarms = NotificationChannel(
            ALARM_CHANNEL,
            alarmName ?: context.getString(R.string.channel_alarms),
            NotificationManager.IMPORTANCE_HIGH,
        ).apply {
            setSound(
                RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM)
                    ?: RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION),
                AudioAttributes.Builder()
                    .setUsage(AudioAttributes.USAGE_ALARM)
                    .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                    .build(),
            )
            enableVibration(true)
            vibrationPattern = longArrayOf(0, 800, 400, 800, 400, 800)
            lockscreenVisibility = Notification.VISIBILITY_PUBLIC
            setBypassDnd(true)
        }
        val notices = NotificationChannel(
            NOTICE_CHANNEL,
            noticeName ?: context.getString(R.string.channel_notices),
            NotificationManager.IMPORTANCE_DEFAULT,
        )
        manager.createNotificationChannels(listOf(alarms, notices))
    }

    fun openAppIntent(context: Context, fromAlarm: Boolean): PendingIntent =
        PendingIntent.getActivity(
            context,
            if (fromAlarm) 1 else 2,
            Intent(context, MainActivity::class.java)
                .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP)
                .putExtra(EXTRA_FROM_ALARM, fromAlarm),
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )

    /**
     * Rings until the alarm screen opens (or [RING_TIMEOUT_MS] passes). With
     * the screen off, Android opens the alarm screen straight away.
     */
    fun showRinging(context: Context, entry: AlarmEntry) {
        val (alarmName, noticeName) = AlarmScheduler.channelNames(context)
        ensureChannels(context, alarmName, noticeName)
        val open = openAppIntent(context, fromAlarm = true)
        val notification = Notification.Builder(context, ALARM_CHANNEL)
            .setSmallIcon(R.drawable.ic_stat_pill)
            .setContentTitle(entry.title)
            .setContentText(entry.body)
            .setStyle(Notification.BigTextStyle().bigText(entry.body))
            .setCategory(Notification.CATEGORY_ALARM)
            .setVisibility(Notification.VISIBILITY_PUBLIC)
            .setFullScreenIntent(open, true)
            .setContentIntent(open)
            .setAutoCancel(true)
            .setTimeoutAfter(RING_TIMEOUT_MS)
            .build()
        notification.flags = notification.flags or Notification.FLAG_INSISTENT
        context.getSystemService(NotificationManager::class.java)
            .notify(RINGING_ID, notification)
    }

    fun stopRinging(context: Context) {
        context.getSystemService(NotificationManager::class.java).cancel(RINGING_ID)
    }

    fun showNotice(context: Context, id: Int, title: String, body: String) {
        val (alarmName, noticeName) = AlarmScheduler.channelNames(context)
        ensureChannels(context, alarmName, noticeName)
        val notification = Notification.Builder(context, NOTICE_CHANNEL)
            .setSmallIcon(R.drawable.ic_stat_pill)
            .setContentTitle(title)
            .setContentText(body)
            .setStyle(Notification.BigTextStyle().bigText(body))
            .setContentIntent(openAppIntent(context, fromAlarm = false))
            .setAutoCancel(true)
            .build()
        context.getSystemService(NotificationManager::class.java).notify(id, notification)
    }
}
