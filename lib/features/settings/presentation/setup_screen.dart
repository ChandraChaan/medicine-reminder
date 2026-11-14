import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/platform/speech_recognizer.dart';
import '../../../core/platform/voice_permissions.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/contact_photo.dart';
import '../../family/domain/contact.dart';
import '../../family/presentation/contacts_controller.dart';
import '../domain/app_settings.dart';
import 'settings_controller.dart';
import 'voice_status.dart';

/// Where the family sets the phone up: language, people, listening, voice
/// and permissions.
class SetupScreen extends ConsumerWidget {
  const SetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final contacts = ref.watch(contactsProvider);
    final list = contacts.value ?? const <Contact>[];
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.familySetup),
        actions: [
          IconButton(
            tooltip: l10n.done,
            onPressed: () => context.canPop() ? context.pop() : context.go('/'),
            icon: const Icon(Icons.check_rounded, size: 30),
          ),
        ],
      ),
      body: ReorderableListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
        buildDefaultDragHandles: false,
        header: const _Header(),
        footer: const _Footer(),
        itemCount: list.length,
        onReorderItem: (from, to) =>
            unawaited(ref.read(contactsProvider.notifier).move(from, to)),
        itemBuilder: (context, index) => _ContactRow(
          key: ValueKey(list[index].id),
          contact: list[index],
          index: index,
        ),
      ),
    );
  }
}

class _Header extends ConsumerWidget {
  const _Header();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final language = ref.watch(languageProvider);
    final hasContacts = ref.watch(
      contactsProvider.select((c) => c.value?.isNotEmpty ?? false),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.setupIntro, style: Theme.of(context).textTheme.bodyLarge),
        _SectionTitle(l10n.languageHeading),
        _LanguagePicker(
          selected: language,
          onSelected: (language) => unawaited(
            ref.read(settingsProvider.notifier).setLanguage(language),
          ),
        ),
        _SectionTitle(l10n.familyMembers),
        if (hasContacts)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              l10n.reorderHint,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
      ],
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        FilledButton.icon(
          onPressed: () => context.push('/setup/contact/new'),
          icon: const Icon(Icons.person_add_alt_1_rounded),
          label: Text(l10n.addContact),
        ),
        _SectionTitle(l10n.setupReminders),
        Text(
          l10n.setupRemindersDetail,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: () => context.push('/medicines'),
          icon: const Icon(Icons.alarm_rounded),
          label: Text(l10n.setupEditReminders),
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: () => context.push('/settings'),
          icon: const Icon(Icons.tune_rounded),
          label: Text(l10n.setupReminderSettings),
        ),
        _SectionTitle(l10n.speechHeading),
        const _ListeningCard(),
        _SectionTitle(l10n.voiceHeading),
        const _VoiceCard(),
        _SectionTitle(l10n.permissionsHeading),
        const _PermissionsCard(),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 28, bottom: 10),
    child: Semantics(
      header: true,
      child: Text(text, style: Theme.of(context).textTheme.titleLarge),
    ),
  );
}

/// Three large choices, each written in its own script.
class _LanguagePicker extends StatelessWidget {
  const _LanguagePicker({required this.selected, required this.onSelected});

