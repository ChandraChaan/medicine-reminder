import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/platform/speech_recognizer.dart';
import '../../../core/platform/voice_permissions.dart';
import '../../../core/providers.dart';
import '../../settings/presentation/settings_controller.dart';
import '../domain/contact.dart';

final contactsProvider =
    AsyncNotifierProvider<ContactsController, List<Contact>>(
      ContactsController.new,
    );

/// The family list, in the order the family chose.
class ContactsController extends AsyncNotifier<List<Contact>> {
  @override
  Future<List<Contact>> build() =>
      ref.watch(contactRepositoryProvider).loadAll();

  Future<void> _replace(List<Contact> contacts) async {
    if (!ref.mounted) return;
    state = AsyncData(contacts);
    await ref.read(contactRepositoryProvider).saveAll(contacts);
  }

  /// Adds a new contact at the end, or replaces one with the same id.
  Future<void> save(Contact contact) async {
    final current = [...(state.value ?? await future)];
    final index = current.indexWhere((c) => c.id == contact.id);
    if (index == -1) {
      current.add(contact);
    } else {
      current[index] = contact;
    }
    await _replace(current);
  }

  Future<void> delete(String id) async {
    final current = state.value ?? await future;
    await _replace([
      for (final contact in current)
        if (contact.id != id) contact,
    ]);
  }

  /// Moves the contact at [from] so it ends up at index [to].
  Future<void> move(int from, int to) async {
    final current = [...(state.value ?? await future)];
    current.insert(to, current.removeAt(from));
    await _replace(current);
  }

  /// Listens once and returns what was heard, so the family can save a name
  /// the way the recogniser writes it. Null when nothing usable was heard.
  Future<String?> hearName() async {
    final permissions = ref.read(voicePermissionsProvider);
    if (!await permissions.isGranted(VoicePermission.microphone) &&
        !await permissions.request(VoicePermission.microphone)) {
      return null;
    }
    final settings = await ref.read(settingsProvider.future);
    final result = await ref
        .read(speechRecognizerProvider)
        .listen(
          settings.language.speechLocale,
          allowOnline: settings.allowOnline,
        );
    return switch (result) {
      Heard(:final words) when words.isNotEmpty => words.first.trim(),
      _ => null,
    };
  }
}

/// A new id that sorts by creation time.
String newContactId() => 'c${DateTime.now().microsecondsSinceEpoch}';
