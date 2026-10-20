import 'package:flutter/foundation.dart';

/// Konfigurasi lingkungan. Base URL bisa diganti saat demo dengan
/// `--dart-define=API_BASE_URL=http://192.168.1.10:8000/api/v1`.
abstract final class Env {
  static const String _override = String.fromEnvironment('API_BASE_URL');

  /// Chrome memakai localhost; emulator Android memakai 10.0.2.2.
  static String get apiBaseUrl {
    if (_override.isNotEmpty) return _override;
    return kIsWeb ? 'http://localhost:8000/api/v1' : 'http://10.0.2.2:8000/api/v1';
  }

  /// Nama token Sanctum per perangkat.
  static String get deviceName => kIsWeb ? 'chrome' : 'android';
}
