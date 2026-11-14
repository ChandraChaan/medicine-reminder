package dev.chandra.medicine_reminder

import android.Manifest
import android.app.Activity
import android.content.ActivityNotFoundException
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.hardware.camera2.CameraAccessException
import android.hardware.camera2.CameraCharacteristics
import android.hardware.camera2.CameraManager
import android.net.Uri
import android.os.BatteryManager
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/**
 * Calls, battery and torch. Methods: `call`, `battery`, `torch`.
 */
class PhoneChannel(private val activity: Activity) : MethodChannel.MethodCallHandler {

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "call" -> result.success(call(call.argument<String>("number")!!))
            "battery" -> result.success(battery())
            "torch" -> result.success(torch(call.argument<Boolean>("on") ?: false))
            else -> result.notImplemented()
        }
    }

    /**
     * Calls straight away when the Phone permission was given; otherwise opens
     * the dialer with the number filled in. Returns "called", "dialer" or
     * "failed".
     */
    private fun call(number: String): String {
        val uri = Uri.fromParts("tel", number, null)
        val direct = activity.checkSelfPermission(Manifest.permission.CALL_PHONE) ==
            PackageManager.PERMISSION_GRANTED
        return try {
            if (direct) {
                activity.startActivity(Intent(Intent.ACTION_CALL, uri))
                "called"
            } else {
                activity.startActivity(Intent(Intent.ACTION_DIAL, uri))
                "dialer"
            }
        } catch (e: ActivityNotFoundException) {
            "failed"
        } catch (e: SecurityException) {
            "failed"
        }
    }

    /** `level` 0–100 (or -1 when unknown) and `charging`. */
    private fun battery(): Map<String, Any> {
        val manager = activity.getSystemService(BatteryManager::class.java)
        val level = manager?.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY) ?: -1
        val sticky = activity.registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
        val status = sticky?.getIntExtra(BatteryManager.EXTRA_STATUS, -1) ?: -1
        val charging = status == BatteryManager.BATTERY_STATUS_CHARGING ||
            status == BatteryManager.BATTERY_STATUS_FULL
        return mapOf("level" to (if (level in 0..100) level else -1), "charging" to charging)
    }

    /** Turns the camera flash on or off. No camera permission is needed. */
    private fun torch(on: Boolean): Boolean {
        val manager = activity.getSystemService(CameraManager::class.java) ?: return false
        return try {
            val id = manager.cameraIdList.firstOrNull {
                manager.getCameraCharacteristics(it)
                    .get(CameraCharacteristics.FLASH_INFO_AVAILABLE) == true
            } ?: return false
            manager.setTorchMode(id, on)
            true
        } catch (e: CameraAccessException) {
            false
        } catch (e: IllegalArgumentException) {
            false
        }
    }
}
