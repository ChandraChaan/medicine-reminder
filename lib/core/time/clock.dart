import 'local_date.dart';

/// The current time. Injected so tests never read the real clock.
abstract interface class Clock {
  DateTime nowUtc();

  /// How far the phone's time zone is ahead of UTC right now.
  Duration get offset;
}

class SystemClock implements Clock {
  const SystemClock();

  @override
  DateTime nowUtc() => DateTime.now().toUtc();

  @override
  Duration get offset => DateTime.now().timeZoneOffset;
}

extension ClockLocal on Clock {
  LocalDateTime nowLocal() => LocalDateTime.fromUtc(nowUtc(), offset);

  LocalDate today() => nowLocal().date;
}
