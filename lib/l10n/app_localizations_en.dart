// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Daily Reminder';

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
      'At reminder time the phone rings, shows the reminder in big letters and reads it out. It works even when the phone is locked.';

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
  String get nothingToday => 'No reminders today.';

  @override
  String get allDoneToday => 'All of today\'s reminders are done. Well done!';

  @override
  String get noMedicinesTitle => 'No reminders yet';

  @override
  String get noMedicinesBody =>
      'Add the things to remember, like a walk, a phone call or drinking water. Each one takes about a minute.';

  @override
  String get addMedicine => 'Add reminder';

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
    return 'Done at $time';
  }

  @override
  String get statusSkipped => 'Skipped';

  @override
  String get statusMissed => 'Missed';

  @override
  String get statusDue => 'Do it now';

  @override
  String statusSnoozed(String time) {
    return 'Again at $time';
  }

  @override
  String get statusUpcoming => 'Later today';

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
  String get alarmTitle => 'Reminder';

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
  String get alarmNothingDue => 'Nothing is due right now.';

  @override
  String get taken => 'Done';

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
  String speechOne(String name) {
    return 'It\'s time for $name.';
  }

  @override
  String get speechMany => 'It\'s time for these reminders:';

  @override
  String speechItem(String name) {
    return '$name.';
  }

  @override
  String get channelAlarms => 'Reminder alarms';

  @override
  String get channelNotices => 'Other notices';

  @override
  String get medicinesTitle => 'Reminders';

  @override
  String get medicinesEmpty => 'No reminders yet. Add the first one.';

  @override
  String deleteMedicineTitle(String name) {
    return 'Delete $name?';
  }

  @override
  String get deleteMedicineBody =>
      'Its alarms and history will be removed from this phone.';

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
  String get stepName => 'What should I remind you about?';

  @override
  String get nameLabel => 'Reminder name';

  @override
  String get nameHint => 'For example: Evening walk';

  @override
  String get sampleMedicine => 'Evening walk';

  @override
  String get nameRequired => 'Please type a name.';

  @override
  String get takePhoto => 'Take a photo';

  @override
  String get choosePhoto => 'Choose a photo';

  @override
  String get removePhoto => 'Remove photo';

  @override
  String get photoHelp => 'A photo makes the reminder easy to recognise.';

  @override
  String get stepTimes => 'When should it ring?';

  @override
  String get addTime => 'Add a time';

  @override
  String removeTime(String time) {
    return 'Remove $time';
  }

  @override
  String get timesRequired => 'Pick at least one time.';

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
  String get stepReview => 'Check and save';

  @override
  String get reviewTimes => 'Times';

  @override
  String get reviewDays => 'Days';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsSpeak => 'Speak reminders aloud';

  @override
  String get settingsSpeakHelp =>
      'Reads out the reminder name when the alarm rings.';

  @override
  String get testVoice => 'Play a test';

  @override
  String get voiceMissing =>
      'This phone has no voice for this language yet, so reminders are read in English. You can add the voice in Android\'s text-to-speech settings.';

  @override
  String get settingsMissedAfter => 'Count a reminder as missed after';

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
  String get aboutSource => 'Free and open source (MIT licence).';

  @override
  String get historyTitle => 'History';

  @override
  String historySummary(int taken, int total) {
    return 'Done $taken of $total reminders this month';
  }

  @override
  String get historyEmpty => 'No reminders this month.';

  @override
  String get previousMonth => 'Previous month';

  @override
  String get nextMonth => 'Next month';

  @override
  String get legendAllTaken => 'All done';

  @override
  String get legendSomeMissed => 'Some missed or skipped';

  @override
  String get legendMissed => 'Missed';

  @override
  String historyDay(String date, int taken, int missed, int skipped) {
    return '$date: $taken done, $missed missed, $skipped skipped';
  }

  @override
  String historyDayNoDoses(String date) {
    return '$date: no reminders';
  }

  @override
  String get familyCheckTitle => 'Family check';

  @override
  String get familyCheckIntro =>
      'If a reminder is not marked Done within the missed time, this phone can let one or two family members know. It stays off until you turn it on here.';

  @override
  String get familyCheckEnable => 'Tell family about missed reminders';

  @override
  String get familyPersonLabel => 'What does the family call them?';

  @override
  String get familyPersonHint => 'For example: Amma';

  @override
  String familyNumberLabel(int index) {
    return 'Family phone number $index';
  }

  @override
  String get familyNumberHint => '+91 98765 43210';

  @override
  String get familyNumberInvalid => 'This doesn\'t look like a phone number.';

  @override
  String get familyHowTitle => 'How should they be told?';

  @override
  String get familyChannelSms => 'SMS from this phone (automatic)';

  @override
  String get familyChannelSmsHelp =>
      'This phone sends it by itself. Normal SMS charges apply.';

  @override
  String get familyChannelSmsManual => 'SMS (someone presses Send)';

  @override
  String get familyChannelSmsManualHelp =>
      'A notification on this phone opens the SMS app with the message ready. Nothing is sent until someone presses Send. Normal SMS charges apply.';

  @override
  String get familyChannelWhatsapp => 'WhatsApp (someone presses Send)';

  @override
  String get familyChannelWhatsappHelp =>
      'A notification on this phone opens WhatsApp with the message ready. Nothing is sent until someone presses Send.';

  @override
  String get familySmsConsent =>
      'I agree that this phone may send an SMS to these numbers when a reminder is missed.';

  @override
  String get familySmsPermission => 'Allow sending SMS';

  @override
  String get familySmsPermissionMissing =>
      'SMS permission is off. Until it is allowed, a notification opens the SMS app with the message ready instead.';

  @override
  String get familySendTest => 'Send a test message';

  @override
  String get familyTestSent => 'Test message sent.';

  @override
  String get familyTestFailed =>
      'The message could not be sent. Check the number and the SIM.';

  @override
  String get familyMessagePreview => 'Message preview';

  @override
  String familyMessage(String person, String medicines, String time) {
    return 'Daily Reminder: $person has not marked $medicines (due at $time) as done. Please check on them.';
  }

  @override
  String familyTestMessage(String person) {
    return 'Daily Reminder: this is a test. You will get a message like this if $person misses a reminder.';
  }

  @override
  String get familyPersonFallback => 'your family member';

  @override
  String get familyNotifySentTitle => 'Family was told';

  @override
  String get familyNotifySentBody =>
      'An SMS about the missed reminder was sent to your family.';

  @override
  String get familyNotifyShareTitle => 'Tell your family';

  @override
  String get familyNotifyShareBody =>
      'A reminder was missed. Tap to send the message.';

  @override
  String get familyNeedsNumber => 'Add at least one phone number.';

  @override
  String get familyNeedsConsent => 'Please tick the agreement to use SMS.';

  @override
  String get familyStatusOn => 'On';

  @override
  String get familyStatusOff => 'Off';
}
