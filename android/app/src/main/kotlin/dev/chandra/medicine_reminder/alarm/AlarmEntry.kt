package dev.chandra.medicine_reminder.alarm

import org.json.JSONArray
import org.json.JSONObject
import java.time.LocalDate
import java.time.ZoneId

/**
 * One alarm planned by the Dart side. The time is wall-clock (a date plus
 * minutes after midnight), so after a reboot or a time zone change the same
 * "8:00" is worked out again in the phone's current zone.
 */
data class AlarmEntry(
    val id: Int,
    val kind: String,
    val date: String,
    val minute: Int,
    val title: String,
    val body: String,
) {
    fun triggerAtMillis(zone: ZoneId): Long =
        LocalDate.parse(date)
            .atStartOfDay(zone)
            .plusMinutes(minute.toLong())
            .toInstant()
            .toEpochMilli()

    fun toJson(): JSONObject = JSONObject()
        .put("id", id)
        .put("kind", kind)
        .put("date", date)
        .put("minute", minute)
        .put("title", title)
        .put("body", body)

    companion object {
        const val KIND_RING = "ring"

        fun fromJson(json: JSONObject) = AlarmEntry(
            id = json.getInt("id"),
            kind = json.getString("kind"),
            date = json.getString("date"),
            minute = json.getInt("minute"),
            title = json.optString("title"),
            body = json.optString("body"),
        )

        fun fromMap(map: Map<*, *>) = AlarmEntry(
            id = (map["id"] as Number).toInt(),
            kind = map["kind"] as String,
            date = map["date"] as String,
            minute = (map["minute"] as Number).toInt(),
            title = map["title"] as? String ?: "",
            body = map["body"] as? String ?: "",
        )

        fun listToJson(entries: List<AlarmEntry>): String =
            JSONArray().apply { entries.forEach { put(it.toJson()) } }.toString()

        fun listFromJson(text: String?): List<AlarmEntry> {
            if (text.isNullOrEmpty()) return emptyList()
            val array = JSONArray(text)
            return (0 until array.length()).map { fromJson(array.getJSONObject(it)) }
        }
    }
}
