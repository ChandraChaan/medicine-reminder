import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/providers.dart';
import '../../../core/widgets/async_view.dart';
import '../../../core/widgets/medicine_photo.dart';
import '../../medicines/domain/medicine.dart';
import '../domain/dose.dart';
import '../domain/schedule.dart';
import 'alarm_voice.dart';
import 'dose_buttons.dart';
import 'dose_controller.dart';

/// Opens when an alarm rings: one medicine at a time, with a photo and
/// three very large answers.
class AlarmScreen extends ConsumerStatefulWidget {
  const AlarmScreen({super.key});

  /// The alarm sound keeps going this long (or until the screen is touched)
  /// so someone in another room still hears it; then the reminder is spoken.
  static const ringFor = Duration(seconds: 20);

  /// The reminder is spoken again this often while doses are unanswered.
  static const repeatEvery = Duration(seconds: 45);
  static const maxRepeats = 3;

  @override
  ConsumerState<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends ConsumerState<AlarmScreen> {
  late final AlarmVoice _voice = ref.read(alarmVoiceProvider);
  Timer? _ringTimer;
  Timer? _speakTimer;
  Timer? _repeat;
  int _repeats = 0;
  int _answers = 0;
  bool _ringing = true;

  @override
  void initState() {
    super.initState();
    _voice; // Read now; ref can't be used in dispose().
    unawaited(_start());
  }

  Future<void> _start() async {
    final pending = await _pendingNow();
    if (!mounted) return;
    if (pending.isEmpty) {
      await _stopRinging();
      return;
    }
    _ringTimer = Timer(AlarmScreen.ringFor, () => unawaited(_stopRinging()));
  }

  /// Silences the alarm sound, then reads the reminder out unless the person
  /// answers within [speakAfter] (a tap that silences is often a "Taken").
  Future<void> _stopRinging({Duration speakAfter = Duration.zero}) async {
    if (!_ringing) return;
    _ringing = false;
    _ringTimer?.cancel();
    final answers = _answers;
    await ref.read(alarmBridgeProvider).stopRinging();
    if (!mounted) return;
    _speakTimer = Timer(speakAfter, () {
      if (_answers == answers) unawaited(_speak());
    });
  }

  Future<void> _speak() async {
    final pending = await _pendingNow();
    if (!mounted || pending.isEmpty) return;
    await _voice.announce(pending);
    if (!mounted) return;
    _repeat = Timer.periodic(AlarmScreen.repeatEvery, (_) async {
      final still = await _pendingNow();
      if (!mounted || still.isEmpty || ++_repeats > AlarmScreen.maxRepeats) {
        _repeat?.cancel();
        return;
      }
      await _voice.announce(still);
    });
  }

  Future<List<Medicine>> _pendingNow() async {
    await ref.read(appDataProvider.future);
    final pending = ref.read(pendingDosesProvider).value ?? const [];
    return [for (final dose in pending) dose.occurrence.medicine];
  }

  @override
  void dispose() {
    _ringTimer?.cancel();
    _speakTimer?.cancel();
    _repeat?.cancel();
    unawaited(_voice.stop());
    super.dispose();
  }

  Future<void> _answer(Future<void> Function() action) async {
    _answers++;
    await _voice.stop();
    await action();
  }

  Future<void> _close() async {
    _repeat?.cancel();
    await _stopRinging();
    await ref.read(alarmBridgeProvider).alarmDone();
    if (!mounted) return;
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final pending = ref.watch(pendingDosesProvider);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) unawaited(_close());
      },
      child: Scaffold(
        body: Listener(
          onPointerDown: (_) => unawaited(
            _stopRinging(speakAfter: const Duration(milliseconds: 1500)),
          ),
          child: SafeArea(
            child: AsyncView(
              value: pending,
              onRetry: () => ref.invalidate(appDataProvider),
              builder: (context, doses) => doses.isEmpty
                  ? _Finished(allDone: _answers > 0, onClose: _close)
                  : _DosePrompt(
                      key: ValueKey(doses.first.occurrence.key.toString()),
                      dose: doses.first,
                      index: 1,
                      total: doses.length,
                      onAnswer: _answer,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DosePrompt extends ConsumerWidget {
  const _DosePrompt({
    required this.dose,
    required this.index,
    required this.total,
    required this.onAnswer,
    super.key,
  });

  final DoseState dose;
  final int index;
  final int total;
  final Future<void> Function(Future<void> Function() action) onAnswer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final occurrence = dose.occurrence;
    final medicine = occurrence.medicine;
    final controller = ref.read(doseEventsProvider.notifier);
    final status = dose.status;
    final canSnooze = status is DoseDue && status.snoozeCount < maxSnoozes;
    final time = formatTimeOf(context, occurrence.scheduled.minuteOfDay);
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Wrap(
                  spacing: 10,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Icon(Icons.alarm_rounded, size: 34, color: scheme.primary),
                    Text(l10n.alarmTitle, style: text.headlineSmall),
                    if (total > 1)
                      Text(
                        l10n.alarmCount(index, total),
                        style: text.titleLarge,
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  status is DoseMissed ? l10n.alarmWasDue(time) : time,
                  style: text.titleLarge?.copyWith(
                    color: status is DoseMissed ? scheme.error : null,
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: MedicinePhoto(
                    name: medicine.name,
                    path: medicine.photoPath,
                    // Smaller on short or narrow phones so the buttons fit.
                    size: MediaQuery.sizeOf(context).shortestSide < 360
                        ? 140
                        : 190,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  medicine.name,
                  style: text.displaySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  doseLabel(l10n, medicine),
                  style: text.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                Text(
                  foodLabel(l10n, medicine.food),
                  style: text.headlineSmall?.copyWith(color: scheme.secondary),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                const SizedBox(height: 20),
                TakenButton(
                  large: true,
                  onPressed: () => onAnswer(() => controller.take(occurrence)),
                ),
                if (canSnooze) ...[
                  const SizedBox(height: 14),
                  SnoozeButton(
                    onPressed: () =>
                        onAnswer(() => controller.snooze(occurrence)),
                  ),
                ],
                const SizedBox(height: 14),
                SkipButton(
                  onPressed: () => onAnswer(() => controller.skip(occurrence)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Finished extends StatelessWidget {
  const _Finished({required this.allDone, required this.onClose});

  final bool allDone;
  final Future<void> Function() onClose;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  allDone ? Icons.verified_rounded : Icons.alarm_off_rounded,
                  size: 120,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 20),
                Text(
                  allDone ? l10n.alarmAllDone : l10n.alarmNothingDue,
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                FilledButton(
                  key: const Key('alarm-close'),
                  onPressed: () => unawaited(onClose()),
                  child: Text(l10n.close),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
