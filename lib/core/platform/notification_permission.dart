import 'package:permission_handler/permission_handler.dart';

/// Asks for the Android 13+ notification permission.
abstract interface class NotificationPermission {
  /// True when reminders may be shown. False when the person said no; the
  /// caller then offers the system settings page.
  Future<bool> request();
}

class PermissionHandlerNotificationPermission
    implements NotificationPermission {
  const PermissionHandlerNotificationPermission();

  @override
  Future<bool> request() async =>
      (await Permission.notification.request()).isGranted;
}

/// Asks for SEND_SMS, used only by the optional family check.
abstract interface class SmsPermission {
  Future<bool> isGranted();

  Future<bool> request();
}

class PermissionHandlerSmsPermission implements SmsPermission {
  const PermissionHandlerSmsPermission();

  @override
  Future<bool> isGranted() => Permission.sms.isGranted;

  @override
  Future<bool> request() async => (await Permission.sms.request()).isGranted;
}
