import 'package:meta/meta.dart';

import '../../../core/time/local_date.dart';
import '../../medicines/domain/medicine.dart';

/// Identifies one planned dose: a medicine at one wall-clock time.
@immutable
class DoseKey {
  const DoseKey(this.medicineId, this.scheduled);

  final String medicineId;
  final LocalDateTime scheduled;

  @override
  bool operator ==(Object other) =>
      other is DoseKey &&
      other.medicineId == medicineId &&
      other.scheduled == scheduled;

  @override
  int get hashCode => Object.hash(medicineId, scheduled);

  @override
  String toString() => '$medicineId@${scheduled.toIso()}';
}

/// A dose the schedule says should happen.
@immutable
class DoseOccurrence {
  const DoseOccurrence(this.medicine, this.scheduled);

  final Medicine medicine;
  final LocalDateTime scheduled;

  DoseKey get key => DoseKey(medicine.id, scheduled);

  @override
  bool operator ==(Object other) =>
      other is DoseOccurrence &&
      other.medicine.id == medicine.id &&
      other.scheduled == scheduled;

  @override
  int get hashCode => key.hashCode;
}

enum DoseAction { taken, skipped, snoozed }

/// Something the person did with a dose.
@immutable
class DoseEvent {
  const DoseEvent({
    required this.key,
    required this.action,
    required this.atUtc,
    this.snoozedUntil,
  }) : assert(action != DoseAction.snoozed || snoozedUntil != null);

  final DoseKey key;
  final DoseAction action;
  final DateTime atUtc;

  /// Only for [DoseAction.snoozed]: when to ring again.
  final LocalDateTime? snoozedUntil;

  @override
  bool operator ==(Object other) =>
      other is DoseEvent &&
      other.key == key &&
      other.action == action &&
      other.atUtc == atUtc &&
      other.snoozedUntil == snoozedUntil;

  @override
  int get hashCode => Object.hash(key, action, atUtc, snoozedUntil);
}

/// What is happening with a dose right now.
@immutable
sealed class DoseStatus {
  const DoseStatus();
}

/// Not time yet.
final class DoseUpcoming extends DoseStatus {
  const DoseUpcoming();
}

/// Time to take it, and no answer yet.
final class DoseDue extends DoseStatus {
  const DoseDue({required this.snoozeCount});

  final int snoozeCount;
}

/// Snoozed; rings again at [until].
final class DoseSnoozed extends DoseStatus {
  const DoseSnoozed({required this.until, required this.snoozeCount});

  final LocalDateTime until;
  final int snoozeCount;
}

final class DoseTaken extends DoseStatus {
  const DoseTaken(this.atUtc);

  final DateTime atUtc;
}

final class DoseSkipped extends DoseStatus {
  const DoseSkipped(this.atUtc);

  final DateTime atUtc;
}

/// No answer within the missed-dose window.
final class DoseMissed extends DoseStatus {
  const DoseMissed();
}

/// A dose together with its current status.
@immutable
class DoseState {
  const DoseState(this.occurrence, this.status);

  final DoseOccurrence occurrence;
  final DoseStatus status;
}
