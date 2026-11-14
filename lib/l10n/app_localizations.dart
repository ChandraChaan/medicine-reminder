import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_te.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
    Locale('te'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Voice Saathi'**
  String get appTitle;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageTelugu.
  ///
  /// In en, this message translates to:
  /// **'తెలుగు'**
  String get languageTelugu;

  /// No description provided for @languageHindi.
  ///
  /// In en, this message translates to:
  /// **'हिन्दी'**
  String get languageHindi;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retry;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorGeneric;

  /// No description provided for @chooseLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a language'**
  String get chooseLanguageTitle;

  /// No description provided for @onboardingTitle.
  ///
  /// In en, this message translates to:
  /// **'A phone helper that listens and reminds'**
  String get onboardingTitle;

  /// No description provided for @onboardingBody.
  ///
  /// In en, this message translates to:
  /// **'Press one big button and speak to call family, ask the time or ask for help. Reminders ring like an alarm and are read out, even when the phone is locked.'**
  String get onboardingBody;

  /// No description provided for @onboardingPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Everything stays on this phone. No account, no ads. Listening uses the phone\'s own speech recognition; online listening stays off unless you turn it on.'**
  String get onboardingPrivacy;

  /// No description provided for @allowReminders.
  ///
  /// In en, this message translates to:
  /// **'Allow reminders'**
  String get allowReminders;

  /// No description provided for @onboardingStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get onboardingStart;

  /// No description provided for @todayTitle.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get todayTitle;

  /// No description provided for @nothingToday.
  ///
  /// In en, this message translates to:
  /// **'No reminders today.'**
  String get nothingToday;

  /// No description provided for @allDoneToday.
  ///
  /// In en, this message translates to:
  /// **'All of today\'s reminders are done. Well done!'**
  String get allDoneToday;

  /// No description provided for @noMedicinesTitle.
  ///
  /// In en, this message translates to:
  /// **'No reminders yet'**
  String get noMedicinesTitle;

  /// No description provided for @noMedicinesBody.
  ///
  /// In en, this message translates to:
  /// **'Add the things to remember, like a walk, a phone call or drinking water. Each one takes about a minute.'**
  String get noMedicinesBody;

  /// No description provided for @addMedicine.
  ///
  /// In en, this message translates to:
  /// **'Add reminder'**
  String get addMedicine;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @familySetup.
  ///
  /// In en, this message translates to:
  /// **'Family setup'**
  String get familySetup;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @partMorning.
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get partMorning;

  /// No description provided for @partAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Afternoon'**
  String get partAfternoon;

  /// No description provided for @partEvening.
  ///
  /// In en, this message translates to:
  /// **'Evening'**
  String get partEvening;

  /// No description provided for @partNight.
  ///
  /// In en, this message translates to:
  /// **'Night'**
  String get partNight;

  /// No description provided for @statusTaken.
  ///
  /// In en, this message translates to:
  /// **'Done at {time}'**
  String statusTaken(String time);

  /// No description provided for @statusSkipped.
  ///
  /// In en, this message translates to:
  /// **'Skipped'**
  String get statusSkipped;

  /// No description provided for @statusMissed.
  ///
  /// In en, this message translates to:
  /// **'Missed'**
  String get statusMissed;

  /// No description provided for @statusDue.
  ///
  /// In en, this message translates to:
  /// **'Do it now'**
  String get statusDue;

  /// No description provided for @statusSnoozed.
  ///
  /// In en, this message translates to:
  /// **'Again at {time}'**
  String statusSnoozed(String time);

  /// No description provided for @statusUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Later today'**
  String get statusUpcoming;

  /// No description provided for @bannerNotifications.
  ///
  /// In en, this message translates to:
  /// **'Reminders are turned off, so they can\'t ring.'**
  String get bannerNotifications;

  /// No description provided for @bannerExactAlarms.
  ///
  /// In en, this message translates to:
  /// **'Alarms may ring late. Turn on \"Alarms & reminders\".'**
  String get bannerExactAlarms;

  /// No description provided for @bannerFullScreen.
  ///
  /// In en, this message translates to:
  /// **'The alarm screen can\'t open over the lock screen.'**
  String get bannerFullScreen;

  /// No description provided for @fix.
  ///
  /// In en, this message translates to:
  /// **'Fix'**
  String get fix;

  /// No description provided for @alarmTitle.
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get alarmTitle;

  /// No description provided for @alarmCount.
  ///
  /// In en, this message translates to:
  /// **'{index} of {total}'**
  String alarmCount(int index, int total);

  /// No description provided for @alarmWasDue.
  ///
  /// In en, this message translates to:
  /// **'This was due at {time}'**
  String alarmWasDue(String time);

  /// No description provided for @alarmAllDone.
  ///
  /// In en, this message translates to:
  /// **'All done. Well done!'**
  String get alarmAllDone;

  /// No description provided for @alarmNothingDue.
  ///
  /// In en, this message translates to:
  /// **'Nothing is due right now.'**
  String get alarmNothingDue;

  /// No description provided for @taken.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get taken;

  /// No description provided for @snooze.
  ///
  /// In en, this message translates to:
  /// **'Snooze {minutes} min'**
  String snooze(int minutes);

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @medicinePhoto.
  ///
  /// In en, this message translates to:
  /// **'Photo of {name}'**
  String medicinePhoto(String name);

  /// No description provided for @speechOne.
  ///
  /// In en, this message translates to:
  /// **'It\'s time for {name}.'**
  String speechOne(String name);

  /// No description provided for @speechMany.
  ///
  /// In en, this message translates to:
  /// **'It\'s time for these reminders:'**
  String get speechMany;

  /// No description provided for @speechItem.
  ///
  /// In en, this message translates to:
  /// **'{name}.'**
  String speechItem(String name);

  /// No description provided for @channelAlarms.
  ///
  /// In en, this message translates to:
  /// **'Reminder alarms'**
  String get channelAlarms;

  /// No description provided for @channelNotices.
  ///
  /// In en, this message translates to:
  /// **'Other notices'**
  String get channelNotices;

  /// No description provided for @medicinesTitle.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get medicinesTitle;

  /// No description provided for @medicinesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No reminders yet. Add the first one.'**
  String get medicinesEmpty;

  /// No description provided for @deleteMedicineTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete {name}?'**
  String deleteMedicineTitle(String name);

  /// No description provided for @deleteMedicineBody.
  ///
  /// In en, this message translates to:
  /// **'Its alarms and history will be removed from this phone.'**
  String get deleteMedicineBody;

  /// No description provided for @untilDate.
  ///
  /// In en, this message translates to:
  /// **'Until {date}'**
  String untilDate(String date);

  /// No description provided for @noEndDateShort.
  ///
  /// In en, this message translates to:
  /// **'No last day'**
  String get noEndDateShort;

  /// No description provided for @stepCounter.
  ///
  /// In en, this message translates to:
  /// **'Step {step} of {total}'**
  String stepCounter(int step, int total);

  /// No description provided for @stepName.
  ///
  /// In en, this message translates to:
  /// **'What should I remind you about?'**
  String get stepName;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Reminder name'**
  String get nameLabel;

  /// No description provided for @nameHint.
  ///
  /// In en, this message translates to:
  /// **'For example: Evening walk'**
  String get nameHint;

  /// No description provided for @sampleMedicine.
  ///
  /// In en, this message translates to:
  /// **'Evening walk'**
  String get sampleMedicine;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please type a name.'**
  String get nameRequired;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get takePhoto;

  /// No description provided for @choosePhoto.
  ///
  /// In en, this message translates to:
  /// **'Choose a photo'**
  String get choosePhoto;

  /// No description provided for @removePhoto.
  ///
  /// In en, this message translates to:
  /// **'Remove photo'**
  String get removePhoto;

  /// No description provided for @photoHelp.
  ///
  /// In en, this message translates to:
  /// **'A photo makes the reminder easy to recognise.'**
  String get photoHelp;

  /// No description provided for @stepTimes.
  ///
  /// In en, this message translates to:
  /// **'When should it ring?'**
  String get stepTimes;

  /// No description provided for @addTime.
  ///
  /// In en, this message translates to:
  /// **'Add a time'**
  String get addTime;

  /// No description provided for @removeTime.
  ///
  /// In en, this message translates to:
  /// **'Remove {time}'**
  String removeTime(String time);

  /// No description provided for @timesRequired.
  ///
  /// In en, this message translates to:
  /// **'Pick at least one time.'**
  String get timesRequired;

  /// No description provided for @stepDays.
  ///
  /// In en, this message translates to:
  /// **'Which days?'**
  String get stepDays;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'First day'**
  String get startDate;

  /// No description provided for @lastDay.
  ///
  /// In en, this message translates to:
  /// **'Last day'**
  String get lastDay;

  /// No description provided for @noEndDate.
  ///
  /// In en, this message translates to:
  /// **'Keep going'**
  String get noEndDate;

  /// No description provided for @pickEndDate.
  ///
  /// In en, this message translates to:
  /// **'Stop on a date'**
  String get pickEndDate;

  /// No description provided for @everyDayLabel.
  ///
  /// In en, this message translates to:
  /// **'Every day'**
  String get everyDayLabel;

  /// No description provided for @someDaysLabel.
  ///
  /// In en, this message translates to:
  /// **'Only some days'**
  String get someDaysLabel;

  /// No description provided for @daysRequired.
  ///
  /// In en, this message translates to:
  /// **'Pick at least one day.'**
  String get daysRequired;

  /// No description provided for @endBeforeStart.
  ///
  /// In en, this message translates to:
  /// **'The last day can\'t be before the first day.'**
  String get endBeforeStart;

  /// No description provided for @stepReview.
  ///
  /// In en, this message translates to:
  /// **'Check and save'**
  String get stepReview;

  /// No description provided for @reviewTimes.
  ///
  /// In en, this message translates to:
  /// **'Times'**
  String get reviewTimes;

  /// No description provided for @reviewDays.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get reviewDays;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsSpeak.
  ///
  /// In en, this message translates to:
  /// **'Speak reminders aloud'**
  String get settingsSpeak;

  /// No description provided for @settingsSpeakHelp.
  ///
  /// In en, this message translates to:
  /// **'Reads out the reminder name when the alarm rings.'**
  String get settingsSpeakHelp;

  /// No description provided for @testVoice.
  ///
  /// In en, this message translates to:
  /// **'Play a test'**
  String get testVoice;

  /// No description provided for @voiceMissing.
  ///
  /// In en, this message translates to:
  /// **'This phone has no voice for this language yet, so reminders are read in English. You can add the voice in Android\'s text-to-speech settings.'**
  String get voiceMissing;

  /// No description provided for @settingsMissedAfter.
  ///
  /// In en, this message translates to:
  /// **'Count a reminder as missed after'**
  String get settingsMissedAfter;

  /// No description provided for @minutesCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 minute} other{{count} minutes}}'**
  String minutesCount(int count);

  /// No description provided for @hoursCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 hour} other{{count} hours}}'**
  String hoursCount(int count);

  /// No description provided for @settingsPermissions.
  ///
  /// In en, this message translates to:
  /// **'Alarm permissions'**
  String get settingsPermissions;

  /// No description provided for @permNotifications.
  ///
  /// In en, this message translates to:
  /// **'Reminders (notifications)'**
  String get permNotifications;

  /// No description provided for @permExactAlarms.
  ///
  /// In en, this message translates to:
  /// **'Alarms & reminders'**
  String get permExactAlarms;

  /// No description provided for @permFullScreen.
  ///
  /// In en, this message translates to:
  /// **'Alarm over the lock screen'**
  String get permFullScreen;

  /// No description provided for @permOn.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get permOn;

  /// No description provided for @permOff.
  ///
  /// In en, this message translates to:
  /// **'Off. Tap to fix.'**
  String get permOff;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @aboutPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Everything stays on this phone. No account, no internet, no ads, no tracking.'**
  String get aboutPrivacy;

  /// No description provided for @aboutSource.
  ///
  /// In en, this message translates to:
  /// **'Free and open source (MIT licence).'**
  String get aboutSource;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyTitle;

  /// No description provided for @historySummary.
  ///
  /// In en, this message translates to:
  /// **'Done {taken} of {total} reminders this month'**
  String historySummary(int taken, int total);

  /// No description provided for @historyEmpty.
  ///
  /// In en, this message translates to:
  /// **'No reminders this month.'**
  String get historyEmpty;

  /// No description provided for @previousMonth.
  ///
  /// In en, this message translates to:
  /// **'Previous month'**
  String get previousMonth;

  /// No description provided for @nextMonth.
  ///
  /// In en, this message translates to:
  /// **'Next month'**
  String get nextMonth;

  /// No description provided for @legendAllTaken.
  ///
  /// In en, this message translates to:
  /// **'All done'**
  String get legendAllTaken;

  /// No description provided for @legendSomeMissed.
  ///
  /// In en, this message translates to:
  /// **'Some missed or skipped'**
  String get legendSomeMissed;

  /// No description provided for @legendMissed.
  ///
  /// In en, this message translates to:
  /// **'Missed'**
  String get legendMissed;

  /// No description provided for @historyDay.
  ///
  /// In en, this message translates to:
  /// **'{date}: {taken} done, {missed} missed, {skipped} skipped'**
  String historyDay(String date, int taken, int missed, int skipped);

  /// No description provided for @historyDayNoDoses.
  ///
  /// In en, this message translates to:
  /// **'{date}: no reminders'**
  String historyDayNoDoses(String date);

  /// No description provided for @familyCheckTitle.
  ///
  /// In en, this message translates to:
  /// **'Family check'**
  String get familyCheckTitle;

  /// No description provided for @familyCheckIntro.
  ///
  /// In en, this message translates to:
  /// **'If a reminder is not marked Done within the missed time, this phone can let one or two family members know. It stays off until you turn it on here.'**
  String get familyCheckIntro;

  /// No description provided for @familyCheckEnable.
  ///
  /// In en, this message translates to:
  /// **'Tell family about missed reminders'**
  String get familyCheckEnable;

  /// No description provided for @familyPersonLabel.
  ///
  /// In en, this message translates to:
  /// **'What does the family call them?'**
  String get familyPersonLabel;

  /// No description provided for @familyPersonHint.
  ///
  /// In en, this message translates to:
  /// **'For example: Amma'**
  String get familyPersonHint;

  /// No description provided for @familyNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Family phone number {index}'**
  String familyNumberLabel(int index);

  /// No description provided for @familyNumberHint.
  ///
  /// In en, this message translates to:
  /// **'+91 98765 43210'**
  String get familyNumberHint;

  /// No description provided for @familyNumberInvalid.
  ///
  /// In en, this message translates to:
  /// **'This doesn\'t look like a phone number.'**
  String get familyNumberInvalid;

  /// No description provided for @familyHowTitle.
  ///
  /// In en, this message translates to:
  /// **'How should they be told?'**
  String get familyHowTitle;

  /// No description provided for @familyChannelSms.
  ///
  /// In en, this message translates to:
  /// **'SMS from this phone (automatic)'**
  String get familyChannelSms;

  /// No description provided for @familyChannelSmsHelp.
  ///
  /// In en, this message translates to:
  /// **'This phone sends it by itself. Normal SMS charges apply.'**
  String get familyChannelSmsHelp;

  /// No description provided for @familyChannelSmsManual.
  ///
  /// In en, this message translates to:
  /// **'SMS (someone presses Send)'**
  String get familyChannelSmsManual;

  /// No description provided for @familyChannelSmsManualHelp.
  ///
  /// In en, this message translates to:
  /// **'A notification on this phone opens the SMS app with the message ready. Nothing is sent until someone presses Send. Normal SMS charges apply.'**
  String get familyChannelSmsManualHelp;

  /// No description provided for @familyChannelWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp (someone presses Send)'**
  String get familyChannelWhatsapp;

  /// No description provided for @familyChannelWhatsappHelp.
  ///
  /// In en, this message translates to:
  /// **'A notification on this phone opens WhatsApp with the message ready. Nothing is sent until someone presses Send.'**
  String get familyChannelWhatsappHelp;

  /// No description provided for @familySmsConsent.
  ///
  /// In en, this message translates to:
  /// **'I agree that this phone may send an SMS to these numbers when a reminder is missed.'**
  String get familySmsConsent;

  /// No description provided for @familySmsPermission.
  ///
  /// In en, this message translates to:
  /// **'Allow sending SMS'**
  String get familySmsPermission;

  /// No description provided for @familySmsPermissionMissing.
  ///
  /// In en, this message translates to:
  /// **'SMS permission is off. Until it is allowed, a notification opens the SMS app with the message ready instead.'**
  String get familySmsPermissionMissing;

  /// No description provided for @familySendTest.
  ///
  /// In en, this message translates to:
  /// **'Send a test message'**
  String get familySendTest;

  /// No description provided for @familyTestSent.
  ///
  /// In en, this message translates to:
  /// **'Test message sent.'**
  String get familyTestSent;

  /// No description provided for @familyTestFailed.
  ///
  /// In en, this message translates to:
  /// **'The message could not be sent. Check the number and the SIM.'**
  String get familyTestFailed;

  /// No description provided for @familyMessagePreview.
  ///
  /// In en, this message translates to:
  /// **'Message preview'**
  String get familyMessagePreview;

  /// No description provided for @familyMessage.
  ///
  /// In en, this message translates to:
  /// **'Voice Saathi: {person} has not marked {medicines} (due at {time}) as done. Please check on them.'**
  String familyMessage(String person, String medicines, String time);

  /// No description provided for @familyTestMessage.
  ///
  /// In en, this message translates to:
  /// **'Voice Saathi: this is a test. You will get a message like this if {person} misses a reminder.'**
  String familyTestMessage(String person);

  /// No description provided for @familyPersonFallback.
  ///
  /// In en, this message translates to:
  /// **'your family member'**
  String get familyPersonFallback;

  /// No description provided for @familyNotifySentTitle.
  ///
  /// In en, this message translates to:
  /// **'Family was told'**
  String get familyNotifySentTitle;

  /// No description provided for @familyNotifySentBody.
  ///
  /// In en, this message translates to:
  /// **'An SMS about the missed reminder was sent to your family.'**
  String get familyNotifySentBody;

  /// No description provided for @familyNotifyShareTitle.
  ///
  /// In en, this message translates to:
  /// **'Tell your family'**
  String get familyNotifyShareTitle;

  /// No description provided for @familyNotifyShareBody.
  ///
  /// In en, this message translates to:
  /// **'A reminder was missed. Tap to send the message.'**
  String get familyNotifyShareBody;

  /// No description provided for @familyNeedsNumber.
  ///
  /// In en, this message translates to:
  /// **'Add at least one phone number.'**
  String get familyNeedsNumber;

  /// No description provided for @familyNeedsConsent.
  ///
  /// In en, this message translates to:
  /// **'Please tick the agreement to use SMS.'**
  String get familyNeedsConsent;

  /// No description provided for @familyStatusOn.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get familyStatusOn;

  /// No description provided for @familyStatusOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get familyStatusOff;

  /// No description provided for @speakButton.
  ///
  /// In en, this message translates to:
  /// **'Press and speak'**
  String get speakButton;

  /// No description provided for @listening.
  ///
  /// In en, this message translates to:
  /// **'Listening…'**
  String get listening;

  /// No description provided for @tapToStop.
  ///
  /// In en, this message translates to:
  /// **'Press again to stop'**
  String get tapToStop;

  /// No description provided for @thinking.
  ///
  /// In en, this message translates to:
  /// **'One moment…'**
  String get thinking;

  /// No description provided for @youSaid.
  ///
  /// In en, this message translates to:
  /// **'You said: “{text}”'**
  String youSaid(String text);

  /// No description provided for @familyHeading.
  ///
  /// In en, this message translates to:
  /// **'Tap a photo to call'**
  String get familyHeading;

  /// No description provided for @helpButton.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get helpButton;

  /// No description provided for @helpButtonHint.
  ///
  /// In en, this message translates to:
  /// **'Calls family for help'**
  String get helpButtonHint;

  /// No description provided for @holdToOpen.
  ///
  /// In en, this message translates to:
  /// **'Press and hold to open'**
  String get holdToOpen;

  /// No description provided for @noContactsYet.
  ///
  /// In en, this message translates to:
  /// **'No family numbers yet. Ask your family to open Family setup.'**
  String get noContactsYet;

  /// No description provided for @callName.
  ///
  /// In en, this message translates to:
  /// **'Call {name}'**
  String callName(String name);

  /// No description provided for @helpNextTitle.
  ///
  /// In en, this message translates to:
  /// **'Did {name} answer?'**
  String helpNextTitle(String name);

  /// No description provided for @helpFine.
  ///
  /// In en, this message translates to:
  /// **'Yes, I\'m fine'**
  String get helpFine;

  /// No description provided for @spokenPartMorning.
  ///
  /// In en, this message translates to:
  /// **'in the morning'**
  String get spokenPartMorning;

  /// No description provided for @spokenPartAfternoon.
  ///
  /// In en, this message translates to:
  /// **'in the afternoon'**
  String get spokenPartAfternoon;

  /// No description provided for @spokenPartEvening.
  ///
  /// In en, this message translates to:
  /// **'in the evening'**
  String get spokenPartEvening;

  /// No description provided for @spokenPartNight.
  ///
  /// In en, this message translates to:
  /// **'at night'**
  String get spokenPartNight;

  /// No description provided for @sayCalling.
  ///
  /// In en, this message translates to:
  /// **'Calling {name}.'**
  String sayCalling(String name);

  /// No description provided for @sayDialer.
  ///
  /// In en, this message translates to:
  /// **'Press the green button to call {name}.'**
  String sayDialer(String name);

  /// No description provided for @sayCallFailed.
  ///
  /// In en, this message translates to:
  /// **'I could not call {name}. Please try again.'**
  String sayCallFailed(String name);

  /// No description provided for @sayCallingForHelp.
  ///
  /// In en, this message translates to:
  /// **'Calling {name} for help.'**
  String sayCallingForHelp(String name);

  /// No description provided for @sayHelpNext.
  ///
  /// In en, this message translates to:
  /// **'If {name} did not answer, press the red Help button to call {next}.'**
  String sayHelpNext(String name, String next);

  /// No description provided for @sayNoHelpContacts.
  ///
  /// In en, this message translates to:
  /// **'No one is set up for Help yet. Please ask your family to set it up.'**
  String get sayNoHelpContacts;

  /// No description provided for @sayWhom.
  ///
  /// In en, this message translates to:
  /// **'Whom should I call? Say the name, or tap a photo.'**
  String get sayWhom;

  /// No description provided for @sayTime.
  ///
  /// In en, this message translates to:
  /// **'It is {clock} {part}.'**
  String sayTime(String clock, String part);

  /// No description provided for @sayDate.
  ///
  /// In en, this message translates to:
  /// **'Today is {weekday}, {date}.'**
  String sayDate(String weekday, String date);

  /// No description provided for @sayBattery.
  ///
  /// In en, this message translates to:
  /// **'The battery is at {percent} percent.'**
  String sayBattery(int percent);

  /// No description provided for @sayCharging.
  ///
  /// In en, this message translates to:
  /// **'It is charging.'**
  String get sayCharging;

  /// No description provided for @sayChargeSoon.
  ///
  /// In en, this message translates to:
  /// **'Please put the phone on charge.'**
  String get sayChargeSoon;

  /// No description provided for @sayBatteryUnknown.
  ///
  /// In en, this message translates to:
  /// **'I could not read the battery.'**
  String get sayBatteryUnknown;

  /// No description provided for @sayTorchOn.
  ///
  /// In en, this message translates to:
  /// **'The light is on.'**
  String get sayTorchOn;

  /// No description provided for @sayTorchOff.
  ///
  /// In en, this message translates to:
  /// **'The light is off.'**
  String get sayTorchOff;

  /// No description provided for @sayNoTorch.
  ///
  /// In en, this message translates to:
  /// **'This phone has no light I can turn on.'**
  String get sayNoTorch;

  /// No description provided for @sayNotUnderstood.
  ///
  /// In en, this message translates to:
  /// **'Sorry, I did not understand. Press the button and say it again, or tap a photo to call.'**
  String get sayNotUnderstood;

  /// No description provided for @sayHeardNothing.
  ///
  /// In en, this message translates to:
  /// **'I did not hear anything. Press the button and speak.'**
  String get sayHeardNothing;

  /// No description provided for @sayVoiceNotReady.
  ///
  /// In en, this message translates to:
  /// **'Listening is not ready on this phone yet. Please ask your family to open Family setup. You can still tap a photo to call.'**
  String get sayVoiceNotReady;

  /// No description provided for @sayNoInternet.
  ///
  /// In en, this message translates to:
  /// **'I need the internet to understand you on this phone. Please try again, or tap a photo to call.'**
  String get sayNoInternet;

  /// No description provided for @sayMicDenied.
  ///
  /// In en, this message translates to:
  /// **'I need the microphone to listen. Please ask your family to allow it in Family setup.'**
  String get sayMicDenied;

  /// No description provided for @sayTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please press the button again.'**
  String get sayTryAgain;

  /// No description provided for @setupIntro.
  ///
  /// In en, this message translates to:
  /// **'Set this up once for your parent. Add the people they call most. The red Help button calls the people marked Help, from the top of the list.'**
  String get setupIntro;

  /// No description provided for @languageHeading.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageHeading;

  /// No description provided for @familyMembers.
  ///
  /// In en, this message translates to:
  /// **'Family members'**
  String get familyMembers;

  /// No description provided for @addContact.
  ///
  /// In en, this message translates to:
  /// **'Add a person'**
  String get addContact;

  /// No description provided for @reorderHint.
  ///
  /// In en, this message translates to:
  /// **'Drag the handle on the right to change the order.'**
  String get reorderHint;

  /// No description provided for @speechHeading.
  ///
  /// In en, this message translates to:
  /// **'Listening'**
  String get speechHeading;

  /// No description provided for @speechOffline.
  ///
  /// In en, this message translates to:
  /// **'{language} is understood on this phone, without internet. Nothing your parent says leaves the phone.'**
  String speechOffline(String language);

  /// No description provided for @speechDownloading.
  ///
  /// In en, this message translates to:
  /// **'Google is downloading {language} for offline use. This can take a few minutes on Wi-Fi.'**
  String speechDownloading(String language);

  /// No description provided for @speechDownloadable.
  ///
  /// In en, this message translates to:
  /// **'{language} can be understood without internet after a one-time download from Google.'**
  String speechDownloadable(String language);

  /// No description provided for @speechDownload.
  ///
  /// In en, this message translates to:
  /// **'Download {language}'**
  String speechDownload(String language);

  /// No description provided for @speechDownloadStarted.
  ///
  /// In en, this message translates to:
  /// **'Follow the phone\'s prompt to download. Keep the phone on Wi-Fi for a few minutes.'**
  String get speechDownloadStarted;

  /// No description provided for @speechDownloadFailed.
  ///
  /// In en, this message translates to:
  /// **'This phone can\'t download it. Turn on online listening below instead.'**
  String get speechDownloadFailed;

  /// No description provided for @speechOnlineOnly.
  ///
  /// In en, this message translates to:
  /// **'This phone can\'t understand {language} without internet.'**
  String speechOnlineOnly(String language);

  /// No description provided for @speechUnknown.
  ///
  /// In en, this message translates to:
  /// **'This phone understands speech on its own, but can\'t tell whether {language} is ready. Try the big button.'**
  String speechUnknown(String language);

  /// No description provided for @speechNone.
  ///
  /// In en, this message translates to:
  /// **'This phone has no speech recognition. Install or update the Google app, or use the photos to call.'**
  String get speechNone;

  /// No description provided for @allowOnline.
  ///
  /// In en, this message translates to:
  /// **'Allow online listening'**
  String get allowOnline;

  /// No description provided for @allowOnlineDetail.
  ///
  /// In en, this message translates to:
  /// **'Uses the phone\'s Google speech service, which sends what your parent says to Google to turn it into text. Only used when the phone can\'t do it alone.'**
  String get allowOnlineDetail;

  /// No description provided for @voiceHeading.
  ///
  /// In en, this message translates to:
  /// **'Voice'**
  String get voiceHeading;

  /// No description provided for @hearSample.
  ///
  /// In en, this message translates to:
  /// **'Hear a sample'**
  String get hearSample;

  /// No description provided for @voiceSample.
  ///
  /// In en, this message translates to:
  /// **'Hello. Press the big button and speak to me.'**
  String get voiceSample;

  /// No description provided for @noVoice.
  ///
  /// In en, this message translates to:
  /// **'This phone has no {language} voice, so replies may be read in another language. Install it in the phone\'s Settings, under Text-to-speech.'**
  String noVoice(String language);

  /// No description provided for @permissionsHeading.
  ///
  /// In en, this message translates to:
  /// **'Permissions'**
  String get permissionsHeading;

  /// No description provided for @micPermission.
  ///
  /// In en, this message translates to:
  /// **'Microphone, to listen'**
  String get micPermission;

  /// No description provided for @phonePermission.
  ///
  /// In en, this message translates to:
  /// **'Phone, to call straight away'**
  String get phonePermission;

  /// No description provided for @phonePermissionDetail.
  ///
  /// In en, this message translates to:
  /// **'Without it, the dialer opens and your parent presses the green button.'**
  String get phonePermissionDetail;

  /// No description provided for @allowed.
  ///
  /// In en, this message translates to:
  /// **'Allowed'**
  String get allowed;

  /// No description provided for @allow.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get allow;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @newContact.
  ///
  /// In en, this message translates to:
  /// **'New person'**
  String get newContact;

  /// No description provided for @editContact.
  ///
  /// In en, this message translates to:
  /// **'Edit {name}'**
  String editContact(String name);

  /// No description provided for @contactNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name shown under the photo'**
  String get contactNameLabel;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneLabel;

  /// No description provided for @contactNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a name'**
  String get contactNameRequired;

  /// No description provided for @phoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a phone number'**
  String get phoneRequired;

  /// No description provided for @photoOf.
  ///
  /// In en, this message translates to:
  /// **'Photo of {name}'**
  String photoOf(String name);

  /// No description provided for @nicknamesHeading.
  ///
  /// In en, this message translates to:
  /// **'Other names your parent uses'**
  String get nicknamesHeading;

  /// No description provided for @nicknamesHint.
  ///
  /// In en, this message translates to:
  /// **'For example “pedda abbayi”, “బాబు” or “बेटा”. Tap Say it and say the name the way your parent says it, so the phone learns how it hears it.'**
  String get nicknamesHint;

  /// No description provided for @nicknameField.
  ///
  /// In en, this message translates to:
  /// **'Type a name'**
  String get nicknameField;

  /// No description provided for @addNickname.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get addNickname;

  /// No description provided for @sayIt.
  ///
  /// In en, this message translates to:
  /// **'Say it'**
  String get sayIt;

  /// No description provided for @heardNickname.
  ///
  /// In en, this message translates to:
  /// **'Heard “{text}”. Added.'**
  String heardNickname(String text);

  /// No description provided for @heardNicknameNothing.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t catch that. Try again.'**
  String get heardNicknameNothing;

  /// No description provided for @removeNickname.
  ///
  /// In en, this message translates to:
  /// **'Remove {name}'**
  String removeNickname(String name);

  /// No description provided for @forHelpTitle.
  ///
  /// In en, this message translates to:
  /// **'Call for Help'**
  String get forHelpTitle;

  /// No description provided for @forHelpDetail.
  ///
  /// In en, this message translates to:
  /// **'The red Help button calls this person.'**
  String get forHelpDetail;

  /// No description provided for @deleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete {name}?'**
  String deleteConfirm(String name);

  /// No description provided for @welcomeBody.
  ///
  /// In en, this message translates to:
  /// **'A phone helper your parent can talk to. Press one big button and speak: call family, ask the time or the day, turn on the light, or ask for help.'**
  String get welcomeBody;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose a language'**
  String get chooseLanguage;

  /// No description provided for @privacyNote.
  ///
  /// In en, this message translates to:
  /// **'Everything stays on this phone. No account, no ads, no tracking.'**
  String get privacyNote;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @todaysReminders.
  ///
  /// In en, this message translates to:
  /// **'Today\'s reminders'**
  String get todaysReminders;

  /// No description provided for @remindersLeft.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 left today} other{{count} left today}}'**
  String remindersLeft(int count);

  /// No description provided for @remindersAllDone.
  ///
  /// In en, this message translates to:
  /// **'Nothing left for today'**
  String get remindersAllDone;

  /// No description provided for @remindersNone.
  ///
  /// In en, this message translates to:
  /// **'No reminders set'**
  String get remindersNone;

  /// No description provided for @sayRemindersLeft.
  ///
  /// In en, this message translates to:
  /// **'Still to do today: {items}.'**
  String sayRemindersLeft(String items);

  /// No description provided for @sayReminderItem.
  ///
  /// In en, this message translates to:
  /// **'{name} at {time}'**
  String sayReminderItem(String name, String time);

  /// No description provided for @sayNoRemindersLeft.
  ///
  /// In en, this message translates to:
  /// **'Nothing is left to do today.'**
  String get sayNoRemindersLeft;

  /// No description provided for @sayNoReminders.
  ///
  /// In en, this message translates to:
  /// **'No reminders are set yet. Please ask your family to add them.'**
  String get sayNoReminders;

  /// No description provided for @setupReminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get setupReminders;

  /// No description provided for @setupRemindersDetail.
  ///
  /// In en, this message translates to:
  /// **'Daily reminders that ring like an alarm, and the family check for missed ones.'**
  String get setupRemindersDetail;

  /// No description provided for @setupEditReminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders and times'**
  String get setupEditReminders;

  /// No description provided for @setupReminderSettings.
  ///
  /// In en, this message translates to:
  /// **'Reminder settings and family check'**
  String get setupReminderSettings;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi', 'te'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
    case 'te':
      return AppLocalizationsTe();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
