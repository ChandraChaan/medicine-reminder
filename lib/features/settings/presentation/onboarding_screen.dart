import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/providers.dart';
import 'settings_controller.dart';
import 'settings_screen.dart';

/// First launch: pick a language, then allow reminders.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  bool _languageChosen = false;

  Future<void> _allowAndStart() async {
    final bridge = ref.read(alarmBridgeProvider);
    await ref.read(notificationPermissionProvider).request();
    final permissions = await bridge.permissions();
    if (!permissions.fullScreen) await bridge.openFullScreenSettings();
    await _finish();
  }

  Future<void> _finish() async {
    await ref
        .read(settingsProvider.notifier)
        .change((s) => s.copyWith(onboarded: true));
    ref.invalidate(permissionsProvider);
    if (!mounted) return;
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final settings = ref.watch(settingsProvider).value;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: _languageChosen
              ? [
                  Icon(
                    Icons.alarm_on_rounded,
                    size: 96,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(l10n.onboardingTitle, style: text.headlineMedium),
                  const SizedBox(height: 12),
                  Text(l10n.onboardingBody, style: text.titleMedium),
                  const SizedBox(height: 12),
                  Text(l10n.onboardingPrivacy, style: text.bodyLarge),
                  const SizedBox(height: 12),
                  Text(l10n.aboutDisclaimer, style: text.bodyLarge),
                  const SizedBox(height: 28),
                  FilledButton.icon(
                    key: const Key('onboarding-allow'),
                    onPressed: () => unawaited(_allowAndStart()),
                    icon: const Icon(Icons.notifications_active_rounded),
                    label: Text(l10n.allowReminders),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () => setState(() => _languageChosen = false),
                    child: Text(l10n.back),
                  ),
                ]
              : [
                  Icon(
                    Icons.translate_rounded,
                    size: 80,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(l10n.chooseLanguageTitle, style: text.headlineMedium),
                  const SizedBox(height: 20),
                  LanguagePicker(
                    selected: settings?.language,
                    onSelected: (language) async {
                      await ref
                          .read(settingsProvider.notifier)
                          .change((s) => s.copyWith(language: language));
                      if (!mounted) return;
                      setState(() => _languageChosen = true);
                    },
                  ),
                ],
        ),
      ),
    );
  }
}
