import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

/// How a call was placed.
enum CallOutcome {
  /// Calling now.
  called,

  /// The dialer opened with the number; the person presses the call button.
  dialer,

  failed,
}

@immutable
class BatteryLevel {
  const BatteryLevel({required this.percent, required this.charging});

  /// 0–100, or null when the phone doesn't say.
  final int? percent;
  final bool charging;
}

/// Calls, battery and torch.
abstract interface class Phone {
  Future<CallOutcome> call(String number);

  Future<BatteryLevel> battery();

  /// False when the phone has no flash or it is in use.
  Future<bool> setTorch({required bool on});
}

class ChannelPhone implements Phone {
  const ChannelPhone();

  static const _channel = MethodChannel('voice_saathi/phone');

  @override
  Future<CallOutcome> call(String number) async {
    final outcome = await _channel.invokeMethod<String>('call', {
      'number': number,
    });
    return switch (outcome) {
      'called' => CallOutcome.called,
      'dialer' => CallOutcome.dialer,
      _ => CallOutcome.failed,
    };
  }

  @override
  Future<BatteryLevel> battery() async {
    final map = await _channel.invokeMapMethod<String, Object?>('battery');
    final level = map?['level'] as int? ?? -1;
    return BatteryLevel(
      percent: level >= 0 ? level : null,
      charging: map?['charging'] == true,
    );
  }

  @override
  Future<bool> setTorch({required bool on}) async =>
      await _channel.invokeMethod<bool>('torch', {'on': on}) ?? false;
}
