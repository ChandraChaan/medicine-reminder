// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'दवा रिमाइंडर';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageTelugu => 'తెలుగు';

  @override
  String get languageHindi => 'हिन्दी';

  @override
  String get next => 'आगे';

  @override
  String get back => 'पीछे';

  @override
  String get save => 'सेव करें';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get close => 'बंद करें';

  @override
  String get delete => 'हटाएँ';

  @override
  String get edit => 'बदलें';

  @override
  String get undo => 'वापस लें';

  @override
  String get retry => 'फिर से कोशिश करें';

  @override
  String get errorGeneric => 'कुछ गड़बड़ हो गई। कृपया फिर से कोशिश करें।';

  @override
  String get chooseLanguageTitle => 'भाषा चुनें';

  @override
  String get onboardingTitle => 'अलार्म की तरह बजने वाले रिमाइंडर';

  @override
  String get onboardingBody =>
      'दवा के समय फ़ोन बजेगा, दवा का नाम बड़े अक्षरों में दिखाएगा और पढ़कर सुनाएगा। फ़ोन लॉक होने पर भी काम करता है।';

  @override
  String get onboardingPrivacy =>
      'सब कुछ इसी फ़ोन में रहता है। न अकाउंट, न इंटरनेट, न विज्ञापन।';

  @override
  String get allowReminders => 'रिमाइंडर की अनुमति दें';

  @override
  String get onboardingStart => 'शुरू करें';

  @override
  String get todayTitle => 'आज';

  @override
  String get nothingToday => 'आज कोई दवा नहीं है।';

  @override
  String get allDoneToday => 'आज की सारी दवाएँ हो गईं। बहुत बढ़िया!';

  @override
  String get noMedicinesTitle => 'अभी कोई दवा नहीं';

  @override
  String get noMedicinesBody =>
      'परिवार के किसी सदस्य से दवाएँ जोड़ने को कहें। हर दवा में लगभग एक मिनट लगता है।';

  @override
  String get addMedicine => 'दवा जोड़ें';

  @override
  String get history => 'इतिहास';

  @override
  String get familySetup => 'परिवार के लिए सेटअप';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get partMorning => 'सुबह';

  @override
  String get partAfternoon => 'दोपहर';

  @override
  String get partEvening => 'शाम';

  @override
  String get partNight => 'रात';

  @override
  String statusTaken(String time) {
    return '$time पर ली';
  }

  @override
  String get statusSkipped => 'छोड़ दी';

  @override
  String get statusMissed => 'नहीं ली';

  @override
  String get statusDue => 'अभी लें';

  @override
  String statusSnoozed(String time) {
    return 'फिर $time पर';
  }

  @override
  String get statusUpcoming => 'आज बाद में';

  @override
  String refillDaysLeft(String name, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'सिर्फ़ $days दिन की बची है',
      one: 'सिर्फ़ 1 दिन की बची है',
    );
    return '$name: $_temp0। जल्दी खरीदें।';
  }

  @override
  String refillRunOut(String name) {
    return '$name खत्म हो गई है। आज ही खरीदें।';
  }

  @override
  String refillNoticeTitle(String name) {
    return '$name खरीदने का समय';
  }

  @override
  String get bannerNotifications => 'रिमाइंडर बंद हैं, इसलिए बज नहीं पाएँगे।';

  @override
  String get bannerExactAlarms =>
      'अलार्म देर से बज सकते हैं। \"अलार्म और रिमाइंडर\" चालू करें।';

  @override
  String get bannerFullScreen => 'लॉक स्क्रीन पर अलार्म स्क्रीन नहीं खुल सकती।';

  @override
  String get fix => 'ठीक करें';

  @override
  String get alarmTitle => 'दवा लेने का समय';

  @override
  String alarmCount(int index, int total) {
    return '$total में से $index';
  }

  @override
  String alarmWasDue(String time) {
    return 'यह $time पर लेनी थी';
  }

  @override
  String get alarmAllDone => 'सब हो गया। बहुत बढ़िया!';

  @override
  String get alarmNothingDue => 'अभी कोई दवा लेनी नहीं है।';

  @override
  String get taken => 'ले ली';

  @override
  String snooze(int minutes) {
    return '$minutes मिनट बाद';
  }

  @override
  String get skip => 'छोड़ें';

  @override
  String medicinePhoto(String name) {
    return '$name की फ़ोटो';
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
      other: 'गोलियाँ',
      one: 'गोली',
    );
    return '$_temp0';
  }

  @override
  String unitCapsule(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'कैप्सूल',
      one: 'कैप्सूल',
    );
    return '$_temp0';
  }

  @override
  String get unitMl => 'मि.ली.';

  @override
  String unitDrops(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'बूँदें',
      one: 'बूँद',
    );
    return '$_temp0';
  }

  @override
  String unitPuff(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'पफ़',
      one: 'पफ़',
    );
    return '$_temp0';
  }

  @override
  String unitInjection(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'इंजेक्शन',
      one: 'इंजेक्शन',
    );
    return '$_temp0';
  }

  @override
  String get foodBefore => 'खाने से पहले';

  @override
  String get foodAfter => 'खाने के बाद';

  @override
  String get foodWith => 'खाने के साथ';

  @override
  String get foodAny => 'कभी भी';

  @override
  String get foodBeforeSpoken => 'खाने से पहले';

  @override
  String get foodAfterSpoken => 'खाने के बाद';

  @override
  String get foodWithSpoken => 'खाने के साथ';

  @override
  String speechOne(String name, String food) {
    return '$name लेने का समय हो गया है, $food।';
  }

  @override
  String speechOneNoFood(String name) {
    return '$name लेने का समय हो गया है।';
  }

  @override
  String get speechMany => 'आपकी दवाएँ लेने का समय हो गया है।';

  @override
  String speechItem(String name, String food) {
    return '$name, $food।';
  }

  @override
  String speechItemNoFood(String name) {
    return '$name।';
  }

  @override
  String get channelAlarms => 'दवा के अलार्म';

  @override
  String get channelNotices => 'दवा खत्म होने की सूचनाएँ';

  @override
  String get medicinesTitle => 'दवाएँ';

  @override
  String get medicinesEmpty => 'अभी कोई दवा नहीं। पहली दवा जोड़ें।';

  @override
  String deleteMedicineTitle(String name) {
    return '$name हटाएँ?';
  }

  @override
  String get deleteMedicineBody =>
      'इसके रिमाइंडर और इतिहास इस फ़ोन से हट जाएँगे।';

  @override
  String get boughtMore => 'और खरीदी';

  @override
  String get boughtMoreTitle => 'कितनी खरीदीं?';

  @override
  String stockLeft(String amount) {
    return '$amount बची हैं';
  }

  @override
  String untilDate(String date) {
    return '$date तक';
  }

  @override
  String get noEndDateShort => 'कोई आखिरी दिन नहीं';

  @override
  String stepCounter(int step, int total) {
    return 'चरण $step / $total';
  }

  @override
  String get stepName => 'दवा का नाम क्या है?';

  @override
  String get nameLabel => 'दवा का नाम';

  @override
  String get nameHint => 'जैसे: BP की गोली';

  @override
  String get sampleMedicine => 'BP की गोली';

  @override
  String get nameRequired => 'कृपया नाम लिखें।';

  @override
  String get takePhoto => 'फ़ोटो खींचें';

  @override
  String get choosePhoto => 'फ़ोटो चुनें';

  @override
  String get removePhoto => 'फ़ोटो हटाएँ';

  @override
  String get photoHelp => 'पत्ते की फ़ोटो से सही दवा पहचानना आसान होता है।';

  @override
  String get stepDose => 'हर बार कितनी?';

  @override
  String get decrease => 'कम करें';

  @override
  String get increase => 'बढ़ाएँ';

  @override
  String get unitLabel => 'प्रकार';

  @override
  String get stepTimes => 'कब लेनी है?';

  @override
  String get addTime => 'समय जोड़ें';

  @override
  String removeTime(String time) {
    return '$time हटाएँ';
  }

  @override
  String get timesRequired => 'कम से कम एक समय चुनें।';

  @override
  String get stepFood => 'खाने से पहले या बाद में?';

  @override
  String get stepDays => 'किन दिनों में?';

  @override
  String get startDate => 'पहला दिन';

  @override
  String get lastDay => 'आखिरी दिन';

  @override
  String get noEndDate => 'चलती रहे';

  @override
  String get pickEndDate => 'किसी तारीख को बंद करें';

  @override
  String get everyDayLabel => 'हर दिन';

  @override
  String get someDaysLabel => 'सिर्फ़ कुछ दिन';

  @override
  String get daysRequired => 'कम से कम एक दिन चुनें।';

  @override
  String get endBeforeStart => 'आखिरी दिन पहले दिन से पहले नहीं हो सकता।';

  @override
  String get stepStock => 'गोलियाँ गिनें?';

  @override
  String get stockHelp =>
      'हर खुराक के बाद ऐप गिनती घटाता है और खत्म होने से पहले बता देता है।';

  @override
  String get dontCount => 'न गिनें';

  @override
  String get countThem => 'गिनें';

  @override
  String get stockInHand => 'अभी कितनी हैं?';

  @override
  String warnDaysBefore(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days दिन',
      one: '1 दिन',
    );
    return 'खत्म होने से $_temp0 पहले बताएँ';
  }

  @override
  String get stepReview => 'जाँचें और सेव करें';

  @override
  String get reviewTimes => 'समय';

  @override
  String get reviewDays => 'दिन';

  @override
  String get reviewStock => 'गिनती';

  @override
  String get notCounted => 'गिनती नहीं';

  @override
  String get settingsLanguage => 'भाषा';

  @override
  String get settingsSpeak => 'रिमाइंडर बोलकर सुनाएँ';

  @override
  String get settingsSpeakHelp =>
      'अलार्म बजने पर दवा का नाम और खाने से पहले या बाद, यह पढ़कर सुनाता है।';

  @override
  String get testVoice => 'जाँच के लिए सुनाएँ';

  @override
  String get voiceMissing =>
      'इस फ़ोन में अभी इस भाषा की आवाज़ नहीं है, इसलिए रिमाइंडर अंग्रेज़ी में सुनाए जाएँगे। Android की टेक्स्ट-टू-स्पीच सेटिंग्स में आवाज़ जोड़ सकते हैं।';

  @override
  String get settingsMissedAfter => 'कितनी देर बाद खुराक छूटी हुई मानें';

  @override
  String minutesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count मिनट',
      one: '1 मिनट',
    );
    return '$_temp0';
  }

  @override
  String hoursCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count घंटे',
      one: '1 घंटा',
    );
    return '$_temp0';
  }

  @override
  String get settingsPermissions => 'अलार्म की अनुमतियाँ';

  @override
  String get permNotifications => 'रिमाइंडर (सूचनाएँ)';

  @override
  String get permExactAlarms => 'अलार्म और रिमाइंडर';

  @override
  String get permFullScreen => 'लॉक स्क्रीन पर अलार्म';

  @override
  String get permOn => 'चालू';

  @override
  String get permOff => 'बंद। ठीक करने के लिए दबाएँ।';

  @override
  String get settingsAbout => 'इस ऐप के बारे में';

  @override
  String get aboutPrivacy =>
      'सब कुछ इसी फ़ोन में रहता है। न अकाउंट, न इंटरनेट, न विज्ञापन, न ट्रैकिंग।';

  @override
  String get aboutDisclaimer =>
      'यह ऐप सिर्फ़ याद दिलाने के लिए है, डॉक्टरी सलाह नहीं। हमेशा डॉक्टर की बात मानें।';

  @override
  String get aboutSource => 'मुफ़्त और ओपन सोर्स (MIT लाइसेंस)।';

  @override
  String get historyTitle => 'इतिहास';

  @override
  String historySummary(int taken, int total) {
    return 'इस महीने $total में से $taken खुराक ली';
  }

  @override
  String get historyEmpty => 'इस महीने कोई खुराक नहीं।';

  @override
  String get previousMonth => 'पिछला महीना';

  @override
  String get nextMonth => 'अगला महीना';

  @override
  String get legendAllTaken => 'सब ली';

  @override
  String get legendSomeMissed => 'कुछ छूटीं या छोड़ीं';

  @override
  String get legendMissed => 'नहीं ली';

  @override
  String historyDay(String date, int taken, int missed, int skipped) {
    return '$date: $taken ली, $missed छूटीं, $skipped छोड़ीं';
  }

  @override
  String historyDayNoDoses(String date) {
    return '$date: कोई खुराक नहीं';
  }
}
