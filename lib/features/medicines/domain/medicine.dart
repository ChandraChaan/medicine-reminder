import 'package:meta/meta.dart';

import '../../../core/time/local_date.dart';

enum FoodTiming { beforeFood, afterFood, withFood, anyTime }

enum DoseUnit { tablet, capsule, ml, drops, puff, injection }

/// Default times offered during setup, in minutes after midnight.
abstract final class DayPart {
  static const morning = 8 * 60;
  static const afternoon = 13 * 60;
  static const night = 21 * 60;
}

/// Every weekday, [DateTime.monday] to [DateTime.sunday].
const everyDay = {1, 2, 3, 4, 5, 6, 7};

/// One medicine and when to take it.
///
/// Amounts are whole quarters ([doseQuarters] 2 = half a tablet), so refill
/// math never rounds.
@immutable
class Medicine {
  const Medicine({
    required this.id,
    required this.name,
    required this.doseQuarters,
    required this.unit,
    required this.times,
    required this.food,
    required this.startDate,
    this.photoPath,
    this.endDate,
    this.weekdays = everyDay,
    this.stockQuarters,
    this.refillWarnDays = 5,
  });

  final String id;
  final String name;
  final String? photoPath;
  final int doseQuarters;
  final DoseUnit unit;

  /// Minutes after midnight, sorted, no duplicates.
  final List<int> times;
  final FoodTiming food;
  final LocalDate startDate;

  /// Last day to take it (inclusive); null means "keep going".
  final LocalDate? endDate;
  final Set<int> weekdays;

  /// Units left in hand, in quarters; null when not counting.
  final int? stockQuarters;
  final int refillWarnDays;

  bool get tracksStock => stockQuarters != null;

  bool isScheduledOn(LocalDate date) =>
      !date.isBefore(startDate) &&
      (endDate == null || !date.isAfter(endDate!)) &&
      weekdays.contains(date.weekday);

  Medicine copyWith({
    String? name,
    String? Function()? photoPath,
    int? doseQuarters,
    DoseUnit? unit,
    List<int>? times,
    FoodTiming? food,
    LocalDate? startDate,
    LocalDate? Function()? endDate,
    Set<int>? weekdays,
    int? Function()? stockQuarters,
    int? refillWarnDays,
  }) => Medicine(
    id: id,
    name: name ?? this.name,
    photoPath: photoPath != null ? photoPath() : this.photoPath,
    doseQuarters: doseQuarters ?? this.doseQuarters,
    unit: unit ?? this.unit,
    times: times ?? this.times,
    food: food ?? this.food,
    startDate: startDate ?? this.startDate,
    endDate: endDate != null ? endDate() : this.endDate,
    weekdays: weekdays ?? this.weekdays,
    stockQuarters: stockQuarters != null ? stockQuarters() : this.stockQuarters,
    refillWarnDays: refillWarnDays ?? this.refillWarnDays,
  );

  @override
  bool operator ==(Object other) =>
      other is Medicine &&
      other.id == id &&
      other.name == name &&
      other.photoPath == photoPath &&
      other.doseQuarters == doseQuarters &&
      other.unit == unit &&
      _listEquals(other.times, times) &&
      other.food == food &&
      other.startDate == startDate &&
      other.endDate == endDate &&
      other.weekdays.length == weekdays.length &&
      other.weekdays.containsAll(weekdays) &&
      other.stockQuarters == stockQuarters &&
      other.refillWarnDays == refillWarnDays;

  @override
  int get hashCode => Object.hash(
    id,
    name,
    photoPath,
    doseQuarters,
    unit,
    Object.hashAll(times),
    food,
    startDate,
    endDate,
    Object.hashAllUnordered(weekdays),
    stockQuarters,
    refillWarnDays,
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
