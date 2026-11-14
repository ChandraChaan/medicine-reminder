// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'वॉयस साथी';

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
  String get onboardingTitle => 'सुनने और याद दिलाने वाला फ़ोन साथी';

  @override
  String get onboardingBody =>
      'एक बड़ा बटन दबाकर बोलिए: परिवार को कॉल, समय पूछना, मदद माँगना। रिमाइंडर अलार्म की तरह बजते हैं और पढ़कर सुनाए जाते हैं, फ़ोन लॉक होने पर भी।';

  @override
  String get onboardingPrivacy =>
      'सब कुछ इसी फ़ोन में रहता है। न अकाउंट, न विज्ञापन। सुनने के लिए फ़ोन की अपनी बोली पहचान इस्तेमाल होती है; ऑनलाइन सुनना तब तक बंद रहता है जब तक आप चालू न करें।';

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
    return 'वॉयस साथी: $person ने $medicines ($time बजे) पूरा नहीं किया है। कृपया उनका हाल पूछ लें।';
  }

  @override
  String familyTestMessage(String person) {
    return 'वॉयस साथी: यह एक टेस्ट है। अगर $person कोई रिमाइंडर छोड़ देते हैं, तो आपको ऐसा संदेश मिलेगा।';
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

  @override
  String get speakButton => 'दबाकर बोलिए';

  @override
  String get listening => 'सुन रहे हैं…';

  @override
  String get tapToStop => 'रोकने के लिए फिर दबाइए';

  @override
  String get thinking => 'एक पल…';

  @override
  String youSaid(String text) {
    return 'आपने कहा: “$text”';
  }

  @override
  String get familyHeading => 'कॉल करने के लिए फ़ोटो दबाइए';

  @override
  String get helpButton => 'मदद';

  @override
  String get helpButtonHint => 'मदद के लिए परिवार को कॉल करता है';

  @override
  String get holdToOpen => 'खोलने के लिए दबाकर रखिए';

  @override
  String get noContactsYet =>
      'अभी परिवार का कोई नंबर नहीं है। परिवार से सेटअप खोलने को कहिए।';

  @override
  String callName(String name) {
    return '$name को कॉल करें';
  }

  @override
  String helpNextTitle(String name) {
    return 'क्या $name ने फ़ोन उठाया?';
  }

  @override
  String get helpFine => 'हाँ, मैं ठीक हूँ';

  @override
  String get spokenPartMorning => 'सुबह';

  @override
  String get spokenPartAfternoon => 'दोपहर';

  @override
  String get spokenPartEvening => 'शाम';

  @override
  String get spokenPartNight => 'रात';

  @override
  String sayCalling(String name) {
    return '$name को फ़ोन लगा रहे हैं।';
  }

  @override
  String sayDialer(String name) {
    return '$name को कॉल करने के लिए हरा बटन दबाइए।';
  }

  @override
  String sayCallFailed(String name) {
    return '$name को फ़ोन नहीं लग पाया। कृपया फिर से कोशिश कीजिए।';
  }

  @override
  String sayCallingForHelp(String name) {
    return 'मदद के लिए $name को फ़ोन लगा रहे हैं।';
  }

  @override
  String sayHelpNext(String name, String next) {
    return 'अगर $name ने फ़ोन नहीं उठाया, तो $next को कॉल करने के लिए लाल मदद बटन दबाइए।';
  }

  @override
  String get sayNoHelpContacts =>
      'मदद के लिए अभी कोई नंबर नहीं रखा है। कृपया परिवार से सेट करने को कहिए।';

  @override
  String get sayWhom => 'किसे फ़ोन करें? नाम बोलिए, या फ़ोटो दबाइए।';

  @override
  String sayTime(String clock, String part) {
    return 'अभी $part के $clock बजे हैं।';
  }

  @override
  String sayDate(String weekday, String date) {
    return 'आज $weekday है, $date।';
  }

  @override
  String sayBattery(int percent) {
    return 'बैटरी $percent प्रतिशत है।';
  }

  @override
  String get sayCharging => 'चार्ज हो रही है।';

  @override
  String get sayChargeSoon => 'कृपया फ़ोन को चार्ज पर लगाइए।';

  @override
  String get sayBatteryUnknown => 'बैटरी नहीं देख पाए।';

  @override
  String get sayTorchOn => 'लाइट जला दी है।';

  @override
  String get sayTorchOff => 'लाइट बंद कर दी है।';

  @override
  String get sayNoTorch => 'इस फ़ोन में ऐसी लाइट नहीं है जिसे मैं जला सकूँ।';

  @override
  String get sayNotUnderstood =>
      'माफ़ कीजिए, समझ नहीं आया। बटन दबाकर फिर से बोलिए, या कॉल करने के लिए फ़ोटो दबाइए।';

  @override
  String get sayHeardNothing => 'कुछ सुनाई नहीं दिया। बटन दबाकर बोलिए।';

  @override
  String get sayVoiceNotReady =>
      'इस फ़ोन पर सुनना अभी तैयार नहीं है। परिवार से सेटअप खोलने को कहिए। फ़ोटो दबाकर कॉल कर सकते हैं।';

  @override
  String get sayNoInternet =>
      'इस फ़ोन पर आपकी बात समझने के लिए इंटरनेट चाहिए। फिर से कोशिश कीजिए, या फ़ोटो दबाकर कॉल कीजिए।';

  @override
  String get sayMicDenied =>
      'सुनने के लिए माइक्रोफ़ोन की अनुमति चाहिए। परिवार से सेटअप में अनुमति देने को कहिए।';

  @override
  String get sayTryAgain => 'कुछ गड़बड़ हो गई। कृपया फिर से बटन दबाइए।';

  @override
  String get setupIntro =>
      'अपने माता-पिता के लिए इसे एक बार सेट कीजिए। जिन्हें वे सबसे ज़्यादा फ़ोन करते हैं, उन्हें जोड़िए। लाल मदद बटन उन लोगों को कॉल करता है जिन पर मदद लगा है, सूची में ऊपर से।';

  @override
  String get languageHeading => 'भाषा';

  @override
  String get familyMembers => 'परिवार के लोग';

  @override
  String get addContact => 'व्यक्ति जोड़ें';

  @override
  String get reorderHint =>
      'क्रम बदलने के लिए दाईं ओर की लकीरों को पकड़कर खींचिए।';

  @override
  String get speechHeading => 'सुनना';

  @override
  String speechOffline(String language) {
    return 'इस फ़ोन पर बिना इंटरनेट के $language समझ आती है। माता-पिता जो भी बोलें, वह फ़ोन से बाहर नहीं जाता।';
  }

  @override
  String speechDownloading(String language) {
    return 'Google ऑफ़लाइन इस्तेमाल के लिए $language डाउनलोड कर रहा है। Wi-Fi पर कुछ मिनट लग सकते हैं।';
  }

  @override
  String speechDownloadable(String language) {
    return 'Google से एक बार डाउनलोड करने के बाद, बिना इंटरनेट के $language समझ आएगी।';
  }

  @override
  String speechDownload(String language) {
    return '$language डाउनलोड करें';
  }

  @override
  String get speechDownloadStarted =>
      'डाउनलोड के लिए फ़ोन जो पूछे, वह कीजिए। कुछ मिनट फ़ोन को Wi-Fi पर रखिए।';

  @override
  String get speechDownloadFailed =>
      'यह फ़ोन इसे डाउनलोड नहीं कर सकता। इसके बजाय नीचे ऑनलाइन सुनना चालू कीजिए।';

  @override
  String speechOnlineOnly(String language) {
    return 'यह फ़ोन बिना इंटरनेट के $language नहीं समझ सकता।';
  }

  @override
  String speechUnknown(String language) {
    return 'यह फ़ोन खुद बोली समझता है, पर यह नहीं बताता कि $language तैयार है या नहीं। बड़े बटन से आज़माइए।';
  }

  @override
  String get speechNone =>
      'इस फ़ोन में बोली पहचानने की सुविधा नहीं है। Google ऐप इंस्टॉल या अपडेट कीजिए, या फ़ोटो से कॉल कीजिए।';

  @override
  String get allowOnline => 'ऑनलाइन सुनने की अनुमति दें';

  @override
  String get allowOnlineDetail =>
      'फ़ोन की Google बोली सेवा इस्तेमाल करता है, जो माता-पिता की बात को अक्षरों में बदलने के लिए Google को भेजती है। सिर्फ़ तब, जब फ़ोन खुद न कर सके।';

  @override
  String get voiceHeading => 'आवाज़';

  @override
  String get hearSample => 'नमूना सुनिए';

  @override
  String get voiceSample => 'नमस्ते। बड़ा बटन दबाकर मुझसे बात कीजिए।';

  @override
  String noVoice(String language) {
    return 'इस फ़ोन में $language आवाज़ नहीं है, इसलिए जवाब किसी और भाषा में पढ़े जा सकते हैं। फ़ोन की सेटिंग में Text-to-speech के अंदर इंस्टॉल कीजिए।';
  }

  @override
  String get permissionsHeading => 'अनुमतियाँ';

  @override
  String get micPermission => 'माइक्रोफ़ोन, सुनने के लिए';

  @override
  String get phonePermission => 'फ़ोन, सीधे कॉल करने के लिए';

  @override
  String get phonePermissionDetail =>
      'इसके बिना डायलर खुलेगा और माता-पिता को हरा बटन दबाना होगा।';

  @override
  String get allowed => 'अनुमति है';

  @override
  String get allow => 'अनुमति दें';

  @override
  String get done => 'हो गया';

  @override
  String get newContact => 'नया व्यक्ति';

  @override
  String editContact(String name) {
    return '$name बदलें';
  }

  @override
  String get contactNameLabel => 'फ़ोटो के नीचे दिखने वाला नाम';

  @override
  String get phoneLabel => 'फ़ोन नंबर';

  @override
  String get contactNameRequired => 'नाम लिखिए';

  @override
  String get phoneRequired => 'फ़ोन नंबर लिखिए';

  @override
  String photoOf(String name) {
    return '$name की फ़ोटो';
  }

  @override
  String get nicknamesHeading => 'माता-पिता जिन दूसरे नामों से बुलाते हैं';

  @override
  String get nicknamesHint =>
      'जैसे “बेटा”, “मुन्ना” या “పెద్ద అబ్బాయి”। बोलिए दबाकर नाम वैसे ही बोलिए जैसे माता-पिता बोलते हैं, ताकि फ़ोन सीख ले कि वह नाम कैसे सुनता है।';

  @override
  String get nicknameField => 'नाम लिखिए';

  @override
  String get addNickname => 'जोड़ें';

  @override
  String get sayIt => 'बोलिए';

  @override
  String heardNickname(String text) {
    return '“$text” सुना। जोड़ दिया।';
  }

  @override
  String get heardNicknameNothing => 'सुनाई नहीं दिया। फिर से कोशिश कीजिए।';

  @override
  String removeNickname(String name) {
    return '$name हटाएँ';
  }

  @override
  String get forHelpTitle => 'मदद के लिए कॉल करें';

  @override
  String get forHelpDetail => 'लाल मदद बटन इस व्यक्ति को कॉल करेगा।';

  @override
  String deleteConfirm(String name) {
    return '$name को हटाएँ?';
  }

  @override
  String get welcomeBody =>
      'फ़ोन का एक साथी जिससे माता-पिता बात कर सकते हैं। एक बड़ा बटन दबाकर बोलिए: परिवार को कॉल, समय या दिन पूछना, लाइट जलाना, या मदद माँगना।';

  @override
  String get chooseLanguage => 'भाषा चुनिए';

  @override
  String get privacyNote =>
      'सब कुछ इसी फ़ोन पर रहता है। कोई खाता नहीं, कोई विज्ञापन नहीं, कोई ट्रैकिंग नहीं।';

  @override
  String get continueButton => 'आगे बढ़ें';

  @override
  String get todaysReminders => 'आज के रिमाइंडर';

  @override
  String remindersLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'आज $count बाकी हैं',
      one: 'आज 1 बाकी है',
    );
    return '$_temp0';
  }

  @override
  String get remindersAllDone => 'आज के लिए कुछ बाकी नहीं';

  @override
  String get remindersNone => 'कोई रिमाइंडर नहीं रखा';

  @override
  String sayRemindersLeft(String items) {
    return 'आज अभी बाकी है: $items।';
  }

  @override
  String sayReminderItem(String name, String time) {
    return '$time पर $name';
  }

  @override
  String get sayNoRemindersLeft => 'आज के लिए कुछ बाकी नहीं है।';

  @override
  String get sayNoReminders =>
      'अभी कोई रिमाइंडर नहीं रखा है। कृपया परिवार से जोड़ने को कहिए।';

  @override
  String get setupReminders => 'रिमाइंडर';

  @override
  String get setupRemindersDetail =>
      'अलार्म की तरह बजने वाले रोज़ के रिमाइंडर, और छूटने पर परिवार को सूचना।';

  @override
  String get setupEditReminders => 'रिमाइंडर और समय';

  @override
  String get setupReminderSettings => 'रिमाइंडर सेटिंग्स और परिवार को सूचना';
}
