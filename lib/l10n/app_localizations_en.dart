// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Voice Saathi';

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
  String get onboardingTitle => 'A phone helper that listens and reminds';

  @override
  String get onboardingBody =>
      'Press one big button and speak to call family, ask the time or ask for help. Reminders ring like an alarm and are read out, even when the phone is locked.';

  @override
  String get onboardingPrivacy =>
      'Everything stays on this phone. No account, no ads. Listening uses the phone\'s own speech recognition; online listening stays off unless you turn it on.';

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
    return 'Voice Saathi: $person has not marked $medicines (due at $time) as done. Please check on them.';
  }

  @override
  String familyTestMessage(String person) {
    return 'Voice Saathi: this is a test. You will get a message like this if $person misses a reminder.';
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

  @override
  String get speakButton => 'Press and speak';

  @override
  String get listening => 'Listening…';

  @override
  String get tapToStop => 'Press again to stop';

  @override
  String get thinking => 'One moment…';

  @override
  String youSaid(String text) {
    return 'You said: “$text”';
  }

  @override
  String get familyHeading => 'Tap a photo to call';

  @override
  String get helpButton => 'Help';

  @override
  String get helpButtonHint => 'Calls family for help';

  @override
  String get holdToOpen => 'Press and hold to open';

  @override
  String get noContactsYet =>
      'No family numbers yet. Ask your family to open Family setup.';

  @override
  String callName(String name) {
    return 'Call $name';
  }

  @override
  String helpNextTitle(String name) {
    return 'Did $name answer?';
  }

  @override
  String get helpFine => 'Yes, I\'m fine';

  @override
  String get spokenPartMorning => 'in the morning';

  @override
  String get spokenPartAfternoon => 'in the afternoon';

  @override
  String get spokenPartEvening => 'in the evening';

  @override
  String get spokenPartNight => 'at night';

  @override
  String sayCalling(String name) {
    return 'Calling $name.';
  }

  @override
  String sayDialer(String name) {
    return 'Press the green button to call $name.';
  }

  @override
  String sayCallFailed(String name) {
    return 'I could not call $name. Please try again.';
  }

  @override
  String sayCallingForHelp(String name) {
    return 'Calling $name for help.';
  }

  @override
  String sayHelpNext(String name, String next) {
    return 'If $name did not answer, press the red Help button to call $next.';
  }

  @override
  String get sayNoHelpContacts =>
      'No one is set up for Help yet. Please ask your family to set it up.';

  @override
  String get sayWhom => 'Whom should I call? Say the name, or tap a photo.';

  @override
  String sayTime(String clock, String part) {
    return 'It is $clock $part.';
  }

  @override
  String sayDate(String weekday, String date) {
    return 'Today is $weekday, $date.';
  }

  @override
  String sayBattery(int percent) {
    return 'The battery is at $percent percent.';
  }

  @override
  String get sayCharging => 'It is charging.';

  @override
  String get sayChargeSoon => 'Please put the phone on charge.';

  @override
  String get sayBatteryUnknown => 'I could not read the battery.';

  @override
  String get sayTorchOn => 'The light is on.';

  @override
  String get sayTorchOff => 'The light is off.';

  @override
  String get sayNoTorch => 'This phone has no light I can turn on.';

  @override
  String get sayNotUnderstood =>
      'Sorry, I did not understand. Press the button and say it again, or tap a photo to call.';

  @override
  String get sayHeardNothing =>
      'I did not hear anything. Press the button and speak.';

  @override
  String get sayVoiceNotReady =>
      'Listening is not ready on this phone yet. Please ask your family to open Family setup. You can still tap a photo to call.';

  @override
  String get sayNoInternet =>
      'I need the internet to understand you on this phone. Please try again, or tap a photo to call.';

  @override
  String get sayMicDenied =>
      'I need the microphone to listen. Please ask your family to allow it in Family setup.';

  @override
  String get sayTryAgain =>
      'Something went wrong. Please press the button again.';

  @override
  String get setupIntro =>
      'Set this up once for your parent. Add the people they call most. The red Help button calls the people marked Help, from the top of the list.';

  @override
  String get languageHeading => 'Language';

  @override
  String get familyMembers => 'Family members';

  @override
  String get addContact => 'Add a person';

  @override
  String get reorderHint => 'Drag the handle on the right to change the order.';

  @override
  String get speechHeading => 'Listening';

  @override
  String speechOffline(String language) {
    return '$language is understood on this phone, without internet. Nothing your parent says leaves the phone.';
  }

  @override
  String speechDownloading(String language) {
    return 'Google is downloading $language for offline use. This can take a few minutes on Wi-Fi.';
  }

  @override
  String speechDownloadable(String language) {
    return '$language can be understood without internet after a one-time download from Google.';
  }

  @override
  String speechDownload(String language) {
    return 'Download $language';
  }

  @override
  String get speechDownloadStarted =>
      'Follow the phone\'s prompt to download. Keep the phone on Wi-Fi for a few minutes.';

  @override
  String get speechDownloadFailed =>
      'This phone can\'t download it. Turn on online listening below instead.';

  @override
  String speechOnlineOnly(String language) {
    return 'This phone can\'t understand $language without internet.';
  }

  @override
  String speechUnknown(String language) {
    return 'This phone understands speech on its own, but can\'t tell whether $language is ready. Try the big button.';
  }

  @override
  String get speechNone =>
      'This phone has no speech recognition. Install or update the Google app, or use the photos to call.';

  @override
  String get allowOnline => 'Allow online listening';

  @override
  String get allowOnlineDetail =>
      'Uses the phone\'s Google speech service, which sends what your parent says to Google to turn it into text. Only used when the phone can\'t do it alone.';

  @override
  String get voiceHeading => 'Voice';

  @override
  String get hearSample => 'Hear a sample';

  @override
  String get voiceSample => 'Hello. Press the big button and speak to me.';

  @override
  String noVoice(String language) {
    return 'This phone has no $language voice, so replies may be read in another language. Install it in the phone\'s Settings, under Text-to-speech.';
  }

  @override
  String get permissionsHeading => 'Permissions';

  @override
  String get micPermission => 'Microphone, to listen';

  @override
  String get phonePermission => 'Phone, to call straight away';

  @override
  String get phonePermissionDetail =>
      'Without it, the dialer opens and your parent presses the green button.';

  @override
  String get allowed => 'Allowed';

  @override
  String get allow => 'Allow';

  @override
  String get done => 'Done';

  @override
  String get newContact => 'New person';

  @override
  String editContact(String name) {
    return 'Edit $name';
  }

  @override
  String get contactNameLabel => 'Name shown under the photo';

  @override
  String get phoneLabel => 'Phone number';

  @override
  String get contactNameRequired => 'Enter a name';

  @override
  String get phoneRequired => 'Enter a phone number';

  @override
  String photoOf(String name) {
    return 'Photo of $name';
  }

  @override
  String get nicknamesHeading => 'Other names your parent uses';

  @override
  String get nicknamesHint =>
      'For example “pedda abbayi”, “బాబు” or “बेटा”. Tap Say it and say the name the way your parent says it, so the phone learns how it hears it.';

  @override
  String get nicknameField => 'Type a name';

  @override
  String get addNickname => 'Add';

  @override
  String get sayIt => 'Say it';

  @override
  String heardNickname(String text) {
    return 'Heard “$text”. Added.';
  }

  @override
  String get heardNicknameNothing => 'Didn\'t catch that. Try again.';

  @override
  String removeNickname(String name) {
    return 'Remove $name';
  }

  @override
  String get forHelpTitle => 'Call for Help';

  @override
  String get forHelpDetail => 'The red Help button calls this person.';

  @override
  String deleteConfirm(String name) {
    return 'Delete $name?';
  }

  @override
  String get welcomeBody =>
      'A phone helper your parent can talk to. Press one big button and speak: call family, ask the time or the day, turn on the light, or ask for help.';

  @override
  String get chooseLanguage => 'Choose a language';

  @override
  String get privacyNote =>
      'Everything stays on this phone. No account, no ads, no tracking.';

  @override
  String get continueButton => 'Continue';

  @override
  String get todaysReminders => 'Today\'s reminders';

  @override
  String remindersLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count left today',
      one: '1 left today',
    );
    return '$_temp0';
  }

  @override
  String get remindersAllDone => 'Nothing left for today';

  @override
  String get remindersNone => 'No reminders set';

  @override
  String sayRemindersLeft(String items) {
    return 'Still to do today: $items.';
  }

  @override
  String sayReminderItem(String name, String time) {
    return '$name at $time';
  }

  @override
  String get sayNoRemindersLeft => 'Nothing is left to do today.';

  @override
  String get sayNoReminders =>
      'No reminders are set yet. Please ask your family to add them.';

  @override
  String get setupReminders => 'Reminders';

  @override
  String get setupRemindersDetail =>
      'Daily reminders that ring like an alarm, and the family check for missed ones.';

  @override
  String get setupEditReminders => 'Reminders and times';

  @override
  String get setupReminderSettings => 'Reminder settings and family check';
}
