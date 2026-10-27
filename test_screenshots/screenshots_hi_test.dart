import 'package:flutter_test/flutter_test.dart';
import 'package:medicine_reminder/core/time/local_date.dart';
import 'package:medicine_reminder/features/settings/domain/app_settings.dart';

import 'screenshot_setup.dart';

void main() {
  setUpAll(() => loadFonts(script: 'hi'));

  testWidgets('today in Hindi', (tester) async {
    await shoot(
      tester,
      '06_today_hindi',
      now: const LocalDateTime(today, 13 * 60 + 40),
      language: AppLanguage.hindi,
    );
  });
}
