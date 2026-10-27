// Renders README screenshots with realistic sample data:
//   flutter test test_screenshots --update-goldens
import 'package:flutter_test/flutter_test.dart';
import 'package:medicine_reminder/core/time/local_date.dart';
import 'package:medicine_reminder/features/settings/domain/app_settings.dart';

import 'screenshot_setup.dart';

void main() {
  setUpAll(loadFonts);

  testWidgets('today', (tester) async {
    await shoot(
      tester,
      '01_today',
      now: const LocalDateTime(today, 13 * 60 + 40),
    );
  });

  testWidgets('alarm', (tester) async {
    await shoot(
      tester,
      '02_alarm',
      now: const LocalDateTime(today, 21 * 60 + 1),
      location: '/alarm',
    );
  });

  testWidgets('history', (tester) async {
    await shoot(
      tester,
      '03_history',
      now: const LocalDateTime(today, 22 * 60),
      location: '/history',
    );
  });

  testWidgets('family check', (tester) async {
    await shoot(
      tester,
      '07_family_check',
      now: const LocalDateTime(today, 10 * 60),
      location: '/family',
      family: const FamilyCheck(
        enabled: true,
        personName: 'Amma',
        numbers: ['+91 98765 43210'],
        smsConsent: true,
      ),
    );
  });

  testWidgets('medicines', (tester) async {
    await shoot(
      tester,
      '04_medicines',
      now: const LocalDateTime(today, 10 * 60),
      location: '/medicines',
    );
  });
}
