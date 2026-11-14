import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/platform/phone.dart';
import '../../../core/platform/speech_recognizer.dart';
import '../../../core/platform/voice_permissions.dart';
import '../../../core/providers.dart';
import '../../../core/time/clock.dart';
import '../../doses/domain/dose.dart';
import '../../doses/presentation/dose_controller.dart';
import '../../family/domain/contact.dart';
import '../../family/presentation/contacts_controller.dart';
import '../../settings/presentation/settings_controller.dart';
import '../../settings/presentation/voice_status.dart';
import '../domain/command.dart';
import '../domain/command_parser.dart';

enum AssistantPhase { idle, listening, working, speaking }

@immutable
class AssistantState {
  const AssistantState({
    this.phase = AssistantPhase.idle,
    this.heard,
    this.reply,
    this.helpCalled,
    this.helpNext,
  });

  final AssistantPhase phase;

  /// What the recogniser heard (partial while listening).
  final String? heard;

  /// The last thing the app said aloud.
  final String? reply;

  /// After a Help call: who was called, and who Help calls next.
  final Contact? helpCalled;
  final Contact? helpNext;

  AssistantState copyWith({
    AssistantPhase? phase,
    String? Function()? heard,
    String? Function()? reply,
    Contact? Function()? helpCalled,
    Contact? Function()? helpNext,
  }) => AssistantState(
    phase: phase ?? this.phase,
    heard: heard != null ? heard() : this.heard,
    reply: reply != null ? reply() : this.reply,
    helpCalled: helpCalled != null ? helpCalled() : this.helpCalled,
    helpNext: helpNext != null ? helpNext() : this.helpNext,
  );
}

final assistantProvider = NotifierProvider<AssistantController, AssistantState>(
  AssistantController.new,
);

/// Everything the home screen does: listen, work out the command, answer
/// aloud and act.
class AssistantController extends Notifier<AssistantState> {
  StreamSubscription<String>? _partial;

  /// A Help call was placed and the app hasn't been back since.
  bool _awaitingHelpReturn = false;

  @override
  AssistantState build() {
    ref.onDispose(() => unawaited(_partial?.cancel()));
    // A reply in the old language would stay on the display otherwise.
    ref.listen(languageProvider, (previous, next) {
      if (previous != next) {
        state = state.copyWith(heard: () => null, reply: () => null);
      }
    });
    return const AssistantState();
  }

  AppLocalizations get _l10n => l10nFor(ref.read(languageProvider));

  String get _localeTag => ref.read(languageProvider).speechLocale;

  /// The big button: starts listening, or stops it when already listening.
  Future<void> pressSpeak() async {
    switch (state.phase) {
      case AssistantPhase.listening:
        await ref.read(speechRecognizerProvider).cancel();
        return;
      case AssistantPhase.working:
        return;
      case AssistantPhase.idle:
      case AssistantPhase.speaking:
        break;
    }
    await ref.read(speechServiceProvider).stop();

    final permissions = ref.read(voicePermissionsProvider);
    if (!await permissions.isGranted(VoicePermission.microphone)) {
      final granted = await permissions.request(VoicePermission.microphone);
      if (!ref.mounted) return;
      ref.invalidate(voicePermissionStatusProvider);
      if (!granted) {
        await _say(_l10n.sayMicDenied);
        return;
      }
    }
    final settings = await ref.read(settingsProvider.future);
    if (!ref.mounted) return;

    state = state.copyWith(
      phase: AssistantPhase.listening,
      heard: () => null,
      reply: () => null,
    );
    final recognizer = ref.read(speechRecognizerProvider);
    _partial = recognizer.partial.listen((text) {
      if (ref.mounted && state.phase == AssistantPhase.listening) {
        state = state.copyWith(heard: () => text);
      }
    });
    final result = await _listen(recognizer, settings.allowOnline);
    // Cancelling stops events at once; its future can complete much later
    // (only when the stream closes), so it is not awaited.
    unawaited(_partial?.cancel());
    _partial = null;
    if (!ref.mounted) return;

    switch (result) {
      case Heard(:final words):
        state = state.copyWith(
          phase: AssistantPhase.working,
          heard: () => words.first,
        );
        final contacts = await ref.read(contactsProvider.future);
        if (!ref.mounted) return;
        await _run(parseCommand(words, contacts));
      case HeardNothing():
        state = state.copyWith(heard: () => null);
        await _say(_l10n.sayHeardNothing);
      case ListenCancelled():
        state = state.copyWith(phase: AssistantPhase.idle, heard: () => null);
      case ListenFailed(:final error):
        state = state.copyWith(heard: () => null);
        await _say(switch (error) {
          SpeechError.needsOnline ||
          SpeechError.languageMissing ||
          SpeechError.unavailable => _l10n.sayVoiceNotReady,
          SpeechError.network => _l10n.sayNoInternet,
          SpeechError.noPermission => _l10n.sayMicDenied,
          SpeechError.busy || SpeechError.other => _l10n.sayTryAgain,
        });
    }
  }

  Future<HeardResult> _listen(
    SpeechRecognizer recognizer,
    bool allowOnline,
  ) async {
    try {
      return await recognizer.listen(_localeTag, allowOnline: allowOnline);
    } on PlatformException catch (error, stack) {
      developer.log('Listening failed', error: error, stackTrace: stack);
      return const ListenFailed(SpeechError.other);
    }
  }

  /// A photo key was tapped.
  Future<void> call(Contact contact) => _call(contact, forHelp: false);

