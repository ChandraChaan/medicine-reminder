import '../../../core/storage/json_file_store.dart';
import '../domain/medicine.dart';
import '../domain/medicine_repository.dart';
import 'medicine_json.dart';

class FileMedicineRepository implements MedicineRepository {
  FileMedicineRepository(this._store);

  static const _name = 'medicines';
  final JsonFileStore _store;

  @override
  Future<List<Medicine>> loadAll() async {
    final json = await _store.read(_name);
    if (json is! List<Object?>) return [];
    return [
      for (final item in json.cast<Map<String, Object?>>())
        medicineFromJson(item),
    ];
  }

  @override
  Future<void> save(Medicine medicine) async {
    final all = await loadAll();
    final index = all.indexWhere((m) => m.id == medicine.id);
    if (index == -1) {
      all.add(medicine);
    } else {
      all[index] = medicine;
    }
    await _store.write(_name, [for (final m in all) medicineToJson(m)]);
  }

  @override
  Future<void> delete(String id) async {
    final all = await loadAll();
    await _store.write(_name, [
      for (final m in all)
        if (m.id != id) medicineToJson(m),
    ]);
  }
}
