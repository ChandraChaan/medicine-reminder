// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'डेली रिमाइंडर';

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
      'रिमाइंडर के समय फ़ोन अलार्म की तरह बजता है, रिमाइंडर बड़े अक्षरों में दिखाता है और पढ़कर सुनाता है। फ़ोन लॉक होने पर भी यह काम करता है।';

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
  String get nothingToday => 'आज कोई रिमाइंडर नहीं है।';

  @override
  String get allDoneToday => 'आज के सभी रिमाइंडर पूरे हो गए। बहुत बढ़िया!';

  @override
  String get noMedicinesTitle => 'अभी कोई रिमाइंडर नहीं';

  @override
  String get noMedicinesBody =>
      'याद रखने वाली चीज़ें जोड़ें, जैसे सैर, फ़ोन कॉल या पानी पीना। हर एक में लगभग एक मिनट लगता है।';

  @override
  String get addMedicine => 'रिमाइंडर जोड़ें';

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
    return '$time बजे पूरा हुआ';
  }

  @override
  String get statusSkipped => 'छोड़ दी';

  @override
  String get statusMissed => 'नहीं ली';

  @override
  String get statusDue => 'अभी करें';

  @override
  String statusSnoozed(String time) {
    return 'फिर $time पर';
  }

  @override
  String get statusUpcoming => 'आज बाद में';

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
  String get alarmTitle => 'रिमाइंडर';

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
  String get alarmNothingDue => 'अभी कुछ भी बाकी नहीं है।';

  @override
  String get taken => 'हो गया';

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
  String speechOne(String name) {
    return '$name का समय हो गया है।';
  }

  @override
  String get speechMany => 'इन रिमाइंडर का समय हो गया है:';

  @override
  String speechItem(String name) {
    return '$name।';
  }

  @override
  String get channelAlarms => 'रिमाइंडर अलार्म';

  @override
  String get channelNotices => 'अन्य सूचनाएँ';

  @override
  String get medicinesTitle => 'रिमाइंडर';

  @override
  String get medicinesEmpty => 'अभी कोई रिमाइंडर नहीं है। पहला जोड़ें।';

  @override
  String deleteMedicineTitle(String name) {
    return '$name हटाएँ?';
  }

  @override
  String get deleteMedicineBody =>
      'इसके अलार्म और इतिहास इस फ़ोन से हटा दिए जाएँगे।';

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
  String get stepName => 'किस बात की याद दिलानी है?';

  @override
  String get nameLabel => 'रिमाइंडर का नाम';

  @override
  String get nameHint => 'उदाहरण: शाम की सैर';

  @override
  String get sampleMedicine => 'शाम की सैर';

  @override
  String get nameRequired => 'कृपया नाम लिखें।';

  @override
  String get takePhoto => 'फ़ोटो खींचें';

  @override
  String get choosePhoto => 'फ़ोटो चुनें';

  @override
  String get removePhoto => 'फ़ोटो हटाएँ';

  @override
  String get photoHelp => 'फ़ोटो से रिमाइंडर पहचानना आसान होता है।';

  @override
  String get stepTimes => 'यह कब बजना चाहिए?';

  @override
  String get addTime => 'समय जोड़ें';

  @override
  String removeTime(String time) {
    return '$time हटाएँ';
  }

  @override
  String get timesRequired => 'कम से कम एक समय चुनें।';

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
  String get stepReview => 'जाँचें और सेव करें';

  @override
  String get reviewTimes => 'समय';

  @override
  String get reviewDays => 'दिन';

  @override
  String get settingsLanguage => 'भाषा';

  @override
  String get settingsSpeak => 'रिमाइंडर बोलकर सुनाएँ';

  @override
  String get settingsSpeakHelp =>
      'अलार्म बजने पर रिमाइंडर का नाम पढ़कर सुनाता है।';

  @override
  String get testVoice => 'जाँच के लिए सुनाएँ';

  @override
  String get voiceMissing =>
      'इस फ़ोन में अभी इस भाषा की आवाज़ नहीं है, इसलिए रिमाइंडर अंग्रेज़ी में सुनाए जाएँगे। Android की टेक्स्ट-टू-स्पीच सेटिंग्स में आवाज़ जोड़ सकते हैं।';

  @override
  String get settingsMissedAfter => 'रिमाइंडर को इतने समय बाद छूटा हुआ मानें';

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
  String get aboutSource => 'मुफ़्त और ओपन सोर्स (MIT लाइसेंस)।';

  @override
  String get historyTitle => 'इतिहास';

  @override
  String historySummary(int taken, int total) {
    return 'इस महीने $total में से $taken रिमाइंडर पूरे हुए';
  }

  @override
  String get historyEmpty => 'इस महीने कोई रिमाइंडर नहीं।';

  @override
  String get previousMonth => 'पिछला महीना';

  @override
  String get nextMonth => 'अगला महीना';

  @override
  String get legendAllTaken => 'सब पूरे';

  @override
  String get legendSomeMissed => 'कुछ छूटीं या छोड़ीं';

  @override
  String get legendMissed => 'नहीं ली';

  @override
  String historyDay(String date, int taken, int missed, int skipped) {
    return '$date: $taken पूरे, $missed छूटे, $skipped छोड़े';
  }

  @override
  String historyDayNoDoses(String date) {
    return '$date: कोई रिमाइंडर नहीं';
  }

  @override
  String get familyCheckTitle => 'परिवार को सूचना';

  @override
  String get familyCheckIntro =>
      'अगर कोई रिमाइंडर तय समय में \"हो गया\" नहीं किया गया, तो यह फ़ोन परिवार के एक या दो लोगों को बता सकता है। जब तक आप इसे यहाँ चालू नहीं करते, यह बंद रहता है।';

  @override
  String get familyCheckEnable =>
      'छूटे हुए रिमाइंडर के बारे में परिवार को बताएँ';

  @override
  String get familyPersonLabel => 'परिवार इन्हें क्या कहकर बुलाता है?';

  @override
  String get familyPersonHint => 'जैसे: माँ';

  @override
  String familyNumberLabel(int index) {
    return 'परिवार का फ़ोन नंबर $index';
  }

  @override
  String get familyNumberHint => '+91 98765 43210';

  @override
  String get familyNumberInvalid => 'यह फ़ोन नंबर जैसा नहीं लगता।';

  @override
  String get familyHowTitle => 'कैसे बताया जाए?';

  @override
  String get familyChannelSms => 'इस फ़ोन से SMS (अपने आप)';

  @override
  String get familyChannelSmsHelp =>
      'यह फ़ोन खुद भेजता है। सामान्य SMS शुल्क लगेगा।';

  @override
  String get familyChannelSmsManual => 'SMS (किसी को Send दबाना होगा)';

  @override
  String get familyChannelSmsManualHelp =>
      'इस फ़ोन पर एक सूचना आएगी जो तैयार संदेश के साथ SMS ऐप खोलती है। जब तक कोई Send न दबाए, कुछ नहीं भेजा जाता। सामान्य SMS शुल्क लगेगा।';

  @override
  String get familyChannelWhatsapp => 'WhatsApp (किसी को Send दबाना होगा)';

  @override
  String get familyChannelWhatsappHelp =>
      'इस फ़ोन पर एक सूचना आएगी जो तैयार संदेश के साथ WhatsApp खोलती है। जब तक कोई Send न दबाए, कुछ नहीं भेजा जाता।';

  @override
  String get familySmsConsent =>
      'मैं सहमत हूँ कि रिमाइंडर छूटने पर यह फ़ोन इन नंबरों पर SMS भेज सकता है।';

  @override
  String get familySmsPermission => 'SMS भेजने की अनुमति दें';

  @override
  String get familySmsPermissionMissing =>
      'SMS की अनुमति बंद है। अनुमति मिलने तक, तैयार संदेश के साथ SMS ऐप खोलने वाली सूचना दिखेगी।';

  @override
  String get familySendTest => 'जाँच संदेश भेजें';

  @override
  String get familyTestSent => 'जाँच संदेश भेज दिया गया।';

  @override
  String get familyTestFailed => 'संदेश नहीं भेजा जा सका। नंबर और SIM जाँचें।';

  @override
  String get familyMessagePreview => 'संदेश ऐसा दिखेगा';

  @override
  String familyMessage(String person, String medicines, String time) {
    return 'डेली रिमाइंडर: $person ने $medicines ($time बजे) पूरा नहीं किया है। कृपया उनका हाल पूछ लें।';
  }

  @override
  String familyTestMessage(String person) {
    return 'डेली रिमाइंडर: यह एक टेस्ट है। अगर $person कोई रिमाइंडर छोड़ देते हैं, तो आपको ऐसा संदेश मिलेगा।';
  }

  @override
  String get familyPersonFallback => 'आपके परिवार के सदस्य';

  @override
  String get familyNotifySentTitle => 'परिवार को बता दिया गया';

  @override
  String get familyNotifySentBody =>
      'छूटे हुए रिमाइंडर के बारे में आपके परिवार को SMS भेजा गया।';

  @override
  String get familyNotifyShareTitle => 'परिवार को बताएँ';

  @override
  String get familyNotifyShareBody =>
      'एक रिमाइंडर छूट गया। संदेश भेजने के लिए टैप करें।';

  @override
  String get familyNeedsNumber => 'कम से कम एक फ़ोन नंबर जोड़ें।';

  @override
  String get familyNeedsConsent => 'SMS के लिए सहमति पर टिक करें।';

  @override
  String get familyStatusOn => 'चालू';

  @override
  String get familyStatusOff => 'बंद';
}
