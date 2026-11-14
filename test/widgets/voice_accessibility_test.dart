import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medicine_reminder/features/settings/domain/app_settings.dart';

import '../helpers/voice_app.dart';

void main() {
  for (final location in ['/', '/setup', '/setup/contact/ravi']) {
    testWidgets('$location meets tap-target and contrast guidelines', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      final app = VoiceTestApp();
      await app.pump(tester, location: location);

      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      handle.dispose();
    });
  }

  for (final language in AppLanguage.values) {
    for (final location in ['/', '/setup', '/setup/contact/ravi']) {
      testWidgets(
        '$location in ${language.code} fits a small phone at 200% text',
        (tester) async {
          final app = VoiceTestApp(
            settings: AppSettings(onboarded: true, language: language),
          );
          await app.pump(
            tester,
            location: location,
            size: const Size(320, 640),
            textScale: 2,
          );
          // Overflow errors fail the test on their own; scroll to the end so
          // every lazily built item is laid out too.
          await tester.drag(
            find.byType(Scrollable).first,
            const Offset(0, -6000),
          );
          await VoiceTestApp.settle(tester);
          expect(tester.takeException(), isNull);
        },
      );
    }
  }

  testWidgets('the talk key is read once, as a button', (tester) async {
    final handle = tester.ensureSemantics();
    final app = VoiceTestApp();
    await app.pump(tester);

    expect(
      tester.getSemantics(find.bySemanticsLabel('Press and speak')),
      matchesSemantics(
        label: 'Press and speak',
        isButton: true,
        hasEnabledState: true,
        isEnabled: true,
        hasTapAction: true,
      ),
    );
    handle.dispose();
  });
}
