import 'dart:async';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

/// Whether a language can be recognised without internet on this phone.
enum OfflineSpeech {
  /// Ready: recognised on the phone.
  installed,

  /// Google is downloading it.
  downloading,

  /// The phone can recognise it offline after a one-time download.
  downloadable,

  /// Not offline on this phone (or no on-device recogniser at all).
  unsupported,

  /// The phone can't tell us (Android 12 and older).
  unknown,
}

@immutable
class RecognizerStatus {
  const RecognizerStatus({
    required this.onDevice,
    required this.anyRecognizer,
    required this.offline,
  });

  /// Android 12+ with an on-device recogniser: audio stays on the phone.
  final bool onDevice;

  /// Some recogniser exists (usually the Google app's).
  final bool anyRecognizer;

  final OfflineSpeech offline;

  /// Listening can work without sending audio anywhere.
  bool get privateListening =>
      onDevice &&
      (offline == OfflineSpeech.installed || offline == OfflineSpeech.unknown);
}

/// Why listening failed.
enum SpeechError {
  /// No on-device recogniser, and online recognition is not allowed.
  needsOnline,

  /// The language isn't available on this phone's recogniser.
  languageMissing,

  /// Online recognition was allowed but there is no internet.
  network,

  noPermission,
  busy,
  unavailable,
  other,
}

sealed class HeardResult {
  const HeardResult();
}

/// The recogniser's guesses, best first.
final class Heard extends HeardResult {
  const Heard(this.words);

  final List<String> words;
}

final class HeardNothing extends HeardResult {
  const HeardNothing();
}

/// Listening was stopped before anything was heard.
final class ListenCancelled extends HeardResult {
  const ListenCancelled();
}

final class ListenFailed extends HeardResult {
  const ListenFailed(this.error);

  final SpeechError error;
}

/// Turns speech into text using Android's own recogniser.
abstract interface class SpeechRecognizer {
  Future<RecognizerStatus> status(String localeTag);

  /// Asks Google to download the offline model; false if this phone can't.
  Future<bool> downloadOffline(String localeTag);

  /// Listens once until the person stops speaking.
  Future<HeardResult> listen(String localeTag, {required bool allowOnline});

  Future<void> cancel();

  /// Words heard so far while [listen] is running.
  Stream<String> get partial;
}

class ChannelSpeechRecognizer implements SpeechRecognizer {
  ChannelSpeechRecognizer() {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onPartial') _partial.add(call.arguments as String);
    });
  }

  static const _channel = MethodChannel('voice_saathi/speech');
  final _partial = StreamController<String>.broadcast();

  @override
  Stream<String> get partial => _partial.stream;

  @override
  Future<RecognizerStatus> status(String localeTag) async {
    final map = await _channel.invokeMapMethod<String, Object?>('status', {
      'locale': localeTag,
    });
    return RecognizerStatus(
      onDevice: map?['onDevice'] == true,
      anyRecognizer: map?['anyRecognizer'] == true,
      offline: switch (map?['offline']) {
        'installed' => OfflineSpeech.installed,
        'downloading' => OfflineSpeech.downloading,
        'downloadable' => OfflineSpeech.downloadable,
        'unsupported' => OfflineSpeech.unsupported,
        _ => OfflineSpeech.unknown,
      },
    );
  }

  @override
  Future<bool> downloadOffline(String localeTag) async =>
      await _channel.invokeMethod<bool>('download', {'locale': localeTag}) ??
      false;

  @override
  Future<HeardResult> listen(
    String localeTag, {
    required bool allowOnline,
  }) async {
    final map = await _channel.invokeMapMethod<String, Object?>('listen', {
      'locale': localeTag,
      'allowOnline': allowOnline,
    });
    if (map == null || map['cancelled'] == true) return const ListenCancelled();
    final words = map['words'];
    if (words is List) {
      return Heard([for (final word in words) word as String]);
    }
    return switch (map['error']) {
      'no_match' => const HeardNothing(),
      'needs_online' => const ListenFailed(SpeechError.needsOnline),
      'language_missing' => const ListenFailed(SpeechError.languageMissing),
      'network' => const ListenFailed(SpeechError.network),
      'permission' => const ListenFailed(SpeechError.noPermission),
      'busy' => const ListenFailed(SpeechError.busy),
      'unavailable' => const ListenFailed(SpeechError.unavailable),
      _ => const ListenFailed(SpeechError.other),
    };
  }

  @override
  Future<void> cancel() => _channel.invokeMethod<void>('cancel');
}
