import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/providers.dart';
import '../../medicines/domain/medicine.dart';
import '../../settings/domain/app_settings.dart';
import '../../settings/presentation/settings_controller.dart';

final alarmVoiceProvider = Provider<AlarmVoice>(AlarmVoice.new);

/// Reads the reminder aloud in the chosen language, or in English when the
/// phone has no voice for it.
class AlarmVoice {
  AlarmVoice(this._ref);

  final Ref _ref;

  Future<void> announce(List<Medicine> medicines) async {
    if (medicines.isEmpty) return;
    final settings = await _ref.read(settingsProvider.future);
    if (!settings.speak) return;
    await say(settings.language, (l10n) => speechFor(l10n, medicines));
  }

  /// Speaks [text] in [language]; returns false if English was used instead.
  Future<bool> say(
    AppLanguage language,
    String Function(AppLocalizations l10n) text,
  ) async {
    final speech = _ref.read(speechServiceProvider);
    final hasVoice =
        language == AppLanguage.english ||
        await speech.hasVoice(language.speechLocale);
    final spoken = hasVoice ? language : AppLanguage.english;
    await speech.speak(text(l10nFor(spoken)), spoken.speechLocale);
    return hasVoice;
  }

  Future<void> stop() => _ref.read(speechServiceProvider).stop();
}
