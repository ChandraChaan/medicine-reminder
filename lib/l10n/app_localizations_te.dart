// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Telugu (`te`).
class AppLocalizationsTe extends AppLocalizations {
  AppLocalizationsTe([String locale = 'te']) : super(locale);

  @override
  String get appTitle => 'మందుల రిమైండర్';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageTelugu => 'తెలుగు';

  @override
  String get languageHindi => 'हिन्दी';

  @override
  String get next => 'తర్వాత';

  @override
  String get back => 'వెనక్కి';

  @override
  String get save => 'సేవ్ చేయండి';

  @override
  String get cancel => 'రద్దు చేయండి';

  @override
  String get close => 'మూసివేయండి';

  @override
  String get delete => 'తొలగించండి';

  @override
  String get edit => 'మార్చండి';

  @override
  String get undo => 'వెనక్కి తీసుకోండి';

  @override
  String get retry => 'మళ్లీ ప్రయత్నించండి';

  @override
  String get errorGeneric =>
      'ఏదో పొరపాటు జరిగింది. దయచేసి మళ్లీ ప్రయత్నించండి.';

  @override
  String get chooseLanguageTitle => 'భాషను ఎంచుకోండి';

  @override
  String get onboardingTitle => 'అలారంలా మోగే రిమైండర్లు';

  @override
  String get onboardingBody =>
      'మందు వేసుకునే సమయానికి ఫోన్ మోగుతుంది, మందు పేరును పెద్ద అక్షరాలలో చూపించి చదివి వినిపిస్తుంది. ఫోన్ లాక్‌లో ఉన్నా పనిచేస్తుంది.';

  @override
  String get onboardingPrivacy =>
      'అన్నీ ఈ ఫోన్‌లోనే ఉంటాయి. అకౌంట్ లేదు, ఇంటర్నెట్ లేదు, ప్రకటనలు లేవు.';

  @override
  String get allowReminders => 'రిమైండర్లను అనుమతించండి';

  @override
  String get onboardingStart => 'ప్రారంభించండి';

  @override
  String get todayTitle => 'ఈ రోజు';

  @override
  String get nothingToday => 'ఈ రోజు మందులు లేవు.';

  @override
  String get allDoneToday => 'ఈ రోజు మందులన్నీ పూర్తయ్యాయి. చాలా బాగుంది!';

  @override
  String get noMedicinesTitle => 'ఇంకా మందులు లేవు';

  @override
  String get noMedicinesBody =>
      'మందులను చేర్చమని కుటుంబ సభ్యులను అడగండి. ఒక్కో మందుకు సుమారు ఒక నిమిషం పడుతుంది.';

  @override
  String get addMedicine => 'మందు చేర్చండి';

  @override
  String get history => 'చరిత్ర';

  @override
  String get familySetup => 'కుటుంబ సెటప్';

  @override
  String get settings => 'సెట్టింగ్‌లు';

  @override
  String get partMorning => 'ఉదయం';

  @override
  String get partAfternoon => 'మధ్యాహ్నం';

  @override
  String get partEvening => 'సాయంత్రం';

  @override
  String get partNight => 'రాత్రి';

  @override
  String statusTaken(String time) {
    return '$timeకి వేసుకున్నారు';
  }

  @override
  String get statusSkipped => 'వదిలేశారు';

  @override
  String get statusMissed => 'వేసుకోలేదు';

  @override
  String get statusDue => 'ఇప్పుడు వేసుకోండి';

  @override
  String statusSnoozed(String time) {
    return 'మళ్లీ $timeకి';
  }

  @override
  String get statusUpcoming => 'ఈ రోజు తర్వాత';