  final AppLanguage selected;
  final ValueChanged<AppLanguage> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        for (final language in AppLanguage.values)
          ChoiceChip(
            label: Text(languageName(l10n, language)),
            labelStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: language == selected ? scheme.onPrimary : scheme.onSurface,
            ),
            selected: language == selected,
            selectedColor: scheme.primary,
            checkmarkColor: scheme.onPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            onSelected: (_) => onSelected(language),
          ),
      ],
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({required this.contact, required this.index, super.key});

  final Contact contact;
  final int index;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = PhoneColors.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => context.push('/setup/contact/${contact.id}'),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 4, 10),
            child: Row(
              children: [
                ContactPhoto(
                  name: contact.name,
                  path: contact.photoPath,
                  size: 56,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contact.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        contact.phone,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      if (contact.forHelp)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Row(
                            children: [
                              Icon(
                                Icons.sos_rounded,
                                size: 20,
                                color: colors.help,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                l10n.helpButton,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: colors.help,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                ReorderableDragStartListener(
                  index: index,
                  child: const SizedBox.square(
                    dimension: 48,
                    child: Icon(Icons.drag_handle_rounded, size: 28),
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

/// Says honestly how listening works on this phone, and offers the offline
/// download or online listening when needed.
class _ListeningCard extends ConsumerWidget {
  const _ListeningCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final language = ref.watch(languageProvider);
    final name = languageName(l10n, language);
    final status = ref.watch(recognizerStatusProvider);
    final allowOnline = ref.watch(settingsProvider).value?.allowOnline ?? false;

    final Widget body = switch (status) {
      AsyncData(:final value) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            _statusText(l10n, value, name),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          if (value.offline == OfflineSpeech.downloadable) ...[
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => unawaited(_download(context, ref, language)),
              icon: const Icon(Icons.download_rounded),
              label: Text(l10n.speechDownload(name)),
            ),
          ],
        ],
      ),
      AsyncError() => Text(
        l10n.errorGeneric,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      _ => const Center(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: CircularProgressIndicator(),
        ),
      ),
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(padding: const EdgeInsets.only(right: 8), child: body),
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: allowOnline,
              onChanged: (value) => unawaited(
                ref.read(settingsProvider.notifier).setAllowOnline(value),
              ),
              title: Text(
                l10n.allowOnline,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              subtitle: Text(l10n.allowOnlineDetail),
            ),
          ],
        ),
      ),
    );
  }

  static String _statusText(
    AppLocalizations l10n,
    RecognizerStatus status,
    String language,
  ) {
    if (!status.onDevice && !status.anyRecognizer) return l10n.speechNone;
    if (!status.onDevice) return l10n.speechOnlineOnly(language);
    return switch (status.offline) {
      OfflineSpeech.installed => l10n.speechOffline(language),
      OfflineSpeech.downloading => l10n.speechDownloading(language),
      OfflineSpeech.downloadable => l10n.speechDownloadable(language),
      OfflineSpeech.unsupported => l10n.speechOnlineOnly(language),
      OfflineSpeech.unknown => l10n.speechUnknown(language),
    };
  }

  Future<void> _download(
    BuildContext context,
    WidgetRef ref,
    AppLanguage language,
  ) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final started = await ref
        .read(speechRecognizerProvider)
        .downloadOffline(language.speechLocale);
    if (!context.mounted) return;
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          started ? l10n.speechDownloadStarted : l10n.speechDownloadFailed,
        ),
      ),
    );
    ref.invalidate(recognizerStatusProvider);
  }
}

class _VoiceCard extends ConsumerWidget {
  const _VoiceCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final language = ref.watch(languageProvider);
    final hasVoice = ref.watch(hasVoiceProvider).value ?? true;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!hasVoice) ...[
              Text(
                l10n.noVoice(languageName(l10n, language)),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 12),
            ],
            OutlinedButton.icon(
              onPressed: () => unawaited(
                ref
                    .read(speechServiceProvider)
                    .speak(l10n.voiceSample, language.speechLocale),
              ),
              icon: const Icon(Icons.volume_up_rounded),
              label: Text(l10n.hearSample),
            ),
          ],
        ),
      ),
    );
  }
}

class _PermissionsCard extends ConsumerWidget {
  const _PermissionsCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final granted = ref.watch(voicePermissionStatusProvider).value ?? const {};
    Future<void> ask(VoicePermission permission) async {
      await ref.read(voicePermissionsProvider).request(permission);
      ref.invalidate(voicePermissionStatusProvider);
    }

    return Card(
      child: Column(
        children: [
          _PermissionRow(
            title: l10n.micPermission,
            granted: granted[VoicePermission.microphone] ?? false,
            onAllow: () => unawaited(ask(VoicePermission.microphone)),
          ),
          const Divider(height: 1),
          _PermissionRow(
            title: l10n.phonePermission,
            detail: l10n.phonePermissionDetail,
            granted: granted[VoicePermission.phone] ?? false,
            onAllow: () => unawaited(ask(VoicePermission.phone)),
          ),
        ],
      ),
    );
  }
}

class _PermissionRow extends StatelessWidget {
  const _PermissionRow({
    required this.title,
    required this.granted,
    required this.onAllow,
    this.detail,
  });

  final String title;
  final String? detail;
  final bool granted;
  final VoidCallback onAllow;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final detailText = detail;
    // Stacked, not side by side: the button must fit at 200% text too.
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          if (detailText != null && !granted)
            Text(detailText, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 8),
          if (granted)
            Row(
              children: [
                Icon(Icons.check_circle_rounded, color: scheme.primary),
                const SizedBox(width: 6),
                Flexible(child: Text(l10n.allowed)),
              ],
            )
          else
            FilledButton(onPressed: onAllow, child: Text(l10n.allow)),
        ],
      ),
    );
  }
}
