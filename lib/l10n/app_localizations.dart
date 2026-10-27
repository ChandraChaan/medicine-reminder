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
  /// **'Medicine Reminder'**
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
  /// **'Reminders that ring like an alarm'**
  String get onboardingTitle;

  /// No description provided for @onboardingBody.
  ///
  /// In en, this message translates to:
  /// **'At medicine time the phone rings, shows the medicine in big letters and reads it out. It works even when the phone is locked.'**
  String get onboardingBody;

  /// No description provided for @onboardingPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Everything stays on this phone. No account, no internet, no ads.'**
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
  /// **'No medicines today.'**
  String get nothingToday;

  /// No description provided for @allDoneToday.
  ///
  /// In en, this message translates to:
  /// **'All of today\'s medicines are done. Well done!'**
  String get allDoneToday;

  /// No description provided for @noMedicinesTitle.
  ///
  /// In en, this message translates to:
  /// **'No medicines yet'**
  String get noMedicinesTitle;

  /// No description provided for @noMedicinesBody.
  ///
  /// In en, this message translates to:
  /// **'Ask a family member to add the medicines. Each one takes about a minute.'**
  String get noMedicinesBody;

  /// No description provided for @addMedicine.
  ///
  /// In en, this message translates to:
  /// **'Add medicine'**
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
  /// **'Taken at {time}'**
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
  /// **'Take now'**
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

  /// No description provided for @refillDaysLeft.
  ///
  /// In en, this message translates to:
  /// **'{name}: {days, plural, =1{1 day left} other{{days} days left}}. Buy more soon.'**
  String refillDaysLeft(String name, int days);

  /// No description provided for @refillRunOut.
  ///
  /// In en, this message translates to:
  /// **'{name} has run out. Buy more today.'**
  String refillRunOut(String name);

  /// No description provided for @refillNoticeTitle.
  ///
  /// In en, this message translates to:
  /// **'Time to buy {name}'**
  String refillNoticeTitle(String name);

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
  /// **'Time for your medicine'**
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
  /// **'No medicine is due right now.'**
  String get alarmNothingDue;

  /// No description provided for @taken.
  ///
  /// In en, this message translates to:
  /// **'Taken'**
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

  /// No description provided for @doseAmount.
  ///
  /// In en, this message translates to:
  /// **'{amount} {unit}'**
  String doseAmount(String amount, String unit);

  /// No description provided for @unitTablet.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{tablet} other{tablets}}'**
  String unitTablet(int count);

  /// No description provided for @unitCapsule.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{capsule} other{capsules}}'**
  String unitCapsule(int count);

  /// No description provided for @unitMl.
  ///
  /// In en, this message translates to:
  /// **'ml'**
  String get unitMl;

  /// No description provided for @unitDrops.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{drop} other{drops}}'**
  String unitDrops(int count);

  /// No description provided for @unitPuff.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{puff} other{puffs}}'**
  String unitPuff(int count);

  /// No description provided for @unitInjection.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{injection} other{injections}}'**
  String unitInjection(int count);

  /// No description provided for @foodBefore.
  ///
  /// In en, this message translates to:
  /// **'Before food'**
  String get foodBefore;

  /// No description provided for @foodAfter.
  ///
  /// In en, this message translates to:
  /// **'After food'**
  String get foodAfter;

  /// No description provided for @foodWith.
  ///
  /// In en, this message translates to:
  /// **'With food'**
  String get foodWith;

  /// No description provided for @foodAny.
  ///
  /// In en, this message translates to:
  /// **'Any time'**
  String get foodAny;

  /// No description provided for @foodBeforeSpoken.
  ///
  /// In en, this message translates to:
  /// **'before food'**
  String get foodBeforeSpoken;

  /// No description provided for @foodAfterSpoken.
  ///
  /// In en, this message translates to:
  /// **'after food'**
  String get foodAfterSpoken;

  /// No description provided for @foodWithSpoken.
  ///
  /// In en, this message translates to:
  /// **'with food'**
  String get foodWithSpoken;

  /// No description provided for @speechOne.
  ///
  /// In en, this message translates to:
  /// **'It\'s time for your {name}, {food}.'**
  String speechOne(String name, String food);

  /// No description provided for @speechOneNoFood.
  ///
  /// In en, this message translates to:
  /// **'It\'s time for your {name}.'**
  String speechOneNoFood(String name);

  /// No description provided for @speechMany.
  ///
  /// In en, this message translates to:
  /// **'It\'s time for your medicines.'**
  String get speechMany;

  /// No description provided for @speechItem.
  ///
  /// In en, this message translates to:
  /// **'{name}, {food}.'**
  String speechItem(String name, String food);

  /// No description provided for @speechItemNoFood.
  ///
  /// In en, this message translates to:
  /// **'{name}.'**
  String speechItemNoFood(String name);

  /// No description provided for @channelAlarms.
  ///
  /// In en, this message translates to:
  /// **'Medicine alarms'**
  String get channelAlarms;

  /// No description provided for @channelNotices.
  ///
  /// In en, this message translates to:
  /// **'Refill and other notices'**
  String get channelNotices;

  /// No description provided for @medicinesTitle.
  ///
  /// In en, this message translates to:
  /// **'Medicines'**
  String get medicinesTitle;

  /// No description provided for @medicinesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No medicines yet. Add the first one.'**
  String get medicinesEmpty;

  /// No description provided for @deleteMedicineTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete {name}?'**
  String deleteMedicineTitle(String name);

  /// No description provided for @deleteMedicineBody.
  ///
  /// In en, this message translates to:
  /// **'Its reminders and history will be removed from this phone.'**
  String get deleteMedicineBody;

  /// No description provided for @boughtMore.
  ///
  /// In en, this message translates to:
  /// **'Bought more'**
  String get boughtMore;

  /// No description provided for @boughtMoreTitle.
  ///
  /// In en, this message translates to:
  /// **'How many did you buy?'**
  String get boughtMoreTitle;

  /// No description provided for @stockLeft.
  ///
  /// In en, this message translates to:
  /// **'{amount} left'**
  String stockLeft(String amount);

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
  /// **'What is the medicine called?'**
  String get stepName;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Medicine name'**
  String get nameLabel;

  /// No description provided for @nameHint.
  ///
  /// In en, this message translates to:
  /// **'For example: BP tablet'**
  String get nameHint;

  /// No description provided for @sampleMedicine.
  ///
  /// In en, this message translates to:
  /// **'BP tablet'**
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
  /// **'A photo of the strip helps pick the right medicine.'**
  String get photoHelp;

  /// No description provided for @stepDose.
  ///
  /// In en, this message translates to:
  /// **'How much each time?'**
  String get stepDose;

  /// No description provided for @decrease.
  ///
  /// In en, this message translates to:
  /// **'Less'**
  String get decrease;

  /// No description provided for @increase.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get increase;

  /// No description provided for @unitLabel.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get unitLabel;

  /// No description provided for @stepTimes.
  ///
  /// In en, this message translates to:
  /// **'When should it be taken?'**
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

  /// No description provided for @stepFood.
  ///
  /// In en, this message translates to:
  /// **'Before or after food?'**
  String get stepFood;

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

  /// No description provided for @stepStock.
  ///
  /// In en, this message translates to:
  /// **'Count the tablets?'**
  String get stepStock;

  /// No description provided for @stockHelp.
  ///
  /// In en, this message translates to:
  /// **'The app counts down after each dose and warns before they run out.'**
  String get stockHelp;

  /// No description provided for @dontCount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t count'**
  String get dontCount;

  /// No description provided for @countThem.
  ///
  /// In en, this message translates to:
  /// **'Count them'**
  String get countThem;

  /// No description provided for @stockInHand.
  ///
  /// In en, this message translates to:
  /// **'How many are there now?'**
  String get stockInHand;

  /// No description provided for @warnDaysBefore.
  ///
  /// In en, this message translates to:
  /// **'Warn {days, plural, =1{1 day} other{{days} days}} before they run out'**
  String warnDaysBefore(int days);

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

  /// No description provided for @reviewStock.
  ///
  /// In en, this message translates to:
  /// **'Count'**
  String get reviewStock;

  /// No description provided for @notCounted.
  ///
  /// In en, this message translates to:
  /// **'Not counted'**
  String get notCounted;

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
  /// **'Reads out the medicine name and food timing when the alarm rings.'**
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
  /// **'Count a dose as missed after'**
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

  /// No description provided for @aboutDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'This app is a reminder aid, not medical advice. Always follow the doctor\'s instructions.'**
  String get aboutDisclaimer;

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
  /// **'Taken {taken} of {total} doses this month'**
  String historySummary(int taken, int total);

  /// No description provided for @historyEmpty.
  ///
  /// In en, this message translates to:
  /// **'No doses this month.'**
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
  /// **'All taken'**
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
  /// **'{date}: {taken} taken, {missed} missed, {skipped} skipped'**
  String historyDay(String date, int taken, int missed, int skipped);

  /// No description provided for @historyDayNoDoses.
  ///
  /// In en, this message translates to:
  /// **'{date}: no doses'**
  String historyDayNoDoses(String date);

  /// No description provided for @familyCheckTitle.
  ///
  /// In en, this message translates to:
  /// **'Family check'**
  String get familyCheckTitle;

  /// No description provided for @familyCheckIntro.
  ///
  /// In en, this message translates to:
  /// **'If a dose is not marked Taken within the missed-dose time, this phone can let one or two family members know. It stays off until you turn it on here.'**
  String get familyCheckIntro;

  /// No description provided for @familyCheckEnable.
  ///
  /// In en, this message translates to:
  /// **'Tell family about missed doses'**
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
  /// **'I agree that this phone may send an SMS to these numbers when a dose is missed.'**
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
  /// **'Medicine Reminder: {person} has not marked {medicines} (due at {time}) as taken. Please check on them.'**
  String familyMessage(String person, String medicines, String time);

  /// No description provided for @familyTestMessage.
  ///
  /// In en, this message translates to:
  /// **'Medicine Reminder: this is a test. You will get a message like this if {person} misses a dose.'**
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
  /// **'An SMS about the missed dose was sent to your family.'**
  String get familyNotifySentBody;

  /// No description provided for @familyNotifyShareTitle.
  ///
  /// In en, this message translates to:
  /// **'Tell your family'**
  String get familyNotifyShareTitle;

  /// No description provided for @familyNotifyShareBody.
  ///
  /// In en, this message translates to:
  /// **'A dose was missed. Tap to send the message.'**
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
