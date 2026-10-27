import '../../../core/storage/json_file_store.dart';
import '../../../core/time/local_date.dart';
import '../domain/dose.dart';
import '../domain/dose_log_repository.dart';

Map<String, Object?> doseEventToJson(DoseEvent e) => {
  'medicineId': e.key.medicineId,
  'scheduled': e.key.scheduled.toIso(),
  'action': e.action.name,
  'at': e.atUtc.toUtc().toIso8601String(),
  'snoozedUntil': e.snoozedUntil?.toIso(),
};

DoseEvent doseEventFromJson(Map<String, Object?> json) => DoseEvent(
  key: DoseKey(
    json['medicineId']! as String,
    LocalDateTime.parse(json['scheduled']! as String),
  ),
  action: DoseAction.values.byName(json['action']! as String),
  atUtc: DateTime.parse(json['at']! as String).toUtc(),
  snoozedUntil: switch (json['snoozedUntil']) {
    final String value => LocalDateTime.parse(value),
    _ => null,
  },
);

class FileDoseLogRepository implements DoseLogRepository {
  FileDoseLogRepository(this._store);

  static const _name = 'dose_log';
  final JsonFileStore _store;

  @override
  Future<List<DoseEvent>> loadAll() async {
    final json = await _store.read(_name);
    if (json is! List<Object?>) return [];
    return [
      for (final item in json.cast<Map<String, Object?>>())
        doseEventFromJson(item),
    ];
  }

  Future<void> _writeAll(Iterable<DoseEvent> events) =>
      _store.write(_name, [for (final e in events) doseEventToJson(e)]);

  @override
  Future<void> add(DoseEvent event) async =>
      _writeAll([...await loadAll(), event]);

  @override
  Future<void> clearAnswer(DoseKey key) async => _writeAll(
    (await loadAll()).where(
      (e) => e.key != key || e.action == DoseAction.snoozed,
    ),
  );

  @override
  Future<void> deleteMedicine(String medicineId) async =>
      _writeAll((await loadAll()).where((e) => e.key.medicineId != medicineId));
}
