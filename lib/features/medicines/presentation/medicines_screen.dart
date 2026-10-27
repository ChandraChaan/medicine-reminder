import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/widgets/async_view.dart';
import '../../../core/widgets/medicine_photo.dart';
import '../domain/medicine.dart';
import 'medicines_controller.dart';

/// The family member's list: add, edit, delete and restock medicines.
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

  Future<void> _boughtMore(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final count = await showDialog<int>(
      context: context,
      builder: (context) => const _BoughtMoreDialog(),
    );
    if (count == null || count <= 0) return;
    if (!context.mounted) return;
    await ref.read(medicinesProvider.notifier).addStock(medicine.id, count * 4);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          l10n.stockLeft(
            amountLabel(
              l10n,
              medicine.unit,
              (medicine.stockQuarters ?? 0) + count * 4,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final end = medicine.endDate;
    final stock = medicine.stockQuarters;
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
                        '${doseLabel(l10n, medicine)} · '
                        '${foodLabel(l10n, medicine.food)}',
                        style: text.bodyLarge,
                      ),
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
                      if (stock != null)
                        Text(
                          l10n.stockLeft(
                            amountLabel(l10n, medicine.unit, stock),
                          ),
                          style: text.titleMedium,
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
                if (stock != null)
                  TextButton.icon(
                    onPressed: () => unawaited(_boughtMore(context, ref)),
                    icon: const Icon(Icons.add_shopping_cart_rounded),
                    label: Text(l10n.boughtMore),
                  ),
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

class _BoughtMoreDialog extends StatefulWidget {
  const _BoughtMoreDialog();

  @override
  State<_BoughtMoreDialog> createState() => _BoughtMoreDialogState();
}

class _BoughtMoreDialogState extends State<_BoughtMoreDialog> {
  final _count = TextEditingController();

  @override
  void dispose() {
    _count.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.boughtMoreTitle),
      content: TextField(
        controller: _count,
        autofocus: true,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, int.tryParse(_count.text)),
          child: Text(l10n.save),
        ),
      ],
    );
  }
}
