import 'dose.dart';

abstract interface class DoseLogRepository {
  Future<List<DoseEvent>> loadAll();

  Future<void> add(DoseEvent event);

  /// Removes every taken or skipped answer for [key] (used by "Undo").
  Future<void> clearAnswer(DoseKey key);

  /// Removes everything recorded for a deleted medicine.
  Future<void> deleteMedicine(String medicineId);
}
