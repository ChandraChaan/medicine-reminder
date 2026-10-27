import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/app_theme.dart';
import '../domain/schedule.dart';

/// The three answers to a dose, sized for unsteady hands.
class TakenButton extends StatelessWidget {
  const TakenButton({required this.onPressed, this.large = false, super.key});

  final VoidCallback onPressed;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final colors = StatusColors.of(context);
    final text = Theme.of(context).textTheme;
    return FilledButton.icon(
      key: const Key('dose-taken'),
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: colors.taken,
        foregroundColor: colors.onTaken,
        minimumSize: Size.fromHeight(large ? 96 : 68),
        textStyle: large ? text.headlineMedium : text.headlineSmall,
      ),
      icon: Icon(Icons.check_rounded, size: large ? 44 : 32),
      label: Text(context.l10n.taken),
    );
  }
}

class SnoozeButton extends StatelessWidget {
  const SnoozeButton({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = StatusColors.of(context);
    return FilledButton.icon(
      key: const Key('dose-snooze'),
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: colors.snooze,
        foregroundColor: colors.onSnooze,
        minimumSize: const Size.fromHeight(76),
        textStyle: Theme.of(context).textTheme.headlineSmall,
      ),
      icon: const Icon(Icons.snooze_rounded, size: 32),
      label: Text(context.l10n.snooze(snoozeMinutes)),
    );
  }
}

class SkipButton extends StatelessWidget {
  const SkipButton({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => OutlinedButton.icon(
    key: const Key('dose-skip'),
    onPressed: onPressed,
    style: OutlinedButton.styleFrom(
      minimumSize: const Size.fromHeight(68),
      textStyle: Theme.of(context).textTheme.titleLarge,
    ),
    icon: const Icon(Icons.close_rounded, size: 28),
    label: Text(context.l10n.skip),
  );
}
