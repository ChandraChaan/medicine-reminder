import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';

import '../../../core/platform/photo_picker.dart';
import '../../../core/providers.dart';
import '../../../core/time/clock.dart';
import '../../../core/time/local_date.dart';
import '../domain/medicine.dart';
import 'medicines_controller.dart';

/// The steps of the add / edit medicine flow, in order.
enum WizardStep { name, dose, times, food, days, stock, review }

enum DraftProblem { nameMissing, noTimes, noDays, endBeforeStart }

/// A medicine being added or edited, before it is saved.
@immutable
class MedicineDraft {
  const MedicineDraft({
    required this.id,
    required this.isNew,
    required this.name,
    required this.photoPath,
    required this.doseQuarters,
    required this.unit,
    required this.times,
    required this.food,
    required this.startDate,
    required this.endDate,
    required this.weekdays,
    required this.counting,
    required this.stockUnits,
    required this.refillWarnDays,
  });

  factory MedicineDraft.blank(String id, LocalDate today) => MedicineDraft(
    id: id,
    isNew: true,
    name: '',
    photoPath: null,
    doseQuarters: 4,
    unit: DoseUnit.tablet,
    times: const [DayPart.morning],
    food: FoodTiming.afterFood,
    startDate: today,
    endDate: null,
    weekdays: everyDay,
    counting: false,
    stockUnits: 30,
    refillWarnDays: 5,
  );

  factory MedicineDraft.of(Medicine m) => MedicineDraft(
    id: m.id,
    isNew: false,
    name: m.name,
    photoPath: m.photoPath,
    doseQuarters: m.doseQuarters,
    unit: m.unit,
    times: m.times,
    food: m.food,
    startDate: m.startDate,
    endDate: m.endDate,
    weekdays: m.weekdays,
    counting: m.tracksStock,
    stockUnits: m.tracksStock ? (m.stockQuarters! / 4).ceil() : 30,
    refillWarnDays: m.refillWarnDays,
  );

  final String id;
  final bool isNew;
  final String name;
  final String? photoPath;
  final int doseQuarters;
  final DoseUnit unit;
  final List<int> times;
  final FoodTiming food;
  final LocalDate startDate;
  final LocalDate? endDate;
  final Set<int> weekdays;
  final bool counting;

  /// Whole tablets (or ml, puffs...) in hand when [counting].
  final int stockUnits;
  final int refillWarnDays;

  bool get everyDaySelected => weekdays.length == 7;

  List<DraftProblem> problemsAt(WizardStep step) => [
    if (step == WizardStep.name && name.trim().isEmpty)
      DraftProblem.nameMissing,
    if (step == WizardStep.times && times.isEmpty) DraftProblem.noTimes,
    if (step == WizardStep.days && weekdays.isEmpty) DraftProblem.noDays,
    if (step == WizardStep.days &&
        endDate != null &&
        endDate!.isBefore(startDate))
      DraftProblem.endBeforeStart,
  ];

  List<DraftProblem> get allProblems => [
    for (final step in WizardStep.values) ...problemsAt(step),
  ];

  Medicine toMedicine() => Medicine(
    id: id,
    name: name.trim(),
    photoPath: photoPath,
    doseQuarters: doseQuarters,
    unit: unit,
    times: normalizeTimes(times),
    food: food,
    startDate: startDate,
    endDate: endDate,
    weekdays: weekdays,
    stockQuarters: counting ? stockUnits * 4 : null,
    refillWarnDays: refillWarnDays,
  );

