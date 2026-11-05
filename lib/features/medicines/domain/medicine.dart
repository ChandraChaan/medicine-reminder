import 'package:meta/meta.dart';

import '../../../core/time/local_date.dart';

/// Default times offered during setup, in minutes after midnight.
abstract final class DayPart {
  static const morning = 8 * 60;
  static const afternoon = 13 * 60;
  static const night = 21 * 60;
}

/// Every weekday, [DateTime.monday] to [DateTime.sunday].
const everyDay = {1, 2, 3, 4, 5, 6, 7};

/// One reminder (for example "Evening walk") and when it rings.
@immutable
class Medicine {
  const Medicine({
    required this.id,
    required this.name,
    required this.times,
    required this.startDate,
    this.photoPath,
    this.endDate,
    this.weekdays = everyDay,
  });

  final String id;
  final String name;
  final String? photoPath;

  /// Minutes after midnight, sorted, no duplicates.
  final List<int> times;
  final LocalDate startDate;

  /// Last day it rings (inclusive); null means "keep going".
  final LocalDate? endDate;
  final Set<int> weekdays;

  bool isScheduledOn(LocalDate date) =>
      !date.isBefore(startDate) &&
      (endDate == null || !date.isAfter(endDate!)) &&
      weekdays.contains(date.weekday);

  Medicine copyWith({
    String? name,
    String? Function()? photoPath,
    List<int>? times,
    LocalDate? startDate,
    LocalDate? Function()? endDate,
    Set<int>? weekdays,
  }) => Medicine(
    id: id,
    name: name ?? this.name,
    photoPath: photoPath != null ? photoPath() : this.photoPath,
    times: times ?? this.times,
    startDate: startDate ?? this.startDate,
    endDate: endDate != null ? endDate() : this.endDate,
    weekdays: weekdays ?? this.weekdays,
  );

  @override
  bool operator ==(Object other) =>
      other is Medicine &&
      other.id == id &&
      other.name == name &&
      other.photoPath == photoPath &&
      _listEquals(other.times, times) &&
      other.startDate == startDate &&
      other.endDate == endDate &&
      other.weekdays.length == weekdays.length &&
      other.weekdays.containsAll(weekdays);

  @override
  int get hashCode => Object.hash(
    id,
    name,
    photoPath,
    Object.hashAll(times),
    startDate,
    endDate,
    Object.hashAllUnordered(weekdays),
  );
}

bool _listEquals(List<int> a, List<int> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

/// Sorts and removes duplicate times.
List<int> normalizeTimes(Iterable<int> times) => times.toSet().toList()..sort();