  @override
  String refillDaysLeft(String name, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'ఇంకా $days రోజులకే సరిపోతుంది',
      one: 'ఇంకా 1 రోజుకే సరిపోతుంది',
    );
    return '$name: $_temp0. త్వరగా కొనండి.';
  }

  @override
  String refillRunOut(String name) {
    return '$name అయిపోయింది. ఈ రోజే కొనండి.';
  }

  @override
  String refillNoticeTitle(String name) {
    return '$name కొనాల్సిన సమయం';
  }

  @override
  String get bannerNotifications => 'రిమైండర్లు ఆఫ్‌లో ఉన్నాయి, అందుకే మోగవు.';

  @override
  String get bannerExactAlarms =>
      'అలారాలు ఆలస్యంగా మోగవచ్చు. \"అలారాలు & రిమైండర్లు\" ఆన్ చేయండి.';

  @override
  String get bannerFullScreen => 'లాక్ స్క్రీన్ మీద అలారం స్క్రీన్ తెరుచుకోదు.';

  @override
  String get fix => 'సరిచేయండి';

  @override
  String get alarmTitle => 'మందు వేసుకునే సమయం';

  @override
  String alarmCount(int index, int total) {
    return '$totalలో $index';
  }

  @override
  String alarmWasDue(String time) {
    return 'ఇది $timeకి వేసుకోవాల్సింది';
  }

  @override
  String get alarmAllDone => 'అన్నీ పూర్తయ్యాయి. చాలా బాగుంది!';

  @override
  String get alarmNothingDue => 'ఇప్పుడు వేసుకోవాల్సిన మందు లేదు.';

  @override
  String get taken => 'వేసుకున్నాను';

  @override
  String snooze(int minutes) {
    return '$minutes నిమిషాల తర్వాత';
  }

  @override
  String get skip => 'వదిలేయండి';

  @override
  String medicinePhoto(String name) {
    return '$name ఫోటో';
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
      other: 'మాత్రలు',
      one: 'మాత్ర',
    );
    return '$_temp0';
  }

  @override
  String unitCapsule(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'క్యాప్సూల్స్',
      one: 'క్యాప్సూల్',
    );
    return '$_temp0';
  }

  @override
  String get unitMl => 'మి.లీ.';

  @override
  String unitDrops(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'చుక్కలు',
      one: 'చుక్క',
    );
    return '$_temp0';
  }

  @override
  String unitPuff(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'పఫ్‌లు',
      one: 'పఫ్',
    );
    return '$_temp0';
  }

  @override
  String unitInjection(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ఇంజెక్షన్లు',
      one: 'ఇంజెక్షన్',
    );
    return '$_temp0';
  }

  @override
  String get foodBefore => 'భోజనానికి ముందు';

  @override
  String get foodAfter => 'భోజనం తర్వాత';

  @override
  String get foodWith => 'భోజనంతో పాటు';

  @override
  String get foodAny => 'ఎప్పుడైనా';

  @override
  String get foodBeforeSpoken => 'భోజనానికి ముందు';

  @override
  String get foodAfterSpoken => 'భోజనం తర్వాత';

  @override
  String get foodWithSpoken => 'భోజనంతో పాటు';

  @override
  String speechOne(String name, String food) {
    return 'మీ $name వేసుకునే సమయం అయింది, $food.';
  }

  @override
  String speechOneNoFood(String name) {
    return 'మీ $name వేసుకునే సమయం అయింది.';
  }

  @override
  String get speechMany => 'మీ మందులు వేసుకునే సమయం అయింది.';

  @override
  String speechItem(String name, String food) {
    return '$name, $food.';
  }

  @override
  String speechItemNoFood(String name) {
    return '$name.';
  }

  @override
  String get channelAlarms => 'మందుల అలారాలు';

  @override
  String get channelNotices => 'మందులు కొనాల్సిన సూచనలు';

  @override
  String get medicinesTitle => 'మందులు';

  @override
  String get medicinesEmpty => 'ఇంకా మందులు లేవు. మొదటిది చేర్చండి.';

  @override
  String deleteMedicineTitle(String name) {
    return '$name తొలగించాలా?';
  }

  @override
  String get deleteMedicineBody =>
      'దీని రిమైండర్లు, చరిత్ర ఈ ఫోన్ నుంచి తొలగిపోతాయి.';

  @override
  String get boughtMore => 'ఇంకా కొన్నాను';

  @override
  String get boughtMoreTitle => 'ఎన్ని కొన్నారు?';

  @override
  String stockLeft(String amount) {
    return '$amount మిగిలాయి';
  }

  @override
  String untilDate(String date) {
    return '$date వరకు';
  }

  @override
  String get noEndDateShort => 'చివరి రోజు లేదు';

  @override
  String stepCounter(int step, int total) {
    return '$totalలో $stepవ దశ';
  }

  @override
  String get stepName => 'మందు పేరు ఏమిటి?';

  @override
  String get nameLabel => 'మందు పేరు';

  @override
  String get nameHint => 'ఉదాహరణ: BP మాత్ర';

  @override
  String get sampleMedicine => 'BP మాత్ర';

  @override
  String get nameRequired => 'దయచేసి పేరు టైప్ చేయండి.';

  @override
  String get takePhoto => 'ఫోటో తీయండి';

  @override
  String get choosePhoto => 'ఫోటో ఎంచుకోండి';

  @override
  String get removePhoto => 'ఫోటో తీసేయండి';

  @override
  String get photoHelp => 'స్ట్రిప్ ఫోటో ఉంటే సరైన మందును గుర్తుపట్టడం సులువు.';

  @override
  String get stepDose => 'ఒక్కసారికి ఎంత?';

  @override
  String get decrease => 'తగ్గించండి';

  @override
  String get increase => 'పెంచండి';

  @override
  String get unitLabel => 'రకం';

  @override
  String get stepTimes => 'ఎప్పుడు వేసుకోవాలి?';

  @override
  String get addTime => 'సమయం చేర్చండి';

  @override
  String removeTime(String time) {
    return '$time తీసేయండి';
  }

  @override
  String get timesRequired => 'కనీసం ఒక సమయం ఎంచుకోండి.';

  @override
  String get stepFood => 'భోజనానికి ముందా, తర్వాతా?';

  @override
  String get stepDays => 'ఏ రోజుల్లో?';

  @override
  String get startDate => 'మొదటి రోజు';

  @override
  String get lastDay => 'చివరి రోజు';

  @override
  String get noEndDate => 'ఆపకుండా కొనసాగించండి';

  @override
  String get pickEndDate => 'ఒక తేదీన ఆపండి';

  @override
  String get everyDayLabel => 'ప్రతి రోజు';

  @override
  String get someDaysLabel => 'కొన్ని రోజులు మాత్రమే';

  @override
  String get daysRequired => 'కనీసం ఒక రోజు ఎంచుకోండి.';

  @override
  String get endBeforeStart => 'చివరి రోజు మొదటి రోజు కంటే ముందు ఉండకూడదు.';

  @override
  String get stepStock => 'మాత్రలను లెక్కించాలా?';

  @override
  String get stockHelp =>
      'ప్రతి డోసు తర్వాత యాప్ లెక్క తగ్గిస్తుంది, అయిపోకముందే హెచ్చరిస్తుంది.';

  @override
  String get dontCount => 'లెక్కించవద్దు';

  @override
  String get countThem => 'లెక్కించండి';

  @override
  String get stockInHand => 'ఇప్పుడు ఎన్ని ఉన్నాయి?';

  @override
  String warnDaysBefore(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days రోజులు',
      one: '1 రోజు',
    );
    return 'అయిపోవడానికి $_temp0 ముందు హెచ్చరించండి';
  }

  @override
  String get stepReview => 'చూసి సేవ్ చేయండి';

  @override
  String get reviewTimes => 'సమయాలు';

  @override
  String get reviewDays => 'రోజులు';

  @override
  String get reviewStock => 'లెక్క';

  @override
  String get notCounted => 'లెక్కించడం లేదు';

  @override
  String get settingsLanguage => 'భాష';

  @override
  String get settingsSpeak => 'రిమైండర్‌ను చదివి వినిపించండి';

  @override
  String get settingsSpeakHelp =>
      'అలారం మోగినప్పుడు మందు పేరు, భోజనానికి ముందా తర్వాతా అనేది చదివి వినిపిస్తుంది.';

  @override
  String get testVoice => 'పరీక్షగా వినిపించండి';

  @override
  String get voiceMissing =>
      'ఈ ఫోన్‌లో ఈ భాషకు ఇంకా వాయిస్ లేదు, అందుకే రిమైండర్లు ఇంగ్లీషులో వినిపిస్తాయి. Android టెక్స్ట్-టు-స్పీచ్ సెట్టింగ్‌లలో వాయిస్‌ను చేర్చుకోవచ్చు.';

  @override
  String get settingsMissedAfter => 'ఎంత సేపటికి వేసుకోకపోతే మిస్ అయినట్లు';

  @override
  String minutesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count నిమిషాలు',
      one: '1 నిమిషం',
    );
    return '$_temp0';
  }

  @override
  String hoursCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count గంటలు',
      one: '1 గంట',
    );
    return '$_temp0';
  }

  @override
  String get settingsPermissions => 'అలారం అనుమతులు';

  @override
  String get permNotifications => 'రిమైండర్లు (నోటిఫికేషన్లు)';

  @override
  String get permExactAlarms => 'అలారాలు & రిమైండర్లు';

  @override
  String get permFullScreen => 'లాక్ స్క్రీన్ మీద అలారం';

  @override
  String get permOn => 'ఆన్';

  @override
  String get permOff => 'ఆఫ్. సరిచేయడానికి నొక్కండి.';

  @override
  String get settingsAbout => 'ఈ యాప్ గురించి';

  @override
  String get aboutPrivacy =>
      'అన్నీ ఈ ఫోన్‌లోనే ఉంటాయి. అకౌంట్ లేదు, ఇంటర్నెట్ లేదు, ప్రకటనలు లేవు, ట్రాకింగ్ లేదు.';

  @override
  String get aboutDisclaimer =>
      'ఈ యాప్ గుర్తు చేయడానికి మాత్రమే, వైద్య సలహా కాదు. ఎప్పుడూ డాక్టర్ సూచనలనే పాటించండి.';

  @override
  String get aboutSource => 'ఉచితం, ఓపెన్ సోర్స్ (MIT లైసెన్స్).';

  @override
  String get historyTitle => 'చరిత్ర';

  @override
  String historySummary(int taken, int total) {
    return 'ఈ నెల $total డోసుల్లో $taken వేసుకున్నారు';
  }

  @override
  String get historyEmpty => 'ఈ నెల డోసులు లేవు.';

  @override
  String get previousMonth => 'గత నెల';

  @override
  String get nextMonth => 'తర్వాతి నెల';

  @override
  String get legendAllTaken => 'అన్నీ వేసుకున్నారు';

  @override
  String get legendSomeMissed => 'కొన్ని మిస్ లేదా వదిలేశారు';

  @override
  String get legendMissed => 'వేసుకోలేదు';

  @override
  String historyDay(String date, int taken, int missed, int skipped) {
    return '$date: $taken వేసుకున్నారు, $missed మిస్, $skipped వదిలేశారు';
  }

  @override
  String historyDayNoDoses(String date) {
    return '$date: డోసులు లేవు';
  }
}