  MedicineDraft copyWith({
    String? name,
    String? Function()? photoPath,
    int? doseQuarters,
    DoseUnit? unit,
    List<int>? times,
    FoodTiming? food,
    LocalDate? startDate,
    LocalDate? Function()? endDate,
    Set<int>? weekdays,
    bool? counting,
    int? stockUnits,
    int? refillWarnDays,
  }) => MedicineDraft(
    id: id,
    isNew: isNew,
    name: name ?? this.name,
    photoPath: photoPath != null ? photoPath() : this.photoPath,
    doseQuarters: doseQuarters ?? this.doseQuarters,
    unit: unit ?? this.unit,
    times: times ?? this.times,
    food: food ?? this.food,
    startDate: startDate ?? this.startDate,
    endDate: endDate != null ? endDate() : this.endDate,
    weekdays: weekdays ?? this.weekdays,
    counting: counting ?? this.counting,
    stockUnits: stockUnits ?? this.stockUnits,
    refillWarnDays: refillWarnDays ?? this.refillWarnDays,
  );
}

/// One step of the dose amount, in quarters: tablets can be quartered,
/// liquids halved, everything else is whole.
int doseStep(DoseUnit unit) => switch (unit) {
  DoseUnit.tablet => 1,
  DoseUnit.ml => 2,
  _ => 4,
};

final medicineDraftProvider = NotifierProvider.autoDispose
    .family<MedicineDraftController, MedicineDraft, String?>(
      MedicineDraftController.new,
    );

class MedicineDraftController extends Notifier<MedicineDraft> {
  MedicineDraftController(this.medicineId);

  /// The medicine being edited, or null when adding a new one.
  final String? medicineId;

  @override
  MedicineDraft build() {
    final clock = ref.read(clockProvider);
    final existing = medicineId == null
        ? null
        : ref.read(medicinesProvider.notifier).byId(medicineId!);
    return existing != null
        ? MedicineDraft.of(existing)
        : MedicineDraft.blank(
            clock.nowUtc().microsecondsSinceEpoch.toRadixString(36),
            clock.today(),
          );
  }

  void setName(String name) => state = state.copyWith(name: name);

  Future<void> pickPhoto(PhotoSource source) async {
    final path = await ref.read(photoPickerProvider).pick(source);
    if (path == null || !ref.mounted) return;
    state = state.copyWith(photoPath: () => path);
  }

  void removePhoto() => state = state.copyWith(photoPath: () => null);

  void setUnit(DoseUnit unit) {
    final step = doseStep(unit);
    // Round the amount to something the new unit allows.
    final rounded = ((state.doseQuarters / step).round() * step).clamp(
      step,
      400,
    );
    state = state.copyWith(unit: unit, doseQuarters: rounded);
  }

  void changeDose(int direction) {
    final step = doseStep(state.unit);
    final next = state.doseQuarters + direction * step;
    if (next < step || next > 400) return;
    state = state.copyWith(doseQuarters: next);
  }

  void addTime(int minute) =>
      state = state.copyWith(times: normalizeTimes([...state.times, minute]));

  void replaceTime(int oldMinute, int newMinute) => state = state.copyWith(
    times: normalizeTimes([
      for (final t in state.times)
        if (t != oldMinute) t,
      newMinute,
    ]),
  );

  void removeTime(int minute) => state = state.copyWith(
    times: [
      for (final t in state.times)
        if (t != minute) t,
    ],
  );

  void setFood(FoodTiming food) => state = state.copyWith(food: food);

  void setStart(LocalDate date) => state = state.copyWith(startDate: date);

  void setEnd(LocalDate? date) => state = state.copyWith(endDate: () => date);

  void setEveryDay(bool all) =>
      state = state.copyWith(weekdays: all ? everyDay : const <int>{});

  void toggleWeekday(int weekday) {
    final days = {...state.weekdays};
    if (!days.remove(weekday)) days.add(weekday);
    state = state.copyWith(weekdays: days);
  }

  void setCounting(bool counting) => state = state.copyWith(counting: counting);

  void setStock(int units) =>
      state = state.copyWith(stockUnits: units.clamp(0, 9999));

  void changeWarnDays(int direction) => state = state.copyWith(
    refillWarnDays: (state.refillWarnDays + direction).clamp(1, 30),
  );

  /// Saves the medicine; returns false when something still needs fixing.
  Future<bool> save() async {
    if (state.allProblems.isNotEmpty) return false;
    await ref.read(medicinesProvider.notifier).save(state.toMedicine());
    return true;
  }
}
