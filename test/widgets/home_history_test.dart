import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medicine_reminder/core/platform/alarm_bridge.dart';
import 'package:medicine_reminder/features/doses/domain/dose.dart';

import '../helpers/fakes.dart';
import '../helpers/pump_app.dart';
import '../helpers/test_data.dart';

void main() {
  final bp = med(
    id: 'bp',
    times: [8 * 60, 20 * 60],
    stockQuarters: 3 * 4,
    refillWarnDays: 5,
  );

  testWidgets("home shows today's doses with status in words", (tester) async {
    final t = TestApp(
      clock: FakeClock(at(day1, 9, 30)),
      medicines: [bp],
      events: [],
    );
    await t.pump(tester);
    expect(find.text('Missed'), findsOneWidget);
    expect(find.text('Later today'), findsOneWidget);
    // 3 tablets, twice a day: runs out in a day and a half.
    expect(find.textContaining('Buy more soon'), findsOneWidget);
  });

  testWidgets('marking a missed dose as taken from home, then undo', (
    tester,
  ) async {
    final t = TestApp(clock: FakeClock(at(day1, 9, 30)), medicines: [bp]);
    await t.pump(tester);
    await tester.tap(find.text('Missed'));
    await TestApp.settle(tester);
    await tester.tap(find.byKey(const Key('dose-taken')));
    await TestApp.settle(tester);
    expect(find.textContaining('Taken at'), findsOneWidget);
    expect(t.medicines.medicines.single.stockQuarters, 8);
    expect(t.bridge.notices, isNotEmpty);

    await tester.tap(find.textContaining('Taken at'));
    await TestApp.settle(tester);
    await tester.tap(find.text('Undo'));
    await TestApp.settle(tester);
    expect(t.log.events, isEmpty);
    expect(t.medicines.medicines.single.stockQuarters, 12);
  });

  testWidgets('permission problems show a banner with a fix button', (
    tester,
  ) async {
    final t = TestApp(clock: FakeClock(at(day1, 7)), medicines: [bp]);
    t.bridge.permissionState = const AlarmPermissions(
      exactAlarms: false,
      fullScreen: true,
      notifications: false,
    );
    await t.pump(tester);
    expect(find.byKey(const Key('banner-exact')), findsOneWidget);
    expect(find.byKey(const Key('banner-notifications')), findsOneWidget);
    expect(find.byKey(const Key('banner-full-screen')), findsNothing);
    await tester.tap(
      find.descendant(
        of: find.byKey(const Key('banner-notifications')),
        matching: find.text('Fix'),
      ),
    );
    await TestApp.settle(tester);
    expect(t.notificationPermission.requests, 1);
  });

  testWidgets('history calendar summarises the month', (tester) async {
    final daily = med(id: 'd', times: [8 * 60]);
    final events = [
      for (var d = 0; d < 5; d++)
        if (d != 2)
          DoseEvent(
            key: DoseKey('d', at(day1.addDays(d), 8)),
            action: DoseAction.taken,
            atUtc: DateTime.utc(2026, 3, 10 + d, 3),
          ),
    ];
    final t = TestApp(
      clock: FakeClock(at(day1.addDays(4), 20)),
      medicines: [daily],
      events: events,
    );
    await t.pump(tester, location: '/history');
    expect(find.text('March 2026'), findsOneWidget);
    expect(find.text('Taken 4 of 5 doses this month'), findsOneWidget);
    expect(
      find.bySemanticsLabel(RegExp(r'^Mar 12, 2026: 0 taken, 1 missed')),
      findsOneWidget,
    );
  });
}
