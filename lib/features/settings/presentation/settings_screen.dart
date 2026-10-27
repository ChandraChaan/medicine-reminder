import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/platform/alarm_bridge.dart';
import '../../../core/providers.dart';
import '../../../core/widgets/async_view.dart';
import '../../doses/presentation/alarm_voice.dart';
import '../domain/app_settings.dart';
import 'settings_controller.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final settings = ref.watch(settingsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: AsyncView(
        value: settings,
        onRetry: () => ref.invalidate(settingsProvider),
        builder: (context, s) => ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
          children: [
            _Heading(l10n.settingsLanguage),
            LanguagePicker(
              selected: s.language,
              onSelected: (language) => ref
                  .read(settingsProvider.notifier)
                  .change((s) => s.copyWith(language: language)),
            ),
            _Heading(l10n.settingsSpeak),
            const _SpeechSettings(),
            _Heading(l10n.settingsMissedAfter),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final minutes in missedAfterChoices)
                  ChoiceChip(
                    label: Text(
                      minutes < 60
                          ? l10n.minutesCount(minutes)
                          : l10n.hoursCount(minutes ~/ 60),
                    ),
                    selected: s.missedAfterMinutes == minutes,
                    onSelected: (_) => ref
                        .read(settingsProvider.notifier)
                        .change((s) => s.copyWith(missedAfterMinutes: minutes)),
                  ),
              ],
            ),
            _Heading(l10n.familyCheckTitle),
            Card(
              child: ListTile(
                key: const Key('open-family-check'),
                leading: const Icon(Icons.family_restroom_rounded, size: 32),
                title: Text(l10n.familyCheckEnable),
                subtitle: Text(
                  s.family.isActive
                      ? l10n.familyStatusOn
                      : l10n.familyStatusOff,
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => context.push('/family'),
              ),
            ),
            _Heading(l10n.settingsPermissions),
            const _PermissionList(),
            _Heading(l10n.settingsAbout),
            Text(
              l10n.aboutPrivacy,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.aboutDisclaimer,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.aboutSource,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 24, bottom: 10),
    child: Semantics(
      header: true,
      child: Text(text, style: Theme.of(context).textTheme.titleLarge),
    ),
  );
}

/// Three big language buttons, each written in its own script.
class LanguagePicker extends StatelessWidget {
  const LanguagePicker({
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final AppLanguage? selected;
  final ValueChanged<AppLanguage> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final language in AppLanguage.values)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: language == selected
                ? FilledButton.icon(
                    key: Key('language-${language.code}'),
                    onPressed: () => onSelected(language),
                    icon: const Icon(Icons.check_rounded),
                    label: Text(languageName(l10n, language)),
                  )
                : OutlinedButton(
                    key: Key('language-${language.code}'),
                    onPressed: () => onSelected(language),
                    child: Text(languageName(l10n, language)),
                  ),
          ),
      ],
    );
  }
}

class _SpeechSettings extends ConsumerStatefulWidget {
  const _SpeechSettings();

  @override
  ConsumerState<_SpeechSettings> createState() => _SpeechSettingsState();
}

class _SpeechSettingsState extends ConsumerState<_SpeechSettings> {
  bool _voiceMissing = false;

  Future<void> _test(AppLanguage language) async {
    final ok = await ref
        .read(alarmVoiceProvider)
        .say(
          language,
          (l10n) => l10n.speechOne(l10n.sampleMedicine, l10n.foodAfterSpoken),
        );
    if (!mounted) return;
    setState(() => _voiceMissing = !ok);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final settings = ref.watch(settingsProvider).value;
    if (settings == null) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          value: settings.speak,
          title: Text(l10n.settingsSpeak),
          subtitle: Text(l10n.settingsSpeakHelp),
          onChanged: (speak) => ref
              .read(settingsProvider.notifier)
              .change((s) => s.copyWith(speak: speak)),
        ),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: OutlinedButton.icon(
            onPressed: () => unawaited(_test(settings.language)),
            icon: const Icon(Icons.volume_up_rounded),
            label: Text(l10n.testVoice),
          ),
        ),
        if (_voiceMissing)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              l10n.voiceMissing,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
      ],
    );
  }
}

class _PermissionList extends ConsumerWidget {
  const _PermissionList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final permissions =
        ref.watch(permissionsProvider).value ?? AlarmPermissions.allGranted;
    final bridge = ref.read(alarmBridgeProvider);
    Future<void> fixNotifications() async {
      if (!await ref.read(notificationPermissionProvider).request()) {
        await bridge.openNotificationSettings();
      }
      ref.invalidate(permissionsProvider);
    }

    Widget tile(String title, bool on, Future<void> Function() fix) => Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          on ? Icons.check_circle_rounded : Icons.error_rounded,
          color: on
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.error,
          size: 30,
        ),
        title: Text(title),
        subtitle: Text(on ? l10n.permOn : l10n.permOff),
        onTap: on ? null : () => unawaited(fix()),
      ),
    );
    return Column(
      children: [
        tile(
          l10n.permNotifications,
          permissions.notifications,
          fixNotifications,
        ),
        tile(
          l10n.permExactAlarms,
          permissions.exactAlarms,
          bridge.openExactAlarmSettings,
        ),
        tile(
          l10n.permFullScreen,
          permissions.fullScreen,
          bridge.openFullScreenSettings,
        ),
      ],
    );
  }
}
