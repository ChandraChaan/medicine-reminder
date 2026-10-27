import 'package:flutter_test/flutter_test.dart';
import 'package:medicine_reminder/core/time/local_date.dart';
import 'package:medicine_reminder/features/doses/data/file_dose_log_repository.dart';
import 'package:medicine_reminder/features/doses/domain/dose.dart';
import 'package:medicine_reminder/features/doses/domain/schedule.dart';
import 'package:medicine_reminder/features/doses/presentation/alarm_sync.dart';
import 'package:medicine_reminder/features/doses/presentation/dose_controller.dart';
import 'package:medicine_reminder/features/medicines/data/medicine_json.dart';
import 'package:medicine_reminder/features/medicines/domain/medicine.dart';
import 'package:medicine_reminder/features/settings/data/file_settings_repository.dart';
import 'package:medicine_reminder/features/settings/domain/app_settings.dart';

import '../helpers/test_data.dart';

void main() {
  test('medicines survive a JSON round trip', () {
    final m = med(
      end: day1.addDays(30),
      weekdays: {1, 3, 5},
      stockQuarters: 42,
      doseQuarters: 2,
      unit: DoseUnit.ml,
      times: [21 * 60, 8 * 60],
    ).copyWith(photoPath: () => '/data/photos/1.jpg');
    final back = medicineFromJson(medicineToJson(m));
    expect(back, m.copyWith(times: [8 * 60, 21 * 60]));
  });

  test('dose events survive a JSON round trip, times stay in UTC', () {
    final e = DoseEvent(
      key: DoseKey('bp', at(day1, 8)),
      action: DoseAction.snoozed,
      atUtc: DateTime.utc(2026, 3, 10, 2, 31),
      snoozedUntil: at(day1, 8, 10),
    );
    final back = doseEventFromJson(doseEventToJson(e));
    expect(back, e);
    expect(back.atUtc.isUtc, isTrue);
  });

  test('settings fall back to defaults for missing keys', () {
    expect(
      settingsFromJson({'language': 'te'}),
      const AppSettings(language: AppLanguage.telugu),
    );
    expect(settingsFromJson({'language': 'xx'}).language, AppLanguage.english);
  });

  group('alarm entries for Android (the reboot rescheduling input)', () {
    final bp = med(id: 'bp', times: [8 * 60, 20 * 60]);
    final sugar = med(
      id: 'sugar',
      name: 'Sugar tablet',
      times: [8 * 60],
      food: FoodTiming.beforeFood,
    );

    AppData data(AppLanguage language) =>
        AppData([bp, sugar], DoseLog.empty, AppSettings(language: language));

    test('carry wall-clock date and minute, not an instant', () {
      final entries = buildAlarmEntries(data(AppLanguage.english), at(day1, 7));
      final first = entries.first.toMap();
      expect(first, containsPair('date', '2026-03-10'));
      expect(first, containsPair('minute', 480));
      expect(first, containsPair('kind', 'ring'));
      expect(first.containsKey('epochMillis'), isFalse);
    });

    test('ids are unique and start at 1', () {
      final entries = buildAlarmEntries(data(AppLanguage.english), at(day1, 7));
      final ids = entries.map((e) => e.id).toList();
      expect(ids.first, 1);
      expect(ids.toSet(), hasLength(ids.length));
    });

    test(
      'text lists each medicine with dose and food, in the chosen language',
      () {
        final en = buildAlarmEntries(
          data(AppLanguage.english),
          at(day1, 7),
        ).first;
        expect(en.title, 'Time for your medicine');
        expect(
          en.body,
          'BP tablet: 1 tablet, After food\nSugar tablet: 1 tablet, Before food',
        );
        final te = buildAlarmEntries(
          data(AppLanguage.telugu),
          at(day1, 7),
        ).first;
        expect(te.title, 'మందు వేసుకునే సమయం');
        expect(te.body, contains('భోజనానికి ముందు'));
        final hi = buildAlarmEntries(
          data(AppLanguage.hindi),
          at(day1, 7),
        ).first;
        expect(hi.body, contains('खाने के बाद'));
      },
    );

    test('a time zone change keeps 8:00 at 8:00', () {
      // The phone moves from IST to UAE time: the plan is the same wall time;
      // Android converts it with the new zone when it reschedules.
      final ist = LocalDateTime.fromUtc(
        DateTime.utc(2026, 3, 10, 1),
        const Duration(hours: 5, minutes: 30),
      );
      final uae = LocalDateTime.fromUtc(
        DateTime.utc(2026, 3, 10, 1),
        const Duration(hours: 4),
      );
      final a = buildAlarmEntries(data(AppLanguage.english), ist).first.toMap();
      final b = buildAlarmEntries(data(AppLanguage.english), uae).first.toMap();
      expect((a['date'], a['minute']), ('2026-03-10', 480));
      expect((b['date'], b['minute']), ('2026-03-10', 480));
    });
  });
}
