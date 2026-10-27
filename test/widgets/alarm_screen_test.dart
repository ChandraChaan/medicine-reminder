import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medicine_reminder/features/doses/domain/dose.dart';
import 'package:medicine_reminder/features/doses/presentation/alarm_screen.dart';
import 'package:medicine_reminder/features/medicines/domain/medicine.dart';
import 'package:medicine_reminder/features/settings/domain/app_settings.dart';

import '../helpers/fakes.dart';
import '../helpers/pump_app.dart';
import '../helpers/test_data.dart';

void main() {
  final bp = med(id: 'bp', name: 'BP tablet', stockQuarters: 40);
  final sugar = med(
    id: 'sugar',
    name: 'Sugar tablet',
    food: FoodTiming.beforeFood,
  );

  TestApp app({
    AppSettings settings = const AppSettings(onboarded: true),
    List<Medicine>? medicines,
  }) => TestApp(
    clock: FakeClock(at(day1, 8, 1)),
    medicines: medicines ?? [bp, sugar],
    settings: settings,
  );

  testWidgets('shows the first due medicine, rings, then speaks', (
    tester,
  ) async {
    final t = app();
    await t.pump(tester, location: '/alarm');
    // Still ringing for the first 20 seconds, nothing spoken yet.
    expect(t.bridge.stopRingingCalls, 0);
    expect(t.speech.spoken, isEmpty);
    await tester.pump(AlarmScreen.ringFor);
    await TestApp.settle(tester);
    expect(find.text('Time for your medicine'), findsOneWidget);
    expect(find.text('BP tablet'), findsOneWidget);
    expect(find.text('1 of 2'), findsOneWidget);
    expect(find.text('After food'), findsOneWidget);
    expect(find.byKey(const Key('dose-taken')), findsOneWidget);
    expect(find.byKey(const Key('dose-snooze')), findsOneWidget);
    expect(find.byKey(const Key('dose-skip')), findsOneWidget);
    expect(t.bridge.stopRingingCalls, 1);
    expect(t.speech.spoken.single, (
      "It's time for your medicines. BP tablet, after food. Sugar tablet, before food.",
      'en-IN',
    ));
  });

  testWidgets('Taken records the dose, counts stock and moves to the next', (
    tester,
  ) async {
    final t = app();
    await t.pump(tester, location: '/alarm');
    await tester.tap(find.byKey(const Key('dose-taken')));
    await TestApp.settle(tester);
    expect(t.log.events.single.action, DoseAction.taken);
    expect(t.log.events.single.key.medicineId, 'bp');
    expect(
      t.medicines.medicines.firstWhere((m) => m.id == 'bp').stockQuarters,
      36,
    );
    expect(find.text('Sugar tablet'), findsOneWidget);
    expect(find.text('1 of 2'), findsNothing);
  });

  testWidgets('Snooze sets a 10 minute snooze and re-plans the alarm', (
    tester,
  ) async {
    final t = app(medicines: [bp]);
    await t.pump(tester, location: '/alarm');
    await tester.tap(find.byKey(const Key('dose-snooze')));
    await TestApp.settle(tester);
    final e = t.log.events.single;
    expect(e.action, DoseAction.snoozed);
    expect(e.snoozedUntil, at(day1, 8, 11));
    expect(t.bridge.scheduled.first.at, at(day1, 8, 11));
    expect(find.text('All done. Well done!'), findsOneWidget);
  });

  testWidgets(
    'Skip records a skip; Close returns home and frees the lock screen',
    (tester) async {
      final t = app(medicines: [bp]);
      await t.pump(tester, location: '/alarm');
      await tester.tap(find.byKey(const Key('dose-skip')));
      await TestApp.settle(tester);
      expect(t.log.events.single.action, DoseAction.skipped);
      await tester.tap(find.byKey(const Key('alarm-close')));
      await TestApp.settle(tester);
      expect(t.bridge.alarmDoneCalls, 1);
      expect(find.text('Today'), findsOneWidget);
    },
  );

  testWidgets('no snooze after three snoozes', (tester) async {
    final key = DoseKey('bp', at(day1, 7, 30));
    final events = [
      for (var i = 0; i < 3; i++)
        DoseEvent(
          key: key,
          action: DoseAction.snoozed,
          atUtc: DateTime.utc(2026, 3, 10, 2, i),
          snoozedUntil: at(day1, 7, 40 + i * 5),
        ),
    ];
    final t = TestApp(
      clock: FakeClock(at(day1, 8, 1)),
      medicines: [
        med(times: [7 * 60 + 30]),
      ],
      events: events,
    );
    await t.pump(tester, location: '/alarm');
    expect(find.byKey(const Key('dose-taken')), findsOneWidget);
    expect(find.byKey(const Key('dose-snooze')), findsNothing);
  });

  testWidgets('touching the screen silences the ring; Taken skips speech', (
    tester,
  ) async {
    final t = app(medicines: [bp]);
    await t.pump(tester, location: '/alarm');
    await tester.tap(find.byKey(const Key('dose-taken')));
    await tester.pump(const Duration(seconds: 2));
    await TestApp.settle(tester);
    expect(t.bridge.stopRingingCalls, 1);
    expect(t.speech.spoken, isEmpty);
    expect(find.text('All done. Well done!'), findsOneWidget);
  });

  testWidgets('speaks Telugu', (tester) async {
    final t = app(
      medicines: [bp],
      settings: const AppSettings(
        onboarded: true,
        language: AppLanguage.telugu,
      ),
    );
    await t.pump(tester, location: '/alarm');
    await tester.pump(AlarmScreen.ringFor);
    await TestApp.settle(tester);
    expect(find.text('మందు వేసుకునే సమయం'), findsOneWidget);
    expect(t.speech.spoken.single, (
      'మీ BP tablet వేసుకునే సమయం అయింది, భోజనం తర్వాత.',
      'te-IN',
    ));
  });

  testWidgets('falls back to English speech without a voice', (tester) async {
    final t = TestApp(
      clock: FakeClock(at(day1, 8, 1)),
      medicines: [bp],
      settings: const AppSettings(onboarded: true, language: AppLanguage.hindi),
    );
    t.speech.voices.clear();
    await t.pump(tester, location: '/alarm');
    await tester.pump(AlarmScreen.ringFor);
    await TestApp.settle(tester);
    expect(t.speech.spoken.single.$2, 'en-IN');
  });

  testWidgets('says nothing is due when opened late with nothing pending', (
    tester,
  ) async {
    final t = TestApp(clock: FakeClock(at(day1, 15)), medicines: [bp]);
    await t.pump(tester, location: '/alarm');
    expect(find.text('No medicine is due right now.'), findsOneWidget);
    expect(t.bridge.stopRingingCalls, 1);
    expect(t.speech.spoken, isEmpty);
  });
}
