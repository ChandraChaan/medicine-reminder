import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:medicine_reminder/app/app.dart';
import 'package:medicine_reminder/core/l10n/l10n.dart';
import 'package:medicine_reminder/core/providers.dart';
import 'package:medicine_reminder/core/theme/app_theme.dart';
import 'package:medicine_reminder/features/doses/domain/dose.dart';
import 'package:medicine_reminder/features/medicines/domain/medicine.dart';
import 'package:medicine_reminder/features/settings/domain/app_settings.dart';

import 'fakes.dart';

/// Everything a widget test can look at after pumping.
class TestApp {
  TestApp({
    required this.clock,
    List<Medicine> medicines = const [],
    List<DoseEvent> events = const [],
    AppSettings settings = const AppSettings(onboarded: true),
  }) : medicines = FakeMedicineRepository(medicines),
       log = FakeDoseLogRepository(events),
       settings = FakeSettingsRepository(settings);

  final FakeClock clock;
  final FakeMedicineRepository medicines;
  final FakeDoseLogRepository log;
  final FakeSettingsRepository settings;
  final bridge = FakeAlarmBridge();
  final speech = FakeSpeech();
  final notificationPermission = FakeNotificationPermission();

  List<Override> get overrides => [
    clockProvider.overrideWithValue(clock),
    alarmBridgeProvider.overrideWithValue(bridge),
    speechServiceProvider.overrideWithValue(speech),
    notificationPermissionProvider.overrideWithValue(notificationPermission),
    photoPickerProvider.overrideWithValue(FakePhotoPicker()),
    medicineRepositoryProvider.overrideWithValue(medicines),
    doseLogRepositoryProvider.overrideWithValue(log),
    settingsRepositoryProvider.overrideWithValue(settings),
  ];

  /// Pumps the real app (router included) starting at [location].
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
    addTearDown(bridge.dispose);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
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

/// A bare MaterialApp around one screen, for screens without routes.
Widget wrapScreen(Widget child, {String locale = 'en'}) => MaterialApp.router(
  theme: buildAppTheme(),
  locale: Locale(locale),
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  routerConfig: GoRouter(
    routes: [GoRoute(path: '/', builder: (_, _) => child)],
  ),
);
