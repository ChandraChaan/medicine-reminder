import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/time/clock.dart';
import 'assistant_controller.dart';

/// The phone's green-black display: the time and date, then what was heard
/// and what the app answered.
class DisplayPanel extends ConsumerWidget {
  const DisplayPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = PhoneColors.of(context);
    final text = Theme.of(context).textTheme;
    final l10n = context.l10n;
    final now =
        (ref.watch(nowProvider).value ?? ref.read(clockProvider).nowLocal())
            .toDateTime();
    final assistant = ref.watch(assistantProvider);
    final time = MaterialLocalizations.of(context).formatTimeOfDay(
      TimeOfDay.fromDateTime(now),
      alwaysUse24HourFormat: MediaQuery.alwaysUse24HourFormatOf(context),
    );
    final listening = assistant.phase == AssistantPhase.listening;
    final heard = assistant.heard;
    final reply = assistant.reply;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
      decoration: BoxDecoration(
        color: colors.display,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.displayEdge, width: 4),
        boxShadow: [BoxShadow(color: colors.key, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            time,
            style: text.displayMedium?.copyWith(
              color: colors.onDisplay,
              fontWeight: FontWeight.w600,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          Text(
            displayDate(l10n, now),
            style: text.titleMedium?.copyWith(color: colors.onDisplayMuted),
          ),
          if (listening || heard != null || reply != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Divider(color: colors.onDisplayMuted, height: 1),
            ),
            Semantics(
              liveRegion: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (listening && heard == null)
                    Text(
                      l10n.listening,
                      style: text.titleLarge?.copyWith(color: colors.onDisplay),
                    ),
                  if (heard != null)
                    Text(
                      listening ? '“$heard”' : l10n.youSaid(heard),
                      style: text.titleMedium?.copyWith(
                        color: colors.onDisplayMuted,
                      ),
                    ),
                  if (!listening && reply != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      reply,
                      style: text.titleLarge?.copyWith(
                        color: colors.onDisplay,
                        height: 1.35,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
