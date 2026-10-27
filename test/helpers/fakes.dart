import 'dart:async';

import 'package:medicine_reminder/core/platform/alarm_bridge.dart';
import 'package:medicine_reminder/core/platform/notification_permission.dart';
import 'package:medicine_reminder/core/platform/photo_picker.dart';
import 'package:medicine_reminder/core/speech/speech_service.dart';
import 'package:medicine_reminder/core/time/clock.dart';
import 'package:medicine_reminder/core/time/local_date.dart';
import 'package:medicine_reminder/features/doses/domain/dose.dart';
import 'package:medicine_reminder/features/doses/domain/dose_log_repository.dart';
import 'package:medicine_reminder/features/medicines/domain/medicine.dart';
import 'package:medicine_reminder/features/medicines/domain/medicine_repository.dart';
import 'package:medicine_reminder/features/settings/domain/app_settings.dart';

/// A clock fixed at a wall-clock time in a zone [offset] ahead of UTC.
class FakeClock implements Clock {
  FakeClock(
    LocalDateTime local, {
    this.offset = const Duration(hours: 5, minutes: 30),
  }) : _utc = local.toUtc(offset);

  DateTime _utc;

  @override
  final Duration offset;

  @override
  DateTime nowUtc() => _utc;

  void advance(Duration by) => _utc = _utc.add(by);
}

class FakeMedicineRepository implements MedicineRepository {
  FakeMedicineRepository([List<Medicine> initial = const []])
    : medicines = [...initial];

  final List<Medicine> medicines;

  @override
  Future<List<Medicine>> loadAll() async => [...medicines];

  @override
  Future<void> save(Medicine medicine) async {
    medicines
      ..removeWhere((m) => m.id == medicine.id)
      ..add(medicine);
  }

  @override
  Future<void> delete(String id) async =>
      medicines.removeWhere((m) => m.id == id);
}

class FakeDoseLogRepository implements DoseLogRepository {
  FakeDoseLogRepository([List<DoseEvent> initial = const []])
    : events = [...initial];

  final List<DoseEvent> events;

  @override
  Future<List<DoseEvent>> loadAll() async => [...events];

  @override
  Future<void> add(DoseEvent event) async => events.add(event);

  @override
  Future<void> clearAnswer(DoseKey key) async =>
      events.removeWhere((e) => e.key == key && e.action != DoseAction.snoozed);

  @override
  Future<void> deleteMedicine(String medicineId) async =>
      events.removeWhere((e) => e.key.medicineId == medicineId);
}

class FakeSettingsRepository implements SettingsRepository {
  FakeSettingsRepository([this.settings = const AppSettings(onboarded: true)]);

  AppSettings settings;

  @override
  Future<AppSettings> load() async => settings;

  @override
  Future<void> save(AppSettings settings) async => this.settings = settings;
}

class FakeAlarmBridge implements AlarmBridge {
  List<AlarmEntry> scheduled = [];
  int scheduleCalls = 0;
  int stopRingingCalls = 0;
  int alarmDoneCalls = 0;
  final notices = <String>[];
  AlarmPermissions permissionState = AlarmPermissions.allGranted;
  final _fired = StreamController<void>.broadcast();

  @override
  Future<void> scheduleAll(List<AlarmEntry> entries, ChannelNames names) async {
    scheduleCalls++;
    scheduled = entries;
  }

  @override
  Future<AlarmPermissions> permissions() async => permissionState;

  @override
  Future<void> openExactAlarmSettings() async {}

  @override
  Future<void> openFullScreenSettings() async {}

  @override
  Future<void> openNotificationSettings() async {}

  @override
  Future<bool> takeLaunchAlarm() async => false;

  @override
  Stream<void> get alarmFired => _fired.stream;

  Future<void> dispose() => _fired.close();

  @override
  Future<void> stopRinging() async => stopRingingCalls++;

  @override
  Future<void> alarmDone() async => alarmDoneCalls++;

  @override
  Future<void> showNotice({
    required int id,
    required String title,
    required String body,
  }) async => notices.add('$title|$body');
}

class FakeSpeech implements SpeechService {
  final voices = {'en-IN', 'te-IN', 'hi-IN'};
  final spoken = <(String, String)>[];

  @override
  Future<bool> hasVoice(String localeTag) async => voices.contains(localeTag);

  @override
  Future<void> speak(String text, String localeTag) async =>
      spoken.add((text, localeTag));

  @override
  Future<void> stop() async {}
}

class FakeNotificationPermission implements NotificationPermission {
  int requests = 0;

  @override
  Future<bool> request() async {
    requests++;
    return true;
  }
}

class FakePhotoPicker implements PhotoPicker {
  @override
  Future<String?> pick(PhotoSource source) async => null;
}
