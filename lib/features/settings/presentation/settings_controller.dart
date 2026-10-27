import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../domain/app_settings.dart';

final settingsProvider = AsyncNotifierProvider<SettingsController, AppSettings>(
  SettingsController.new,
);

class SettingsController extends AsyncNotifier<AppSettings> {
  @override
  Future<AppSettings> build() => ref.watch(settingsRepositoryProvider).load();

  Future<void> change(AppSettings Function(AppSettings current) update) async {
    final next = update(await future);
    if (!ref.mounted) return;
    state = AsyncData(next);
    await ref.read(settingsRepositoryProvider).save(next);
  }
}
