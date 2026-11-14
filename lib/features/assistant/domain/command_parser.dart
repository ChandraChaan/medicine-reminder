import '../../family/domain/contact.dart';
import 'command.dart';
import 'keywords.dart';

/// Works out a [Command] from what the speech recogniser heard.
///
/// Recognisers return a few guesses, best first. Each guess is tried in
/// order and the first one that means something wins, so a slightly wrong
/// best guess ("call robbie") can still be saved by the next ("call Ravi").
///
/// Plain word matching, on the phone, no internet and no AI model: easy to
/// test and to explain, and it never sends anything anywhere.
Command parseCommand(List<String> heard, List<Contact> contacts) {
  Command? callWhom;
  for (final guess in heard) {
    final command = _parseOne(_normalise(guess), contacts);
    switch (command) {
      case NotUnderstood():
        continue;
      // "Call" with an unknown name is a weak answer: a later guess may
      // have the name right.
      case CallWhom():
        callWhom ??= command;
      default:
        return command;
    }
  }
  return callWhom ?? const NotUnderstood();
}

Command _parseOne(String text, List<Contact> contacts) {
  if (text.isEmpty) return const NotUnderstood();

  if (_hasAny(text, Keywords.help)) return const AskHelp();

  final contact = _findContact(text, contacts);
  final wantsCall = _hasAny(text, Keywords.call);
  if (contact != null && wantsCall) return CallContact(contact);

  if (_hasAny(text, Keywords.torch)) {
    return SetTorch(on: !_hasAny(text, Keywords.off));
  }
  if (_hasAny(text, Keywords.battery)) return const TellBattery();
  // Before time: "tablet time" asks about the reminders.
  if (_hasAny(text, Keywords.reminders)) return const TellReminders();
  if (_hasAny(text, Keywords.time)) return const TellTime();
  if (_hasAny(text, Keywords.date)) return const TellDate();

  // Just a name ("Ravi") means call them.
  if (contact != null) return CallContact(contact);
  if (wantsCall) return const CallWhom();
  return const NotUnderstood();
}

/// The contact whose name or nickname appears in [text]. When several do,
/// the longest match wins, so "pedda abbayi" beats "abbayi".
Contact? _findContact(String text, List<Contact> contacts) {
  Contact? best;
  var bestLength = 0;
  for (final contact in contacts) {
    for (final name in contact.spokenNames) {
      final word = _normalise(name);
      if (word.isEmpty || word.length <= bestLength) continue;
      if (_has(text, word)) {
        best = contact;
        bestLength = word.length;
      }
    }
  }
  return best;
}

bool _hasAny(String text, List<String> words) =>
    words.any((word) => _has(text, _normalise(word)));

final _telugu = RegExp('[ఀ-౿]');

/// क़ ख़ ग़ ज़ ड़ ढ़ फ़ य़ without their nukta.
const _withoutNukta = ['क', 'ख', 'ग', 'ज', 'ड', 'ढ', 'फ', 'य'];

/// Telugu words match the start of a word (endings join on); English and
/// Hindi words match whole words. See [Keywords].
bool _has(String text, String word) {
  if (word.isEmpty) return false;
  if (_telugu.hasMatch(word)) return ' $text'.contains(' $word');
  return ' $text '.contains(' $word ');
}

/// Lower case, without apostrophes and punctuation, spaces collapsed.
///
/// Telugu and Hindi vowel signs and the virama count as letters and are
/// kept. Recognisers sometimes add a nukta ("फ़ोन") and sometimes not
/// ("फोन"); both forms are listed in [Keywords].
String _normalise(String text) => text
    .toLowerCase()
    // Zero-width joiners change how a word is drawn, not what it says.
    .replaceAll(RegExp('[​-‍]'), '')
    // Recognisers write the Hindi nukta either way ("फ़ोन" or "फोन"), so it
    // is dropped: both the joined letters (U+0958–U+095F) and the sign.
    .replaceAllMapped(
      RegExp('[क़-य़]'),
      (m) => _withoutNukta[m[0]!.codeUnitAt(0) - 0x0958],
    )
    .replaceAll('़', '')
    .replaceAll('’', "'")
    .replaceAll(RegExp(r"'s\b"), '')
    .replaceAll("'", '')
    .replaceAll(RegExp(r'[^\p{L}\p{M}\p{N} ]', unicode: true), ' ')
    .replaceAll(RegExp(r'\s+'), ' ')
    .trim();
