import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/contact_photo.dart';
import '../../../core/widgets/phone_key.dart';
import '../../doses/domain/dose.dart';
import '../../doses/presentation/dose_controller.dart';
import '../../family/domain/contact.dart';
import '../../family/presentation/contacts_controller.dart';
import 'assistant_controller.dart';
import 'display_panel.dart';
import 'speak_key.dart';

/// The parent's screen: the display, the big talk key, a key for each
/// family member, and the red Help key.
class VoiceHomeScreen extends ConsumerWidget {
  const VoiceHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = PhoneColors.of(context);
    final contacts = ref.watch(contactsProvider).value ?? const <Contact>[];
    final helpNext = ref.watch(assistantProvider.select((s) => s.helpNext));
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Two photo keys per row on phones, three on wide screens.
            final columns = constraints.maxWidth >= 600 ? 3 : 2;
            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              children: [
                const _SpeakerGrille(),
                const SizedBox(height: 12),
                const DisplayPanel(),
                const SizedBox(height: 20),
                const Center(child: SpeakKey()),
                if (helpNext != null) ...[
                  const SizedBox(height: 20),
                  _HelpNextCard(next: helpNext),
                ],
                const SizedBox(height: 24),
                _Engraved(text: context.l10n.familyHeading),
                const SizedBox(height: 10),
                if (contacts.isEmpty)
                  _EmptyFamily(colors: colors)
                else
                  _ContactGrid(contacts: contacts, columns: columns),
                const SizedBox(height: 8),
                const _RemindersKey(),
                const SizedBox(height: 20),
                const _HelpKey(),
                const SizedBox(height: 28),
                const _SetupKey(),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// The rows of holes over an old phone's earpiece. Decoration only.
class _SpeakerGrille extends StatelessWidget {
  const _SpeakerGrille();

  @override
  Widget build(BuildContext context) {
    final colors = PhoneColors.of(context);
    return ExcludeSemantics(
      child: Column(
        children: [
          for (var row = 0; row < 2; row++)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < 9 - row; i++)
                    Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: colors.bodyShade,
                        shape: BoxShape.circle,
                        border: Border.all(color: colors.keyEdge, width: 0.8),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// A label that looks pressed into the plastic.
class _Engraved extends StatelessWidget {
  const _Engraved({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = PhoneColors.of(context);
    return Text(
      text,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: colors.onBodyMuted,
        shadows: [Shadow(color: colors.key, offset: const Offset(0, 1))],
      ),
    );
  }
}

class _EmptyFamily extends StatelessWidget {
  const _EmptyFamily({required this.colors});

  final PhoneColors colors;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: colors.keyEdge, width: 1.5),
    ),
    child: Text(
      context.l10n.noContactsYet,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge,
    ),
  );
}

class _ContactGrid extends StatelessWidget {
  const _ContactGrid({required this.contacts, required this.columns});

  final List<Contact> contacts;
  final int columns;

  @override
  Widget build(BuildContext context) {
    final rows = <List<Contact>>[
      for (var i = 0; i < contacts.length; i += columns)
        contacts.sublist(i, (i + columns).clamp(0, contacts.length)),
    ];
    return Column(
      children: [
        for (final row in rows)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < columns; i++) ...[
                  if (i > 0) const SizedBox(width: 12),
                  Expanded(
                    child: i < row.length
                        ? _ContactKey(key: ValueKey(row[i].id), contact: row[i])
                        : const SizedBox.shrink(),
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

class _ContactKey extends ConsumerWidget {
  const _ContactKey({required this.contact, super.key});

  final Contact contact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = PhoneColors.of(context);
    return PhoneKey(
      color: colors.key,
      edgeColor: colors.keyEdge,
      semanticLabel: context.l10n.callName(contact.name),
      onTap: () =>
          unawaited(ref.read(assistantProvider.notifier).call(contact)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            LayoutBuilder(
              builder: (context, constraints) => ContactPhoto(
                name: contact.name,
                path: contact.photoPath,
                size: constraints.maxWidth,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.call_rounded, color: colors.talk, size: 24),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    contact.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(color: colors.onKey),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Opens today's reminders (the Daily Reminder screen) and says how many
/// are left.
class _RemindersKey extends ConsumerWidget {
  const _RemindersKey();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = PhoneColors.of(context);
    final l10n = context.l10n;
    final today = ref.watch(todayProvider).value;
    final hasReminders =
        ref.watch(appDataProvider).value?.medicines.isNotEmpty ?? false;
    final left = today
        ?.where((d) => d.status is! DoseTaken && d.status is! DoseSkipped)
        .length;
    final detail = !hasReminders
        ? l10n.remindersNone
        : left == null
        ? null
        : left == 0
        ? l10n.remindersAllDone
        : l10n.remindersLeft(left);
    final text = Theme.of(context).textTheme;
    return PhoneKey(
      color: colors.key,
      edgeColor: colors.keyEdge,
      semanticLabel: [l10n.todaysReminders, ?detail].join('. '),
      onTap: () => context.push('/reminders'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(Icons.alarm_rounded, color: colors.talk, size: 36),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.todaysReminders,
                    style: text.titleLarge?.copyWith(color: colors.onKey),
                  ),
                  if (detail != null)
                    Text(
                      detail,
                      style: text.bodyLarge?.copyWith(
                        color: colors.onBodyMuted,
                      ),
                    ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: colors.onKey, size: 32),
          ],
        ),
      ),
    );
  }
}

class _HelpKey extends ConsumerWidget {
  const _HelpKey();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = PhoneColors.of(context);
    final l10n = context.l10n;
    return PhoneKey(
      color: colors.help,
      edgeColor: colors.helpEdge,
      semanticLabel: '${l10n.helpButton}. ${l10n.helpButtonHint}',
      onTap: () => unawaited(ref.read(assistantProvider.notifier).pressHelp()),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 84),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.sos_rounded, color: colors.onHelp, size: 40),
              const SizedBox(width: 14),
              Flexible(
                child: Text(
                  l10n.helpButton,
                  style: Theme.of(
                    context,
                  ).textTheme.headlineMedium?.copyWith(color: colors.onHelp),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Shown after a Help call so the parent can quickly call the next person.
class _HelpNextCard extends ConsumerWidget {
  const _HelpNextCard({required this.next});

  final Contact next;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = PhoneColors.of(context);
    final l10n = context.l10n;
    final called = ref.watch(assistantProvider.select((s) => s.helpCalled));
    final controller = ref.read(assistantProvider.notifier);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.help, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (called != null)
            Text(
              l10n.helpNextTitle(called.name),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          const SizedBox(height: 12),
          PhoneKey(
            color: colors.help,
            edgeColor: colors.helpEdge,
            semanticLabel: l10n.callName(next.name),
            onTap: () => unawaited(controller.pressHelp()),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.call_rounded, color: colors.onHelp, size: 30),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      l10n.callName(next.name),
                      textAlign: TextAlign.center,
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(color: colors.onHelp),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            style: TextButton.styleFrom(minimumSize: const Size(48, 52)),
            onPressed: controller.dismissHelp,
            child: Text(l10n.helpFine),
          ),
        ],
      ),
    );
  }
}

/// Family setup opens on a long press, so a stray tap by the parent doesn't
/// land them in settings.
class _SetupKey extends StatelessWidget {
  const _SetupKey();

  @override
  Widget build(BuildContext context) {
    final colors = PhoneColors.of(context);
    final l10n = context.l10n;
    return Center(
      child: PhoneKey(
        color: colors.body,
        edgeColor: colors.bodyShade,
        depth: 3,
        semanticLabel: '${l10n.familySetup}. ${l10n.holdToOpen}',
        onLongPress: () => context.push('/setup'),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.settings_rounded,
                    color: colors.onBodyMuted,
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      l10n.familySetup,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colors.onBodyMuted,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                l10n.holdToOpen,
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: colors.onBodyMuted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
