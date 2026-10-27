import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/l10n/l10n.dart';
import '../core/providers.dart';
import '../core/theme/app_theme.dart';
import '../features/doses/presentation/alarm_screen.dart';
import '../features/doses/presentation/alarm_sync.dart';
import '../features/doses/presentation/history_screen.dart';
import '../features/doses/presentation/home_screen.dart';
import '../features/medicines/presentation/medicine_form_screen.dart';
import '../features/medicines/presentation/medicines_screen.dart';
import '../features/settings/domain/app_settings.dart';
import '../features/settings/presentation/family_check_screen.dart';
import '../features/settings/presentation/onboarding_screen.dart';
import '../features/settings/presentation/settings_controller.dart';
import '../features/settings/presentation/settings_screen.dart';

GoRouter buildRouter(String initialLocation) => GoRouter(
  initialLocation: initialLocation,
  routes: [
    GoRoute(path: '/', builder: (_, _) => const HomeScreen()),
    GoRoute(path: '/welcome', builder: (_, _) => const OnboardingScreen()),
    GoRoute(path: '/alarm', builder: (_, _) => const AlarmScreen()),
    GoRoute(path: '/history', builder: (_, _) => const HistoryScreen()),
    GoRoute(path: '/settings', builder: (_, _) => const SettingsScreen()),
    GoRoute(path: '/family', builder: (_, _) => const FamilyCheckScreen()),
    GoRoute(
      path: '/medicines',
      builder: (_, _) => const MedicinesScreen(),
      routes: [
        GoRoute(path: 'new', builder: (_, _) => const MedicineFormScreen()),
        GoRoute(
          path: ':id',
          builder: (_, state) =>
              MedicineFormScreen(medicineId: state.pathParameters['id']),
        ),
      ],
    ),
  ],
);

class MedicineReminderApp extends ConsumerStatefulWidget {
  const MedicineReminderApp({required this.initialLocation, super.key});

  final String initialLocation;

  @override
  ConsumerState<MedicineReminderApp> createState() =>
      _MedicineReminderAppState();
}

class _MedicineReminderAppState extends ConsumerState<MedicineReminderApp>
    with WidgetsBindingObserver {
  late final GoRouter _router = buildRouter(widget.initialLocation);
  StreamSubscription<void>? _alarms;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _alarms = ref.read(alarmBridgeProvider).alarmFired.listen((_) {
      _router.go('/alarm');
      unawaited(ref.read(alarmSyncProvider).resync());
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.invalidate(permissionsProvider);
      ref.invalidate(nowProvider);
      unawaited(ref.read(alarmSyncProvider).resync());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_alarms?.cancel());
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Keeps Android's alarms in step with every change.
    ref.watch(alarmSyncProvider);
    final language =
        ref.watch(settingsProvider).value?.language ?? AppLanguage.english;
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => context.l10n.appTitle,
      theme: buildAppTheme(),
      locale: Locale(language.code),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: _router,
    );
  }
}
