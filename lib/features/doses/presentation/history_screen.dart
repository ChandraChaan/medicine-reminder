import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/time/clock.dart';
import '../../../core/time/local_date.dart';
import '../../../core/widgets/async_view.dart';
import '../../../core/widgets/status_badge.dart';
import '../domain/dose.dart';
import '../domain/schedule.dart';
import 'dose_controller.dart';

@immutable
class MonthHistory {
  const MonthHistory(this.days);

  final List<DaySummary> days;

  int get taken => days.fold(0, (sum, d) => sum + d.taken);

  /// Doses already decided: taken, skipped or missed.
  int get decided =>
      days.fold(0, (sum, d) => sum + d.taken + d.skipped + d.missed);
}

/// Every day of the month that starts on [firstOfMonth], up to today.
final monthHistoryProvider =
    Provider.family<AsyncValue<MonthHistory>, LocalDate>((ref, firstOfMonth) {
      final data = ref.watch(appDataProvider);
      final now =
          ref.watch(nowProvider).value ?? ref.read(clockProvider).nowLocal();
      return data.whenData((d) {
        final days = <DaySummary>[];
        for (
          var day = firstOfMonth;
          day.month == firstOfMonth.month && !day.isAfter(now.date);
          day = day.addDays(1)
        ) {
          days.add(
            summarizeDay(
              d.medicines,
              d.log,
              day,
              now,
              missedAfterMinutes: d.missedAfter,
            ),
          );
        }
        return MonthHistory(days);
      });
    });

final dayDosesProvider =
    Provider.family<AsyncValue<List<DoseState>>, LocalDate>((ref, date) {
      final data = ref.watch(appDataProvider);
      final now =
          ref.watch(nowProvider).value ?? ref.read(clockProvider).nowLocal();
      return data.whenData(
        (d) => dayStates(
          d.medicines,
          d.log,
          date,
          now,
          missedAfterMinutes: d.missedAfter,
        ),
      );
    });

/// A month calendar of taken and missed doses, clear enough to screenshot
/// and send to family.
class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  LocalDate? _month;
  LocalDate? _selected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final today = ref.read(clockProvider).today();
    final month = _month ?? today.firstOfMonth;
    final selected = _selected ?? today;
    final history = ref.watch(monthHistoryProvider(month));
    final isCurrentMonth = month == today.firstOfMonth;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.historyTitle)),
      body: AsyncView(
        value: history,
        onRetry: () => ref.invalidate(appDataProvider),
        builder: (context, data) => ListView(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
          children: [
            Row(
              children: [
                IconButton(
                  tooltip: l10n.previousMonth,
                  iconSize: 32,
                  onPressed: () => setState(() {
                    _month = month.addDays(-1).firstOfMonth;
                    _selected = null;
                  }),
                  icon: const Icon(Icons.chevron_left_rounded),
                ),
                Expanded(
                  child: Text(
                    DateFormat.yMMMM(
                      l10n.localeName,
                    ).format(month.toDateTime()),
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                ),
                IconButton(
                  tooltip: l10n.nextMonth,
                  iconSize: 32,
                  onPressed: isCurrentMonth
                      ? null
                      : () => setState(() {
                          _month = month.addDays(32).firstOfMonth;
                          _selected = null;
                        }),
                  icon: const Icon(Icons.chevron_right_rounded),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                data.decided == 0
                    ? l10n.historyEmpty
                    : l10n.historySummary(data.taken, data.decided),
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
            ),
            _MonthGrid(
              month: month,
              days: data.days,
              selected: selected,
              onSelect: (day) => setState(() => _selected = day),
            ),
            const SizedBox(height: 12),
            const _Legend(),
            const SizedBox(height: 16),
            _DayDetail(date: selected),
          ],
        ),
      ),
    );
  }
}

class _MonthGrid extends StatelessWidget {
  const _MonthGrid({
    required this.month,
    required this.days,
    required this.selected,
    required this.onSelect,
  });

  final LocalDate month;
  final List<DaySummary> days;
  final LocalDate selected;
  final ValueChanged<LocalDate> onSelect;

