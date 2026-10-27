import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medicine_reminder/core/platform/alarm_bridge.dart';
import 'package:medicine_reminder/features/settings/domain/app_settings.dart';

import '../helpers/fakes.dart';
import '../helpers/pump_app.dart';
import '../helpers/test_data.dart';

Future<void> tapVisible(WidgetTester tester, Finder finder) async {
  await tester.scrollUntilVisible(
    finder,
    200,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.ensureVisible(finder);
  await tester.pump();
  await tester.tap(finder);
}

void main() {
  testWidgets('off by default; turning it on needs a number and SMS consent', (
    tester,
  ) async {
    final t = TestApp(clock: FakeClock(at(day1, 7)), medicines: [med()]);
    await t.pump(tester, location: '/family');
    expect(find.byKey(const Key('family-person')), findsNothing);

    await tester.tap(find.byKey(const Key('family-enabled')));
    await TestApp.settle(tester);
    expect(find.text('Add at least one phone number.'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('family-person')), 'Amma');
    await tester.enterText(
      find.byKey(const Key('family-number-0')),
      '98765 43210',
    );
    await TestApp.settle(tester);
    // Not active yet: SMS needs consent first, so no check alarms.
    expect(t.bridge.scheduled.where((e) => e.kind == AlarmKind.check), isEmpty);
    expect(t.smsPermission.requests, 0);

    await tapVisible(tester, find.byKey(const Key('family-consent')));
    await TestApp.settle(tester);
    expect(t.smsPermission.requests, 1);
    expect(t.settings.settings.family.isActive, isTrue);
    expect(
      t.bridge.scheduled.where((e) => e.kind == AlarmKind.check),
      isNotEmpty,
    );
    expect(
      find.text(
        'Medicine Reminder: Amma has not marked BP tablet (due at 8:00 AM) as taken. Please check on them.',
      ),
      findsOneWidget,
    );

    await tapVisible(tester, find.byKey(const Key('family-test')));
    await TestApp.settle(tester);
    expect(t.bridge.sms.single.$1, ['+919876543210']);
    expect(t.bridge.sms.single.$2, contains('this is a test'));
    expect(find.text('Test message sent.'), findsOneWidget);
  });

  testWidgets('WhatsApp needs no SMS permission and only opens a message', (
    tester,
  ) async {
    final t = TestApp(
      clock: FakeClock(at(day1, 7)),
      medicines: [med()],
      settings: const AppSettings(
        onboarded: true,
        family: FamilyCheck(
          enabled: true,
          personName: 'Nanna',
          numbers: ['+91 99887 76655'],
        ),
      ),
    );
    await t.pump(tester, location: '/family');
    await tapVisible(tester, find.byKey(const Key('family-channel-whatsapp')));
    await TestApp.settle(tester);
    expect(t.settings.settings.family.isActive, isTrue);
    await tapVisible(tester, find.byKey(const Key('family-test')));
    await TestApp.settle(tester);
    expect(t.bridge.whatsApp.single.$1, '+919988776655');
    expect(t.bridge.sms, isEmpty);
    expect(t.smsPermission.requests, 0);
  });

  testWidgets('an invalid number is flagged', (tester) async {
    final t = TestApp(
      clock: FakeClock(at(day1, 7)),
      settings: const AppSettings(
        onboarded: true,
        family: FamilyCheck(enabled: true),
      ),
    );
    await t.pump(tester, location: '/family');
    await tester.enterText(find.byKey(const Key('family-number-0')), '12345');
    await TestApp.settle(tester);
    expect(find.text("This doesn't look like a phone number."), findsOneWidget);
  });

  testWidgets('/family meets accessibility guidelines when filled in', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    final t = TestApp(
      clock: FakeClock(at(day1, 7)),
      medicines: [med()],
      settings: const AppSettings(
        onboarded: true,
        family: FamilyCheck(
          enabled: true,
          personName: 'Amma',
          numbers: ['9876543210'],
          smsConsent: true,
        ),
      ),
    );
    await t.pump(tester, location: '/family');
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    await expectLater(tester, meetsGuideline(textContrastGuideline));
    handle.dispose();
  });

  testWidgets('/family works at 200% text on a 320dp phone', (tester) async {
    final t = TestApp(
      clock: FakeClock(at(day1, 7)),
      settings: const AppSettings(
        onboarded: true,
        family: FamilyCheck(enabled: true),
      ),
    );
    await t.pump(
      tester,
      location: '/family',
      size: const Size(320, 640),
      textScale: 2,
    );
    expect(tester.takeException(), isNull);
  });
}
