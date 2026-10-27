import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider/path_provider.dart';

import 'app/app.dart';
import 'core/platform/alarm_bridge.dart';
import 'core/platform/notification_permission.dart';
import 'core/platform/photo_picker.dart';
import 'core/providers.dart';
import 'core/speech/speech_service.dart';
import 'core/storage/json_file_store.dart';
import 'features/doses/data/file_dose_log_repository.dart';
import 'features/medicines/data/file_medicine_repository.dart';
import 'features/settings/data/file_settings_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();
  final support = await getApplicationSupportDirectory();
  final store = JsonFileStore(Directory('${support.path}/data'));
  final settingsRepository = FileSettingsRepository(store);
  final bridge = MethodChannelAlarmBridge();
  final settings = await settingsRepository.load();
  final fromAlarm = await bridge.takeLaunchAlarm();
  final initialLocation = !settings.onboarded
      ? '/welcome'
      : fromAlarm
      ? '/alarm'
      : '/';
  runApp(
    ProviderScope(
      overrides: [
        alarmBridgeProvider.overrideWithValue(bridge),
        speechServiceProvider.overrideWithValue(TtsSpeechService()),
        notificationPermissionProvider.overrideWithValue(
          const PermissionHandlerNotificationPermission(),
        ),
        photoPickerProvider.overrideWithValue(ImagePickerPhotoPicker()),
        medicineRepositoryProvider.overrideWithValue(
          FileMedicineRepository(store),
        ),
        doseLogRepositoryProvider.overrideWithValue(
          FileDoseLogRepository(store),
        ),
        settingsRepositoryProvider.overrideWithValue(settingsRepository),
      ],
      child: MedicineReminderApp(initialLocation: initialLocation),
    ),
  );
}
