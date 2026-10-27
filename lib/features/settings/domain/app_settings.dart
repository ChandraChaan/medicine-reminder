import 'package:meta/meta.dart';

/// Languages the app speaks and shows.
enum AppLanguage {
  english('en', 'en-IN'),
  telugu('te', 'te-IN'),
  hindi('hi', 'hi-IN');

  const AppLanguage(this.code, this.speechLocale);

  final String code;

  /// BCP 47 tag for text-to-speech.
  final String speechLocale;

  static AppLanguage fromCode(String? code) => values.firstWhere(
    (language) => language.code == code,
    orElse: () => english,
  );
}

/// Choices offered for "count a dose as missed after".
const missedAfterChoices = [30, 60, 120];

@immutable
class AppSettings {
  const AppSettings({
    this.language = AppLanguage.english,
    this.onboarded = false,
    this.speak = true,
    this.missedAfterMinutes = 60,
  });

  final AppLanguage language;

  /// True once language and permissions were set up on first launch.
  final bool onboarded;

  /// Speak the reminder aloud when the alarm screen opens.
  final bool speak;

  /// An unanswered dose counts as missed this long after it was due.
  final int missedAfterMinutes;

  AppSettings copyWith({
    AppLanguage? language,
    bool? onboarded,
    bool? speak,
    int? missedAfterMinutes,
  }) => AppSettings(
    language: language ?? this.language,
    onboarded: onboarded ?? this.onboarded,
    speak: speak ?? this.speak,
    missedAfterMinutes: missedAfterMinutes ?? this.missedAfterMinutes,
  );

  @override
  bool operator ==(Object other) =>
      other is AppSettings &&
      other.language == language &&
      other.onboarded == onboarded &&
      other.speak == speak &&
      other.missedAfterMinutes == missedAfterMinutes;

  @override
  int get hashCode =>
      Object.hash(language, onboarded, speak, missedAfterMinutes);
}

abstract interface class SettingsRepository {
  Future<AppSettings> load();

  Future<void> save(AppSettings settings);
}
