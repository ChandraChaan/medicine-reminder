// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Medicine Reminder';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageTelugu => 'తెలుగు';

  @override
  String get languageHindi => 'हिन्दी';

  @override
  String get next => 'Next';

  @override
  String get back => 'Back';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get close => 'Close';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get undo => 'Undo';

  @override
  String get retry => 'Try again';

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';

  @override
  String get chooseLanguageTitle => 'Choose a language';

  @override
  String get onboardingTitle => 'Reminders that ring like an alarm';

  @override
  String get onboardingBody =>
      'At medicine time the phone rings, shows the medicine in big letters and reads it out. It works even when the phone is locked.';

  @override
  String get onboardingPrivacy =>
      'Everything stays on this phone. No account, no internet, no ads.';

  @override
  String get allowReminders => 'Allow reminders';

  @override
  String get onboardingStart => 'Start';

  @override
  String get todayTitle => 'Today';

  @override
  String get nothingToday => 'No medicines today.';

  @override
  String get allDoneToday => 'All of today\'s medicines are done. Well done!';

  @override
  String get noMedicinesTitle => 'No medicines yet';

  @override
  String get noMedicinesBody =>
      'Ask a family member to add the medicines. Each one takes about a minute.';

  @override
  String get addMedicine => 'Add medicine';

  @override
  String get history => 'History';

  @override
  String get familySetup => 'Family setup';

  @override
  String get settings => 'Settings';

  @override
  String get partMorning => 'Morning';

  @override
  String get partAfternoon => 'Afternoon';

  @override
  String get partEvening => 'Evening';

  @override
  String get partNight => 'Night';

  @override
  String statusTaken(String time) {
    return 'Taken at $time';
  }

  @override
  String get statusSkipped => 'Skipped';

  @override
  String get statusMissed => 'Missed';

  @override
  String get statusDue => 'Take now';

  @override
  String statusSnoozed(String time) {
    return 'Again at $time';
  }

  @override
  String get statusUpcoming => 'Later today';

  @override
  String refillDaysLeft(String name, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days left',
      one: '1 day left',
    );
    return '$name: $_temp0. Buy more soon.';
  }

  @override
  String refillRunOut(String name) {
    return '$name has run out. Buy more today.';
  }

  @override
  String refillNoticeTitle(String name) {
    return 'Time to buy $name';
  }

  @override
  String get bannerNotifications =>
      'Reminders are turned off, so they can\'t ring.';

  @override
  String get bannerExactAlarms =>
      'Alarms may ring late. Turn on \"Alarms & reminders\".';

  @override
  String get bannerFullScreen =>
      'The alarm screen can\'t open over the lock screen.';

  @override
  String get fix => 'Fix';

  @override
  String get alarmTitle => 'Time for your medicine';

  @override
  String alarmCount(int index, int total) {
    return '$index of $total';
  }

  @override
  String alarmWasDue(String time) {
    return 'This was due at $time';
  }

  @override
  String get alarmAllDone => 'All done. Well done!';

  @override
  String get alarmNothingDue => 'No medicine is due right now.';

  @override
  String get taken => 'Taken';

  @override
  String snooze(int minutes) {
    return 'Snooze $minutes min';
  }

  @override
  String get skip => 'Skip';

  @override
  String medicinePhoto(String name) {
    return 'Photo of $name';
  }

  @override
  String doseAmount(String amount, String unit) {
    return '$amount $unit';
  }

  @override
  String unitTablet(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'tablets',
      one: 'tablet',
    );
    return '$_temp0';
  }

  @override
  String unitCapsule(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'capsules',
      one: 'capsule',
    );
    return '$_temp0';
  }

  @override
  String get unitMl => 'ml';

  @override
  String unitDrops(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'drops',
      one: 'drop',
    );
    return '$_temp0';
  }

  @override
  String unitPuff(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'puffs',
      one: 'puff',
    );
    return '$_temp0';
  }

  @override
  String unitInjection(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'injections',
      one: 'injection',
    );
    return '$_temp0';
  }

  @override
  String get foodBefore => 'Before food';

  @override
  String get foodAfter => 'After food';

  @override
  String get foodWith => 'With food';

  @override
  String get foodAny => 'Any time';

  @override
  String get foodBeforeSpoken => 'before food';

  @override
  String get foodAfterSpoken => 'after food';

  @override
  String get foodWithSpoken => 'with food';

  @override
  String speechOne(String name, String food) {
    return 'It\'s time for your $name, $food.';
  }

  @override
  String speechOneNoFood(String name) {
    return 'It\'s time for your $name.';
  }

  @override
  String get speechMany => 'It\'s time for your medicines.';

  @override
  String speechItem(String name, String food) {
    return '$name, $food.';
  }

  @override
  String speechItemNoFood(String name) {
    return '$name.';
  }

  @override
  String get channelAlarms => 'Medicine alarms';

  @override
  String get channelNotices => 'Refill and other notices';

  @override
  String get medicinesTitle => 'Medicines';

  @override
  String get medicinesEmpty => 'No medicines yet. Add the first one.';

  @override
  String deleteMedicineTitle(String name) {
    return 'Delete $name?';
  }

  @override
  String get deleteMedicineBody =>
      'Its reminders and history will be removed from this phone.';

  @override
  String get boughtMore => 'Bought more';

  @override
  String get boughtMoreTitle => 'How many did you buy?';

  @override
  String stockLeft(String amount) {
    return '$amount left';
  }

  @override
  String untilDate(String date) {
    return 'Until $date';
  }

  @override
  String get noEndDateShort => 'No last day';

  @override
  String stepCounter(int step, int total) {
    return 'Step $step of $total';
  }

  @override
  String get stepName => 'What is the medicine called?';

  @override
  String get nameLabel => 'Medicine name';

  @override
  String get nameHint => 'For example: BP tablet';

  @override
  String get sampleMedicine => 'BP tablet';

  @override
  String get nameRequired => 'Please type a name.';

  @override
  String get takePhoto => 'Take a photo';

  @override
  String get choosePhoto => 'Choose a photo';

  @override
  String get removePhoto => 'Remove photo';

  @override
  String get photoHelp => 'A photo of the strip helps pick the right medicine.';

  @override
  String get stepDose => 'How much each time?';

  @override
  String get decrease => 'Less';

  @override
  String get increase => 'More';

  @override
  String get unitLabel => 'Type';

  @override
  String get stepTimes => 'When should it be taken?';

  @override
  String get addTime => 'Add a time';

  @override
  String removeTime(String time) {
    return 'Remove $time';
  }

  @override
  String get timesRequired => 'Pick at least one time.';

  @override
  String get stepFood => 'Before or after food?';

  @override
  String get stepDays => 'Which days?';

  @override
  String get startDate => 'First day';

  @override
  String get lastDay => 'Last day';

  @override
  String get noEndDate => 'Keep going';

  @override
  String get pickEndDate => 'Stop on a date';

  @override
  String get everyDayLabel => 'Every day';

  @override
  String get someDaysLabel => 'Only some days';

  @override
  String get daysRequired => 'Pick at least one day.';

  @override
  String get endBeforeStart => 'The last day can\'t be before the first day.';

  @override
  String get stepStock => 'Count the tablets?';

  @override
  String get stockHelp =>
      'The app counts down after each dose and warns before they run out.';

  @override
  String get dontCount => 'Don\'t count';

  @override
  String get countThem => 'Count them';

  @override
  String get stockInHand => 'How many are there now?';

  @override
  String warnDaysBefore(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '1 day',
    );
    return 'Warn $_temp0 before they run out';
  }

  @override
  String get stepReview => 'Check and save';

  @override
  String get reviewTimes => 'Times';

  @override
  String get reviewDays => 'Days';

  @override
  String get reviewStock => 'Count';

  @override
  String get notCounted => 'Not counted';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsSpeak => 'Speak reminders aloud';

  @override
  String get settingsSpeakHelp =>
      'Reads out the medicine name and food timing when the alarm rings.';

  @override
  String get testVoice => 'Play a test';

  @override
  String get voiceMissing =>
      'This phone has no voice for this language yet, so reminders are read in English. You can add the voice in Android\'s text-to-speech settings.';

  @override
  String get settingsMissedAfter => 'Count a dose as missed after';

  @override
  String minutesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutes',
      one: '1 minute',
    );
    return '$_temp0';
  }

  @override
  String hoursCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hours',
      one: '1 hour',
    );
    return '$_temp0';
  }

  @override
  String get settingsPermissions => 'Alarm permissions';

  @override
  String get permNotifications => 'Reminders (notifications)';

  @override
  String get permExactAlarms => 'Alarms & reminders';

  @override
  String get permFullScreen => 'Alarm over the lock screen';

  @override
  String get permOn => 'On';

  @override
  String get permOff => 'Off. Tap to fix.';

  @override
  String get settingsAbout => 'About';

  @override
  String get aboutPrivacy =>
      'Everything stays on this phone. No account, no internet, no ads, no tracking.';

  @override
  String get aboutDisclaimer =>
      'This app is a reminder aid, not medical advice. Always follow the doctor\'s instructions.';

  @override
  String get aboutSource => 'Free and open source (MIT licence).';

  @override
  String get historyTitle => 'History';

  @override
  String historySummary(int taken, int total) {
    return 'Taken $taken of $total doses this month';
  }

  @override
  String get historyEmpty => 'No doses this month.';

  @override
  String get previousMonth => 'Previous month';

  @override
  String get nextMonth => 'Next month';

  @override
  String get legendAllTaken => 'All taken';

  @override
  String get legendSomeMissed => 'Some missed or skipped';

  @override
  String get legendMissed => 'Missed';

  @override
  String historyDay(String date, int taken, int missed, int skipped) {
    return '$date: $taken taken, $missed missed, $skipped skipped';
  }

  @override
  String historyDayNoDoses(String date) {
    return '$date: no doses';
  }
}
