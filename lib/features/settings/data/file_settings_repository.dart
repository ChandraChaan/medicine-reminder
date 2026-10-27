import '../../../core/storage/json_file_store.dart';
import '../domain/app_settings.dart';

Map<String, Object?> settingsToJson(AppSettings s) => {
  'language': s.language.code,
  'onboarded': s.onboarded,
  'speak': s.speak,
  'missedAfterMinutes': s.missedAfterMinutes,
  'family': {
    'enabled': s.family.enabled,
    'personName': s.family.personName,
    'numbers': s.family.numbers,
    'channel': s.family.channel.name,
    'smsConsent': s.family.smsConsent,
  },
};

FamilyCheck _familyFromJson(Object? json) {
  if (json is! Map<String, Object?>) return const FamilyCheck();
  return FamilyCheck(
    enabled: json['enabled'] as bool? ?? false,
    personName: json['personName'] as String? ?? '',
    numbers: (json['numbers'] as List<Object?>?)?.cast<String>() ?? const [],
    channel:
        FamilyChannel.values.asNameMap()[json['channel']] ?? FamilyChannel.sms,
    smsConsent: json['smsConsent'] as bool? ?? false,
  );
}

AppSettings settingsFromJson(Map<String, Object?> json) {
  const defaults = AppSettings();
  return AppSettings(
    language: AppLanguage.fromCode(json['language'] as String?),
    onboarded: json['onboarded'] as bool? ?? defaults.onboarded,
    speak: json['speak'] as bool? ?? defaults.speak,
    missedAfterMinutes:
        json['missedAfterMinutes'] as int? ?? defaults.missedAfterMinutes,
    family: _familyFromJson(json['family']),
  );
}

class FileSettingsRepository implements SettingsRepository {
  FileSettingsRepository(this._store);

  static const _name = 'settings';
  final JsonFileStore _store;

  @override
  Future<AppSettings> load() async {
    final json = await _store.read(_name);
    return json is Map<String, Object?>
        ? settingsFromJson(json)
        : const AppSettings();
  }

  @override
  Future<void> save(AppSettings settings) =>
      _store.write(_name, settingsToJson(settings));
}
