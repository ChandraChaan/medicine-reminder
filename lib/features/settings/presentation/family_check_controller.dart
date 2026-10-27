import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/providers.dart';
import '../domain/app_settings.dart';
import 'settings_controller.dart';

/// Whether this phone may send SMS right now.
final smsGrantedProvider = FutureProvider<bool>(
  (ref) => ref.watch(smsPermissionProvider).isGranted(),
);

enum FamilyTestResult { sent, opened, failed, needsNumber, needsConsent }

final familyCheckControllerProvider = Provider<FamilyCheckController>(
  FamilyCheckController.new,
);

class FamilyCheckController {
  FamilyCheckController(this._ref);

  final Ref _ref;

  Future<void> change(FamilyCheck Function(FamilyCheck family) update) => _ref
      .read(settingsProvider.notifier)
      .change((s) => s.copyWith(family: update(s.family)));

  Future<void> setNumber(int index, String value) => change((family) {
    final numbers = [...family.numbers];
    while (numbers.length <= index) {
      numbers.add('');
    }
    numbers[index] = value.trim();
    return family.copyWith(numbers: numbers);
  });

  Future<bool> requestSms() async {
    final granted = await _ref.read(smsPermissionProvider).request();
    _ref.invalidate(smsGrantedProvider);
    return granted;
  }

  /// Sends (SMS) or opens (WhatsApp) a test message to the family numbers.
  Future<FamilyTestResult> sendTest() async {
    final settings = await _ref.read(settingsProvider.future);
    final family = settings.family;
    final numbers = family.validNumbers;
    if (numbers.isEmpty) return FamilyTestResult.needsNumber;
    final l10n = l10nFor(settings.language);
    final person = family.personName.trim().isEmpty
        ? l10n.familyPersonFallback
        : family.personName.trim();
    final message = l10n.familyTestMessage(person);
    final bridge = _ref.read(alarmBridgeProvider);
    switch (family.channel) {
      case FamilyChannel.whatsapp:
        await bridge.openWhatsApp(numbers.first, message);
        return FamilyTestResult.opened;
      case FamilyChannel.sms:
        if (!family.smsConsent) return FamilyTestResult.needsConsent;
        if (!await _ref.read(smsPermissionProvider).isGranted() &&
            !await requestSms()) {
          return FamilyTestResult.failed;
        }
        return await bridge.sendSms(numbers, message)
            ? FamilyTestResult.sent
            : FamilyTestResult.failed;
    }
  }
}
