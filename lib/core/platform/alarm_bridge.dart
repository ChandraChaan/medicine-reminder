import 'dart:async';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

import '../time/local_date.dart';

enum AlarmKind {
  /// Ring and open the alarm screen.
  ring,

  /// Tell family if the doses are still not taken.
  check,
}

/// One alarm for Android to keep. Times are wall-clock, so Android works out
/// the instant in whatever time zone the phone is in when it (re)schedules.
@immutable
class AlarmEntry {
  const AlarmEntry({
    required this.id,
    required this.kind,
    required this.at,
    required this.title,
    required this.body,
    this.extra = const {},
  });

  final int id;
  final AlarmKind kind;
  final LocalDateTime at;
  final String title;
  final String body;

  /// Kind-specific data, for example the family numbers of a check.
  final Map<String, Object> extra;

  /// The map the Android side stores and reads back after a reboot.
  Map<String, Object> toMap() => {
    'id': id,
    'kind': kind.name,
    'date': at.date.toIso(),
    'minute': at.minuteOfDay,
    'title': title,
    'body': body,
    if (extra.isNotEmpty) 'extra': extra,
  };
}

/// Localised names Android shows for the app's notification channels.
@immutable
class ChannelNames {
  const ChannelNames({required this.alarms, required this.notices});

  final String alarms;
  final String notices;
}

@immutable
class AlarmPermissions {
  const AlarmPermissions({
    required this.exactAlarms,
    required this.fullScreen,
    required this.notifications,
  });

  static const allGranted = AlarmPermissions(
    exactAlarms: true,
    fullScreen: true,
    notifications: true,
  );

  /// Android 12+ "Alarms & reminders" access.
  final bool exactAlarms;

  /// Android 14+ permission to open the alarm screen over the lock screen.
  final bool fullScreen;
  final bool notifications;

  bool get allOk => exactAlarms && fullScreen && notifications;
}

/// The Android alarm side of the app.
abstract interface class AlarmBridge {
  /// Replaces every scheduled alarm with [entries].
  Future<void> scheduleAll(List<AlarmEntry> entries, ChannelNames names);

  Future<AlarmPermissions> permissions();

  Future<void> openExactAlarmSettings();

  Future<void> openFullScreenSettings();

  Future<void> openNotificationSettings();

  /// True once if the app was opened by an alarm.
  Future<bool> takeLaunchAlarm();

  /// Fires when an alarm opens the already-running app.
  Stream<void> get alarmFired;

  /// Silences the ringing alarm notification.
  Future<void> stopRinging();

  /// Lets the lock screen come back after the alarm screen closes.
  Future<void> alarmDone();

  /// Sends [message] by SMS to each of [phones] now; false if it couldn't.
  Future<bool> sendSms(List<String> phones, String message);

  /// Opens WhatsApp with [message] ready to send to [phone].
  Future<void> openWhatsApp(String phone, String message);

  /// A plain notification, for example "Only 3 days of BP tablet left".
  Future<void> showNotice({
    required int id,
    required String title,
    required String body,
  });
}

class MethodChannelAlarmBridge implements AlarmBridge {
  MethodChannelAlarmBridge() {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'alarmFired') _fired.add(null);
    });
  }

  static const _channel = MethodChannel('dev.chandra.medicine_reminder/alarms');
  final _fired = StreamController<void>.broadcast();

  @override
  Future<void> scheduleAll(List<AlarmEntry> entries, ChannelNames names) =>
      _channel.invokeMethod<void>('scheduleAll', {
        'entries': [for (final e in entries) e.toMap()],
        'alarmChannel': names.alarms,
        'noticeChannel': names.notices,
      });

  @override
  Future<AlarmPermissions> permissions() async {
    final map = await _channel.invokeMapMethod<String, bool>('permissions');
    return AlarmPermissions(
      exactAlarms: map?['exactAlarms'] ?? true,
      fullScreen: map?['fullScreen'] ?? true,
      notifications: map?['notifications'] ?? true,
    );
  }

  @override
  Future<void> openExactAlarmSettings() =>
      _channel.invokeMethod<void>('openExactAlarmSettings');

  @override
  Future<void> openFullScreenSettings() =>
      _channel.invokeMethod<void>('openFullScreenSettings');

  @override
  Future<void> openNotificationSettings() =>
      _channel.invokeMethod<void>('openNotificationSettings');

  @override
  Future<bool> takeLaunchAlarm() async =>
      await _channel.invokeMethod<bool>('takeLaunchAlarm') ?? false;

  @override
  Stream<void> get alarmFired => _fired.stream;

  @override
  Future<void> stopRinging() => _channel.invokeMethod<void>('stopRinging');

  @override
  Future<void> alarmDone() => _channel.invokeMethod<void>('alarmDone');

  @override
  Future<bool> sendSms(List<String> phones, String message) async =>
      await _channel.invokeMethod<bool>('sendSms', {
        'phones': phones,
        'message': message,
      }) ??
      false;

  @override
  Future<void> openWhatsApp(String phone, String message) => _channel
      .invokeMethod<void>('openWhatsApp', {'phone': phone, 'message': message});

  @override
  Future<void> showNotice({
    required int id,
    required String title,
    required String body,
  }) => _channel.invokeMethod<void>('showNotice', {
    'id': id,
    'title': title,
    'body': body,
  });
}
