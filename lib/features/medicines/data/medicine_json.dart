import '../../../core/time/local_date.dart';
import '../domain/medicine.dart';

Map<String, Object?> medicineToJson(Medicine m) => {
  'id': m.id,
  'name': m.name,
  'photoPath': m.photoPath,
  'doseQuarters': m.doseQuarters,
  'unit': m.unit.name,
  'times': m.times,
  'food': m.food.name,
  'startDate': m.startDate.toIso(),
  'endDate': m.endDate?.toIso(),
  'weekdays': (m.weekdays.toList()..sort()),
  'stockQuarters': m.stockQuarters,
  'refillWarnDays': m.refillWarnDays,
};

Medicine medicineFromJson(Map<String, Object?> json) => Medicine(
  id: json['id']! as String,
  name: json['name']! as String,
  photoPath: json['photoPath'] as String?,
  doseQuarters: json['doseQuarters']! as int,
  unit: DoseUnit.values.byName(json['unit']! as String),
  times: normalizeTimes((json['times']! as List<Object?>).cast<int>()),
  food: FoodTiming.values.byName(json['food']! as String),
  startDate: LocalDate.parse(json['startDate']! as String),
  endDate: switch (json['endDate']) {
    final String value => LocalDate.parse(value),
    _ => null,
  },
  weekdays:
      (json['weekdays'] as List<Object?>?)?.cast<int>().toSet() ?? everyDay,
  stockQuarters: json['stockQuarters'] as int?,
  refillWarnDays: json['refillWarnDays'] as int? ?? 5,
);
