// Shared setup for the README screenshots with realistic sample data:
//   flutter test test_screenshots --update-goldens
// Not part of the normal test run (it needs fonts from the Flutter SDK and,
// for Telugu and Hindi, from macOS).
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medicine_reminder/core/time/local_date.dart';
import 'package:medicine_reminder/features/doses/domain/dose.dart';
import 'package:medicine_reminder/features/medicines/domain/medicine.dart';
import 'package:medicine_reminder/features/settings/domain/app_settings.dart';

import '../test/helpers/fakes.dart';
import '../test/helpers/pump_app.dart';

const today = LocalDate(2026, 10, 28);

Future<void> _load(String family, List<String> paths) async {
  final loader = FontLoader(family);
  for (final path in paths) {
    if (!File(path).existsSync()) continue;
    loader.addFont(
      Future.value(ByteData.sublistView(File(path).readAsBytesSync())),
    );
  }
  await loader.load();
}

/// Test renders have no font fallback, so Telugu and Hindi shots use a
/// macOS font that covers both that script and Latin as the app font.
Future<void> loadFonts({String? script}) async {
  final flutterRoot = File(
    Platform.resolvedExecutable,
  ).parent.parent.parent.parent.parent.parent.path;
  final fonts = '$flutterRoot/bin/cache/artifacts/material_fonts';
  await _load('Roboto', switch (script) {
    'te' => ['/System/Library/Fonts/KohinoorTelugu.ttc'],
    'hi' => ['/System/Library/Fonts/Kohinoor.ttc'],
    _ => [
      '$fonts/Roboto-Regular.ttf',
      '$fonts/Roboto-Medium.ttf',
      '$fonts/Roboto-Bold.ttf',
    ],
  });
  await _load('MaterialIcons', ['$fonts/MaterialIcons-Regular.otf']);
}

final medicines = [
  const Medicine(
    id: 'amlo',
    name: 'Amlodipine 5 mg',
    doseQuarters: 4,
    unit: DoseUnit.tablet,
    times: [8 * 60, 21 * 60],
    food: FoodTiming.afterFood,
    startDate: LocalDate(2026, 9, 1),
    stockQuarters: 8 * 4,
  ),
  const Medicine(
    id: 'met',
    name: 'Metformin 500',
    doseQuarters: 4,
    unit: DoseUnit.tablet,
    times: [8 * 60, 14 * 60, 21 * 60],
    food: FoodTiming.withFood,
    startDate: LocalDate(2026, 9, 1),
  ),
  const Medicine(
    id: 'thy',
    name: 'Thyroxine 50',
    doseQuarters: 4,
    unit: DoseUnit.tablet,
    times: [6 * 60 + 30],
    food: FoodTiming.beforeFood,
    startDate: LocalDate(2026, 9, 1),
  ),
];

/// Three weeks of history: mostly taken, a few missed and one skipped.
List<DoseEvent> history() {
  final events = <DoseEvent>[];
  for (
    var day = const LocalDate(2026, 10, 1);
    day.isBefore(today);
    day = day.addDays(1)
  ) {
    for (final m in medicines) {
      for (final t in m.times) {
        final seed = day.day * 7 + t ~/ 60 + m.id.length;
        if (seed % 53 == 0) continue; // missed
        events.add(
          DoseEvent(
            key: DoseKey(m.id, LocalDateTime(day, t)),
            action: seed % 67 == 0 ? DoseAction.skipped : DoseAction.taken,
            atUtc: LocalDateTime(
              day,
              t + 6,
            ).toUtc(const Duration(hours: 5, minutes: 30)),
          ),
        );
      }
    }
  }
  // Today: early doses done.
  for (final (id, t) in [
    ('thy', 6 * 60 + 30),
    ('amlo', 8 * 60),
    ('met', 8 * 60),
  ]) {
    events.add(
      DoseEvent(
        key: DoseKey(id, LocalDateTime(today, t)),
        action: DoseAction.taken,
        atUtc: LocalDateTime(
          today,
          t + 4,
        ).toUtc(const Duration(hours: 5, minutes: 30)),
      ),
    );
  }
  return events;
}

Future<void> shoot(
  WidgetTester tester,
  String name, {
  required LocalDateTime now,
  String location = '/',
  AppLanguage language = AppLanguage.english,
  List<DoseEvent>? events,
}) async {
  final app = TestApp(
    clock: FakeClock(now),
    medicines: medicines,
    events: events ?? history(),
    settings: AppSettings(onboarded: true, language: language),
  );
  await app.pump(tester, location: location);
  await expectLater(
    find.byType(MaterialApp),
    matchesGoldenFile('../docs/screenshots/$name.png'),
  );
}
