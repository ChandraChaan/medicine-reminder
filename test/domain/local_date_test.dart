import 'package:flutter_test/flutter_test.dart';
import 'package:medicine_reminder/core/time/local_date.dart';

void main() {
  group('LocalDate', () {
    test('adds days across month, year and leap-day boundaries', () {
      expect(
        const LocalDate(2026, 1, 31).addDays(1),
        const LocalDate(2026, 2, 1),
      );
      expect(
        const LocalDate(2026, 12, 31).addDays(1),
        const LocalDate(2027, 1, 1),
      );
      expect(
        const LocalDate(2028, 2, 28).addDays(1),
        const LocalDate(2028, 2, 29),
      );
      expect(
        const LocalDate(2026, 3, 1).addDays(-1),
        const LocalDate(2026, 2, 28),
      );
    });

    test('counts days between dates', () {
      expect(
        const LocalDate(2026, 3, 10).daysUntil(const LocalDate(2026, 4, 9)),
        30,
      );
      expect(
        const LocalDate(2026, 3, 10).daysUntil(const LocalDate(2026, 3, 9)),
        -1,
      );
    });

    test('parses and prints ISO dates', () {
      expect(LocalDate.parse('2026-03-09').toIso(), '2026-03-09');
      expect(() => LocalDate.parse('2026/03/09'), throwsFormatException);
    });

    test('knows the weekday', () {
      expect(const LocalDate(2026, 10, 28).weekday, DateTime.wednesday);
    });
  });

  group('LocalDateTime', () {
    const date = LocalDate(2026, 3, 10);

    test('adding minutes rolls over midnight both ways', () {
      expect(
        const LocalDateTime(date, 23 * 60 + 55).addMinutes(10),
        LocalDateTime(date.addDays(1), 5),
      );
      expect(
        const LocalDateTime(date, 5).addMinutes(-10),
        LocalDateTime(date.addDays(-1), 23 * 60 + 55),
      );
      expect(
        const LocalDateTime(date, 0).addMinutes(3 * 24 * 60),
        LocalDateTime(date.addDays(3), 0),
      );
    });

    test('minutesUntil spans days', () {
      expect(
        const LocalDateTime(
          date,
          23 * 60,
        ).minutesUntil(LocalDateTime(date.addDays(1), 60)),
        120,
      );
    });

    test('the same instant is a different wall-clock time in each zone', () {
      final instant = DateTime.utc(2026, 3, 9, 20, 0);
      expect(
        LocalDateTime.fromUtc(instant, const Duration(hours: 5, minutes: 30)),
        const LocalDateTime(LocalDate(2026, 3, 10), 90), // 01:30 IST next day
      );
      expect(
        LocalDateTime.fromUtc(instant, const Duration(hours: -7)),
        const LocalDateTime(LocalDate(2026, 3, 9), 13 * 60),
      );
    });

    test('8:00 wall-clock maps to the right UTC instant per zone', () {
      const eight = LocalDateTime(date, 8 * 60);
      expect(
        eight.toUtc(const Duration(hours: 5, minutes: 30)),
        DateTime.utc(2026, 3, 10, 2, 30),
      );
      expect(
        eight.toUtc(const Duration(hours: -5)),
        DateTime.utc(2026, 3, 10, 13),
      );
      expect(
        eight.toUtc(const Duration(hours: 9)),
        DateTime.utc(2026, 3, 9, 23),
      );
    });

    test('round-trips through ISO text', () {
      const value = LocalDateTime(date, 21 * 60 + 5);
      expect(value.toIso(), '2026-03-10T21:05');
      expect(LocalDateTime.parse(value.toIso()), value);
    });
  });
}
