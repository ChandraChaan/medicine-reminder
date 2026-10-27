package dev.chandra.medicine_reminder.alarm

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

/**
 * Android forgets alarms on reboot and keeps their old instant when the clock
 * or time zone changes. This puts the stored alarms back, recomputed in the
 * current zone.
 */
class RescheduleReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        when (intent.action) {
            Intent.ACTION_BOOT_COMPLETED,
            Intent.ACTION_MY_PACKAGE_REPLACED,
            Intent.ACTION_TIME_CHANGED,
            Intent.ACTION_TIMEZONE_CHANGED,
            "android.app.action.SCHEDULE_EXACT_ALARM_PERMISSION_STATE_CHANGED",
            -> AlarmScheduler.scheduleStored(context)
        }
    }
}
