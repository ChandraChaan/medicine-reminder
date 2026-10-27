import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/platform/alarm_bridge.dart';
import '../../../core/providers.dart';
import '../../../core/time/clock.dart';
import '../../../core/widgets/async_view.dart';
import '../../../core/widgets/medicine_photo.dart';
import '../../../core/widgets/status_badge.dart';
import '../../medicines/domain/medicine.dart';
import '../../medicines/presentation/medicines_controller.dart';
import '../domain/dose.dart';
import '../domain/refill.dart';
import 'dose_buttons.dart';
import 'dose_controller.dart';

/// The everyday screen: today's medicines and what happened with each.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final today = ref.watch(todayProvider);
    final medicines = ref.watch(medicinesProvider);
    final date =
        ref.watch(nowProvider).value?.date ?? ref.read(clockProvider).today();
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.todayTitle),
            Text(
              formatDayMonth(l10n, date),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
      body: AsyncView(
        value: today,
        onRetry: () => ref.invalidate(appDataProvider),
        builder: (context, doses) => _TodayList(
          doses: doses,
          hasMedicines: medicines.value?.isNotEmpty ?? false,
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  key: const Key('home-history'),
                  onPressed: () => context.push('/history'),
                  icon: const Icon(Icons.calendar_month_rounded),
                  label: Text(l10n.history),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  key: const Key('home-family'),
                  onPressed: () => context.push('/medicines'),
                  icon: const Icon(Icons.family_restroom_rounded),
                  label: Text(l10n.familySetup),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TodayList extends ConsumerWidget {
  const _TodayList({required this.doses, required this.hasMedicines});

  final List<DoseState> doses;
  final bool hasMedicines;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final permissions = ref.watch(permissionsProvider).value;
    final refills = ref.watch(refillWarningsProvider).value ?? const [];
    final allDone =
        doses.isNotEmpty &&
        doses.every((d) => d.status is DoseTaken || d.status is DoseSkipped);
    final groups = <int, List<DoseState>>{};
    for (final dose in doses) {
      (groups[dose.occurrence.scheduled.minuteOfDay] ??= []).add(dose);
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      children: [
        if (permissions != null && !permissions.allOk)
          _PermissionBanners(permissions: permissions),
        for (final (medicine, forecast) in refills)
          _RefillBanner(medicine: medicine, forecast: forecast),
        if (!hasMedicines)
          const _NoMedicines()
        else if (doses.isEmpty)
          _Message(text: l10n.nothingToday, icon: Icons.event_available_rounded)
        else if (allDone)
          _Message(text: l10n.allDoneToday, icon: Icons.verified_rounded),
        for (final MapEntry(key: minute, value: group) in groups.entries) ...[
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: Text(
              '${formatTimeOf(context, minute)} · ${partOfDay(l10n, minute)}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          for (final dose in group)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _DoseCard(
                key: ValueKey(dose.occurrence.key.toString()),
                dose: dose,
              ),
            ),
        ],
      ],
    );
  }
}

class _DoseCard extends StatelessWidget {
  const _DoseCard({required this.dose, super.key});

  final DoseState dose;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final medicine = dose.occurrence.medicine;
    final text = Theme.of(context).textTheme;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          showDragHandle: true,
          builder: (_) => DoseActionSheet(dose: dose),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MedicinePhoto(
                name: medicine.name,
                path: medicine.photoPath,
                size: 72,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(medicine.name, style: text.headlineSmall),
                    const SizedBox(height: 2),
                    Text(
                      '${doseLabel(l10n, medicine)} · '
                      '${foodLabel(l10n, medicine.food)}',
                      style: text.bodyLarge,
                    ),
                    const SizedBox(height: 8),
                    StatusBadge(status: dose.status),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Taken / Skip for one dose from the home screen, or Undo after answering.
class DoseActionSheet extends ConsumerWidget {
  const DoseActionSheet({required this.dose, super.key});

  final DoseState dose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final medicine = dose.occurrence.medicine;
    final controller = ref.read(doseEventsProvider.notifier);
    final answered = dose.status is DoseTaken || dose.status is DoseSkipped;
    Future<void> act(Future<void> Function() action) async {
      Navigator.of(context).pop();
      await action();
    }

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              medicine.name,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              '${formatTimeOf(context, dose.occurrence.scheduled.minuteOfDay)}'
              ' · ${doseLabel(l10n, medicine)}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            if (answered)
              FilledButton.icon(
                onPressed: () => act(
                  () => controller.undo(
                    dose.occurrence,
                    wasTaken: dose.status is DoseTaken,
                  ),
                ),
                icon: const Icon(Icons.undo_rounded),
                label: Text(l10n.undo),
              )
            else ...[
              TakenButton(
                onPressed: () => act(() => controller.take(dose.occurrence)),
              ),
              const SizedBox(height: 12),
              SkipButton(
                onPressed: () => act(() => controller.skip(dose.occurrence)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PermissionBanners extends ConsumerWidget {
  const _PermissionBanners({required this.permissions});

  final AlarmPermissions permissions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final bridge = ref.read(alarmBridgeProvider);
    Future<void> fixNotifications() async {
      final granted = await ref.read(notificationPermissionProvider).request();
      if (!granted) await bridge.openNotificationSettings();
      ref.invalidate(permissionsProvider);
    }

    return Column(
      children: [
        if (!permissions.notifications)
          _Banner(
            key: const Key('banner-notifications'),
            text: l10n.bannerNotifications,
            onFix: fixNotifications,
          ),
        if (!permissions.exactAlarms)
          _Banner(
            key: const Key('banner-exact'),
            text: l10n.bannerExactAlarms,
            onFix: bridge.openExactAlarmSettings,
          ),
        if (!permissions.fullScreen)
          _Banner(
            key: const Key('banner-full-screen'),
            text: l10n.bannerFullScreen,
            onFix: bridge.openFullScreenSettings,
          ),
      ],
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner({required this.text, required this.onFix, super.key});

  final String text;
  final Future<void> Function() onFix;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Card(
        color: scheme.errorContainer,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: scheme.onErrorContainer,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      text,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: scheme.onErrorContainer,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: FilledButton(
                  onPressed: () => unawaited(onFix()),
                  style: FilledButton.styleFrom(
                    backgroundColor: scheme.error,
                    foregroundColor: scheme.onError,
                  ),
                  child: Text(context.l10n.fix),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RefillBanner extends StatelessWidget {
  const _RefillBanner({required this.medicine, required this.forecast});

  final Medicine medicine;
  final RefillForecast forecast;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final days = forecast.daysLeft ?? 0;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Card(
        color: scheme.secondaryContainer,
        child: ListTile(
          leading: Icon(
            Icons.shopping_bag_rounded,
            color: scheme.onSecondaryContainer,
            size: 32,
          ),
          title: Text(
            days == 0
                ? l10n.refillRunOut(medicine.name)
                : l10n.refillDaysLeft(medicine.name, days),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: scheme.onSecondaryContainer,
            ),
          ),
        ),
      ),
    );
  }
}

class _NoMedicines extends StatelessWidget {
  const _NoMedicines();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(
            Icons.medication_liquid_rounded,
            size: 96,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.noMedicinesTitle,
            style: text.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.noMedicinesBody,
            style: text.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            key: const Key('home-add-medicine'),
            onPressed: () => context.push('/medicines/new'),
            icon: const Icon(Icons.add_rounded),
            label: Text(l10n.addMedicine),
          ),
        ],
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.text, required this.icon});

  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Card(
        color: scheme.primaryContainer,
        child: ListTile(
          leading: Icon(icon, color: scheme.onPrimaryContainer, size: 32),
          title: Text(
            text,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: scheme.onPrimaryContainer),
          ),
        ),
      ),
    );
  }
}
