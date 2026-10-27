import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fakes.dart';
import '../helpers/pump_app.dart';
import '../helpers/test_data.dart';

/// Tap targets, labels and contrast on every main screen, plus layouts at
/// 200% system font size.
void main() {
  final medicines = [
    med(
      id: 'bp',
      name: 'BP tablet',
      times: [8 * 60, 20 * 60],
      stockQuarters: 8,
    ),
    med(id: 'sugar', name: 'Metformin 500', times: [8 * 60]),
  ];
  const screens = [
    '/',
    '/alarm',
    '/history',
    '/medicines',
    '/medicines/new',
    '/settings',
    '/welcome',
  ];

  for (final location in screens) {
    testWidgets('$location meets tap target, label and contrast guidelines', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      final t = TestApp(clock: FakeClock(at(day1, 8, 5)), medicines: medicines);
      await t.pump(tester, location: location);
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      handle.dispose();
    });

    for (final size in const [Size(320, 640), Size(412, 915)]) {
      testWidgets('$location works at 200% text on ${size.width.toInt()}dp', (
        tester,
      ) async {
        final t = TestApp(
          clock: FakeClock(at(day1, 8, 5)),
          medicines: medicines,
        );
        await t.pump(tester, location: location, size: size, textScale: 2);
        expect(tester.takeException(), isNull);
      });
    }
  }

  testWidgets('the alarm buttons are huge', (tester) async {
    final t = TestApp(clock: FakeClock(at(day1, 8, 5)), medicines: medicines);
    await t.pump(tester, location: '/alarm');
    expect(
      tester.getSize(find.byKey(const Key('dose-taken'))).height,
      greaterThanOrEqualTo(96),
    );
    expect(
      tester.getSize(find.byKey(const Key('dose-snooze'))).height,
      greaterThanOrEqualTo(72),
    );
    expect(
      tester.getSize(find.byKey(const Key('dose-skip'))).height,
      greaterThanOrEqualTo(64),
    );
  });
}