  @override
  Widget build(BuildContext context) {
    final material = MaterialLocalizations.of(context);
    final firstWeekday = material.firstDayOfWeekIndex; // 0 = Sunday
    // Blank cells before the 1st, so columns line up with weekdays.
    final leading = (month.weekday % 7 - firstWeekday) % 7;
    final daysInMonth = month.addDays(32).firstOfMonth.addDays(-1).day;
    final byDay = {for (final d in days) d.date.day: d};
    final cells = <Widget>[
      for (var i = 0; i < 7; i++)
        ExcludeSemantics(
          child: Center(
            child: Text(
              material.narrowWeekdays[(firstWeekday + i) % 7],
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
      for (var i = 0; i < leading; i++) const SizedBox.shrink(),
      for (var day = 1; day <= daysInMonth; day++)
        _DayCell(
          date: LocalDate(month.year, month.month, day),
          summary: byDay[day],
          selected: selected == LocalDate(month.year, month.month, day),
          onTap: onSelect,
        ),
    ];
    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      children: cells,
    );
  }
}

enum _DayKind { none, open, allTaken, someMissed, missed }

_DayKind _kindOf(DaySummary? summary) {
  if (summary == null || !summary.hasDoses) return _DayKind.none;
  final decided = summary.taken + summary.skipped + summary.missed;
  if (decided == 0) return _DayKind.open;
  if (summary.missed + summary.skipped == 0) return _DayKind.allTaken;
  if (summary.taken == 0) return _DayKind.missed;
  return _DayKind.someMissed;
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.date,
    required this.summary,
    required this.selected,
    required this.onTap,
  });

  final LocalDate date;
  final DaySummary? summary;
  final bool selected;
  final ValueChanged<LocalDate> onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final status = StatusColors.of(context);
    final kind = _kindOf(summary);
    final (background, foreground, icon) = switch (kind) {
      _DayKind.allTaken => (status.taken, status.onTaken, Icons.check_rounded),
      _DayKind.someMissed => (
        status.snooze,
        status.onSnooze,
        Icons.priority_high_rounded,
      ),
      _DayKind.missed => (status.missed, status.onMissed, Icons.close_rounded),
      _DayKind.open ||
      _DayKind.none => (scheme.surfaceContainer, scheme.onSurface, null),
    };
    final s = summary;
    final dateText = formatDate(l10n, date);
    final label = s == null || !s.hasDoses
        ? l10n.historyDayNoDoses(dateText)
        : l10n.historyDay(dateText, s.taken, s.missed, s.skipped);
    return Semantics(
      label: label,
      selected: selected,
      button: true,
      excludeSemantics: true,
      child: Material(
        color: background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: selected
              ? BorderSide(color: scheme.onSurface, width: 3)
              : BorderSide.none,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => onTap(date),
          child: FittedBox(
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${date.day}',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: foreground),
                  ),
                  if (icon != null)
                    Icon(icon, size: 18, color: foreground)
                  else
                    const SizedBox(height: 18),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final status = StatusColors.of(context);
    Widget item(
      Color background,
      Color foreground,
      IconData icon,
      String text,
    ) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: Icon(icon, size: 20, color: foreground),
          ),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
        ),
      ],
    );
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: [
        item(
          status.taken,
          status.onTaken,
          Icons.check_rounded,
          l10n.legendAllTaken,
        ),
        item(
          status.snooze,
          status.onSnooze,
          Icons.priority_high_rounded,
          l10n.legendSomeMissed,
        ),
        item(
          status.missed,
          status.onMissed,
          Icons.close_rounded,
          l10n.legendMissed,
        ),
      ],
    );
  }
}

class _DayDetail extends ConsumerWidget {
  const _DayDetail({required this.date});

  final LocalDate date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final doses = ref.watch(dayDosesProvider(date)).value ?? const [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          formatDayMonth(l10n, date),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        if (doses.isEmpty)
          Text(
            l10n.historyDayNoDoses(formatDate(l10n, date)),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        for (final dose in doses)
          Card(
            key: ValueKey(dose.occurrence.key.toString()),
            margin: const EdgeInsets.only(bottom: 8),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Wrap(
                spacing: 12,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    '${formatTimeOf(context, dose.occurrence.scheduled.minuteOfDay)}'
                    '  ${dose.occurrence.medicine.name}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  StatusBadge(status: dose.status),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
