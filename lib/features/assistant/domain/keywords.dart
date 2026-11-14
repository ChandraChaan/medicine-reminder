/// Words that point to each command, in English, Telugu and Hindi.
///
/// All lists are checked whatever the app language is: people mix languages
/// ("light on చెయ్యి"), and speech recognisers write English loan words in
/// either script ("battery", "బ్యాటరీ", "बैटरी").
///
/// How a word matches depends on its script (see `command_parser.dart`):
///  * English and Hindi words match whole words only, so "on" never matches
///    "phone" and "दिन" never matches "दिनेश". Hindi keeps its endings as
///    separate words ("रवि को"), so whole words are enough.
///  * Telugu words match the start of a word, because Telugu joins endings
///    on ("రవికి" is "to Ravi", "ఫోను", "ఫోన్"). That is why some Telugu
///    entries below are cut short on purpose, for example "ఫోన".
abstract final class Keywords {
  static const help = [
    'help',
    'emergency',
    'save me',
    'sos',
    // Telugu
    'హెల్ప',
    'సహాయ',
    'సాయం',
    'కాపాడ',
    'రక్షించ',
    'ఎమర్జెన్స',
    // Hindi
    'हेल्प',
    'बचाओ',
    'बचा लो',
    'बचाइए',
    'मदद',
    'सहायता',
    'इमरजेंसी',
  ];

  static const call = [
    'call',
    'phone',
    'ring',
    'dial',
    'talk to',
    'speak to',
    // Telugu
    'కాల్',
    'ఫోన',
    'కలుపు',
    'కలప',
    'మాట్లాడ',
    // Hindi
    'कॉल',
    'फोन',
    'लगाओ',
    'लगा दो',
    'लगाइए',
    'मिलाओ',
    'मिला दो',
    'मिलाइए',
    'बात कराओ',
    'बात करवाओ',
    'बात करनी',
    'बात करना',
  ];

  static const time = [
    'time',
    'clock',
    'oclock',
    // Telugu
    'టైం',
    'టైమ',
    'సమయం',
    'గంటలు',
    'గంట ఎంత',
    // Hindi
    'टाइम',
    'टाईम',
    'समय',
    'बजे',
    'बजा',
    'वक्त',
  ];

  static const date = [
    'date',
    'day',
    'today',
    // Telugu
    'తేదీ',
    'తేది',
    'తారీ',
    'రోజు',
    'ఈరోజు',
    'వారం',
    'డేట',
    // Hindi
    'तारीख',
    'तिथि',
    'दिन',
    'आज',
    'डेट',
  ];

  static const battery = [
    'battery',
    'charge',
    'charging',
    // Telugu
    'బ్యాటర',
    'బేటర',
    'ఛార్జ',
    'చార్జ',
    // Hindi
    'बैटरी',
    'बेटरी',
    'चार्ज',
    'चार्जिंग',
  ];

  static const reminders = [
    'reminder',
    'reminders',
    'medicine',
    'medicines',
    'tablet',
    'tablets',
    'pill',
    'pills',
    // Telugu ("మాత్ర" alone would also match "మాత్రమే", "only")
    'రిమైండర',
    'మందు',
    'మాత్రలు',
    'టాబ్లెట',
    // Hindi
    'रिमाइंडर',
    'दवा',
    'दवाई',
    'दवाइयां',
    'दवाइयाँ',
    'गोली',
    'गोलियां',
    'टैबलेट',
  ];

  static const torch = [
    'torch',
    'light',
    'lights',
    'flashlight',
    'flash',
    'lamp',
    // Telugu
    'టార్చ',
    'లైట',
    'దీపం',
    'వెలుగు',
    // Hindi
    'टॉर्च',
    'टार्च',
    'लाइट',
    'बत्ती',
    'रोशनी',
  ];

  /// With a torch word: turn it off.
  static const off = [
    'off',
    'stop',
    'close',
    // Telugu
    'ఆఫ్',
    'ఆప',
    'ఆర్ప',
    'తీసే',
    'బంద్',
    // Hindi
    'बंद',
    'ऑफ',
    'बुझा',
    'बुझाओ',
    'हटाओ',
  ];
}
