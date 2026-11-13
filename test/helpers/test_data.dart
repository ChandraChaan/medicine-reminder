import 'package:medicine_reminder/core/time/local_date.dart';
import 'package:medicine_reminder/features/medicines/domain/medicine.dart';

const day1 = LocalDate(2026, 3, 10);

LocalDateTime at(LocalDate date, int hour, [int minute = 0]) =>
    LocalDateTime(date, hour * 60 + minute);

Medicine med({
  String id = 'bp',
  String name = 'Morning walk',
  List<int> times = const [8 * 60],
  LocalDate start = day1,
  LocalDate? end,
  Set<int> weekdays = everyDay,
}) => Medicine(
  id: id,
  name: name,
  times: times,
  startDate: start,
  endDate: end,
  weekdays: weekdays,
);
