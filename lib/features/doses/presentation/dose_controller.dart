import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';

import '../../../core/providers.dart';
import '../../../core/time/clock.dart';
import '../../medicines/domain/medicine.dart';
import '../../medicines/presentation/medicines_controller.dart';
import '../../settings/domain/app_settings.dart';
import '../../settings/presentation/settings_controller.dart';
import '../domain/dose.dart';
import '../domain/schedule.dart';

/// Medicines, the dose log and settings, loaded together.
@immutable
class AppData {
  const AppData(this.medicines, this.log, this.settings);

  final List<Medicine> medicines;
  final DoseLog log;
  final AppSettings settings;

  int get missedAfter => settings.missedAfterMinutes;
}

final doseEventsProvider =
    AsyncNotifierProvider<DoseEventsController, List<DoseEvent>>(
      DoseEventsController.new,
    );

final appDataProvider = FutureProvider<AppData>((ref) async {
  final medicines = await ref.watch(medicinesProvider.future);
  final events = await ref.watch(doseEventsProvider.future);
  final settings = await ref.watch(settingsProvider.future);
  return AppData(medicines, DoseLog(events), settings);
});

/// Today's doses with their live status.
final todayProvider = Provider<AsyncValue<List<DoseState>>>((ref) {
  final data = ref.watch(appDataProvider);
  final now =
      ref.watch(nowProvider).value ?? ref.read(clockProvider).nowLocal();
  return data.whenData(
    (d) => dayStates(
      d.medicines,
      d.log,
      now.date,
      now,
      missedAfterMinutes: d.missedAfter,
    ),
  );
});

/// Doses the alarm screen should ask about right now.
final pendingDosesProvider = Provider<AsyncValue<List<DoseState>>>((ref) {
  final data = ref.watch(appDataProvider);
  final now =
      ref.watch(nowProvider).value ?? ref.read(clockProvider).nowLocal();
  return data.whenData(
    (d) => [
      for (final dose in pendingDoses(
        d.medicines,
        d.log,
        now,
        missedAfterMinutes: d.missedAfter,
      ))
        DoseState(
          dose,
          doseStatus(dose, d.log, now, missedAfterMinutes: d.missedAfter),
        ),
    ],
  );
});

/// Records what the person did with each dose.
class DoseEventsController extends AsyncNotifier<List<DoseEvent>> {
  @override
  Future<List<DoseEvent>> build() =>
      ref.watch(doseLogRepositoryProvider).loadAll();

  Future<void> _add(DoseEvent event) async {
    final current = await future;
    await ref.read(doseLogRepositoryProvider).add(event);
    if (!ref.mounted) return;
    state = AsyncData([...current, event]);
  }

  DateTime get _nowUtc => ref.read(clockProvider).nowUtc();

  Future<void> take(DoseOccurrence dose) async {
    await _add(
      DoseEvent(key: dose.key, action: DoseAction.taken, atUtc: _nowUtc),
    );
  }

  Future<void> skip(DoseOccurrence dose) => _add(
    DoseEvent(key: dose.key, action: DoseAction.skipped, atUtc: _nowUtc),
  );

  Future<void> snooze(DoseOccurrence dose) {
    final now = ref.read(clockProvider).nowLocal();
    return _add(
      DoseEvent(
        key: dose.key,
        action: DoseAction.snoozed,
        atUtc: _nowUtc,
        snoozedUntil: now.addMinutes(snoozeMinutes),
      ),
    );
  }

  /// Clears a mistaken Done or Skip.
  Future<void> undo(DoseOccurrence dose) async {
    final current = await future;
    await ref.read(doseLogRepositoryProvider).clearAnswer(dose.key);
    if (!ref.mounted) return;
    state = AsyncData([
      for (final e in current)
        if (e.key != dose.key || e.action == DoseAction.snoozed) e,
    ]);
  }
}
