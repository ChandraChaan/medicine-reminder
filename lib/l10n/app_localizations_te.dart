// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Telugu (`te`).
class AppLocalizationsTe extends AppLocalizations {
  AppLocalizationsTe([String locale = 'te']) : super(locale);

  @override
  String get appTitle => 'డైలీ రిమైండర్';

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
      'రిమైండర్ సమయానికి ఫోన్ అలారంలా మోగుతుంది, రిమైండర్‌ను పెద్ద అక్షరాలతో చూపించి చదివి వినిపిస్తుంది. ఫోన్ లాక్ అయి ఉన్నా పనిచేస్తుంది.';

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
  String get nothingToday => 'ఈ రోజు రిమైండర్లు లేవు.';

  @override
  String get allDoneToday => 'ఈ రోజు రిమైండర్లన్నీ పూర్తయ్యాయి. చాలా బాగుంది!';

  @override
  String get noMedicinesTitle => 'ఇంకా రిమైండర్లు లేవు';

  @override
  String get noMedicinesBody =>
      'గుర్తుంచుకోవాల్సినవి జోడించండి, ఉదాహరణకు నడక, ఫోన్ కాల్ లేదా నీళ్లు తాగడం. ఒక్కోదానికి దాదాపు ఒక నిమిషం పడుతుంది.';

