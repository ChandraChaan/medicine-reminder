import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/platform/speech_recognizer.dart';
import '../../../core/platform/voice_permissions.dart';
import '../../../core/providers.dart';
import '../domain/app_settings.dart';
import 'settings_controller.dart';

/// The language in use; English until settings have loaded.
final languageProvider = Provider<AppLanguage>(
  (ref) => ref.watch(settingsProvider).value?.language ?? AppLanguage.english,
);

/// Whether this phone can listen in the chosen language, and how privately.
/// Invalidated when the app comes back to the foreground.
final recognizerStatusProvider = FutureProvider<RecognizerStatus>((ref) {
  final language = ref.watch(languageProvider);
  return ref.watch(speechRecognizerProvider).status(language.speechLocale);
});

/// Whether the phone has a text-to-speech voice for the chosen language.
final hasVoiceProvider = FutureProvider<bool>((ref) {
  final language = ref.watch(languageProvider);
  return ref.watch(speechServiceProvider).hasVoice(language.speechLocale);
});

/// Which voice permissions (microphone, phone) are granted. Invalidated on
/// resume.
final voicePermissionStatusProvider =
    FutureProvider<Map<VoicePermission, bool>>((ref) async {
      final permissions = ref.watch(voicePermissionsProvider);
      return {
        for (final permission in VoicePermission.values)
          permission: await permissions.isGranted(permission),
      };
    });
