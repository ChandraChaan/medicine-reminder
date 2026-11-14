import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/platform/photo_picker.dart';
import '../../../core/providers.dart';
import '../../../core/widgets/contact_photo.dart';
import '../domain/contact.dart';
import 'contacts_controller.dart';

/// Add or change one family member.
class ContactFormScreen extends ConsumerWidget {
  const ContactFormScreen({this.contactId, super.key});

  /// Null for a new person.
  final String? contactId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contacts = ref.watch(contactsProvider);
    return switch (contacts) {
      AsyncData(:final value) => _ContactForm(
        initial: value.where((c) => c.id == contactId).firstOrNull,
      ),
      AsyncError() => Scaffold(
        appBar: AppBar(),
        body: Center(
          child: FilledButton(
            onPressed: () => ref.invalidate(contactsProvider),
            child: Text(context.l10n.retry),
          ),
        ),
      ),
      _ => Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      ),
    };
  }
}

class _ContactForm extends ConsumerStatefulWidget {
  const _ContactForm({required this.initial});

  final Contact? initial;

  @override
  ConsumerState<_ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends ConsumerState<_ContactForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _phone;
  final _nickname = TextEditingController();
  late List<String> _nicknames;
  late bool _forHelp;
  String? _photoPath;
  bool _hearing = false;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    _name = TextEditingController(text: initial?.name ?? '');
    _phone = TextEditingController(text: initial?.phone ?? '');
    _nicknames = [...?initial?.nicknames];
    _forHelp = initial?.forHelp ?? true;
    _photoPath = initial?.photoPath;
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _nickname.dispose();
    super.dispose();
  }

  void _addNickname(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    final exists = _nicknames.any(
      (n) => n.toLowerCase() == trimmed.toLowerCase(),
    );
    setState(() {
      if (!exists) _nicknames.add(trimmed);
      _nickname.clear();
    });
  }

  Future<void> _sayIt() async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _hearing = true);
    final heard = await ref.read(contactsProvider.notifier).hearName();
    if (!mounted) return;
    setState(() => _hearing = false);
    if (heard == null || heard.isEmpty) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.heardNicknameNothing)),
      );
      return;
    }
    _addNickname(heard);
    messenger.showSnackBar(SnackBar(content: Text(l10n.heardNickname(heard))));
  }

  Future<void> _pickPhoto(PhotoSource source) async {
    final path = await ref.read(photoPickerProvider).pick(source);
    if (path != null && mounted) setState(() => _photoPath = path);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final initial = widget.initial;
    final contact = Contact(
      id: initial?.id ?? newContactId(),
      name: _name.text.trim(),
      phone: _phone.text.trim(),
      photoPath: _photoPath,
      nicknames: _nicknames,
      forHelp: _forHelp,
    );
    await ref.read(contactsProvider.notifier).save(contact);
    if (mounted) context.pop();
  }

  Future<void> _delete() async {
    final initial = widget.initial;
    if (initial == null) return;
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteConfirm(initial.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(contactsProvider.notifier).delete(initial.id);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final initial = widget.initial;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          initial == null ? l10n.newContact : l10n.editContact(initial.name),
        ),
        actions: [
          if (initial != null)
            IconButton(
              tooltip: l10n.delete,
              onPressed: () => unawaited(_delete()),
              icon: const Icon(Icons.delete_outline_rounded),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            Center(
              child: ListenableBuilder(
                listenable: _name,
                builder: (context, _) =>
                    ContactPhoto(name: _name.text, path: _photoPath, size: 140),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton.icon(
                  onPressed: () => unawaited(_pickPhoto(PhotoSource.camera)),
                  icon: const Icon(Icons.photo_camera_rounded),
                  label: Text(l10n.takePhoto),
                ),
                OutlinedButton.icon(
                  onPressed: () => unawaited(_pickPhoto(PhotoSource.gallery)),
                  icon: const Icon(Icons.photo_library_rounded),
                  label: Text(l10n.choosePhoto),
                ),
                if (_photoPath != null)
                  TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: const Size(48, 52),
                    ),
                    onPressed: () => setState(() => _photoPath = null),
                    child: Text(l10n.removePhoto),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _name,
              textCapitalization: TextCapitalization.words,
              style: text.titleMedium,
              decoration: InputDecoration(labelText: l10n.contactNameLabel),
              validator: (value) => (value ?? '').trim().isEmpty
                  ? l10n.contactNameRequired
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              style: text.titleMedium,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9+ ]')),
              ],
              decoration: InputDecoration(labelText: l10n.phoneLabel),
              validator: (value) {
                final digits = (value ?? '').replaceAll(RegExp(r'\D'), '');
                return digits.length < 3 ? l10n.phoneRequired : null;
              },
            ),
            const SizedBox(height: 28),
            Text(l10n.nicknamesHeading, style: text.titleLarge),
            const SizedBox(height: 6),
            Text(l10n.nicknamesHint, style: text.bodyMedium),
            const SizedBox(height: 12),
            if (_nicknames.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final nickname in _nicknames)
                    InputChip(
                      label: Text(nickname, style: text.titleMedium),
                      deleteButtonTooltipMessage: l10n.removeNickname(nickname),
                      onDeleted: () =>
                          setState(() => _nicknames.remove(nickname)),
                    ),
                ],
              ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextField(
                    controller: _nickname,
                    style: text.titleMedium,
                    decoration: InputDecoration(labelText: l10n.nicknameField),
                    onSubmitted: _addNickname,
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 60,
                  child: OutlinedButton(
                    onPressed: () => _addNickname(_nickname.text),
                    child: Text(l10n.addNickname),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            FilledButton.tonalIcon(
              onPressed: _hearing ? null : () => unawaited(_sayIt()),
              icon: _hearing
                  ? const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(strokeWidth: 2.5),
                    )
                  : const Icon(Icons.mic_rounded),
              label: Text(_hearing ? l10n.listening : l10n.sayIt),
            ),
            const SizedBox(height: 20),
            Card(
              child: SwitchListTile(
                value: _forHelp,
                onChanged: (value) => setState(() => _forHelp = value),
                secondary: Icon(
                  Icons.sos_rounded,
                  color: Theme.of(context).colorScheme.error,
                  size: 32,
                ),
                title: Text(l10n.forHelpTitle, style: text.titleMedium),
                subtitle: Text(l10n.forHelpDetail),
              ),
            ),
            const SizedBox(height: 28),
            FilledButton(
              onPressed: () => unawaited(_save()),
              child: Text(l10n.save),
            ),
          ],
        ),
      ),
    );
  }
}
