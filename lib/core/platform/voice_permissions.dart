import 'package:permission_handler/permission_handler.dart';

enum VoicePermission { microphone, phone }

/// Runtime permissions the app asks for.
abstract interface class VoicePermissions {
  Future<bool> isGranted(VoicePermission permission);

  /// Asks Android; when it won't ask again, opens the app's settings page.
  Future<bool> request(VoicePermission permission);
}

class PermissionHandlerVoicePermissions implements VoicePermissions {
  const PermissionHandlerVoicePermissions();

  Permission _of(VoicePermission permission) => switch (permission) {
    VoicePermission.microphone => Permission.microphone,
    VoicePermission.phone => Permission.phone,
  };

  @override
  Future<bool> isGranted(VoicePermission permission) =>
      _of(permission).isGranted;

  @override
  Future<bool> request(VoicePermission permission) async {
    final status = await _of(permission).request();
    if (status.isPermanentlyDenied) await openAppSettings();
    return status.isGranted;
  }
}
