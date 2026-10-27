import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:medicine_reminder/core/platform/alarm_bridge.dart';
import 'package:medicine_reminder/core/time/local_date.dart';
import 'package:medicine_reminder/features/doses/domain/dose.dart';
import 'package:medicine_reminder/features/doses/domain/schedule.dart';
import 'package:medicine_reminder/features/doses/presentation/alarm_sync.dart';
import 'package:medicine_reminder/features/doses/presentation/dose_controller.dart';
import 'package:medicine_reminder/features/settings/data/file_settings_repository.dart';
import 'package:medicine_reminder/features/settings/domain/app_settings.dart';

import '../helpers/test_data.dart';

DoseEvent answer(
  String id,
  LocalDateTime scheduled,
  DoseAction action, {
  LocalDateTime? until,
}) => DoseEvent(
  key: DoseKey(id, scheduled),
  action: action,
  atUtc: DateTime.utc(2026, 3, 10),
  snoozedUntil: until,
);

void main() {
  setUpAll(initializeDateFormatting);

  final bp = med(id: 'bp', times: [8 * 60, 20 * 60]);
  final sugar = med(id: 'sugar', name: 'Sugar tablet', times: [8 * 60]);

  group('planFamilyChecks (missed-dose detection for family)', () {
    test('one check per deadline, grouping doses due together', () {
      final checks = planFamilyChecks(
        [bp, sugar],
        DoseLog.empty,
        at(day1, 7),
        missedAfterMinutes: 60,
        horizonDays: 1,
      );
      expect(checks.map((c) => c.at), [at(day1, 9), at(day1, 21)]);
      expect(checks.first.doses.map((d) => d.medicine.id), ['bp', 'sugar']);
    });

    test('a dose marked Taken is never reported', () {
      final log = DoseLog([answer('bp', at(day1, 8), DoseAction.taken)]);
      final checks = planFamilyChecks(
        [bp],
        log,
        at(day1, 8, 5),
        missedAfterMinutes: 60,
        horizonDays: 1,
      );
      expect(checks.map((c) => c.at), [at(day1, 21)]);
    });

    test('a skipped dose is still reported (it was not taken)', () {
      final log = DoseLog([answer('bp', at(day1, 8), DoseAction.skipped)]);
      final checks = planFamilyChecks(
        [bp],
        log,
        at(day1, 8, 5),
        missedAfterMinutes: 60,
        horizonDays: 1,
      );
      expect(checks.first.at, at(day1, 9));
    });

    test('a snooze moves the check to after the snooze', () {
      final log = DoseLog([
        answer('bp', at(day1, 8), DoseAction.snoozed, until: at(day1, 8, 50)),
      ]);
      final checks = planFamilyChecks(
        [bp],
        log,
        at(day1, 8, 41),
        missedAfterMinutes: 30,
        horizonDays: 1,
      );
      expect(checks.first.at, at(day1, 9, 20));
    });

    test(
      'a deadline already passed is not re-planned (no repeat SMS after reboot)',
      () {
        final checks = planFamilyChecks(
          [bp],
          DoseLog.empty,
          at(day1, 9, 30),
          missedAfterMinutes: 60,
          horizonDays: 1,
        );
        expect(checks.map((c) => c.at), [at(day1, 21), at(day1.addDays(1), 9)]);
      },
    );

    test('a late-night dose is checked after midnight', () {
      final night = med(times: [23 * 60 + 30]);
      final checks = planFamilyChecks(
        [night],
        DoseLog.empty,
        at(day1, 23, 45),
        missedAfterMinutes: 60,
        horizonDays: 1,
      );
      expect(checks.first.at, at(day1.addDays(1), 0, 30));
    });
  });

  group('normalizePhone', () {
    test('accepts Indian and international numbers', () {
      expect(normalizePhone('98765 43210'), '+919876543210');
      expect(normalizePhone('098765-43210'), '+919876543210');
      expect(normalizePhone('919876543210'), '+919876543210');
      expect(normalizePhone('+1 (415) 555-0100'), '+14155550100');
      expect(normalizePhone('+44 7700 900123'), '+447700900123');
    });

    test('rejects things that are not phone numbers', () {
      expect(normalizePhone(''), isNull);
      expect(normalizePhone('12345'), isNull);
      expect(normalizePhone('call amma'), isNull);
    });
  });

  group('family check settings', () {
    const ready = FamilyCheck(
      enabled: true,
      personName: 'Amma',
      numbers: ['98765 43210', ''],
      smsConsent: true,
    );

    test('is only active when on, with a number and (for SMS) consent', () {
      expect(const FamilyCheck().isActive, isFalse);
      expect(ready.isActive, isTrue);
      expect(ready.copyWith(enabled: false).isActive, isFalse);
      expect(ready.copyWith(numbers: ['123']).isActive, isFalse);
      expect(ready.copyWith(smsConsent: false).isActive, isFalse);
      expect(
        ready
            .copyWith(smsConsent: false, channel: FamilyChannel.whatsapp)
            .isActive,
        isTrue,
      );
    });

    test('survives a JSON round trip; old files default to off', () {
      const settings = AppSettings(onboarded: true, family: ready);
      expect(settingsFromJson(settingsToJson(settings)), settings);
      expect(settingsFromJson({'onboarded': true}).family, const FamilyCheck());
    });

    AppData data(
      FamilyCheck family, {
      AppLanguage language = AppLanguage.english,
    }) => AppData(
      [bp],
      DoseLog.empty,
      AppSettings(family: family, language: language),
    );

    test('no check alarms unless the family check is active', () {
      final entries = buildAlarmEntries(data(const FamilyCheck()), at(day1, 7));
      expect(entries.where((e) => e.kind == AlarmKind.check), isEmpty);
      final noConsent = buildAlarmEntries(
        data(ready.copyWith(smsConsent: false)),
        at(day1, 7),
      );
      expect(noConsent.where((e) => e.kind == AlarmKind.check), isEmpty);
    });

    test('check alarms carry numbers, channel and the message', () {
      final entries = buildAlarmEntries(data(ready), at(day1, 7));
      final checks = entries.where((e) => e.kind == AlarmKind.check).toList();
      expect(checks, hasLength(14));
      final first = checks.first.toMap();
      expect((first['date'], first['minute']), ('2026-03-10', 9 * 60));
      final extra = first['extra']! as Map<String, Object>;
      expect(extra['phones'], ['+919876543210']);
      expect(extra['channel'], 'sms');
      expect(
        extra['message'],
        'Medicine Reminder: Amma has not marked BP tablet (due at 8:00 AM) as taken. Please check on them.',
      );
      // Ids stay unique across ring and check alarms.
      expect(entries.map((e) => e.id).toSet(), hasLength(entries.length));
    });

    test('the message follows the app language', () {
      final te = buildAlarmEntries(
        data(ready, language: AppLanguage.telugu),
        at(day1, 7),
      ).firstWhere((e) => e.kind == AlarmKind.check);
      expect(
        (te.extra['message']! as String),
        startsWith('మందుల రిమైండర్: Amma'),
      );
    });
  });
}
