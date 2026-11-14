// Fakes for the Voice Saathi part of the app.
import 'dart:async';

import 'package:medicine_reminder/core/platform/phone.dart';
import 'package:medicine_reminder/core/platform/speech_recognizer.dart';
import 'package:medicine_reminder/core/platform/voice_permissions.dart';
import 'package:medicine_reminder/core/speech/speech_service.dart';
import 'package:medicine_reminder/features/family/domain/contact.dart';

/// Records what was spoken; speaking finishes at once.
class VoiceFakeSpeech implements SpeechService {
  final spoken = <String>[];
  final locales = <String>[];
  bool voiceAvailable = true;

  @override
  Future<bool> hasVoice(String localeTag) async => voiceAvailable;

  @override
  Future<void> speak(String text, String localeTag) async {
    spoken.add(text);
    locales.add(localeTag);
  }

  @override
  Future<void> stop() async {}
}

/// Answers each [listen] with the next queued result.
class FakeRecognizer implements SpeechRecognizer {
  final results = <HeardResult>[];
  final listenedIn = <String>[];
  final allowOnlineFlags = <bool>[];
  final downloads = <String>[];
  RecognizerStatus currentStatus = const RecognizerStatus(
    onDevice: true,
    anyRecognizer: true,
    offline: OfflineSpeech.installed,
  );
  bool downloadWorks = true;
  final _partial = StreamController<String>.broadcast();

  @override
  Stream<String> get partial => _partial.stream;

  @override
  Future<RecognizerStatus> status(String localeTag) async => currentStatus;

  @override
  Future<bool> downloadOffline(String localeTag) async {
    downloads.add(localeTag);
    return downloadWorks;
  }

  @override
  Future<HeardResult> listen(
    String localeTag, {
    required bool allowOnline,
  }) async {
    listenedIn.add(localeTag);
    allowOnlineFlags.add(allowOnline);
    return results.isEmpty ? const HeardNothing() : results.removeAt(0);
  }

  @override
  Future<void> cancel() async {}

  Future<void> dispose() => _partial.close();
}

class FakePhone implements Phone {
  final called = <String>[];
  CallOutcome outcome = CallOutcome.called;
  BatteryLevel level = const BatteryLevel(percent: 80, charging: false);
  bool hasTorch = true;
  bool? torchOn;

  @override
  Future<CallOutcome> call(String number) async {
    called.add(number);
    return outcome;
  }

  @override
  Future<BatteryLevel> battery() async => level;

  @override
  Future<bool> setTorch({required bool on}) async {
    if (!hasTorch) return false;
    torchOn = on;
    return true;
  }
}

class FakeVoicePermissions implements VoicePermissions {
  FakeVoicePermissions({this.microphone = true, this.phone = true});

  bool microphone;
  bool phone;

  /// What a request returns (and grants).
  bool grantOnRequest = true;
  final requested = <VoicePermission>[];

  @override
  Future<bool> isGranted(VoicePermission permission) async =>
      switch (permission) {
        VoicePermission.microphone => microphone,
        VoicePermission.phone => phone,
      };

  @override
  Future<bool> request(VoicePermission permission) async {
    requested.add(permission);
    if (grantOnRequest) {
      switch (permission) {
        case VoicePermission.microphone:
          microphone = true;
        case VoicePermission.phone:
          phone = true;
      }
    }
    return grantOnRequest;
  }
}

class FakeContactRepository implements ContactRepository {
  FakeContactRepository([List<Contact> initial = const []])
    : contacts = [...initial];

  List<Contact> contacts;

  @override
  Future<List<Contact>> loadAll() async => [...contacts];

  @override
  Future<void> saveAll(List<Contact> contacts) async =>
      this.contacts = [...contacts];
}
