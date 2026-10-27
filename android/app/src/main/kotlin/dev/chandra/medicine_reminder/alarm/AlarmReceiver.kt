package dev.chandra.medicine_reminder.alarm

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import org.json.JSONException
import org.json.JSONObject

/** Called by [android.app.AlarmManager] when a planned alarm is due. */
class AlarmReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val text = intent.getStringExtra(AlarmScheduler.EXTRA_ENTRY) ?: return
        val entry = try {
            AlarmEntry.fromJson(JSONObject(text))
        } catch (e: JSONException) {
            Log.e("AlarmReceiver", "Unreadable alarm", e)
            return
        }
        // Sending an SMS can take a moment; keep the receiver alive for it.
        if (entry.kind == AlarmEntry.KIND_CHECK) {
            val pending = goAsync()
            Thread {
                try {
                    FamilyAlert.send(context, entry)
                } finally {
                    pending.finish()
                }
            }.start()
            return
        }
        when (entry.kind) {
            AlarmEntry.KIND_RING -> AlarmNotifications.showRinging(context, entry)
        }
    }
}
