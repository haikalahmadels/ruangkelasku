import 'package:material_ui/material_ui.dart' show ThemeMode;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/preferences_repository.dart';

part 'theme_mode.g.dart';

/// Mode terang/gelap: mengikuti sistem atau dipilih di Setelan (docs/design.md).
@Riverpod(keepAlive: true)
class ThemeModeSetting extends _$ThemeModeSetting {
  @override
  Future<ThemeMode> build() => ref.watch(preferencesRepositoryProvider).themeMode();

  Future<void> set(ThemeMode mode) async {
    state = AsyncData(mode);
    await ref.read(preferencesRepositoryProvider).setThemeMode(mode);
  }
}
