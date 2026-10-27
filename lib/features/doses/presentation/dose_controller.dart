import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/providers.dart';
import '../../../core/time/clock.dart';
import '../../medicines/domain/medicine.dart';
import '../../medicines/presentation/medicines_controller.dart';
import '../../settings/domain/app_settings.dart';
import '../../settings/presentation/settings_controller.dart';
import '../domain/dose.dart';
import '../domain/refill.dart';
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

/// Counted medicines that are running low, most urgent first.
final refillWarningsProvider =
    Provider<AsyncValue<List<(Medicine, RefillForecast)>>>((ref) {
      final data = ref.watch(appDataProvider);
      final now =
          ref.watch(nowProvider).value ?? ref.read(clockProvider).nowLocal();
      return data.whenData((d) {
        final warnings = [
          for (final medicine in d.medicines)
            if (forecastRefill(
                  medicine,
                  d.log,
                  now,
                  missedAfterMinutes: d.missedAfter,
                )
                case final forecast? when forecast.needsRefill)
              (medicine, forecast),
        ];
        warnings.sort((a, b) => a.$2.daysLeft!.compareTo(b.$2.daysLeft!));
        return warnings;
      });
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
    final updated = await ref
        .read(medicinesProvider.notifier)
        .useDose(dose.medicine.id);
    if (updated != null) await _warnIfLow(updated);
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

  /// Clears a mistaken Taken or Skip; a Taken dose goes back into the count.
  Future<void> undo(DoseOccurrence dose, {required bool wasTaken}) async {
    final current = await future;
    await ref.read(doseLogRepositoryProvider).clearAnswer(dose.key);
    if (wasTaken) {
      await ref.read(medicinesProvider.notifier).returnDose(dose.medicine.id);
    }
    if (!ref.mounted) return;
    state = AsyncData([
      for (final e in current)
        if (e.key != dose.key || e.action == DoseAction.snoozed) e,
    ]);
  }

  Future<void> _warnIfLow(Medicine medicine) async {
    final settings = await ref.read(settingsProvider.future);
    final forecast = forecastRefill(
      medicine,
      DoseLog(await future),
      ref.read(clockProvider).nowLocal(),
      missedAfterMinutes: settings.missedAfterMinutes,
    );
    if (forecast == null || !forecast.needsRefill) return;
    final l10n = l10nFor(settings.language);
    final days = forecast.daysLeft!;
    await ref
        .read(alarmBridgeProvider)
        .showNotice(
          id: 9000 + medicine.id.hashCode.abs() % 1000,
          title: l10n.refillNoticeTitle(medicine.name),
          body: days == 0
              ? l10n.refillRunOut(medicine.name)
              : l10n.refillDaysLeft(medicine.name, days),
        );
  }
}
