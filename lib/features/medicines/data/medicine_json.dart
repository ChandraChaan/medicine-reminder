import '../../../core/time/local_date.dart';
import '../domain/medicine.dart';

Map<String, Object?> medicineToJson(Medicine m) => {
  'id': m.id,
  'name': m.name,
  'photoPath': m.photoPath,
  'times': m.times,
  'startDate': m.startDate.toIso(),
  'endDate': m.endDate?.toIso(),
  'weekdays': (m.weekdays.toList()..sort()),
};

/// Older files also have dose, food and stock fields; they are ignored.
Medicine medicineFromJson(Map<String, Object?> json) => Medicine(
  id: json['id']! as String,
  name: json['name']! as String,
  photoPath: json['photoPath'] as String?,
  times: normalizeTimes((json['times']! as List<Object?>).cast<int>()),
  startDate: LocalDate.parse(json['startDate']! as String),
  endDate: switch (json['endDate']) {
    final String value => LocalDate.parse(value),
    _ => null,
  },
  weekdays:
      (json['weekdays'] as List<Object?>?)?.cast<int>().toSet() ?? everyDay,
);
