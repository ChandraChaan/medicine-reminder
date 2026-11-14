import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:medicine_reminder/app/app.dart';
import 'package:medicine_reminder/core/providers.dart';
import 'package:medicine_reminder/core/time/local_date.dart';
import 'package:medicine_reminder/features/doses/domain/dose.dart';
import 'package:medicine_reminder/features/family/domain/contact.dart';
import 'package:medicine_reminder/features/medicines/domain/medicine.dart';
import 'package:medicine_reminder/features/settings/domain/app_settings.dart';

import 'fakes.dart';
import 'voice_fakes.dart';

const ravi = Contact(
  id: 'ravi',
  name: 'Ravi',
  phone: '9800000001',
  nicknames: ['pedda abbayi', 'రవి'],
  forHelp: true,
);
const lata = Contact(
  id: 'lata',
  name: 'Lata',
  phone: '9800000002',
  nicknames: ['లత'],
  forHelp: true,
);
const kiran = Contact(id: 'kiran', name: 'Kiran', phone: '9800000003');

/// The real app with fakes, set up for the voice home (Voice Saathi) tests.
class VoiceTestApp {
  VoiceTestApp({
    List<Contact> contacts = const [ravi, lata, kiran],
    List<Medicine> medicines = const [],
    List<DoseEvent> events = const [],
    AppSettings settings = const AppSettings(onboarded: true),
    DateTime? now,
    bool microphone = true,
    bool phone = true,
  }) : contacts = FakeContactRepository(contacts),
       settings = FakeSettingsRepository(settings),
       medicines = FakeMedicineRepository(medicines),
       log = FakeDoseLogRepository(events),
       clock = FakeClock(_local(now ?? DateTime(2026, 11, 15, 10, 35))),
       permissions = FakeVoicePermissions(microphone: microphone, phone: phone);

  static LocalDateTime _local(DateTime t) =>
      LocalDateTime(LocalDate(t.year, t.month, t.day), t.hour * 60 + t.minute);

  final FakeContactRepository contacts;
  final FakeSettingsRepository settings;
  final FakeMedicineRepository medicines;
  final FakeDoseLogRepository log;
  final FakeClock clock;
  final FakeVoicePermissions permissions;
  final speech = VoiceFakeSpeech();
  final recognizer = FakeRecognizer();
  final phoneService = FakePhone();
  final bridge = FakeAlarmBridge();

  /// The app's providers, available after [pump].
  ProviderContainer get container => ProviderScope.containerOf(
    _tester.element(find.byType(MedicineReminderApp)),
  );
  late WidgetTester _tester;

  List<Override> get overrides => [
    clockProvider.overrideWithValue(clock),
    alarmBridgeProvider.overrideWithValue(bridge),
    speechServiceProvider.overrideWithValue(speech),
    notificationPermissionProvider.overrideWithValue(
      FakeNotificationPermission(),
    ),
    smsPermissionProvider.overrideWithValue(FakeSmsPermission()),
    autoSmsProvider.overrideWithValue(true),
    photoPickerProvider.overrideWithValue(FakePhotoPicker()),
    medicineRepositoryProvider.overrideWithValue(medicines),
    doseLogRepositoryProvider.overrideWithValue(log),
    settingsRepositoryProvider.overrideWithValue(settings),
    speechRecognizerProvider.overrideWithValue(recognizer),
    phoneProvider.overrideWithValue(phoneService),
    voicePermissionsProvider.overrideWithValue(permissions),
    contactRepositoryProvider.overrideWithValue(contacts),
  ];

  Future<void> pump(
    WidgetTester tester, {
    String location = '/',
    Size size = const Size(412, 915),
    double textScale = 1,
  }) async {
    await initializeDateFormatting();
    tester.view.physicalSize = size * 2.625;
    tester.view.devicePixelRatio = 2.625;
    tester.platformDispatcher.textScaleFactorTestValue = textScale;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    addTearDown(recognizer.dispose);
    addTearDown(bridge.dispose);
    _tester = tester;
    // Disposed with the widget tree, so the clock's timer stops in time.
    await tester.pumpWidget(
      ProviderScope(
        overrides: overrides,
        child: MedicineReminderApp(initialLocation: location),
      ),
    );
    await settle(tester);
  }

  /// Lets futures and frames finish without waiting on endless animations.
  static Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }
}
