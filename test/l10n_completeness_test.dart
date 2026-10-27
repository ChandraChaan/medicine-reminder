import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

Map<String, Object?> _arb(String locale) =>
    (jsonDecode(File('lib/l10n/app_$locale.arb').readAsStringSync()) as Map)
        .cast<String, Object?>();

Set<String> _messages(Map<String, Object?> arb) =>
    arb.keys.where((k) => !k.startsWith('@')).toSet();

/// Top-level placeholder names in a message, e.g. {name} and
/// {days, plural, ...}; text inside plural branches is skipped.
Set<String> _placeholders(String message) {
  final names = <String>{};
  var depth = 0;
  for (var i = 0; i < message.length; i++) {
    final char = message[i];
    if (char == '{') {
      if (depth == 0) {
        final match = RegExp(r'\w+').matchAsPrefix(message, i + 1);
        if (match != null) names.add(match.group(0)!);
      }
      depth++;
    } else if (char == '}') {
      depth--;
    }
  }
  return names;
}

void main() {
  final english = _arb('en');

  for (final locale in ['te', 'hi']) {
    group('$locale translation', () {
      final other = _arb(locale);

      test('has every English message and nothing extra', () {
        expect(_messages(other).difference(_messages(english)), isEmpty);
        expect(_messages(english).difference(_messages(other)), isEmpty);
      });

      test('has no empty messages', () {
        for (final key in _messages(other)) {
          expect((other[key]! as String).trim(), isNotEmpty, reason: key);
        }
      });

      test('uses the same placeholders as English', () {
        for (final key in _messages(english)) {
          expect(
            _placeholders(other[key]! as String),
            _placeholders(english[key]! as String),
            reason: key,
          );
        }
      });

      test('is actually translated (not left in English)', () {
        const sameOnPurpose = {
          'languageEnglish',
          'languageTelugu',
          'languageHindi',
          'doseAmount',
          'speechItem',
          'speechItemNoFood',
          'familyNumberHint',
        };
        for (final key in _messages(english).difference(sameOnPurpose)) {
          if (key.startsWith('@')) continue;
          expect(other[key], isNot(english[key]), reason: key);
        }
      });
    });
  }

  test('every English placeholder is declared', () {
    for (final key in _messages(english)) {
      final used = _placeholders(english[key]! as String);
      if (used.isEmpty) continue;
      final meta = english['@$key'] as Map<String, Object?>?;
      final declared =
          (meta?['placeholders'] as Map<String, Object?>?)?.keys.toSet() ?? {};
      expect(declared, used, reason: key);
    }
  });
}
