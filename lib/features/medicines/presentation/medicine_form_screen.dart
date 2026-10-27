import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/platform/photo_picker.dart';
import '../../../core/time/local_date.dart';
import '../../../core/widgets/async_view.dart';
import '../../../core/widgets/medicine_photo.dart';
import '../domain/medicine.dart';
import 'medicine_draft.dart';
import 'medicines_controller.dart';

/// Adds or edits a medicine, one simple question per step.
class MedicineFormScreen extends StatelessWidget {
  const MedicineFormScreen({this.medicineId, super.key});

  final String? medicineId;

  @override
  Widget build(BuildContext context) =>
      _MedicineFormLoader(child: _MedicineForm(medicineId: medicineId));
}

class _MedicineForm extends ConsumerStatefulWidget {
  const _MedicineForm({required this.medicineId});

  final String? medicineId;

  @override
  ConsumerState<_MedicineForm> createState() => _MedicineFormScreenState();
}

/// Waits for the medicine list so an edited medicine's draft starts filled in.
class _MedicineFormLoader extends ConsumerWidget {
  const _MedicineFormLoader({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      switch (ref.watch(medicinesProvider)) {
        AsyncValue(hasValue: true) => child,
        AsyncError() => Scaffold(
          appBar: AppBar(),
          body: ErrorRetry(onRetry: () => ref.invalidate(medicinesProvider)),
        ),
        _ => const Scaffold(body: Center(child: CircularProgressIndicator())),
      };
}

class _MedicineFormScreenState extends ConsumerState<_MedicineForm> {
  var _step = WizardStep.name;
  var _showProblems = false;
  bool _saving = false;

  MedicineDraftController get _controller =>
      ref.read(medicineDraftProvider(widget.medicineId).notifier);

  Future<void> _next() async {
    final draft = ref.read(medicineDraftProvider(widget.medicineId));
    if (draft.problemsAt(_step).isNotEmpty) {
      setState(() => _showProblems = true);
      return;
    }
    if (_step == WizardStep.review) {
      setState(() => _saving = true);
      final saved = await _controller.save();
      if (!mounted) return;
      setState(() => _saving = false);
      if (saved) context.pop();
      return;
    }
    setState(() {
      _showProblems = false;
      _step = WizardStep.values[_step.index + 1];
    });
  }

  void _back() {
    if (_step == WizardStep.name) {
      context.pop();
      return;
    }
    setState(() {
      _showProblems = false;
      _step = WizardStep.values[_step.index - 1];
    });
  }

  void _goTo(WizardStep step) => setState(() {
    _showProblems = false;
    _step = step;
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final draft = ref.watch(medicineDraftProvider(widget.medicineId));
    final problems = _showProblems
        ? draft.problemsAt(_step)
        : const <DraftProblem>[];
    final total = WizardStep.values.length;
    return PopScope(
      canPop: _step == WizardStep.name,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _back();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(draft.isNew ? l10n.addMedicine : draft.name),
              Text(
                l10n.stepCounter(_step.index + 1, total),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            LinearProgressIndicator(
              value: (_step.index + 1) / total,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 20),
            switch (_step) {
              WizardStep.name => _NameStep(id: widget.medicineId),
              WizardStep.dose => _DoseStep(id: widget.medicineId),
              WizardStep.times => _TimesStep(id: widget.medicineId),
              WizardStep.food => _FoodStep(id: widget.medicineId),
              WizardStep.days => _DaysStep(id: widget.medicineId),
              WizardStep.stock => _StockStep(id: widget.medicineId),
              WizardStep.review => _ReviewStep(
                id: widget.medicineId,
                onEdit: _goTo,
              ),
            },
            for (final problem in problems)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  switch (problem) {
                    DraftProblem.nameMissing => l10n.nameRequired,
                    DraftProblem.noTimes => l10n.timesRequired,
                    DraftProblem.noDays => l10n.daysRequired,
                    DraftProblem.endBeforeStart => l10n.endBeforeStart,
                  },
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    key: const Key('wizard-back'),
                    onPressed: _back,
                    child: Text(
                      _step == WizardStep.name ? l10n.cancel : l10n.back,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    key: const Key('wizard-next'),
                    onPressed: _saving ? null : () => unawaited(_next()),
                    child: Text(
                      _step == WizardStep.review ? l10n.save : l10n.next,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Question extends StatelessWidget {
  const _Question(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Text(text, style: Theme.of(context).textTheme.headlineSmall),
  );
}

class _NameStep extends ConsumerStatefulWidget {
  const _NameStep({required this.id});

  final String? id;

  @override
  ConsumerState<_NameStep> createState() => _NameStepState();
}

class _NameStepState extends ConsumerState<_NameStep> {
  late final TextEditingController _name;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(
      text: ref.read(medicineDraftProvider(widget.id)).name,
    );
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final draft = ref.watch(medicineDraftProvider(widget.id));
    final controller = ref.read(medicineDraftProvider(widget.id).notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Question(l10n.stepName),
        TextField(
          key: const Key('wizard-name'),
          controller: _name,
          onChanged: controller.setName,
          textCapitalization: TextCapitalization.sentences,
          style: Theme.of(context).textTheme.titleLarge,
          decoration: InputDecoration(
            labelText: l10n.nameLabel,
            hintText: l10n.nameHint,
          ),
        ),
        const SizedBox(height: 24),
        Center(
          child: MedicinePhoto(
            name: draft.name,
            path: draft.photoPath,
            size: 140,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.photoHelp,
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: [
            OutlinedButton.icon(
              onPressed: () =>
                  unawaited(controller.pickPhoto(PhotoSource.camera)),
              icon: const Icon(Icons.photo_camera_rounded),
              label: Text(l10n.takePhoto),
            ),
            OutlinedButton.icon(
              onPressed: () =>
                  unawaited(controller.pickPhoto(PhotoSource.gallery)),
              icon: const Icon(Icons.photo_library_rounded),
              label: Text(l10n.choosePhoto),
            ),
            if (draft.photoPath != null)
              TextButton.icon(
                onPressed: controller.removePhoto,
                icon: const Icon(Icons.delete_outline_rounded),
                label: Text(l10n.removePhoto),
              ),
          ],
        ),
      ],
    );
  }
}

class _DoseStep extends ConsumerWidget {
  const _DoseStep({required this.id});

  final String? id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final draft = ref.watch(medicineDraftProvider(id));
    final controller = ref.read(medicineDraftProvider(id).notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Question(l10n.stepDose),
        Row(
          children: [
            IconButton.filledTonal(
              key: const Key('dose-less'),
              tooltip: l10n.decrease,
              iconSize: 36,
              onPressed: () => controller.changeDose(-1),
              icon: const Icon(Icons.remove_rounded),
            ),
            Expanded(
              child: Text(
                amountLabel(l10n, draft.unit, draft.doseQuarters),
                key: const Key('dose-amount'),
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
            ),
            IconButton.filledTonal(
              key: const Key('dose-more'),
              tooltip: l10n.increase,
              iconSize: 36,
              onPressed: () => controller.changeDose(1),
              icon: const Icon(Icons.add_rounded),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(l10n.unitLabel, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final unit in DoseUnit.values)
              ChoiceChip(
                label: Text(unitLabel(l10n, unit, 4)),
                selected: draft.unit == unit,
                onSelected: (_) => controller.setUnit(unit),
              ),
          ],
        ),
      ],
    );
  }
}

class _TimesStep extends ConsumerWidget {
  const _TimesStep({required this.id});

  final String? id;

  Future<int?> _pick(BuildContext context, int initial) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: initial ~/ 60, minute: initial % 60),
    );
    return picked == null ? null : picked.hour * 60 + picked.minute;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final draft = ref.watch(medicineDraftProvider(id));
    final controller = ref.read(medicineDraftProvider(id).notifier);
    const presets = [DayPart.morning, DayPart.afternoon, DayPart.night];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Question(l10n.stepTimes),
        for (final minute in draft.times)
          Card(
            key: ValueKey('time-$minute'),
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              leading: const Icon(Icons.alarm_rounded, size: 32),
              title: Text(
                formatTimeOf(context, minute),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              subtitle: Text(partOfDay(l10n, minute)),
              onTap: () async {
                final picked = await _pick(context, minute);
                if (picked != null) controller.replaceTime(minute, picked);
              },
              trailing: IconButton(
                tooltip: l10n.removeTime(formatTimeOf(context, minute)),
                onPressed: () => controller.removeTime(minute),
                icon: const Icon(Icons.close_rounded),
              ),
            ),
          ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final preset in presets)
              if (!draft.times.contains(preset))
                ActionChip(
                  avatar: const Icon(Icons.add_rounded),
                  label: Text(
                    '${partOfDay(l10n, preset)} ${formatTimeOf(context, preset)}',
                  ),
                  onPressed: () => controller.addTime(preset),
                ),
            ActionChip(
              key: const Key('add-time'),
              avatar: const Icon(Icons.more_time_rounded),
              label: Text(l10n.addTime),
              onPressed: () async {
                final picked = await _pick(context, 12 * 60);
                if (picked != null) controller.addTime(picked);
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _FoodStep extends ConsumerWidget {
  const _FoodStep({required this.id});

  final String? id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final draft = ref.watch(medicineDraftProvider(id));
    final controller = ref.read(medicineDraftProvider(id).notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Question(l10n.stepFood),
        RadioGroup<FoodTiming>(
          groupValue: draft.food,
          onChanged: (food) {
            if (food != null) controller.setFood(food);
          },
          child: Column(
            children: [
              for (final food in FoodTiming.values)
                Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: RadioListTile<FoodTiming>(
                    value: food,
                    title: Text(
                      foodLabel(l10n, food),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DaysStep extends ConsumerWidget {
  const _DaysStep({required this.id});

  final String? id;

  Future<LocalDate?> _pickDate(BuildContext context, LocalDate initial) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initial.toDateTime(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    return picked == null ? null : LocalDate.fromDateTime(picked);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final draft = ref.watch(medicineDraftProvider(id));
    final controller = ref.read(medicineDraftProvider(id).notifier);
    final material = MaterialLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final end = draft.endDate;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Question(l10n.stepDays),
        Card(
          child: ListTile(
            leading: const Icon(Icons.event_rounded, size: 32),
            title: Text(l10n.startDate),
            subtitle: Text(
              formatDate(l10n, draft.startDate),
              style: text.titleLarge,
            ),
            onTap: () async {
              final date = await _pickDate(context, draft.startDate);
              if (date != null) controller.setStart(date);
            },
          ),
        ),
        const SizedBox(height: 12),
        SegmentedButton<bool>(
          segments: [
            ButtonSegment(value: false, label: Text(l10n.noEndDate)),
            ButtonSegment(value: true, label: Text(l10n.pickEndDate)),
          ],
          selected: {end != null},
          onSelectionChanged: (choice) async {
            if (!choice.first) {
              controller.setEnd(null);
              return;
            }
            final date = await _pickDate(context, draft.startDate.addDays(30));
            if (date != null) controller.setEnd(date);
          },
        ),
        if (end != null)
          Card(
            margin: const EdgeInsets.only(top: 12),
            child: ListTile(
              leading: const Icon(Icons.event_busy_rounded, size: 32),
              title: Text(l10n.lastDay),
              subtitle: Text(formatDate(l10n, end), style: text.titleLarge),
              onTap: () async {
                final date = await _pickDate(context, end);
                if (date != null) controller.setEnd(date);
              },
            ),
          ),
        const SizedBox(height: 20),
        SegmentedButton<bool>(
          segments: [
            ButtonSegment(value: true, label: Text(l10n.everyDayLabel)),
            ButtonSegment(value: false, label: Text(l10n.someDaysLabel)),
          ],
          selected: {draft.everyDaySelected},
          onSelectionChanged: (choice) => controller.setEveryDay(choice.first),
        ),
        if (!draft.everyDaySelected) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var i = 0; i < 7; i++)
                Builder(
                  builder: (context) {
                    // Material weekday index 0 is Sunday; LocalDate uses 7.
                    final index = (material.firstDayOfWeekIndex + i) % 7;
                    final weekday = index == 0 ? 7 : index;
                    return FilterChip(
                      label: Text(
                        DateFormat.E(l10n.localeName).format(
                          DateTime(
                            2024,
                            1,
                            weekday,
                          ), // 1 Jan 2024 was a Monday.
                        ),
                      ),
                      selected: draft.weekdays.contains(weekday),
                      onSelected: (_) => controller.toggleWeekday(weekday),
                    );
                  },
                ),
            ],
          ),
        ],
      ],
    );
  }
}

class _StockStep extends ConsumerStatefulWidget {
  const _StockStep({required this.id});

  final String? id;

  @override
  ConsumerState<_StockStep> createState() => _StockStepState();
}

class _StockStepState extends ConsumerState<_StockStep> {
  late final TextEditingController _stock;

  @override
  void initState() {
    super.initState();
    _stock = TextEditingController(
      text: '${ref.read(medicineDraftProvider(widget.id)).stockUnits}',
    );
  }

  @override
  void dispose() {
    _stock.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final draft = ref.watch(medicineDraftProvider(widget.id));
    final controller = ref.read(medicineDraftProvider(widget.id).notifier);
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Question(l10n.stepStock),
        Text(l10n.stockHelp, style: text.bodyLarge),
        const SizedBox(height: 16),
        SegmentedButton<bool>(
          segments: [
            ButtonSegment(value: false, label: Text(l10n.dontCount)),
            ButtonSegment(value: true, label: Text(l10n.countThem)),
          ],
          selected: {draft.counting},
          onSelectionChanged: (choice) => controller.setCounting(choice.first),
        ),
        if (draft.counting) ...[
          const SizedBox(height: 20),
          TextField(
            key: const Key('wizard-stock'),
            controller: _stock,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: text.headlineSmall,
            decoration: InputDecoration(
              labelText: l10n.stockInHand,
              suffixText: unitLabel(l10n, draft.unit, 8),
            ),
            onChanged: (value) => controller.setStock(int.tryParse(value) ?? 0),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              IconButton.filledTonal(
                tooltip: l10n.decrease,
                onPressed: () => controller.changeWarnDays(-1),
                icon: const Icon(Icons.remove_rounded),
              ),
              Expanded(
                child: Text(
                  l10n.warnDaysBefore(draft.refillWarnDays),
                  style: text.titleMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              IconButton.filledTonal(
                tooltip: l10n.increase,
                onPressed: () => controller.changeWarnDays(1),
                icon: const Icon(Icons.add_rounded),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _ReviewStep extends ConsumerWidget {
  const _ReviewStep({required this.id, required this.onEdit});

  final String? id;
  final ValueChanged<WizardStep> onEdit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final draft = ref.watch(medicineDraftProvider(id));
    final days = draft.everyDaySelected
        ? l10n.everyDayLabel
        : [
            for (final d in draft.weekdays.toList()..sort())
              DateFormat.E(l10n.localeName).format(DateTime(2024, 1, d)),
          ].join(', ');
    final end = draft.endDate;
    Widget row(WizardStep step, String title, String value) => Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: Text(title),
        subtitle: Text(value, style: Theme.of(context).textTheme.titleLarge),
        trailing: IconButton(
          tooltip: '${l10n.edit}: $title',
          onPressed: () => onEdit(step),
          icon: const Icon(Icons.edit_rounded),
        ),
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Question(l10n.stepReview),
        Row(
          children: [
            MedicinePhoto(name: draft.name, path: draft.photoPath, size: 72),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                draft.name,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        row(
          WizardStep.dose,
          l10n.stepDose,
          amountLabel(l10n, draft.unit, draft.doseQuarters),
        ),
        row(
          WizardStep.times,
          l10n.reviewTimes,
          [for (final t in draft.times) formatTimeOf(context, t)].join(', '),
        ),
        row(WizardStep.food, l10n.stepFood, foodLabel(l10n, draft.food)),
        row(
          WizardStep.days,
          l10n.reviewDays,
          '$days\n${formatDate(l10n, draft.startDate)} – '
          '${end == null ? l10n.noEndDateShort : formatDate(l10n, end)}',
        ),
        row(
          WizardStep.stock,
          l10n.reviewStock,
          draft.counting
              ? l10n.stockLeft(
                  '${draft.stockUnits} ${unitLabel(l10n, draft.unit, draft.stockUnits * 4)}',
                )
              : l10n.notCounted,
        ),
      ],
    );
  }
}
