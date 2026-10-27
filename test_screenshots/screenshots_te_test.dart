import 'package:flutter_test/flutter_test.dart';
import 'package:medicine_reminder/core/time/local_date.dart';
import 'package:medicine_reminder/features/settings/domain/app_settings.dart';

import 'screenshot_setup.dart';

void main() {
  setUpAll(() => loadFonts(script: 'te'));

  testWidgets('alarm in Telugu', (tester) async {
    await shoot(
      tester,
      '05_alarm_telugu',
      now: const LocalDateTime(today, 14 * 60 + 1),
      location: '/alarm',
      language: AppLanguage.telugu,
    );
  });
}
