import 'dart:convert';
import 'dart:io';

/// Keeps small JSON documents as files in one private folder.
///
/// Writes go to a temporary file first and are renamed into place, so a
/// crash mid-write never leaves a half-written file. Writes are queued so two
/// saves never interleave.
class JsonFileStore {
  JsonFileStore(this.directory);

  final Directory directory;
  Future<void> _queue = Future.value();

  File _file(String name) => File('${directory.path}/$name.json');

  /// The stored document, or null when nothing was saved yet.
  Future<Object?> read(String name) async {
    await _queue;
    final file = _file(name);
    if (!file.existsSync()) return null;
    final text = await file.readAsString();
    return text.isEmpty ? null : jsonDecode(text);
  }

  Future<void> write(String name, Object json) {
    final next = _queue.then((_) async {
      await directory.create(recursive: true);
      final file = _file(name);
      final temp = File('${file.path}.tmp');
      await temp.writeAsString(jsonEncode(json), flush: true);
      await temp.rename(file.path);
    });
    _queue = next.catchError((Object _) {});
    return next;
  }
}
