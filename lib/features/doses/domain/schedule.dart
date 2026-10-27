import 'package:meta/meta.dart';

import '../../../core/time/local_date.dart';
import '../../medicines/domain/medicine.dart';
import 'dose.dart';

/// Minutes added by one "Snooze".
const snoozeMinutes = 10;

/// After this many snoozes only Taken and Skip are offered.
const maxSnoozes = 3;

/// Doses the alarm screen still offers after they count as missed.
const alarmLookbackMinutes = 4 * 60;

/// Every recorded event, grouped by dose.
class DoseLog {
  DoseLog(Iterable<DoseEvent> events) {
    for (final event in events) {
      (_byKey[event.key] ??= []).add(event);
    }
    for (final list in _byKey.values) {
      list.sort((a, b) => a.atUtc.compareTo(b.atUtc));
    }
  }

  static final empty = DoseLog(const []);

  final Map<DoseKey, List<DoseEvent>> _byKey = {};

  List<DoseEvent> eventsFor(DoseKey key) => _byKey[key] ?? const [];
}

/// Doses of [medicines] on [date], ordered by time then name.
List<DoseOccurrence> occurrencesOn(
  Iterable<Medicine> medicines,
  LocalDate date,
) {
  final result = <DoseOccurrence>[
    for (final medicine in medicines)
      if (medicine.isScheduledOn(date))
        for (final minute in medicine.times)
          DoseOccurrence(medicine, LocalDateTime(date, minute)),
  ];
  result.sort(_byTimeThenName);
  return result;
}

/// Doses from [from] to [to], both inclusive.
List<DoseOccurrence> occurrencesBetween(
  Iterable<Medicine> medicines,
  LocalDate from,
  LocalDate to,
) => [
  for (var day = from; !day.isAfter(to); day = day.addDays(1))
    ...occurrencesOn(medicines, day),
];

int _byTimeThenName(DoseOccurrence a, DoseOccurrence b) {
  final byTime = a.scheduled.compareTo(b.scheduled);
  return byTime != 0
      ? byTime
      : a.medicine.name.toLowerCase().compareTo(b.medicine.name.toLowerCase());
}

/// What the log says about one dose, before looking at the clock.
@immutable
class _Answer {
  const _Answer(this.answer, this.snoozeCount, this.snoozedUntil);

  factory _Answer.of(DoseOccurrence dose, DoseLog log) {
    DoseEvent? answer;
    var snoozes = 0;
    LocalDateTime? until;
    for (final event in log.eventsFor(dose.key)) {
      switch (event.action) {
        case DoseAction.taken:
        case DoseAction.skipped:
          answer = event;
        case DoseAction.snoozed:
          snoozes++;
          final next = event.snoozedUntil!;
          if (until == null || next.isAfter(until)) until = next;
      }
    }
    return _Answer(answer, snoozes, until);
  }

  final DoseEvent? answer;
  final int snoozeCount;
  final LocalDateTime? snoozedUntil;
}

/// When an unanswered dose counts as missed: [missedAfterMinutes] after it
/// was due, or after the last snooze ended if that is later.
LocalDateTime missedDeadline(
  DoseOccurrence dose,
  DoseLog log, {
  required int missedAfterMinutes,
}) {
  final until = _Answer.of(dose, log).snoozedUntil;
  final base = until != null && until.isAfter(dose.scheduled)
      ? until
      : dose.scheduled;
  return base.addMinutes(missedAfterMinutes);
}

DoseStatus doseStatus(
  DoseOccurrence dose,
  DoseLog log,
  LocalDateTime now, {
  required int missedAfterMinutes,
}) {
  final info = _Answer.of(dose, log);
  final answer = info.answer;
  if (answer != null) {
    return answer.action == DoseAction.taken
        ? DoseTaken(answer.atUtc)
        : DoseSkipped(answer.atUtc);
  }
  if (now.isBefore(dose.scheduled)) return const DoseUpcoming();
  final until = info.snoozedUntil;
  if (until != null && now.isBefore(until)) {
    return DoseSnoozed(until: until, snoozeCount: info.snoozeCount);
  }
  final deadline = missedDeadline(
    dose,
    log,
    missedAfterMinutes: missedAfterMinutes,
  );
  if (!now.isBefore(deadline)) return const DoseMissed();
  return DoseDue(snoozeCount: info.snoozeCount);
}

/// Every dose on [date] with its status at [now].
List<DoseState> dayStates(
  Iterable<Medicine> medicines,
  DoseLog log,
  LocalDate date,
  LocalDateTime now, {
  required int missedAfterMinutes,
}) => [
  for (final dose in occurrencesOn(medicines, date))
    DoseState(
      dose,
      doseStatus(dose, log, now, missedAfterMinutes: missedAfterMinutes),
    ),
];

