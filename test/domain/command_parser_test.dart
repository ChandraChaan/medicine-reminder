import 'package:flutter_test/flutter_test.dart';
import 'package:medicine_reminder/features/assistant/domain/command.dart';
import 'package:medicine_reminder/features/assistant/domain/command_parser.dart';
import 'package:medicine_reminder/features/family/domain/contact.dart';

const ravi = Contact(
  id: 'ravi',
  name: 'Ravi',
  phone: '9800000001',
  nicknames: ['pedda abbayi', 'రవి', 'रवि', 'बेटे'],
  forHelp: true,
);
const lata = Contact(
  id: 'lata',
  name: 'Lata',
  phone: '9800000002',
  nicknames: ['ammayi', 'లత', 'बेटी'],
);
const abbayi = Contact(
  id: 'kiran',
  name: 'Kiran',
  phone: '9800000003',
  nicknames: ['abbayi'],
);
const family = [ravi, lata, abbayi];

Command parse(String heard) => parseCommand([heard], family);

void main() {
  group('English', () {
    final cases = <String, Command>{
      'Call Ravi': const CallContact(ravi),
      "Please phone Lata's number": const CallContact(lata),
      'ravi': const CallContact(ravi),
      'call pedda abbayi': const CallContact(ravi),
      'call abbayi': const CallContact(abbayi),
      'call': const CallWhom(),
      'call the doctor': const CallWhom(),
      'Help!': const AskHelp(),
      'emergency, call Ravi': const AskHelp(),
      'What time is it?': const TellTime(),
      "what's the time now": const TellTime(),
      'what day is today': const TellDate(),
      "What's the date": const TellDate(),
      'how much battery is left': const TellBattery(),
      'is the phone charging': const TellBattery(),
      'turn on the light': const SetTorch(on: true),
      'torch': const SetTorch(on: true),
      'light off': const SetTorch(on: false),
      'switch off the torch': const SetTorch(on: false),
      'play a song': const NotUnderstood(),
      '': const NotUnderstood(),
    };
    cases.forEach((heard, expected) {
      test('"$heard"', () => expect(parse(heard), expected));
    });
  });

  group('Telugu', () {
    final cases = <String, Command>{
      'రవికి ఫోన్ చెయ్యి': const CallContact(ravi),
      'రవికి కాల్ చెయ్యి': const CallContact(ravi),
      'లతకి ఫోను కలుపు': const CallContact(lata),
      'లతతో మాట్లాడాలి': const CallContact(lata),
      'రవి': const CallContact(ravi),
      'ఫోన్ చెయ్యి': const CallWhom(),
      'కాపాడండి': const AskHelp(),
      'సహాయం కావాలి': const AskHelp(),
      'టైం ఎంత అయింది': const TellTime(),
      'టైమెంత': const TellTime(),
      'సమయం ఎంత': const TellTime(),
      'ఈరోజు ఏ రోజు': const TellDate(),
      'ఈ రోజు తేదీ ఎంత': const TellDate(),
      'బ్యాటరీ ఎంత ఉంది': const TellBattery(),
      'ఛార్జింగ్ ఎంత ఉంది': const TellBattery(),
      'లైట్ వెయ్యి': const SetTorch(on: true),
      'టార్చ్ ఆన్ చెయ్యి': const SetTorch(on: true),
      'లైట్ ఆపు': const SetTorch(on: false),
      'లైటు ఆఫ్ చెయ్యి': const SetTorch(on: false),
      'పాట పెట్టు': const NotUnderstood(),
    };
    cases.forEach((heard, expected) {
      test('"$heard"', () => expect(parse(heard), expected));
    });
  });

  group('Hindi', () {
    final cases = <String, Command>{
      'रवि को फोन लगाओ': const CallContact(ravi),
      'बेटे को फ़ोन करो': const CallContact(ravi),
      'बेटी से बात कराओ': const CallContact(lata),
      'रवि': const CallContact(ravi),
      'फोन लगाओ': const CallWhom(),
      'बचाओ': const AskHelp(),
      'मदद चाहिए': const AskHelp(),
      'कितने बजे हैं': const TellTime(),
      'अभी टाइम क्या हुआ है': const TellTime(),
      'आज कौन सा दिन है': const TellDate(),
      'आज क्या तारीख है': const TellDate(),
      'बैटरी कितनी है': const TellBattery(),
      'मेरे फोन में कितना चार्ज है': const TellBattery(),
      'टॉर्च जलाओ': const SetTorch(on: true),
      'लाइट बंद करो': const SetTorch(on: false),
      'गाना चलाओ': const NotUnderstood(),
      // "वार" inside "परिवार" or "दिन" inside "दिनेश" must not read as a date.
      'परिवार को फोन लगाओ': const CallWhom(),
      'दिनेश को फोन लगाओ': const CallWhom(),
    };
    cases.forEach((heard, expected) {
      test('"$heard"', () => expect(parse(heard), expected));
    });
  });

  group('reminders', () {
    final cases = <String, Command>{
      'what are my reminders': const TellReminders(),
      'did I take my medicine': const TellReminders(),
      'tablet time': const TellReminders(),
      'మందులు వేసుకున్నానా': const TellReminders(),
      'ఈ రోజు మాత్రలు ఏవి': const TellReminders(),
      'आज की दवाई': const TellReminders(),
      'गोली कब लेनी है': const TellReminders(),
      // "మాత్రమే" means "only"; it is not about tablets.
      'టైం మాత్రమే చెప్పు': const TellTime(),
    };
    cases.forEach((heard, expected) {
      test('"$heard"', () => expect(parse(heard), expected));
    });
  });

  group('mixed and messy speech', () {
    test('English words inside Telugu', () {
      expect(parse('light on చెయ్యి'), const SetTorch(on: true));
      expect(parse('రవికి call చెయ్యి'), const CallContact(ravi));
    });

    test('"on" inside "phone" is not a torch word', () {
      expect(parse('phone Lata'), const CallContact(lata));
    });

    test('the longest matching name wins', () {
      expect(parse('call pedda abbayi'), const CallContact(ravi));
      expect(parse('call abbayi'), const CallContact(abbayi));
    });

    test('zero-width joiners are ignored', () {
      expect(parse('ర‌వికి ఫోన్'), const CallContact(ravi));
    });

    test('a later guess is used when the best one means nothing', () {
      expect(
        parseCommand(['call robbie', 'call Ravi'], family),
        const CallContact(ravi),
      );
      expect(parseCommand(['hmm', 'what time'], family), const TellTime());
    });

    test('no contacts: a name alone is not understood', () {
      expect(parseCommand(['Ravi'], const []), const NotUnderstood());
      expect(parseCommand(['call Ravi'], const []), const CallWhom());
    });

    test('nothing heard', () {
      expect(parseCommand(const [], family), const NotUnderstood());
    });
  });

  group('Contact', () {
    test('spokenNames drops blanks and repeats', () {
      const contact = Contact(
        id: 'a',
        name: 'Ravi',
        phone: '1',
        nicknames: [' ravi ', '', 'Babu'],
      );
      expect(contact.spokenNames, ['Ravi', 'Babu']);
    });

    test('survives a JSON round trip', () {
      expect(Contact.fromJson(ravi.toJson()), ravi);
    });
  });
}
