import 'package:flutter_tts/flutter_tts.dart';

/// Speaks reminders aloud.
abstract interface class SpeechService {
  /// Whether this phone has a voice for [localeTag] (for example `te-IN`).
  Future<bool> hasVoice(String localeTag);

  Future<void> speak(String text, String localeTag);

  Future<void> stop();
}

class TtsSpeechService implements SpeechService {
  final FlutterTts _tts = FlutterTts();

  @override
  Future<bool> hasVoice(String localeTag) async {
    final available = await _tts.isLanguageAvailable(localeTag);
    return available == true;
  }

  @override
  Future<void> speak(String text, String localeTag) async {
    await _tts.setLanguage(localeTag);
    // Slower than default: easier to follow for older listeners.
    await _tts.setSpeechRate(0.42);
    await _tts.setVolume(1);
    await _tts.speak(text);
  }

  @override
  Future<void> stop() async {
    await _tts.stop();
  }
}
