import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../features/doses/domain/dose.dart';
import '../../features/medicines/domain/medicine.dart';
import '../../features/settings/domain/app_settings.dart';
import '../../l10n/app_localizations.dart';
import '../time/local_date.dart';

export '../../l10n/app_localizations.dart';

extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

/// Localisations for code that runs outside the widget tree (alarm texts).
AppLocalizations l10nFor(AppLanguage language) =>
    lookupAppLocalizations(Locale(language.code));

String languageName(AppLocalizations l10n, AppLanguage language) =>
    switch (language) {
      AppLanguage.english => l10n.languageEnglish,
      AppLanguage.telugu => l10n.languageTelugu,
      AppLanguage.hindi => l10n.languageHindi,
    };

String partOfDay(AppLocalizations l10n, int minuteOfDay) {
  final hour = minuteOfDay ~/ 60;
  if (hour >= 4 && hour < 12) return l10n.partMorning;
  if (hour >= 12 && hour < 17) return l10n.partAfternoon;
  if (hour >= 17 && hour < 20) return l10n.partEvening;
  return l10n.partNight;
}

/// What the alarm says aloud, for example "It's time for Evening walk."
String speechFor(AppLocalizations l10n, List<Medicine> medicines) {
  if (medicines.length == 1) return l10n.speechOne(medicines.single.name);
  return [
    l10n.speechMany,
    for (final medicine in medicines) l10n.speechItem(medicine.name),
  ].join(' ');
}

/// Times outside widgets (notifications, SMS), for example "8:00 AM".
///
/// ICU puts a narrow no-break space before "AM"; older phones show it as a
/// box in an SMS, so it becomes a plain space.
String formatClock(AppLocalizations l10n, int minuteOfDay) =>
    DateFormat.jm(l10n.localeName)
        .format(DateTime(2000, 1, 1, minuteOfDay ~/ 60, minuteOfDay % 60))
        .replaceAll(RegExp('[\u202F\u00A0]'), ' ');

/// Times inside widgets; follows the phone's 12/24-hour setting.
String formatTimeOf(BuildContext context, int minuteOfDay) =>
    MaterialLocalizations.of(context).formatTimeOfDay(
      TimeOfDay(hour: minuteOfDay ~/ 60, minute: minuteOfDay % 60),
      alwaysUse24HourFormat: MediaQuery.alwaysUse24HourFormatOf(context),
    );

String formatDate(AppLocalizations l10n, LocalDate date) =>
    DateFormat.yMMMd(l10n.localeName).format(date.toDateTime());

String formatDayMonth(AppLocalizations l10n, LocalDate date) =>
    DateFormat.MMMMEEEEd(l10n.localeName).format(date.toDateTime());

String statusLabel(BuildContext context, DoseStatus status) {
  final l10n = context.l10n;
  return switch (status) {
    DoseTaken(:final atUtc) => l10n.statusTaken(
      formatTimeOf(context, _minuteOfDay(atUtc.toLocal())),
    ),
    DoseSkipped() => l10n.statusSkipped,
    DoseMissed() => l10n.statusMissed,
    DoseDue() => l10n.statusDue,
    DoseSnoozed(:final until) => l10n.statusSnoozed(
      formatTimeOf(context, until.minuteOfDay),
    ),
    DoseUpcoming() => l10n.statusUpcoming,
  };
}

int _minuteOfDay(DateTime local) => local.hour * 60 + local.minute;
