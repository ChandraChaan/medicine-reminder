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

/// Quarter amounts as people write them: ¼, ½, 1, 1½.
String formatQuarters(int quarters) {
  final whole = quarters ~/ 4;
  final fraction = switch (quarters % 4) {
    1 => '¼',
    2 => '½',
    3 => '¾',
    _ => '',
  };
  if (whole == 0) return fraction.isEmpty ? '0' : fraction;
  return '$whole$fraction';
}

String unitLabel(AppLocalizations l10n, DoseUnit unit, int quarters) {
  // "1 tablet" but "½ tablet" and "1½ tablets".
  final count = quarters <= 4 ? 1 : 2;
  return switch (unit) {
    DoseUnit.tablet => l10n.unitTablet(count),
    DoseUnit.capsule => l10n.unitCapsule(count),
    DoseUnit.ml => l10n.unitMl,
    DoseUnit.drops => l10n.unitDrops(count),
    DoseUnit.puff => l10n.unitPuff(count),
    DoseUnit.injection => l10n.unitInjection(count),
  };
}

String amountLabel(AppLocalizations l10n, DoseUnit unit, int quarters) =>
    l10n.doseAmount(formatQuarters(quarters), unitLabel(l10n, unit, quarters));

String doseLabel(AppLocalizations l10n, Medicine medicine) =>
    amountLabel(l10n, medicine.unit, medicine.doseQuarters);

String foodLabel(AppLocalizations l10n, FoodTiming food) => switch (food) {
  FoodTiming.beforeFood => l10n.foodBefore,
  FoodTiming.afterFood => l10n.foodAfter,
  FoodTiming.withFood => l10n.foodWith,
  FoodTiming.anyTime => l10n.foodAny,
};

String? _foodSpoken(AppLocalizations l10n, FoodTiming food) => switch (food) {
  FoodTiming.beforeFood => l10n.foodBeforeSpoken,
  FoodTiming.afterFood => l10n.foodAfterSpoken,
  FoodTiming.withFood => l10n.foodWithSpoken,
  FoodTiming.anyTime => null,
};

String partOfDay(AppLocalizations l10n, int minuteOfDay) {
  final hour = minuteOfDay ~/ 60;
  if (hour >= 4 && hour < 12) return l10n.partMorning;
  if (hour >= 12 && hour < 17) return l10n.partAfternoon;
  if (hour >= 17 && hour < 20) return l10n.partEvening;
  return l10n.partNight;
}

/// What the alarm says aloud, for example
/// "It's time for your BP tablet, after food."
String speechFor(AppLocalizations l10n, List<Medicine> medicines) {
  if (medicines.length == 1) {
    final medicine = medicines.single;
    final food = _foodSpoken(l10n, medicine.food);
    return food == null
        ? l10n.speechOneNoFood(medicine.name)
        : l10n.speechOne(medicine.name, food);
  }
  return [
    l10n.speechMany,
    for (final medicine in medicines)
      switch (_foodSpoken(l10n, medicine.food)) {
        final String food => l10n.speechItem(medicine.name, food),
        null => l10n.speechItemNoFood(medicine.name),
      },
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
