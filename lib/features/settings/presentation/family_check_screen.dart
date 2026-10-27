import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/widgets/async_view.dart';
import '../../doses/presentation/alarm_sync.dart';
import '../../medicines/presentation/medicines_controller.dart';
import '../domain/app_settings.dart';
import 'family_check_controller.dart';
import 'settings_controller.dart';

/// Optional: tell one or two family members when a dose isn't taken.
/// Off until the setup person turns it on and, for SMS, agrees.
class FamilyCheckScreen extends ConsumerWidget {
  const FamilyCheckScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.familyCheckTitle)),
      body: AsyncView(
        value: settings,
        onRetry: () => ref.invalidate(settingsProvider),
        builder: (context, s) => _FamilyForm(initial: s.family),
      ),
    );
  }
}

class _FamilyForm extends ConsumerStatefulWidget {
  const _FamilyForm({required this.initial});

  final FamilyCheck initial;

  @override
  ConsumerState<_FamilyForm> createState() => _FamilyFormState();
}

class _FamilyFormState extends ConsumerState<_FamilyForm> {
  late final TextEditingController _person;
  late final List<TextEditingController> _numbers;

  @override
  void initState() {
    super.initState();
    _person = TextEditingController(text: widget.initial.personName);
    _numbers = [
      for (var i = 0; i < maxFamilyNumbers; i++)
        TextEditingController(
          text: i < widget.initial.numbers.length
              ? widget.initial.numbers[i]
              : '',
        ),
    ];
  }

  @override
  void dispose() {
    _person.dispose();
    for (final c in _numbers) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _sendTest() async {
    final l10n = context.l10n;
    final result = await ref.read(familyCheckControllerProvider).sendTest();
    if (!mounted || result == FamilyTestResult.opened) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(switch (result) {
          FamilyTestResult.sent => l10n.familyTestSent,
          FamilyTestResult.needsNumber => l10n.familyNeedsNumber,
          FamilyTestResult.needsConsent => l10n.familyNeedsConsent,
          FamilyTestResult.failed ||
          FamilyTestResult.opened => l10n.familyTestFailed,
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final family = ref.watch(settingsProvider).value?.family ?? widget.initial;
    final controller = ref.read(familyCheckControllerProvider);
    final smsGranted = ref.watch(smsGrantedProvider).value ?? false;
    final language =
        ref.watch(settingsProvider).value?.language ?? AppLanguage.english;
    final medicines = ref.watch(medicinesProvider).value ?? const [];
    final previewL10n = l10nFor(language);
    final preview = familyMessage(previewL10n, family, [
      medicines.isEmpty ? previewL10n.sampleMedicine : medicines.first.name,
    ], medicines.isEmpty ? 8 * 60 : medicines.first.times.first);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
      children: [
        Text(l10n.familyCheckIntro, style: text.bodyLarge),
        const SizedBox(height: 12),
        SwitchListTile(
          key: const Key('family-enabled'),
          contentPadding: EdgeInsets.zero,
          value: family.enabled,
          title: Text(l10n.familyCheckEnable, style: text.titleLarge),
          onChanged: (on) =>
              unawaited(controller.change((f) => f.copyWith(enabled: on))),
        ),
        if (family.enabled) ...[
          const SizedBox(height: 12),
          TextField(
            key: const Key('family-person'),
            controller: _person,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              labelText: l10n.familyPersonLabel,
              hintText: l10n.familyPersonHint,
            ),
            onChanged: (value) => unawaited(
              controller.change((f) => f.copyWith(personName: value)),
            ),
          ),
          for (var i = 0; i < maxFamilyNumbers; i++) ...[
            const SizedBox(height: 12),
            TextField(
              key: Key('family-number-$i'),
              controller: _numbers[i],
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: l10n.familyNumberLabel(i + 1),
                hintText: l10n.familyNumberHint,
                errorText:
                    _numbers[i].text.trim().isNotEmpty &&
                        normalizePhone(_numbers[i].text) == null
                    ? l10n.familyNumberInvalid
                    : null,
              ),
              onChanged: (value) {
                setState(() {});
                unawaited(controller.setNumber(i, value));
              },
            ),
          ],
          if (family.validNumbers.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                l10n.familyNeedsNumber,
                style: text.titleMedium?.copyWith(color: scheme.error),
              ),
            ),
          const SizedBox(height: 20),
          Text(l10n.familyHowTitle, style: text.titleLarge),
          RadioGroup<FamilyChannel>(
            groupValue: family.channel,
            onChanged: (channel) {
              if (channel != null) {
                unawaited(
                  controller.change((f) => f.copyWith(channel: channel)),
                );
              }
            },
            child: Column(
              children: [
                RadioListTile<FamilyChannel>(
                  key: const Key('family-channel-sms'),
                  contentPadding: EdgeInsets.zero,
                  value: FamilyChannel.sms,
                  title: Text(l10n.familyChannelSms),
                  subtitle: Text(l10n.familyChannelSmsHelp),
                ),
                RadioListTile<FamilyChannel>(
                  key: const Key('family-channel-whatsapp'),
                  contentPadding: EdgeInsets.zero,
                  value: FamilyChannel.whatsapp,
                  title: Text(l10n.familyChannelWhatsapp),
                  subtitle: Text(l10n.familyChannelWhatsappHelp),
                ),
              ],
            ),
          ),
          if (family.channel == FamilyChannel.sms) ...[
            CheckboxListTile(
              key: const Key('family-consent'),
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              value: family.smsConsent,
              title: Text(l10n.familySmsConsent),
              onChanged: (agreed) async {
                await controller.change(
                  (f) => f.copyWith(smsConsent: agreed ?? false),
                );
                if ((agreed ?? false) && !smsGranted) {
                  await controller.requestSms();
                }
              },
            ),
            if (family.smsConsent && !smsGranted) ...[
              Text(
                l10n.familySmsPermissionMissing,
                style: text.bodyLarge?.copyWith(color: scheme.error),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () => unawaited(controller.requestSms()),
                icon: const Icon(Icons.sms_rounded),
                label: Text(l10n.familySmsPermission),
              ),
            ],
          ],
          const SizedBox(height: 20),
          Text(l10n.familyMessagePreview, style: text.titleLarge),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Text(
                preview,
                key: const Key('family-preview'),
                style: text.bodyLarge,
              ),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            key: const Key('family-test'),
            onPressed: () => unawaited(_sendTest()),
            icon: const Icon(Icons.send_rounded),
            label: Text(l10n.familySendTest),
          ),
        ],
      ],
    );
  }
}