  /// The red Help key, or "help" spoken. Calls the people marked for Help in
  /// list order: the first press calls the first one; after a Help call,
  /// the next press calls the next one.
  Future<void> pressHelp() async {
    final contacts = await ref.read(contactsProvider.future);
    if (!ref.mounted) return;
    final helpers = [
      for (final contact in contacts)
        if (contact.forHelp) contact,
    ];
    if (helpers.isEmpty) {
      await _say(_l10n.sayNoHelpContacts);
      return;
    }
    final wanted = state.helpNext;
    // The next person may have been removed from Help since; start over.
    final index = wanted == null
        ? 0
        : helpers
              .indexWhere((c) => c.id == wanted.id)
              .clamp(0, helpers.length - 1);
    final target = helpers[index];
    final next = index + 1 < helpers.length ? helpers[index + 1] : null;
    state = state.copyWith(helpCalled: () => target, helpNext: () => next);
    _awaitingHelpReturn = next != null;
    await _call(target, forHelp: true);
  }

  /// "Yes, I'm fine" after a Help call.
  void dismissHelp() {
    _awaitingHelpReturn = false;
    unawaited(ref.read(speechServiceProvider).stop());
    state = state.copyWith(
      phase: state.phase == AssistantPhase.speaking
          ? AssistantPhase.idle
          : state.phase,
      helpCalled: () => null,
      helpNext: () => null,
      heard: () => null,
      reply: () => null,
    );
  }

  /// The app is back in front, usually after a call ended.
  Future<void> onResumed() async {
    final called = state.helpCalled;
    final next = state.helpNext;
    if (!_awaitingHelpReturn || called == null || next == null) return;
    _awaitingHelpReturn = false;
    await _say(_l10n.sayHelpNext(called.name, next.name));
  }

  Future<void> _call(Contact contact, {required bool forHelp}) async {
    await ref.read(speechServiceProvider).stop();
    final direct = await ref
        .read(voicePermissionsProvider)
        .isGranted(VoicePermission.phone);
    if (!ref.mounted) return;
    final l10n = _l10n;
    await _say(
      !direct
          ? l10n.sayDialer(contact.name)
          : forHelp
          ? l10n.sayCallingForHelp(contact.name)
          : l10n.sayCalling(contact.name),
    );
    if (!ref.mounted) return;
    final CallOutcome outcome;
    try {
      outcome = await ref.read(phoneProvider).call(contact.phone);
    } on PlatformException catch (error, stack) {
      developer.log('Call failed', error: error, stackTrace: stack);
      await _say(l10n.sayCallFailed(contact.name));
      return;
    }
    if (outcome == CallOutcome.failed && ref.mounted) {
      await _say(l10n.sayCallFailed(contact.name));
    }
  }

  Future<void> _run(Command command) async {
    final l10n = _l10n;
    try {
      switch (command) {
        case CallContact(:final contact):
          await call(contact);
        case CallWhom():
          await _say(l10n.sayWhom);
        case AskHelp():
          await pressHelp();
        case TellTime():
          await _say(
            spokenTime(l10n, ref.read(clockProvider).nowLocal().toDateTime()),
          );
        case TellDate():
          await _say(
            spokenDate(l10n, ref.read(clockProvider).nowLocal().toDateTime()),
          );
        case TellReminders():
          await _say(await _remindersText(l10n));
        case TellBattery():
          await _say(
            _batteryText(l10n, await ref.read(phoneProvider).battery()),
          );
        case SetTorch(:final on):
          final done = await ref.read(phoneProvider).setTorch(on: on);
          await _say(
            !done
                ? l10n.sayNoTorch
                : on
                ? l10n.sayTorchOn
                : l10n.sayTorchOff,
          );
        case NotUnderstood():
          await _say(l10n.sayNotUnderstood);
      }
    } on PlatformException catch (error, stack) {
      developer.log('Command failed', error: error, stackTrace: stack);
      await _say(l10n.sayTryAgain);
    }
  }

  /// What is still to do today, in time order, or that nothing is left.
  /// Taken and skipped reminders are left out; missed ones are kept, since
  /// they can still be done.
  Future<String> _remindersText(AppLocalizations l10n) async {
    final data = await ref.read(appDataProvider.future);
    if (data.medicines.isEmpty) return l10n.sayNoReminders;
    final today = ref.read(todayProvider).value ?? const <DoseState>[];
    final left = [
      for (final dose in today)
        if (dose.status is! DoseTaken && dose.status is! DoseSkipped) dose,
    ];
    if (left.isEmpty) return l10n.sayNoRemindersLeft;
    return l10n.sayRemindersLeft(
      [
        for (final dose in left)
          l10n.sayReminderItem(
            dose.occurrence.medicine.name,
            formatClock(l10n, dose.occurrence.scheduled.minuteOfDay),
          ),
      ].join(', '),
    );
  }

  String _batteryText(AppLocalizations l10n, BatteryLevel battery) {
    final percent = battery.percent;
    if (percent == null) return l10n.sayBatteryUnknown;
    return [
      l10n.sayBattery(percent),
      if (battery.charging)
        l10n.sayCharging
      else if (percent <= 20)
        l10n.sayChargeSoon,
    ].join(' ');
  }

  /// Shows [text] on the display and reads it aloud.
  Future<void> _say(String text) async {
    if (!ref.mounted) return;
    state = state.copyWith(phase: AssistantPhase.speaking, reply: () => text);
    try {
      await ref.read(speechServiceProvider).speak(text, _localeTag);
    } on PlatformException catch (error, stack) {
      developer.log('Speaking failed', error: error, stackTrace: stack);
    }
    // Pressing the big button while speaking starts listening; don't undo it.
    if (ref.mounted &&
        state.phase == AssistantPhase.speaking &&
        state.reply == text) {
      state = state.copyWith(phase: AssistantPhase.idle);
    }
  }
}
