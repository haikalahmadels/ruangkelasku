import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:material_ui/material_ui.dart' show ThemeMode;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'preferences_repository.g.dart';

/// Preferensi perangkat (bukan akun). Disimpan di flutter_secure_storage yang
/// sudah dipakai untuk token, agar tidak menambah paket.
class PreferencesRepository {
  PreferencesRepository([FlutterSecureStorage? storage]) : _storage = storage ?? const FlutterSecureStorage();

  static const _themeModeKey = 'theme_mode';

  final FlutterSecureStorage _storage;

  Future<ThemeMode> themeMode() async {
    final value = await _storage.read(key: _themeModeKey);
    return ThemeMode.values.asNameMap()[value] ?? ThemeMode.system;
  }

  Future<void> setThemeMode(ThemeMode mode) => _storage.write(key: _themeModeKey, value: mode.name);
}

@Riverpod(keepAlive: true)
PreferencesRepository preferencesRepository(Ref ref) => PreferencesRepository();
