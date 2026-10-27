import 'package:flutter/material.dart';

import '../../features/doses/domain/dose.dart';
import '../l10n/l10n.dart';
import '../theme/app_theme.dart';

/// A dose status as icon plus words, so it never depends on colour alone.
class StatusBadge extends StatelessWidget {
  const StatusBadge({required this.status, super.key});

  final DoseStatus status;

  @override
  Widget build(BuildContext context) {
    final colors = StatusColors.of(context);
    final scheme = Theme.of(context).colorScheme;
    final (icon, background, foreground) = switch (status) {
      DoseTaken() => (Icons.check_circle_rounded, colors.taken, colors.onTaken),
      DoseMissed() => (Icons.cancel_rounded, colors.missed, colors.onMissed),
      DoseSkipped() => (
        Icons.remove_circle_outline_rounded,
        scheme.surfaceContainerHighest,
        scheme.onSurface,
      ),
      DoseDue() => (Icons.alarm_rounded, colors.due, colors.onDue),
      DoseSnoozed() => (Icons.snooze_rounded, colors.snooze, colors.onSnooze),
      DoseUpcoming() => (
        Icons.schedule_rounded,
        scheme.surfaceContainerHigh,
        scheme.onSurface,
      ),
    };
    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: foreground, size: 22),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                statusLabel(context, status),
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: foreground),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
