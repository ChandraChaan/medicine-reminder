import '../../../core/storage/json_file_store.dart';
import '../domain/contact.dart';

class FileContactRepository implements ContactRepository {
  FileContactRepository(this._store);

  final JsonFileStore _store;

  @override
  Future<List<Contact>> loadAll() async {
    final json = await _store.read('contacts');
    if (json is! List) return const [];
    return [
      for (final item in json)
        if (item is Map) Contact.fromJson(item.cast<String, Object?>()),
    ];
  }

  @override
  Future<void> saveAll(List<Contact> contacts) => _store.write('contacts', [
    for (final contact in contacts) contact.toJson(),
  ]);
}
