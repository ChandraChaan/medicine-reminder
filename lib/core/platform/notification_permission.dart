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
