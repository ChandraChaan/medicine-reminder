import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medicine_reminder/core/platform/speech_recognizer.dart';
import 'package:medicine_reminder/core/platform/voice_permissions.dart';

import '../helpers/voice_app.dart';

Future<void> scrollTo(WidgetTester tester, Finder finder) async {
  await tester.scrollUntilVisible(
    finder,
    300,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.ensureVisible(finder);
  await tester.pump();
}

void main() {
  group('listening status', () {
    Future<void> showStatus(
      WidgetTester tester,
      RecognizerStatus status,
    ) async {
      final app = VoiceTestApp(contacts: const []);
      app.recognizer.currentStatus = status;
      await app.pump(tester, location: '/setup');
      await scrollTo(tester, find.text('Allow online listening'));
    }

    testWidgets('offline and private', (tester) async {
      await showStatus(
        tester,
        const RecognizerStatus(
          onDevice: true,
          anyRecognizer: true,
          offline: OfflineSpeech.installed,
        ),
      );
      expect(
        find.textContaining('English is understood on this phone'),
        findsOneWidget,
      );
      expect(find.text('Download English'), findsNothing);
    });

    testWidgets('online only', (tester) async {
      await showStatus(
        tester,
        const RecognizerStatus(
          onDevice: true,
          anyRecognizer: true,
          offline: OfflineSpeech.unsupported,
        ),
      );
      expect(
        find.text("This phone can't understand English without internet."),
        findsOneWidget,
      );
    });

    testWidgets('no recogniser at all', (tester) async {
      await showStatus(
        tester,
        const RecognizerStatus(
          onDevice: false,
          anyRecognizer: false,
          offline: OfflineSpeech.unsupported,
        ),
      );
      expect(
        find.textContaining('This phone has no speech recognition'),
        findsOneWidget,
      );
    });

    testWidgets('offers the download when there is one', (tester) async {
      final app = VoiceTestApp(contacts: const []);
      app.recognizer.currentStatus = const RecognizerStatus(
        onDevice: true,
        anyRecognizer: true,
        offline: OfflineSpeech.downloadable,
      );
      await app.pump(tester, location: '/setup');
      final download = find.text('Download English');
      await scrollTo(tester, download);

      await tester.tap(download);
      await VoiceTestApp.settle(tester);

      expect(app.recognizer.downloads, ['en-IN']);
      expect(find.textContaining("Follow the phone's prompt"), findsOneWidget);
    });

    testWidgets('online listening is off until switched on', (tester) async {
      final app = VoiceTestApp(contacts: const []);
      await app.pump(tester, location: '/setup');
      final toggle = find.text('Allow online listening');
      await scrollTo(tester, toggle);
      expect(app.settings.settings.allowOnline, isFalse);

      await tester.tap(toggle);
      await VoiceTestApp.settle(tester);

      expect(app.settings.settings.allowOnline, isTrue);
    });
  });

  testWidgets('warns when the phone has no voice for the language', (
    tester,
  ) async {
    final app = VoiceTestApp(contacts: const []);
    app.speech.voiceAvailable = false;
    await app.pump(tester, location: '/setup');
    await scrollTo(tester, find.text('Hear a sample'));

    expect(find.textContaining('This phone has no English voice'), findsOne);
  });

  testWidgets('permissions show their state and can be asked for', (
    tester,
  ) async {
    final app = VoiceTestApp(contacts: const [], phone: false);
    await app.pump(tester, location: '/setup');
    await scrollTo(tester, find.text('Phone, to call straight away'));

    expect(find.text('Allowed'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Allow'));
    await VoiceTestApp.settle(tester);

    expect(app.permissions.requested, [VoicePermission.phone]);
    expect(find.text('Allowed'), findsNWidgets(2));
  });

  group('family members', () {
    testWidgets('adds a person with a typed and a spoken nickname', (
      tester,
    ) async {
      final app = VoiceTestApp(contacts: const []);
      app.recognizer.results.add(const Heard(['రవి']));
      await app.pump(tester, location: '/setup');

      await tester.tap(find.text('Add a person'));
      await VoiceTestApp.settle(tester);
      expect(find.text('New person'), findsOneWidget);

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Name shown under the photo'),
        'Ravi',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Phone number'),
        '98000 00001',
      );
      await scrollTo(tester, find.widgetWithText(TextField, 'Type a name'));
      await tester.enterText(
        find.widgetWithText(TextField, 'Type a name'),
        'pedda abbayi',
      );
      await scrollTo(tester, find.text('Add'));
      await tester.tap(find.text('Add'));
      await VoiceTestApp.settle(tester);

      await scrollTo(tester, find.text('Say it'));
      await tester.tap(find.text('Say it'));
      await VoiceTestApp.settle(tester);
      expect(find.text('Heard “రవి”. Added.'), findsOneWidget);
      // Let the message go away; it floats over the bottom of the form.
      await tester.pump(const Duration(seconds: 5));
      await VoiceTestApp.settle(tester);

      await scrollTo(tester, find.text('Save'));
      await tester.tap(find.text('Save'));
      await VoiceTestApp.settle(tester);

      final saved = app.contacts.contacts.single;
      expect(saved.name, 'Ravi');
      expect(saved.phone, '98000 00001');
      expect(saved.nicknames, ['pedda abbayi', 'రవి']);
      expect(saved.forHelp, isTrue);
      expect(find.text('Set this up once', findRichText: true), findsNothing);
      expect(find.text('Ravi'), findsOneWidget);
    });

    testWidgets('needs a name and a number', (tester) async {
      final app = VoiceTestApp(contacts: const []);
      await app.pump(tester, location: '/setup/contact/new');

      await scrollTo(tester, find.text('Save'));
      await tester.tap(find.text('Save'));
      await VoiceTestApp.settle(tester);
      await tester.scrollUntilVisible(
        find.text('Enter a name'),
        -300,
        scrollable: find.byType(Scrollable).first,
      );

      expect(find.text('Enter a name'), findsOneWidget);
      expect(find.text('Enter a phone number'), findsOneWidget);
      expect(app.contacts.contacts, isEmpty);
    });

    testWidgets('edits and deletes a person after asking', (tester) async {
      final app = VoiceTestApp();
      await app.pump(tester, location: '/setup');

      await scrollTo(tester, find.text('Kiran'));
      await tester.tap(find.text('Kiran'));
      await VoiceTestApp.settle(tester);
      expect(find.text('Edit Kiran'), findsOneWidget);

      await tester.tap(find.byTooltip('Delete'));
      await VoiceTestApp.settle(tester);
      expect(find.text('Delete Kiran?'), findsOneWidget);
      await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
      await VoiceTestApp.settle(tester);

      expect(app.contacts.contacts.map((c) => c.id), ['ravi', 'lata']);
    });

    testWidgets('changing the order changes who Help calls first', (
      tester,
    ) async {
      final app = VoiceTestApp();
      await app.pump(tester, location: '/setup');

      // Drag Lata's handle above Ravi, in small steps like a finger.
      final handle = find.byIcon(Icons.drag_handle_rounded).at(1);
      final gesture = await tester.startGesture(tester.getCenter(handle));
      await tester.pump();
      for (var i = 0; i < 15; i++) {
        await gesture.moveBy(const Offset(0, -12));
        await tester.pump(const Duration(milliseconds: 16));
      }
      await gesture.up();
      await VoiceTestApp.settle(tester);

      expect(app.contacts.contacts.map((c) => c.id), ['lata', 'ravi', 'kiran']);
    });
  });
}
