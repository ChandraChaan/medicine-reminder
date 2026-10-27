package dev.chandra.medicine_reminder.alarm

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import android.util.Log
import dev.chandra.medicine_reminder.MainActivity
import java.time.ZoneId

/**
 * Keeps the planned alarms in private storage and registers them with
 * [AlarmManager]. The stored list is what [RescheduleReceiver] uses after a
 * reboot, an app update or a clock change, without starting Flutter.
 */
object AlarmScheduler {
    private const val TAG = "AlarmScheduler"
    private const val PREFS = "alarms"
    private const val KEY_ENTRIES = "entries"
    private const val KEY_ALARM_CHANNEL = "alarm_channel"
    private const val KEY_NOTICE_CHANNEL = "notice_channel"
    const val EXTRA_ENTRY = "entry"

    fun replaceAll(
        context: Context,
        entries: List<AlarmEntry>,
        alarmChannel: String,
        noticeChannel: String,
    ) {
        val prefs = context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
        val previous = AlarmEntry.listFromJson(prefs.getString(KEY_ENTRIES, null))
        val keep = entries.map { it.id }.toSet()
        previous.filter { it.id !in keep }.forEach { cancel(context, it.id) }
        prefs.edit()
            .putString(KEY_ENTRIES, AlarmEntry.listToJson(entries))
            .putString(KEY_ALARM_CHANNEL, alarmChannel)
            .putString(KEY_NOTICE_CHANNEL, noticeChannel)
            .apply()
        AlarmNotifications.ensureChannels(context, alarmChannel, noticeChannel)
        scheduleStored(context)
    }

    /** Registers every stored alarm that is still in the future. */
    fun scheduleStored(context: Context) {
        val prefs = context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
        val entries = AlarmEntry.listFromJson(prefs.getString(KEY_ENTRIES, null))
        val zone = ZoneId.systemDefault()
        val now = System.currentTimeMillis()
        for (entry in entries) {
            val at = entry.triggerAtMillis(zone)
            if (at <= now) {
                cancel(context, entry.id)
            } else {
                schedule(context, entry, at)
            }
        }
    }

    fun channelNames(context: Context): Pair<String?, String?> {
        val prefs = context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
        return prefs.getString(KEY_ALARM_CHANNEL, null) to
            prefs.getString(KEY_NOTICE_CHANNEL, null)
    }

    fun canScheduleExact(context: Context): Boolean {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.S) return true
        return context.getSystemService(AlarmManager::class.java).canScheduleExactAlarms()
    }

    private fun schedule(context: Context, entry: AlarmEntry, at: Long) {
        val manager = context.getSystemService(AlarmManager::class.java)
        val operation = PendingIntent.getBroadcast(
            context,
            entry.id,
            Intent(context, AlarmReceiver::class.java)
                .putExtra(EXTRA_ENTRY, entry.toJson().toString()),
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
        try {
            if (canScheduleExact(context)) {
                // An alarm clock alarm is exact, wakes the phone from Doze and
                // shows the next alarm time on the lock screen.
                val show = PendingIntent.getActivity(
                    context,
                    0,
                    Intent(context, MainActivity::class.java),
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
                )
                manager.setAlarmClock(AlarmManager.AlarmClockInfo(at, show), operation)
            } else {
                // Without exact-alarm access Android may delay this a little;
                // the app asks for access on its home screen.
                manager.setAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, at, operation)
            }
        } catch (e: SecurityException) {
            Log.w(TAG, "Exact alarm refused, falling back to inexact", e)
            manager.setAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, at, operation)
        }
    }

    private fun cancel(context: Context, id: Int) {
        val pending = PendingIntent.getBroadcast(
            context,
            id,
            Intent(context, AlarmReceiver::class.java),
            PendingIntent.FLAG_NO_CREATE or PendingIntent.FLAG_IMMUTABLE,
        ) ?: return
        context.getSystemService(AlarmManager::class.java).cancel(pending)
        pending.cancel()
    }
}
