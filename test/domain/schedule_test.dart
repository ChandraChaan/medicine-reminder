import 'package:flutter_test/flutter_test.dart';
import 'package:medicine_reminder/core/time/local_date.dart';
import 'package:medicine_reminder/features/doses/domain/dose.dart';
import 'package:medicine_reminder/features/doses/domain/schedule.dart';
import 'package:medicine_reminder/features/medicines/domain/medicine.dart';

import '../helpers/test_data.dart';

DoseEvent event(
  Medicine m,
  LocalDateTime scheduled,
  DoseAction action, {
  LocalDateTime? until,
  int minute = 0,
}) => DoseEvent(
  key: DoseKey(m.id, scheduled),
  action: action,
  atUtc: DateTime.utc(2026, 3, 10, 0, minute),
  snoozedUntil: until,
);

DoseStatus status(
  Medicine m,
  LocalDateTime scheduled,
  List<DoseEvent> events,
  LocalDateTime now, {
  int missedAfter = 60,
}) => doseStatus(
  DoseOccurrence(m, scheduled),
  DoseLog(events),
  now,
  missedAfterMinutes: missedAfter,
);

void main() {
  group('occurrences', () {
    test('start and end dates are both inclusive', () {
      final m = med(start: day1, end: day1.addDays(2));
      expect(occurrencesOn([m], day1.addDays(-1)), isEmpty);
      expect(occurrencesOn([m], day1), hasLength(1));
      expect(occurrencesOn([m], day1.addDays(2)), hasLength(1));
      expect(occurrencesOn([m], day1.addDays(3)), isEmpty);
    });

    test('only on chosen weekdays', () {
      // day1 (10 March 2026) is a Tuesday.
      final m = med(weekdays: {DateTime.tuesday, DateTime.friday});
      final week = occurrencesBetween([m], day1, day1.addDays(6));
      expect(
        [for (final d in week) d.scheduled.date.weekday],
        [DateTime.tuesday, DateTime.friday],
      );
    });

    test('doses at midnight and at 23:59 belong to their own day', () {
      final m = med(times: [0, 23 * 60 + 59]);
      final doses = occurrencesOn([m], day1);
      expect(doses.map((d) => d.scheduled), [
        const LocalDateTime(day1, 0),
        const LocalDateTime(day1, 23 * 60 + 59),
      ]);
    });

    test('sorted by time, then name', () {
      final a = med(id: 'a', name: 'Zinc', times: [8 * 60]);
      final b = med(id: 'b', name: 'aspirin', times: [8 * 60, 7 * 60]);
      expect(
        occurrencesOn([
          a,
          b,
        ], day1).map((d) => '${d.scheduled.hour}${d.medicine.name}'),
        ['7aspirin', '8aspirin', '8Zinc'],
      );
    });
  });

  group('status and missed-dose detection', () {
    final m = med();
    final eight = at(day1, 8);

    test('upcoming before, due at the minute, missed after the window', () {
      expect(status(m, eight, [], at(day1, 7, 59)), isA<DoseUpcoming>());
      expect(status(m, eight, [], eight), isA<DoseDue>());
      expect(status(m, eight, [], at(day1, 8, 59)), isA<DoseDue>());
      expect(status(m, eight, [], at(day1, 9)), isA<DoseMissed>());
    });

    test('the missed window is configurable', () {
      expect(
        status(m, eight, [], at(day1, 8, 30), missedAfter: 30),
        isA<DoseMissed>(),
      );
      expect(
        status(m, eight, [], at(day1, 9, 30), missedAfter: 120),
        isA<DoseDue>(),
      );
    });

    test('taken and skipped are final, even long after', () {
      expect(
        status(m, eight, [event(m, eight, DoseAction.taken)], at(day1, 23)),
        isA<DoseTaken>(),
      );
      expect(
        status(m, eight, [event(m, eight, DoseAction.skipped)], at(day1, 23)),
        isA<DoseSkipped>(),
      );
    });

    test('a late Taken still counts after the dose was missed', () {
      final events = [event(m, eight, DoseAction.taken, minute: 30)];
      expect(status(m, eight, events, at(day1, 11)), isA<DoseTaken>());
    });

    test('the latest answer wins', () {
      final events = [
        event(m, eight, DoseAction.skipped, minute: 1),
        event(m, eight, DoseAction.taken, minute: 2),
      ];
      expect(status(m, eight, events, at(day1, 9)), isA<DoseTaken>());
    });

    test('snooze holds the dose, then it is due again', () {
      final until = at(day1, 8, 10);
      final events = [event(m, eight, DoseAction.snoozed, until: until)];
      expect(status(m, eight, events, at(day1, 8, 5)), isA<DoseSnoozed>());
      final again = status(m, eight, events, at(day1, 8, 10));
      expect(again, isA<DoseDue>());
      expect((again as DoseDue).snoozeCount, 1);
    });

    test('snoozing moves the missed deadline to after the snooze', () {
      final until = at(day1, 8, 55);
      final events = [event(m, eight, DoseAction.snoozed, until: until)];
      expect(
        missedDeadline(
          DoseOccurrence(m, eight),
          DoseLog(events),
          missedAfterMinutes: 60,
        ),
        at(day1, 9, 55),
      );
      expect(status(m, eight, events, at(day1, 9, 30)), isA<DoseDue>());
      expect(status(m, eight, events, at(day1, 9, 55)), isA<DoseMissed>());
    });

    test('a snooze past midnight keeps the dose on its own day', () {
      final late = at(day1, 23, 55);
      final lateMed = med(times: [late.minuteOfDay]);
      final until = late.addMinutes(snoozeMinutes);
      expect(until.date, day1.addDays(1));
      final events = [event(lateMed, late, DoseAction.snoozed, until: until)];
      final next = at(day1.addDays(1), 0, 1);
      expect(status(lateMed, late, events, next), isA<DoseSnoozed>());
      final states = dayStates(
        [lateMed],
        DoseLog(events),
        day1,
        next,
        missedAfterMinutes: 60,
      );
      expect(states.single.occurrence.scheduled, late);
    });
  });

  group('pendingDoses (what the alarm screen asks about)', () {
    final bp = med(id: 'bp', times: [8 * 60, 20 * 60]);
    final sugar = med(id: 'sugar', name: 'Sugar tablet', times: [8 * 60]);

    test('lists every unanswered due dose of the minute', () {
      final pending = pendingDoses(
        [bp, sugar],
        DoseLog.empty,
        at(day1, 8, 1),
        missedAfterMinutes: 60,
      );
      expect(pending.map((d) => d.medicine.id), ['bp', 'sugar']);
    });

    test('drops answered and snoozed doses', () {
      final log = DoseLog([
        event(bp, at(day1, 8), DoseAction.taken),
        event(sugar, at(day1, 8), DoseAction.snoozed, until: at(day1, 8, 10)),
      ]);
      expect(
        pendingDoses([bp, sugar], log, at(day1, 8, 2), missedAfterMinutes: 60),
        isEmpty,
      );
    });

    test('keeps recently missed doses so a late Taken is possible', () {
      expect(
        pendingDoses(
          [bp],
          DoseLog.empty,
          at(day1, 11),
          missedAfterMinutes: 60,
        ).single.scheduled,
        at(day1, 8),
      );
      expect(
        pendingDoses(
          [bp],
          DoseLog.empty,
          at(day1, 12, 1),
          missedAfterMinutes: 60,
        ),
        isEmpty,
      );
    });

    test("includes yesterday's late-night dose just after midnight", () {
      final night = med(times: [23 * 60 + 30]);
      expect(
        pendingDoses(
          [night],
          DoseLog.empty,
          at(day1.addDays(1), 0, 10),
          missedAfterMinutes: 60,
        ).single.scheduled,
        at(day1, 23, 30),
      );
    });
  });

  group('planAlarms (handed to Android, also after reboot)', () {
    final bp = med(id: 'bp', times: [8 * 60, 20 * 60]);
    final sugar = med(id: 'sugar', name: 'Sugar tablet', times: [8 * 60]);

    test('one alarm per minute, grouping medicines due together', () {
      final plan = planAlarms(
        [bp, sugar],
        DoseLog.empty,
        at(day1, 7),
        missedAfterMinutes: 60,
        horizonDays: 1,
      );
      // Tomorrow's 8:00 is past the one-day horizon (tomorrow 7:00).
      expect(plan.map((a) => a.at), [at(day1, 8), at(day1, 20)]);
      expect(plan.first.doses.map((d) => d.medicine.id), ['bp', 'sugar']);
    });

    test('never includes past, answered or due-now doses', () {
      final log = DoseLog([event(bp, at(day1, 20), DoseAction.skipped)]);
      final plan = planAlarms(
        [bp],
        log,
        at(day1, 8, 30),
        missedAfterMinutes: 60,
        horizonDays: 1,
      );
      // 8:00 is due now, 20:00 was skipped early: only tomorrow's 8:00.
      expect(plan.map((a) => a.at), [at(day1.addDays(1), 8)]);
    });

    test('a snoozed dose rings again at the snooze time', () {
      final log = DoseLog([
        event(bp, at(day1, 8), DoseAction.snoozed, until: at(day1, 8, 10)),
      ]);
      final plan = planAlarms(
        [bp],
        log,
        at(day1, 8, 1),
        missedAfterMinutes: 60,
        horizonDays: 1,
      );
      expect(plan.first.at, at(day1, 8, 10));
      expect(plan.first.doses.single.scheduled, at(day1, 8));
    });

    test('covers the horizon and respects the cap', () {
      final plan = planAlarms(
        [bp],
        DoseLog.empty,
        at(day1, 0),
        missedAfterMinutes: 60,
        horizonDays: 7,
      );
      expect(plan, hasLength(14));
      expect(plan.last.at, at(day1.addDays(6), 20));
      final capped = planAlarms(
        [bp],
        DoseLog.empty,
        at(day1, 0),
        missedAfterMinutes: 60,
        maxAlarms: 3,
      );
      expect(capped, hasLength(3));
    });

    test('after the clock jumps forward, missed times are not re-planned', () {
      // Phone was off from 7:00 to 9:00 (reboot) or the clock was corrected.
      final plan = planAlarms(
        [bp],
        DoseLog.empty,
        at(day1, 9),
        missedAfterMinutes: 60,
        horizonDays: 1,
      );
      expect(plan.first.at, at(day1, 20));
    });

    test('stops at the end date', () {
      final short = med(times: [8 * 60], end: day1.addDays(1));
      final plan = planAlarms(
        [short],
        DoseLog.empty,
        at(day1, 0),
        missedAfterMinutes: 60,
      );
      expect(plan.map((a) => a.at), [at(day1, 8), at(day1.addDays(1), 8)]);
    });
  });

  group('summarizeDay', () {
    test('counts taken, skipped, missed and open doses', () {
      final m = med(times: [8 * 60, 13 * 60, 20 * 60, 22 * 60]);
      final log = DoseLog([
        event(m, at(day1, 8), DoseAction.taken),
        event(m, at(day1, 13), DoseAction.skipped),
      ]);
      final summary = summarizeDay(
        [m],
        log,
        day1,
        at(day1, 21, 30),
        missedAfterMinutes: 60,
      );
      expect(
        (summary.taken, summary.skipped, summary.missed, summary.open),
        (1, 1, 1, 1),
      );
      expect(summary.total, 4);
    });
  });
}
