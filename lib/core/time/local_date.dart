import 'package:meta/meta.dart';

/// A calendar date with no time zone attached.
///
/// Day arithmetic goes through UTC, so adding days never shifts by an hour.
@immutable
class LocalDate implements Comparable<LocalDate> {
  const LocalDate(this.year, this.month, this.day);

  factory LocalDate.fromDateTime(DateTime dateTime) =>
      LocalDate(dateTime.year, dateTime.month, dateTime.day);

  /// Parses `yyyy-MM-dd`.
  factory LocalDate.parse(String value) {
    final parts = value.split('-');
    if (parts.length != 3) {
      throw FormatException('Expected yyyy-MM-dd', value);
    }
    return LocalDate(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
  }

  final int year;
  final int month;
  final int day;

  DateTime get _utc => DateTime.utc(year, month, day);

  /// [DateTime.monday] (1) to [DateTime.sunday] (7).
  int get weekday => _utc.weekday;

  LocalDate addDays(int days) =>
      LocalDate.fromDateTime(_utc.add(Duration(days: days)));

  /// Whole days from this date to [other]; negative when [other] is earlier.
  int daysUntil(LocalDate other) => other._utc.difference(_utc).inDays;

  bool isBefore(LocalDate other) => compareTo(other) < 0;
  bool isAfter(LocalDate other) => compareTo(other) > 0;

  LocalDate get firstOfMonth => LocalDate(year, month, 1);

  /// A local [DateTime] at midnight, for display formatting only.
  DateTime toDateTime() => DateTime(year, month, day);

  String toIso() =>
      '${year.toString().padLeft(4, '0')}-'
      '${month.toString().padLeft(2, '0')}-'
      '${day.toString().padLeft(2, '0')}';

  @override
  int compareTo(LocalDate other) {
    if (year != other.year) return year.compareTo(other.year);
    if (month != other.month) return month.compareTo(other.month);
    return day.compareTo(other.day);
  }

  @override
  bool operator ==(Object other) =>
      other is LocalDate &&
      other.year == year &&
      other.month == month &&
      other.day == day;

  @override
  int get hashCode => Object.hash(year, month, day);

  @override
  String toString() => toIso();
}

/// A wall-clock moment: a [LocalDate] plus minutes since midnight.
///
/// Doses are scheduled in wall-clock time ("8:00 every morning"), so a dose
/// stays at 8:00 when the phone moves to another time zone.
@immutable
class LocalDateTime implements Comparable<LocalDateTime> {
  const LocalDateTime(this.date, this.minuteOfDay)
    : assert(minuteOfDay >= 0 && minuteOfDay < minutesPerDay);

  /// The wall-clock time at [utc] in a zone that is [offset] ahead of UTC.
  factory LocalDateTime.fromUtc(DateTime utc, Duration offset) {
    final wall = utc.toUtc().add(offset);
    return LocalDateTime(
      LocalDate(wall.year, wall.month, wall.day),
      wall.hour * 60 + wall.minute,
    );
  }

  /// Parses `yyyy-MM-ddTHH:mm`.
  factory LocalDateTime.parse(String value) {
    final parts = value.split('T');
    final time = parts[1].split(':');
    return LocalDateTime(
      LocalDate.parse(parts[0]),
      int.parse(time[0]) * 60 + int.parse(time[1]),
    );
  }

  static const minutesPerDay = 24 * 60;

  final LocalDate date;
  final int minuteOfDay;

  int get hour => minuteOfDay ~/ 60;
  int get minute => minuteOfDay % 60;

  LocalDateTime addMinutes(int minutes) {
    final total = minuteOfDay + minutes;
    final days = (total / minutesPerDay).floor();
    return LocalDateTime(date.addDays(days), total - days * minutesPerDay);
  }

  /// Minutes from this moment to [other]; negative when [other] is earlier.
  int minutesUntil(LocalDateTime other) =>
      date.daysUntil(other.date) * minutesPerDay +
      other.minuteOfDay -
      minuteOfDay;

  /// The UTC instant of this wall-clock time in a zone [offset] ahead of UTC.
  DateTime toUtc(Duration offset) => DateTime.utc(
    date.year,
    date.month,
    date.day,
    hour,
    minute,
  ).subtract(offset);

  bool isBefore(LocalDateTime other) => compareTo(other) < 0;
  bool isAfter(LocalDateTime other) => compareTo(other) > 0;

  String toIso() =>
      '${date.toIso()}T${hour.toString().padLeft(2, '0')}:'
      '${minute.toString().padLeft(2, '0')}';

  @override
  int compareTo(LocalDateTime other) {
    final byDate = date.compareTo(other.date);
    return byDate != 0 ? byDate : minuteOfDay.compareTo(other.minuteOfDay);
  }

  @override
  bool operator ==(Object other) =>
      other is LocalDateTime &&
      other.date == date &&
      other.minuteOfDay == minuteOfDay;

  @override
  int get hashCode => Object.hash(date, minuteOfDay);

  @override
  String toString() => toIso();
}
