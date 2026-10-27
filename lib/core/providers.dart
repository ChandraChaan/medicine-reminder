import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/doses/domain/dose_log_repository.dart';
import '../features/medicines/domain/medicine_repository.dart';
import '../features/settings/domain/app_settings.dart';
import 'platform/alarm_bridge.dart';
import 'platform/notification_permission.dart';
import 'platform/photo_picker.dart';
import 'speech/speech_service.dart';
import 'time/clock.dart';
import 'time/local_date.dart';

// Every service is overridden in main() with the real implementation and in
// tests with a fake, so nothing here touches the platform by default.

final clockProvider = Provider<Clock>((ref) => const SystemClock());

final alarmBridgeProvider = Provider<AlarmBridge>(
  (ref) => throw UnimplementedError('Override alarmBridgeProvider'),
);

final speechServiceProvider = Provider<SpeechService>(
  (ref) => throw UnimplementedError('Override speechServiceProvider'),
);

final notificationPermissionProvider = Provider<NotificationPermission>(
  (ref) => throw UnimplementedError('Override notificationPermissionProvider'),
);

final photoPickerProvider = Provider<PhotoPicker>(
  (ref) => throw UnimplementedError('Override photoPickerProvider'),
);

final medicineRepositoryProvider = Provider<MedicineRepository>(
  (ref) => throw UnimplementedError('Override medicineRepositoryProvider'),
);

final doseLogRepositoryProvider = Provider<DoseLogRepository>(
  (ref) => throw UnimplementedError('Override doseLogRepositoryProvider'),
);

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => throw UnimplementedError('Override settingsRepositoryProvider'),
);

/// The current wall-clock minute; screens watch it so statuses like "Missed"
/// appear without a restart.
final nowProvider = StreamProvider<LocalDateTime>((ref) {
  final clock = ref.watch(clockProvider);
  final controller = StreamController<LocalDateTime>();
  controller.add(clock.nowLocal());
  final timer = Timer.periodic(
    const Duration(seconds: 20),
    (_) => controller.add(clock.nowLocal()),
  );
  ref.onDispose(() {
    timer.cancel();
    unawaited(controller.close());
  });
  return controller.stream.distinct();
});

/// Bumped when the app comes back to the foreground or an alarm fires, so
/// permission banners refresh.
final permissionsProvider = FutureProvider<AlarmPermissions>(
  (ref) => ref.watch(alarmBridgeProvider).permissions(),
);
