import 'package:meta/meta.dart';

import '../../../core/time/local_date.dart';
import '../../medicines/domain/medicine.dart';
import 'dose.dart';
import 'schedule.dart';

/// How long the medicine in hand will last.
@immutable
class RefillForecast {
  const RefillForecast({
    required this.dosesLeft,
    required this.runsOutOn,
    required this.daysLeft,
    required this.needsRefill,
  });

  /// Whole doses the remaining stock covers.
  final int dosesLeft;

  /// First day without enough for every dose; null if the course ends first.
  final LocalDate? runsOutOn;

  /// Days from today to [runsOutOn]; null when [runsOutOn] is null.
  final int? daysLeft;

  /// True when [daysLeft] is within the medicine's warning window.
  final bool needsRefill;
}

/// Looks ahead at most this far; a stock that lasts longer is "plenty".
const _maxLookaheadDays = 366;

/// Walks the schedule from [now] and finds the day the stock runs out.
///
/// Today's doses that are already taken, skipped or missed don't use any
/// more stock. Returns null when the medicine's stock isn't counted.
RefillForecast? forecastRefill(
  Medicine medicine,
  DoseLog log,
  LocalDateTime now, {
  required int missedAfterMinutes,
}) {
  final stock = medicine.stockQuarters;
  if (stock == null) return null;
  final dosesLeft = medicine.doseQuarters <= 0
      ? 0
      : stock ~/ medicine.doseQuarters;
  var remaining = dosesLeft;
  final today = now.date;
  for (var offset = 0; offset < _maxLookaheadDays; offset++) {
    final day = today.addDays(offset);
    final end = medicine.endDate;
    if (end != null && day.isAfter(end)) break;
    for (final dose in occurrencesOn([medicine], day)) {
      if (offset == 0) {
        final status = doseStatus(
          dose,
          log,
          now,
          missedAfterMinutes: missedAfterMinutes,
        );
        if (status is DoseTaken ||
            status is DoseSkipped ||
            status is DoseMissed) {
          continue;
        }
      }
      if (remaining == 0) {
        return RefillForecast(
          dosesLeft: dosesLeft,
          runsOutOn: day,
          daysLeft: offset,
          needsRefill: offset <= medicine.refillWarnDays,
        );
      }
      remaining--;
    }
  }
  return RefillForecast(
    dosesLeft: dosesLeft,
    runsOutOn: null,
    daysLeft: null,
    needsRefill: false,
  );
}

/// Stock after taking one dose; never below zero.
int stockAfterDose(int stockQuarters, int doseQuarters) =>
    stockQuarters - doseQuarters < 0 ? 0 : stockQuarters - doseQuarters;
