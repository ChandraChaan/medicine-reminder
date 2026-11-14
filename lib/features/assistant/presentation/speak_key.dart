import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/phone_key.dart';
import 'assistant_controller.dart';

/// The big round talk key. Press once to speak; it listens until the
/// person stops talking. Press again to stop early.
class SpeakKey extends ConsumerWidget {
  const SpeakKey({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = PhoneColors.of(context);
    final l10n = context.l10n;
    final phase = ref.watch(assistantProvider.select((s) => s.phase));
    final listening = phase == AssistantPhase.listening;
    final working = phase == AssistantPhase.working;
    final label = listening
        ? l10n.listening
        : working
        ? l10n.thinking
        : l10n.speakButton;
    final width = MediaQuery.sizeOf(context).width;
    final size = (width * 0.5).clamp(160.0, 220.0);

    return Column(
      children: [
        // A ring around the key while it listens, like a lit button.
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: listening ? colors.listening : colors.bodyShade,
              width: 6,
            ),
          ),
          child: SizedBox.square(
            dimension: size,
            child: PhoneKey(
              color: listening ? colors.listening : colors.talk,
              edgeColor: listening ? colors.onBodyMuted : colors.talkEdge,
              shape: const CircleBorder(),
              depth: 8,
              semanticLabel: listening ? l10n.tapToStop : l10n.speakButton,
              onTap: working
                  ? null
                  : () => unawaited(
                      ref.read(assistantProvider.notifier).pressSpeak(),
                    ),
              child: Center(
                child: Icon(
                  listening ? Icons.graphic_eq_rounded : Icons.mic_rounded,
                  size: size * 0.42,
                  color: listening ? colors.onKey : colors.onTalk,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // The key itself carries the label for screen readers.
        ExcludeSemantics(
          child: Column(
            children: [
              Text(
                label,
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.headlineMedium?.copyWith(color: colors.onBody),
              ),
              if (listening)
                Text(
                  l10n.tapToStop,
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: colors.onBodyMuted),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
