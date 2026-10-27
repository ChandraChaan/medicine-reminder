import 'package:flutter_test/flutter_test.dart';
import 'package:medicine_reminder/features/doses/domain/dose.dart';
import 'package:medicine_reminder/features/doses/domain/refill.dart';
import 'package:medicine_reminder/features/doses/domain/schedule.dart';

import '../helpers/test_data.dart';

void main() {
  test('not counted means no forecast', () {
    expect(
      forecastRefill(med(), DoseLog.empty, at(day1, 7), missedAfterMinutes: 60),
      isNull,
    );
  });

  test('twice a day with 10 tablets lasts 5 days', () {
    final m = med(
      times: [8 * 60, 20 * 60],
      stockQuarters: 10 * 4,
      refillWarnDays: 3,
    );
    final f = forecastRefill(
      m,
      DoseLog.empty,
      at(day1, 7),
      missedAfterMinutes: 60,
    )!;
    expect(f.dosesLeft, 10);
    expect(f.runsOutOn, day1.addDays(5));
    expect(f.daysLeft, 5);
    expect(f.needsRefill, isFalse);
  });

  test('warns within the warning window', () {
    final m = med(
      times: [8 * 60, 20 * 60],
      stockQuarters: 6 * 4,
      refillWarnDays: 3,
    );
    final f = forecastRefill(
      m,
      DoseLog.empty,
      at(day1, 7),
      missedAfterMinutes: 60,
    )!;
    expect(f.daysLeft, 3);
    expect(f.needsRefill, isTrue);
  });

  test("today's answered doses don't use stock again", () {
    final m = med(times: [8 * 60, 20 * 60], stockQuarters: 2 * 4);
    final log = DoseLog([
      DoseEvent(
        key: DoseKey(m.id, at(day1, 8)),
        action: DoseAction.taken,
        atUtc: DateTime.utc(2026),
      ),
    ]);
    final f = forecastRefill(m, log, at(day1, 9), missedAfterMinutes: 60)!;
    // 20:00 today and 08:00 tomorrow are covered; runs out tomorrow night.
    expect(f.runsOutOn, day1.addDays(1));
  });

  test('half tablets: 5 tablets at ½ a day lasts 10 days', () {
    final m = med(doseQuarters: 2, stockQuarters: 5 * 4, refillWarnDays: 2);
    final f = forecastRefill(
      m,
      DoseLog.empty,
      at(day1, 7),
      missedAfterMinutes: 60,
    )!;
    expect(f.dosesLeft, 10);
    expect(f.daysLeft, 10);
  });

  test('empty stock runs out today', () {
    final m = med(stockQuarters: 0);
    final f = forecastRefill(
      m,
      DoseLog.empty,
      at(day1, 7),
      missedAfterMinutes: 60,
    )!;
    expect((f.daysLeft, f.needsRefill), (0, true));
  });

  test('no warning when the course ends before the stock runs out', () {
    final m = med(stockQuarters: 3 * 4, end: day1.addDays(1));
    final f = forecastRefill(
      m,
      DoseLog.empty,
      at(day1, 7),
      missedAfterMinutes: 60,
    )!;
    expect(f.runsOutOn, isNull);
    expect(f.needsRefill, isFalse);
  });

  test('weekday-only medicines count only their days', () {
    // Tuesday and Friday only; 2 tablets: Tue 10th, Fri 13th; runs out Tue 17th.
    final m = med(
      weekdays: {DateTime.tuesday, DateTime.friday},
      stockQuarters: 2 * 4,
    );
    final f = forecastRefill(
      m,
      DoseLog.empty,
      at(day1, 7),
      missedAfterMinutes: 60,
    )!;
    expect(f.runsOutOn, day1.addDays(7));
  });

  test('stockAfterDose never goes below zero', () {
    expect(stockAfterDose(8, 4), 4);
    expect(stockAfterDose(2, 4), 0);
  });

  test('stock counts only whole doses', () {
    expect(
      forecastRefill(
        med(doseQuarters: 4, stockQuarters: 7),
        DoseLog.empty,
        at(day1, 7),
        missedAfterMinutes: 60,
      )!.dosesLeft,
      1,
    );
  });
}
