import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/platform/alarm_bridge.dart';
import '../../../core/providers.dart';
import '../../../core/time/clock.dart';
import '../../../core/time/local_date.dart';
import '../domain/schedule.dart';
import 'dose_controller.dart';

/// Turns planned alarms into what Android stores: one entry per minute, with
/// the notification text already in the chosen language.
List<AlarmEntry> buildAlarmEntries(AppData data, LocalDateTime now) {
  final l10n = l10nFor(data.settings.language);
  final plan = planAlarms(
    data.medicines,
    data.log,
    now,
    missedAfterMinutes: data.missedAfter,
  );
  return [
    for (final (index, alarm) in plan.indexed)
      AlarmEntry(
        id: index + 1,
        kind: AlarmKind.ring,
        at: alarm.at,
        title: l10n.alarmTitle,
        body: [
          for (final dose in alarm.doses)
            '${dose.medicine.name}: ${doseLabel(l10n, dose.medicine)}, '
                '${foodLabel(l10n, dose.medicine.food)}',
        ].join('\n'),
      ),
  ];
}

/// Keeps Android's alarms in step with the medicines and the dose log.
final alarmSyncProvider = Provider<AlarmSync>((ref) {
  final sync = AlarmSync(ref);
  ref.listen(appDataProvider, (_, next) {
    if (next case AsyncData(:final value)) unawaited(sync.push(value));
  }, fireImmediately: true);
  return sync;
});

class AlarmSync {
  AlarmSync(this._ref);

  final Ref _ref;

  Future<void> push(AppData data) async {
    final l10n = l10nFor(data.settings.language);
    final entries = buildAlarmEntries(
      data,
      _ref.read(clockProvider).nowLocal(),
    );
    try {
      await _ref
          .read(alarmBridgeProvider)
          .scheduleAll(
            entries,
            ChannelNames(
              alarms: l10n.channelAlarms,
              notices: l10n.channelNotices,
            ),
          );
    } on Exception catch (error, stack) {
      // Nothing to show the person; the next change or app start retries.
      debugPrint('Scheduling alarms failed: $error\n$stack');
    }
  }

  /// Re-plans from scratch, for example when the app comes back to the front.
  Future<void> resync() async => push(await _ref.read(appDataProvider.future));
}