/// Doses the alarm screen should ask about at [now]: due ones, plus ones
/// missed in the last [alarmLookbackMinutes] so a late "Taken" still counts.
List<DoseOccurrence> pendingDoses(
  Iterable<Medicine> medicines,
  DoseLog log,
  LocalDateTime now, {
  required int missedAfterMinutes,
}) => [
  for (final dose in occurrencesBetween(
    medicines,
    now.date.addDays(-1),
    now.date,
  ))
    if (switch (doseStatus(
      dose,
      log,
      now,
      missedAfterMinutes: missedAfterMinutes,
    )) {
      DoseDue() => true,
      DoseMissed() => dose.scheduled.minutesUntil(now) <= alarmLookbackMinutes,
      _ => false,
    })
      dose,
];

/// One alarm that rings for one or more doses at the same minute.
@immutable
class PlannedAlarm {
  const PlannedAlarm(this.at, this.doses);

  final LocalDateTime at;
  final List<DoseOccurrence> doses;
}

/// Alarms to hand to Android: every unanswered dose from [now] up to
/// [horizonDays] ahead, snoozes included, grouped by minute.
///
/// The app re-plans whenever it opens or an alarm rings, so a week ahead is
/// plenty, and [maxAlarms] keeps well under Android's 500-alarm limit.
List<PlannedAlarm> planAlarms(
  Iterable<Medicine> medicines,
  DoseLog log,
  LocalDateTime now, {
  required int missedAfterMinutes,
  int horizonDays = 7,
  int maxAlarms = 200,
}) {
  final end = now.addMinutes(horizonDays * LocalDateTime.minutesPerDay);
  final byMinute = <LocalDateTime, List<DoseOccurrence>>{};
  for (final dose in occurrencesBetween(
    medicines,
    now.date.addDays(-1),
    end.date,
  )) {
    final at = switch (doseStatus(
      dose,
      log,
      now,
      missedAfterMinutes: missedAfterMinutes,
    )) {
      DoseUpcoming() => dose.scheduled,
      DoseSnoozed(:final until) => until,
      _ => null,
    };
    if (at == null || at.isAfter(end)) continue;
    (byMinute[at] ??= []).add(dose);
  }
  final times = byMinute.keys.toList()..sort();
  return [
    for (final at in times.take(maxAlarms)) PlannedAlarm(at, byMinute[at]!),
  ];
}

/// Taken, skipped and missed doses on one day, for the history calendar.
@immutable
class DaySummary {
  const DaySummary({
    required this.date,
    required this.taken,
    required this.skipped,
    required this.missed,
    required this.open,
  });

  final LocalDate date;
  final int taken;
  final int skipped;
  final int missed;

  /// Upcoming, due or snoozed: not decided yet.
  final int open;

  int get total => taken + skipped + missed + open;
  bool get hasDoses => total > 0;
}

DaySummary summarizeDay(
  Iterable<Medicine> medicines,
  DoseLog log,
  LocalDate date,
  LocalDateTime now, {
  required int missedAfterMinutes,
}) {
  var taken = 0, skipped = 0, missed = 0, open = 0;
  for (final state in dayStates(
    medicines,
    log,
    date,
    now,
    missedAfterMinutes: missedAfterMinutes,
  )) {
    switch (state.status) {
      case DoseTaken():
        taken++;
      case DoseSkipped():
        skipped++;
      case DoseMissed():
        missed++;
      case DoseUpcoming() || DoseDue() || DoseSnoozed():
        open++;
    }
  }
  return DaySummary(
    date: date,
    taken: taken,
    skipped: skipped,
    missed: missed,
    open: open,
  );
}

/// A moment to check on doses that may still be unanswered: if they are not
/// marked Taken by [at], the family is told.
@immutable
class PlannedCheck {
  const PlannedCheck(this.at, this.doses);

  final LocalDateTime at;
  final List<DoseOccurrence> doses;
}

/// One check per missed-dose deadline from [now] up to [horizonDays] ahead,
/// for every dose not yet marked Taken. Skipped doses are included: a Skip
/// pressed by mistake is exactly what the family would want to know about.
List<PlannedCheck> planFamilyChecks(
  Iterable<Medicine> medicines,
  DoseLog log,
  LocalDateTime now, {
  required int missedAfterMinutes,
  int horizonDays = 7,
  int maxChecks = 200,
}) {
  final end = now.addMinutes(horizonDays * LocalDateTime.minutesPerDay);
  final byMinute = <LocalDateTime, List<DoseOccurrence>>{};
  for (final dose in occurrencesBetween(
    medicines,
    now.date.addDays(-1),
    end.date,
  )) {
    final status = doseStatus(
      dose,
      log,
      now,
      missedAfterMinutes: missedAfterMinutes,
    );
    if (status is DoseTaken || status is DoseMissed) continue;
    final deadline = missedDeadline(
      dose,
      log,
      missedAfterMinutes: missedAfterMinutes,
    );
    if (!deadline.isAfter(now) || deadline.isAfter(end)) continue;
    (byMinute[deadline] ??= []).add(dose);
  }
  final times = byMinute.keys.toList()..sort();
  return [
    for (final at in times.take(maxChecks)) PlannedCheck(at, byMinute[at]!),
  ];
}
