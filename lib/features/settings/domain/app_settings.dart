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

/// How the family hears about a missed dose.
enum FamilyChannel {
  /// This phone sends an SMS by itself (needs consent and SEND_SMS).
  sms,

  /// This phone shows a notification that opens a ready-made WhatsApp
  /// message; someone has to press Send.
  whatsapp,
}

/// At most this many family numbers.
const maxFamilyNumbers = 2;

/// The optional family check, off until the setup person turns it on.
@immutable
class FamilyCheck {
  const FamilyCheck({
    this.enabled = false,
    this.personName = '',
    this.numbers = const [],
    this.channel = FamilyChannel.sms,
    this.smsConsent = false,
  });

  final bool enabled;

  /// What the family calls the person taking the medicine, e.g. "Amma".
  final String personName;

  /// Phone numbers with country code, e.g. +919876543210.
  final List<String> numbers;
  final FamilyChannel channel;

  /// The setup person agreed that this phone may send SMS on its own.
  final bool smsConsent;

  /// Numbers that look dialable.
  List<String> get validNumbers => [
    for (final n in numbers)
      if (normalizePhone(n) != null) normalizePhone(n)!,
  ];

  /// True when a missed dose will actually reach someone.
  bool get isActive =>
      enabled &&
      validNumbers.isNotEmpty &&
      (channel == FamilyChannel.whatsapp || smsConsent);

  FamilyCheck copyWith({
    bool? enabled,
    String? personName,
    List<String>? numbers,
    FamilyChannel? channel,
    bool? smsConsent,
  }) => FamilyCheck(
    enabled: enabled ?? this.enabled,
    personName: personName ?? this.personName,
    numbers: numbers ?? this.numbers,
    channel: channel ?? this.channel,
    smsConsent: smsConsent ?? this.smsConsent,
  );

  @override
  bool operator ==(Object other) =>
      other is FamilyCheck &&
      other.enabled == enabled &&
      other.personName == personName &&
      other.numbers.length == numbers.length &&
      [
        for (var i = 0; i < numbers.length; i++) other.numbers[i] == numbers[i],
      ].every((same) => same) &&
      other.channel == channel &&
      other.smsConsent == smsConsent;

  @override
  int get hashCode => Object.hash(
    enabled,
    personName,
    Object.hashAll(numbers),
    channel,
    smsConsent,
  );
}

/// `+<country><number>` with digits only, or null if it can't be a phone
/// number. Ten-digit numbers are taken as Indian mobiles (+91).
String? normalizePhone(String input) {
  final digits = input.replaceAll(RegExp(r'[^0-9]'), '');
  final international = input.trim().startsWith('+');
  if (!international && digits.length == 10) return '+91$digits';
  if (!international && digits.length == 12 && digits.startsWith('91')) {
    return '+$digits';
  }
  if (!international && digits.length == 11 && digits.startsWith('0')) {
    return '+91${digits.substring(1)}';
  }
  if (international && digits.length >= 8 && digits.length <= 15) {
    return '+$digits';
  }
  return null;
}

@immutable
class AppSettings {
  const AppSettings({
    this.language = AppLanguage.english,
    this.onboarded = false,
    this.speak = true,
    this.missedAfterMinutes = 60,
    this.family = const FamilyCheck(),
  });

  final AppLanguage language;

  /// True once language and permissions were set up on first launch.
  final bool onboarded;

  /// Speak the reminder aloud when the alarm screen opens.
  final bool speak;

  /// An unanswered dose counts as missed this long after it was due.
  final int missedAfterMinutes;

  /// Tell family about missed doses (optional).
  final FamilyCheck family;

  AppSettings copyWith({
    AppLanguage? language,
    bool? onboarded,
    bool? speak,
    int? missedAfterMinutes,
    FamilyCheck? family,
  }) => AppSettings(
    language: language ?? this.language,
    onboarded: onboarded ?? this.onboarded,
    speak: speak ?? this.speak,
    missedAfterMinutes: missedAfterMinutes ?? this.missedAfterMinutes,
    family: family ?? this.family,
  );

  @override
  bool operator ==(Object other) =>
      other is AppSettings &&
      other.language == language &&
      other.onboarded == onboarded &&
      other.speak == speak &&
      other.missedAfterMinutes == missedAfterMinutes &&
      other.family == family;

  @override
  int get hashCode =>
      Object.hash(language, onboarded, speak, missedAfterMinutes, family);
}

abstract interface class SettingsRepository {
  Future<AppSettings> load();

  Future<void> save(AppSettings settings);
}
