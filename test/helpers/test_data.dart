import 'package:medicine_reminder/core/time/local_date.dart';
import 'package:medicine_reminder/features/medicines/domain/medicine.dart';

const day1 = LocalDate(2026, 3, 10);

LocalDateTime at(LocalDate date, int hour, [int minute = 0]) =>
    LocalDateTime(date, hour * 60 + minute);

Medicine med({
  String id = 'bp',
  String name = 'BP tablet',
  List<int> times = const [8 * 60],
  FoodTiming food = FoodTiming.afterFood,
  LocalDate start = day1,
  LocalDate? end,
  Set<int> weekdays = everyDay,
  int doseQuarters = 4,
  DoseUnit unit = DoseUnit.tablet,
  int? stockQuarters,
  int refillWarnDays = 5,
}) => Medicine(
  id: id,
  name: name,
  doseQuarters: doseQuarters,
  unit: unit,
  times: times,
  food: food,
  startDate: start,
  endDate: end,
  weekdays: weekdays,
  stockQuarters: stockQuarters,
  refillWarnDays: refillWarnDays,
);
