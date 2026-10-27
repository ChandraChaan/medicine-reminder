import 'medicine.dart';

abstract interface class MedicineRepository {
  Future<List<Medicine>> loadAll();

  /// Adds [medicine], or replaces the one with the same id.
  Future<void> save(Medicine medicine);

  Future<void> delete(String id);
}
