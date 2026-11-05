import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/widgets/async_view.dart';
import '../../../core/widgets/medicine_photo.dart';
import '../domain/medicine.dart';
import 'medicines_controller.dart';

/// The family member's list: add, edit and delete reminders.
class MedicinesScreen extends ConsumerWidget {
  const MedicinesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final medicines = ref.watch(medicinesProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.medicinesTitle),
        actions: [
          IconButton(
            key: const Key('open-settings'),
            tooltip: l10n.settings,
            iconSize: 30,
            onPressed: () => context.push('/settings'),
            icon: const Icon(Icons.settings_rounded),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('add-medicine'),
        onPressed: () => context.push('/medicines/new'),
        icon: const Icon(Icons.add_rounded),
        label: Text(l10n.addMedicine),
      ),
      body: AsyncView(
        value: medicines,
        onRetry: () => ref.invalidate(medicinesProvider),
        builder: (context, list) => list.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    l10n.medicinesEmpty,
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
                itemCount: list.length,
                itemBuilder: (context, index) => _MedicineCard(
                  key: ValueKey(list[index].id),
                  medicine: list[index],
                ),
              ),
      ),
    );
  }
}

class _MedicineCard extends ConsumerWidget {
  const _MedicineCard({required this.medicine, super.key});

  final Medicine medicine;

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteMedicineTitle(medicine.name)),
        content: Text(l10n.deleteMedicineBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed ?? false) {
      await ref.read(medicinesProvider.notifier).delete(medicine.id);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final end = medicine.endDate;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MedicinePhoto(
                  name: medicine.name,
                  path: medicine.photoPath,
                  size: 64,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(medicine.name, style: text.headlineSmall),
                      Text(
                        [
                          for (final t in medicine.times)
                            formatTimeOf(context, t),
                        ].join(', '),
                        style: text.titleMedium,
                      ),
                      Text(
                        end == null
                            ? l10n.noEndDateShort
                            : l10n.untilDate(formatDate(l10n, end)),
                        style: text.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => context.push('/medicines/${medicine.id}'),
                  icon: const Icon(Icons.edit_rounded),
                  label: Text(l10n.edit),
                ),
                TextButton.icon(
                  onPressed: () => unawaited(_confirmDelete(context, ref)),
                  icon: const Icon(Icons.delete_outline_rounded),
                  label: Text(l10n.delete),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
