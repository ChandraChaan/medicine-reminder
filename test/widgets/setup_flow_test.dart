import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fakes.dart';
import '../helpers/pump_app.dart';
import '../helpers/test_data.dart';

Future<void> next(WidgetTester tester) async {
  await tester.tap(find.byKey(const Key('wizard-next')));
  await TestApp.settle(tester);
}

void main() {
  testWidgets('a family member adds a reminder step by step', (tester) async {
    final t = TestApp(clock: FakeClock(at(day1, 7)));
    await t.pump(tester);
    expect(find.text('No reminders yet'), findsOneWidget);
    await tester.tap(find.byKey(const Key('home-add-medicine')));
    await TestApp.settle(tester);

    // Step 1: a name is required.
    expect(find.text('Step 1 of 4'), findsOneWidget);
    await next(tester);
    expect(find.text('Please type a name.'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('wizard-name')), 'Yoga');
    await next(tester);

    // Step 2: morning is preselected; add night.
    expect(find.text('When should it ring?'), findsOneWidget);
    await tester.tap(find.textContaining('Night'));
    await TestApp.settle(tester);
    await next(tester);

    // Step 3: days, keep defaults.
    expect(find.text('Which days?'), findsOneWidget);
    await next(tester);

    // Step 4: review and save.
    expect(find.text('Check and save'), findsOneWidget);
    await next(tester);

    final saved = t.medicines.medicines.single;
    expect(saved.name, 'Yoga');
    expect(saved.times, [8 * 60, 21 * 60]);
    expect(saved.startDate, day1);
    expect(saved.endDate, isNull);
    // Home lists it at 8:00 and at 21:00.
    expect(find.text('Yoga'), findsNWidgets(2));
    // Alarms were handed to Android: 8:00 and 21:00 for a week.
    expect(t.bridge.scheduled, hasLength(14));
  });

  testWidgets('editing keeps the id and changes the medicine', (tester) async {
    final t = TestApp(clock: FakeClock(at(day1, 7)), medicines: [med()]);
    await t.pump(tester, location: '/medicines/bp');
    await tester.enterText(
      find.byKey(const Key('wizard-name')),
      'Morning walk 5 km',
    );
    // Three steps to the review, then Save.
    for (var i = 0; i < 4; i++) {
      await next(tester);
    }
    expect(t.medicines.medicines.single.id, 'bp');
    expect(t.medicines.medicines.single.name, 'Morning walk 5 km');
  });

  testWidgets('removing every time blocks the next step', (tester) async {
    final t = TestApp(clock: FakeClock(at(day1, 7)));
    await t.pump(tester, location: '/medicines/new');
    await tester.enterText(find.byKey(const Key('wizard-name')), 'Read news');
    await next(tester);
    await tester.tap(find.byTooltip('Remove 8:00 AM'));
    await TestApp.settle(tester);
    await next(tester);
    expect(find.text('Pick at least one time.'), findsOneWidget);
  });
}
