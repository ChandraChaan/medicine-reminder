import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../doses/domain/refill.dart';
import '../domain/medicine.dart';

final medicinesProvider =
    AsyncNotifierProvider<MedicinesController, List<Medicine>>(
      MedicinesController.new,
    );

class MedicinesController extends AsyncNotifier<List<Medicine>> {
  @override
  Future<List<Medicine>> build() async =>
      _sorted(await ref.watch(medicineRepositoryProvider).loadAll());

  List<Medicine> _sorted(Iterable<Medicine> medicines) =>
      medicines.toList()
        ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

  Medicine? byId(String id) {
    for (final medicine in state.value ?? const <Medicine>[]) {
      if (medicine.id == id) return medicine;
    }
    return null;
  }

  Future<void> save(Medicine medicine) async {
    final current = await future;
    await ref.read(medicineRepositoryProvider).save(medicine);
    if (!ref.mounted) return;
    state = AsyncData(
      _sorted([
        for (final m in current)
          if (m.id != medicine.id) m,
        medicine,
      ]),
    );
  }

  Future<void> delete(String id) async {
    final current = await future;
    await ref.read(medicineRepositoryProvider).delete(id);
    await ref.read(doseLogRepositoryProvider).deleteMedicine(id);
    if (!ref.mounted) return;
    state = AsyncData([
      for (final m in current)
        if (m.id != id) m,
    ]);
  }

  /// Adds bought stock (in quarters) to a counted medicine.
  Future<void> addStock(String id, int quarters) async {
    final medicine = byId(id);
    if (medicine == null) return;
    await save(
      medicine.copyWith(
        stockQuarters: () => (medicine.stockQuarters ?? 0) + quarters,
      ),
    );
  }

  /// Takes one dose out of the count. Returns the updated medicine.
  Future<Medicine?> useDose(String id) async {
    final medicine = byId(id);
    final stock = medicine?.stockQuarters;
    if (medicine == null || stock == null) return medicine;
    final updated = medicine.copyWith(
      stockQuarters: () => stockAfterDose(stock, medicine.doseQuarters),
    );
    await save(updated);
    return updated;
  }

  /// Puts one dose back after an "Undo".
  Future<void> returnDose(String id) async {
    final medicine = byId(id);
    final stock = medicine?.stockQuarters;
    if (medicine == null || stock == null) return;
    await save(
      medicine.copyWith(stockQuarters: () => stock + medicine.doseQuarters),
    );
  }
}
