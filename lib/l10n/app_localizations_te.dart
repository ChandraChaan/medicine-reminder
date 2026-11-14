// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Telugu (`te`).
class AppLocalizationsTe extends AppLocalizations {
  AppLocalizationsTe([String locale = 'te']) : super(locale);

  @override
  String get appTitle => 'వాయిస్ సాథీ';

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
  String get onboardingTitle => 'వినే, గుర్తు చేసే ఫోన్ సహాయకుడు';

  @override
  String get onboardingBody =>
      'ఒక పెద్ద బటన్ నొక్కి మాట్లాడితే చాలు: కుటుంబానికి కాల్, సమయం అడగడం, సహాయం అడగడం. రిమైండర్లు అలారంలా మోగి చదివి వినిపిస్తాయి, ఫోన్ లాక్ అయి ఉన్నా.';

  @override
  String get onboardingPrivacy =>
      'అన్నీ ఈ ఫోన్‌లోనే ఉంటాయి. అకౌంట్ లేదు, ప్రకటనలు లేవు. వినడానికి ఫోన్‌లోని మాటల గుర్తింపునే వాడుతుంది; మీరు ఆన్ చేస్తే తప్ప ఆన్‌లైన్ వినడం ఆఫ్‌లోనే ఉంటుంది.';

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
    return 'వాయిస్ సాథీ: $person గారు $medicines ($timeకి) పూర్తి చేసినట్లు గుర్తించలేదు. దయచేసి ఒకసారి వారిని అడగండి.';
  }

  @override
  String familyTestMessage(String person) {
    return 'వాయిస్ సాథీ: ఇది టెస్ట్ మాత్రమే. $person గారు ఏదైనా రిమైండర్ మిస్ అయితే మీకు ఇలాంటి మెసేజ్ వస్తుంది.';
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

  @override
  String get speakButton => 'నొక్కి మాట్లాడండి';

  @override
  String get listening => 'వింటున్నాను…';

  @override
  String get tapToStop => 'ఆపడానికి మళ్ళీ నొక్కండి';

  @override
  String get thinking => 'ఒక్క నిమిషం…';

  @override
  String youSaid(String text) {
    return 'మీరు అన్నది: “$text”';
  }

  @override
  String get familyHeading => 'కాల్ చేయడానికి ఫోటో నొక్కండి';

  @override
  String get helpButton => 'సహాయం';

  @override
  String get helpButtonHint => 'సహాయం కోసం కుటుంబానికి కాల్ చేస్తుంది';

  @override
  String get holdToOpen => 'తెరవడానికి నొక్కి పట్టుకోండి';

  @override
  String get noContactsYet =>
      'ఇంకా కుటుంబ నంబర్లు లేవు. కుటుంబ సెటప్ తెరవమని మీ వాళ్ళని అడగండి.';

  @override
  String callName(String name) {
    return '$nameకి కాల్ చేయండి';
  }

  @override
  String helpNextTitle(String name) {
    return '$name ఫోన్ ఎత్తారా?';
  }

  @override
  String get helpFine => 'అవును, బాగానే ఉన్నాను';

  @override
  String get spokenPartMorning => 'ఉదయం';

  @override
  String get spokenPartAfternoon => 'మధ్యాహ్నం';

  @override
  String get spokenPartEvening => 'సాయంత్రం';

  @override
  String get spokenPartNight => 'రాత్రి';

  @override
  String sayCalling(String name) {
    return '$nameకి కాల్ చేస్తున్నాను.';
  }

  @override
  String sayDialer(String name) {
    return '$nameకి కాల్ చేయడానికి ఆకుపచ్చ బటన్ నొక్కండి.';
  }

  @override
  String sayCallFailed(String name) {
    return '$nameకి కాల్ చేయలేకపోయాను. దయచేసి మళ్ళీ ప్రయత్నించండి.';
  }

  @override
  String sayCallingForHelp(String name) {
    return 'సహాయం కోసం $nameకి కాల్ చేస్తున్నాను.';
  }

  @override
  String sayHelpNext(String name, String next) {
    return '$name ఫోన్ ఎత్తకపోతే, $nextకి కాల్ చేయడానికి ఎరుపు సహాయం బటన్ నొక్కండి.';
  }

  @override
  String get sayNoHelpContacts =>
      'సహాయం కోసం ఇంకా ఎవరినీ పెట్టలేదు. దయచేసి మీ కుటుంబాన్ని సెట్ చేయమని అడగండి.';

  @override
  String get sayWhom =>
      'ఎవరికి కాల్ చేయాలి? పేరు చెప్పండి, లేదా ఫోటో నొక్కండి.';

  @override
  String sayTime(String clock, String part) {
    return 'ఇప్పుడు సమయం $part $clock.';
  }

  @override
  String sayDate(String weekday, String date) {
    return 'ఈరోజు $weekday, $date.';
  }

  @override
  String sayBattery(int percent) {
    return 'బ్యాటరీ $percent శాతం ఉంది.';
  }

  @override
  String get sayCharging => 'ఛార్జ్ అవుతోంది.';

  @override
  String get sayChargeSoon => 'దయచేసి ఫోన్‌ను ఛార్జింగ్‌లో పెట్టండి.';

  @override
  String get sayBatteryUnknown => 'బ్యాటరీ ఎంత ఉందో చూడలేకపోయాను.';

  @override
  String get sayTorchOn => 'లైట్ వేశాను.';

  @override
  String get sayTorchOff => 'లైట్ ఆపేశాను.';

  @override
  String get sayNoTorch => 'ఈ ఫోన్‌లో నేను వేయగల లైట్ లేదు.';

  @override
  String get sayNotUnderstood =>
      'క్షమించండి, అర్థం కాలేదు. బటన్ నొక్కి మళ్ళీ చెప్పండి, లేదా కాల్ చేయడానికి ఫోటో నొక్కండి.';

  @override
  String get sayHeardNothing =>
      'నాకు ఏమీ వినిపించలేదు. బటన్ నొక్కి మాట్లాడండి.';

  @override
  String get sayVoiceNotReady =>
      'ఈ ఫోన్‌లో వినడం ఇంకా సిద్ధంగా లేదు. కుటుంబ సెటప్ తెరవమని మీ వాళ్ళని అడగండి. ఫోటో నొక్కి కాల్ చేయవచ్చు.';

  @override
  String get sayNoInternet =>
      'ఈ ఫోన్‌లో మీ మాట అర్థం చేసుకోవడానికి ఇంటర్నెట్ కావాలి. మళ్ళీ ప్రయత్నించండి, లేదా ఫోటో నొక్కి కాల్ చేయండి.';

  @override
  String get sayMicDenied =>
      'వినడానికి మైక్రోఫోన్ అనుమతి కావాలి. కుటుంబ సెటప్‌లో అనుమతించమని మీ వాళ్ళని అడగండి.';

  @override
  String get sayTryAgain => 'ఏదో పొరపాటు జరిగింది. దయచేసి మళ్ళీ బటన్ నొక్కండి.';

  @override
  String get setupIntro =>
      'మీ అమ్మానాన్నల కోసం ఒక్కసారి సెట్ చేయండి. వాళ్ళు ఎక్కువగా కాల్ చేసే వాళ్ళను చేర్చండి. ఎరుపు సహాయం బటన్, సహాయం అని గుర్తు పెట్టిన వాళ్ళకు జాబితాలో పై నుండి కాల్ చేస్తుంది.';

  @override
  String get languageHeading => 'భాష';

  @override
  String get familyMembers => 'కుటుంబ సభ్యులు';

  @override
  String get addContact => 'వ్యక్తిని చేర్చండి';

  @override
  String get reorderHint =>
      'క్రమం మార్చడానికి కుడి వైపు ఉన్న గీతలను పట్టుకుని లాగండి.';

  @override
  String get speechHeading => 'వినడం';

  @override
  String speechOffline(String language) {
    return 'ఈ ఫోన్‌లో ఇంటర్నెట్ లేకుండానే $language అర్థమవుతుంది. మీ అమ్మానాన్నలు అన్నది ఏదీ ఫోన్ దాటి వెళ్ళదు.';
  }

  @override
  String speechDownloading(String language) {
    return 'Google ఆఫ్‌లైన్ కోసం $language డౌన్‌లోడ్ చేస్తోంది. Wi-Fi లో కొన్ని నిమిషాలు పట్టవచ్చు.';
  }

  @override
  String speechDownloadable(String language) {
    return 'Google నుండి ఒక్కసారి డౌన్‌లోడ్ చేస్తే, ఇంటర్నెట్ లేకుండా $language అర్థమవుతుంది.';
  }

  @override
  String speechDownload(String language) {
    return '$language డౌన్‌లోడ్ చేయండి';
  }

  @override
  String get speechDownloadStarted =>
      'డౌన్‌లోడ్ కోసం ఫోన్ అడిగేది అనుసరించండి. కొన్ని నిమిషాలు ఫోన్‌ను Wi-Fi లో ఉంచండి.';

  @override
  String get speechDownloadFailed =>
      'ఈ ఫోన్ డౌన్‌లోడ్ చేయలేదు. బదులుగా కింద ఆన్‌లైన్ వినడం ఆన్ చేయండి.';

  @override
  String speechOnlineOnly(String language) {
    return 'ఈ ఫోన్ ఇంటర్నెట్ లేకుండా $language అర్థం చేసుకోలేదు.';
  }

  @override
  String speechUnknown(String language) {
    return 'ఈ ఫోన్ సొంతంగా మాటలు అర్థం చేసుకుంటుంది, కానీ $language సిద్ధంగా ఉందో లేదో చెప్పలేదు. పెద్ద బటన్‌తో ప్రయత్నించండి.';
  }

  @override
  String get speechNone =>
      'ఈ ఫోన్‌లో మాటలు గుర్తించే సౌకర్యం లేదు. Google యాప్ ఇన్‌స్టాల్ లేదా అప్‌డేట్ చేయండి, లేదా ఫోటోలతో కాల్ చేయండి.';

  @override
  String get allowOnline => 'ఆన్‌లైన్ వినడం అనుమతించండి';

  @override
  String get allowOnlineDetail =>
      'ఫోన్‌లోని Google మాటల సేవను వాడుతుంది. మీ అమ్మానాన్నలు అన్నది అక్షరాలుగా మార్చడానికి Google కి పంపుతుంది. ఫోన్ సొంతంగా చేయలేనప్పుడు మాత్రమే వాడుతుంది.';

  @override
  String get voiceHeading => 'గొంతు';

  @override
  String get hearSample => 'నమూనా వినండి';

  @override
  String get voiceSample => 'నమస్కారం. పెద్ద బటన్ నొక్కి నాతో మాట్లాడండి.';

  @override
  String noVoice(String language) {
    return 'ఈ ఫోన్‌లో $language గొంతు లేదు, కాబట్టి జవాబులు వేరే భాషలో చదవవచ్చు. ఫోన్ సెట్టింగ్‌లలో Text-to-speech కింద ఇన్‌స్టాల్ చేయండి.';
  }

  @override
  String get permissionsHeading => 'అనుమతులు';

  @override
  String get micPermission => 'మైక్రోఫోన్, వినడానికి';

  @override
  String get phonePermission => 'ఫోన్, వెంటనే కాల్ చేయడానికి';

  @override
  String get phonePermissionDetail =>
      'ఇది లేకపోతే డయలర్ తెరుచుకుంటుంది, మీ అమ్మానాన్నలు ఆకుపచ్చ బటన్ నొక్కాలి.';

  @override
  String get allowed => 'అనుమతి ఉంది';

  @override
  String get allow => 'అనుమతించండి';

  @override
  String get done => 'పూర్తయింది';

  @override
  String get newContact => 'కొత్త వ్యక్తి';

  @override
  String editContact(String name) {
    return '$name మార్చండి';
  }

  @override
  String get contactNameLabel => 'ఫోటో కింద చూపించే పేరు';

  @override
  String get phoneLabel => 'ఫోన్ నంబర్';

  @override
  String get contactNameRequired => 'పేరు ఇవ్వండి';

  @override
  String get phoneRequired => 'ఫోన్ నంబర్ ఇవ్వండి';

  @override
  String photoOf(String name) {
    return '$name ఫోటో';
  }

  @override
  String get nicknamesHeading => 'మీ అమ్మానాన్నలు పిలిచే ఇతర పేర్లు';

  @override
  String get nicknamesHint =>
      'ఉదాహరణకు “పెద్ద అబ్బాయి”, “బాబు” లేదా “बेटा”. చెప్పండి నొక్కి, మీ అమ్మానాన్నలు పిలిచే లాగే పేరు చెప్పండి. అప్పుడు ఫోన్ ఆ పేరు ఎలా వింటుందో నేర్చుకుంటుంది.';

  @override
  String get nicknameField => 'పేరు టైప్ చేయండి';

  @override
  String get addNickname => 'చేర్చు';

  @override
  String get sayIt => 'చెప్పండి';

  @override
  String heardNickname(String text) {
    return '“$text” విన్నాను. చేర్చాను.';
  }

  @override
  String get heardNicknameNothing => 'వినిపించలేదు. మళ్ళీ ప్రయత్నించండి.';

  @override
  String removeNickname(String name) {
    return '$name తీసేయండి';
  }

  @override
  String get forHelpTitle => 'సహాయం కోసం కాల్ చేయాలి';

  @override
  String get forHelpDetail => 'ఎరుపు సహాయం బటన్ ఈ వ్యక్తికి కాల్ చేస్తుంది.';

  @override
  String deleteConfirm(String name) {
    return '$nameని తొలగించాలా?';
  }

  @override
  String get welcomeBody =>
      'మీ అమ్మానాన్నలు మాట్లాడగల ఫోన్ సహాయకుడు. ఒక పెద్ద బటన్ నొక్కి మాట్లాడితే చాలు: కుటుంబానికి కాల్, సమయం లేదా రోజు అడగడం, లైట్ వేయడం, లేదా సహాయం అడగడం.';

  @override
  String get chooseLanguage => 'భాష ఎంచుకోండి';

  @override
  String get privacyNote =>
      'అన్నీ ఈ ఫోన్‌లోనే ఉంటాయి. ఖాతా లేదు, ప్రకటనలు లేవు, ట్రాకింగ్ లేదు.';

  @override
  String get continueButton => 'కొనసాగించండి';

  @override
  String get todaysReminders => 'ఈ రోజు రిమైండర్లు';

  @override
  String remindersLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ఈ రోజు ఇంకా $count ఉన్నాయి',
      one: 'ఈ రోజు ఇంకా 1 ఉంది',
    );
    return '$_temp0';
  }

  @override
  String get remindersAllDone => 'ఈ రోజుకి అన్నీ అయిపోయాయి';

  @override
  String get remindersNone => 'రిమైండర్లు ఏవీ పెట్టలేదు';

  @override
  String sayRemindersLeft(String items) {
    return 'ఈ రోజు ఇంకా చేయాల్సినవి: $items.';
  }

  @override
  String sayReminderItem(String name, String time) {
    return '$timeకి $name';
  }

  @override
  String get sayNoRemindersLeft => 'ఈ రోజు ఇంకా చేయాల్సినవి ఏవీ లేవు.';

  @override
  String get sayNoReminders =>
      'ఇంకా రిమైండర్లు ఏవీ పెట్టలేదు. దయచేసి మీ కుటుంబాన్ని చేర్చమని అడగండి.';

  @override
  String get setupReminders => 'రిమైండర్లు';

  @override
  String get setupRemindersDetail =>
      'అలారంలా మోగే రోజువారీ రిమైండర్లు, మర్చిపోతే కుటుంబానికి తెలియజేయడం.';

  @override
  String get setupEditReminders => 'రిమైండర్లు, సమయాలు';

  @override
  String get setupReminderSettings =>
      'రిమైండర్ సెట్టింగ్‌లు, కుటుంబానికి తెలియజేయడం';
}