  @override
  String get addMedicine => 'రిమైండర్ జోడించండి';

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
    return '$timeకి పూర్తయింది';
  }

  @override
  String get statusSkipped => 'వదిలేశారు';

  @override
  String get statusMissed => 'వేసుకోలేదు';

  @override
  String get statusDue => 'ఇప్పుడు చేయండి';

  @override
  String statusSnoozed(String time) {
    return 'మళ్లీ $timeకి';
  }

  @override
  String get statusUpcoming => 'ఈ రోజు తర్వాత';

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
  String get alarmTitle => 'రిమైండర్';

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
  String get alarmNothingDue => 'ఇప్పుడు ఏదీ మిగిలి లేదు.';

  @override
  String get taken => 'అయిపోయింది';

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
  String speechOne(String name) {
    return '$name సమయం అయింది.';
  }

  @override
  String get speechMany => 'ఈ రిమైండర్ల సమయం అయింది:';

  @override
  String speechItem(String name) {
    return '$name.';
  }

  @override
  String get channelAlarms => 'రిమైండర్ అలారాలు';

  @override
  String get channelNotices => 'ఇతర సూచనలు';

  @override
  String get medicinesTitle => 'రిమైండర్లు';

  @override
  String get medicinesEmpty => 'ఇంకా రిమైండర్లు లేవు. మొదటిది జోడించండి.';

  @override
  String deleteMedicineTitle(String name) {
    return '$name తొలగించాలా?';
  }

  @override
  String get deleteMedicineBody =>
      'దీని అలారాలు, చరిత్ర ఈ ఫోన్ నుండి తీసివేయబడతాయి.';

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
  String get stepName => 'దేని గురించి గుర్తు చేయాలి?';

  @override
  String get nameLabel => 'రిమైండర్ పేరు';

  @override
  String get nameHint => 'ఉదాహరణకు: సాయంత్రం నడక';

  @override
  String get sampleMedicine => 'సాయంత్రం నడక';

  @override
  String get nameRequired => 'దయచేసి పేరు టైప్ చేయండి.';

  @override
  String get takePhoto => 'ఫోటో తీయండి';

  @override
  String get choosePhoto => 'ఫోటో ఎంచుకోండి';

  @override
  String get removePhoto => 'ఫోటో తీసేయండి';

  @override
  String get photoHelp => 'ఫోటో ఉంటే రిమైండర్‌ను సులభంగా గుర్తుపట్టవచ్చు.';

  @override
  String get stepTimes => 'ఇది ఎప్పుడు మోగాలి?';

  @override
  String get addTime => 'సమయం చేర్చండి';

  @override
  String removeTime(String time) {
    return '$time తీసేయండి';
  }

  @override
  String get timesRequired => 'కనీసం ఒక సమయం ఎంచుకోండి.';

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
  String get stepReview => 'చూసి సేవ్ చేయండి';

  @override
  String get reviewTimes => 'సమయాలు';

  @override
  String get reviewDays => 'రోజులు';

  @override
  String get settingsLanguage => 'భాష';

  @override
  String get settingsSpeak => 'రిమైండర్‌ను చదివి వినిపించండి';

  @override
  String get settingsSpeakHelp =>
      'అలారం మోగినప్పుడు రిమైండర్ పేరును చదివి వినిపిస్తుంది.';

  @override
  String get testVoice => 'పరీక్షగా వినిపించండి';

  @override
  String get voiceMissing =>
      'ఈ ఫోన్‌లో ఈ భాషకు ఇంకా వాయిస్ లేదు, అందుకే రిమైండర్లు ఇంగ్లీషులో వినిపిస్తాయి. Android టెక్స్ట్-టు-స్పీచ్ సెట్టింగ్‌లలో వాయిస్‌ను చేర్చుకోవచ్చు.';

  @override
  String get settingsMissedAfter =>
      'ఇంత సమయం తర్వాత రిమైండర్‌ను మిస్ అయినట్లు లెక్కించండి';

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
  String get aboutSource => 'ఉచితం, ఓపెన్ సోర్స్ (MIT లైసెన్స్).';

  @override
  String get historyTitle => 'చరిత్ర';

  @override
  String historySummary(int taken, int total) {
    return 'ఈ నెల $totalలో $taken రిమైండర్లు పూర్తయ్యాయి';
  }

  @override
  String get historyEmpty => 'ఈ నెల రిమైండర్లు లేవు.';

  @override
  String get previousMonth => 'గత నెల';

  @override
  String get nextMonth => 'తర్వాతి నెల';

  @override
  String get legendAllTaken => 'అన్నీ పూర్తి';

  @override
  String get legendSomeMissed => 'కొన్ని మిస్ లేదా వదిలేశారు';

  @override
  String get legendMissed => 'వేసుకోలేదు';

  @override
  String historyDay(String date, int taken, int missed, int skipped) {
    return '$date: $taken పూర్తి, $missed మిస్, $skipped వదిలేశారు';
  }

  @override
  String historyDayNoDoses(String date) {
    return '$date: రిమైండర్లు లేవు';
  }

  @override
  String get familyCheckTitle => 'కుటుంబానికి తెలియజేయడం';

  @override
  String get familyCheckIntro =>
      'మిస్ అయ్యే సమయంలోపు రిమైండర్‌ను \"అయిపోయింది\" అని గుర్తించకపోతే, ఈ ఫోన్ కుటుంబంలో ఒకరిద్దరికి తెలియజేయగలదు. మీరు ఇక్కడ ఆన్ చేసే వరకు ఇది ఆఫ్‌లోనే ఉంటుంది.';

  @override
  String get familyCheckEnable =>
      'మిస్ అయిన రిమైండర్ల గురించి కుటుంబానికి చెప్పండి';

  @override
  String get familyPersonLabel => 'కుటుంబంలో వీరిని ఏమని పిలుస్తారు?';

  @override
  String get familyPersonHint => 'ఉదాహరణ: అమ్మ';

  @override
  String familyNumberLabel(int index) {
    return 'కుటుంబ సభ్యుల ఫోన్ నంబర్ $index';
  }

  @override
  String get familyNumberHint => '+91 98765 43210';

  @override
  String get familyNumberInvalid => 'ఇది ఫోన్ నంబర్‌లా లేదు.';

  @override
  String get familyHowTitle => 'ఎలా తెలియజేయాలి?';

  @override
  String get familyChannelSms => 'ఈ ఫోన్ నుంచి SMS (ఆటోమేటిక్‌గా)';

  @override
  String get familyChannelSmsHelp =>
      'ఈ ఫోనే స్వయంగా పంపుతుంది. మామూలు SMS ఛార్జీలు వర్తిస్తాయి.';

  @override
  String get familyChannelSmsManual => 'SMS (ఎవరైనా Send నొక్కాలి)';

  @override
  String get familyChannelSmsManualHelp =>
      'ఈ ఫోన్‌లో ఒక నోటిఫికేషన్ వస్తుంది, అది సందేశం సిద్ధంగా ఉన్న SMS యాప్‌ను తెరుస్తుంది. ఎవరైనా Send నొక్కే వరకు ఏదీ పంపబడదు. మామూలు SMS ఛార్జీలు వర్తిస్తాయి.';

  @override
  String get familyChannelWhatsapp => 'WhatsApp (ఎవరైనా Send నొక్కాలి)';

  @override
  String get familyChannelWhatsappHelp =>
      'ఈ ఫోన్‌లో ఒక నోటిఫికేషన్ వస్తుంది, అది సందేశం సిద్ధంగా ఉన్న WhatsAppను తెరుస్తుంది. ఎవరైనా Send నొక్కే వరకు ఏదీ పంపబడదు.';

  @override
  String get familySmsConsent =>
      'రిమైండర్ మిస్ అయినప్పుడు ఈ ఫోన్ ఈ నంబర్లకు SMS పంపవచ్చని నేను అంగీకరిస్తున్నాను.';

  @override
  String get familySmsPermission => 'SMS పంపడానికి అనుమతించండి';

  @override
  String get familySmsPermissionMissing =>
      'SMS అనుమతి ఆఫ్‌లో ఉంది. అనుమతించే వరకు, సందేశం సిద్ధంగా ఉన్న SMS యాప్‌ను తెరిచే నోటిఫికేషన్ వస్తుంది.';

  @override
  String get familySendTest => 'పరీక్ష సందేశం పంపండి';

  @override
  String get familyTestSent => 'పరీక్ష సందేశం పంపబడింది.';

  @override
  String get familyTestFailed => 'సందేశం పంపలేకపోయాం. నంబర్‌ను, SIMను చూడండి.';

  @override
  String get familyMessagePreview => 'సందేశం ఇలా ఉంటుంది';

  @override
  String familyMessage(String person, String medicines, String time) {
    return 'డైలీ రిమైండర్: $person గారు $medicines ($timeకి) పూర్తి చేసినట్లు గుర్తించలేదు. దయచేసి ఒకసారి వారిని అడగండి.';
  }

  @override
  String familyTestMessage(String person) {
    return 'డైలీ రిమైండర్: ఇది టెస్ట్ మాత్రమే. $person గారు ఏదైనా రిమైండర్ మిస్ అయితే మీకు ఇలాంటి మెసేజ్ వస్తుంది.';
  }

  @override
  String get familyPersonFallback => 'మీ కుటుంబ సభ్యులు';

  @override
  String get familyNotifySentTitle => 'కుటుంబానికి తెలియజేశాం';

  @override
  String get familyNotifySentBody =>
      'మిస్ అయిన రిమైండర్ గురించి మీ కుటుంబానికి SMS పంపబడింది.';

  @override
  String get familyNotifyShareTitle => 'కుటుంబానికి చెప్పండి';

  @override
  String get familyNotifyShareBody =>
      'ఒక రిమైండర్ మిస్ అయింది. మెసేజ్ పంపడానికి నొక్కండి.';

  @override
  String get familyNeedsNumber => 'కనీసం ఒక ఫోన్ నంబర్ చేర్చండి.';

  @override
  String get familyNeedsConsent => 'SMS కోసం అంగీకారాన్ని టిక్ చేయండి.';

  @override
  String get familyStatusOn => 'ఆన్';

  @override
  String get familyStatusOff => 'ఆఫ్';
}
