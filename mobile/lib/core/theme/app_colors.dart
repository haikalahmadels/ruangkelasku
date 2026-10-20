import 'package:material_ui/material_ui.dart';

import '../models/display_status.dart';

/// Warna merek dan status yang tidak tercakup ColorScheme; ikut berganti mode.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({required this.sun, required this.onSun, required this.mascotLine, required this.status});

  static const Color seed = Color(0xFF2E9E6B);
  static const Color _sun = Color(0xFFFFB547);
  static const Color _ink = Color(0xFF16302A);
  static const Color _inkDark = Color(0xFFE3F2EA);

  /// Warna garis maskot di file SVG; diganti [mascotLine] saat dimuat.
  static const String mascotLineInSvg = '#16302A';

  final Color sun;

  /// Teks di atas [sun] selalu ink (8,02:1), tidak pernah putih.
  final Color onSun;
  final Color mascotLine;
  final Map<DisplayStatus, StatusColors> status;

  static const light = AppColors(
    sun: _sun,
    onSun: _ink,
    mascotLine: _ink,
    status: {
      DisplayStatus.assigned: StatusColors(Color(0xFF4F5B56), Color(0xFFEAF0ED)),
      DisplayStatus.missing: StatusColors(Color(0xFFBA1A1A), Color(0xFFFFDAD6)),
      DisplayStatus.turnedIn: StatusColors(Color(0xFF17694A), Color(0xFFD3F1E2)),
      DisplayStatus.graded: StatusColors(Color(0xFF7A4F00), Color(0xFFFFE6BA)),
      DisplayStatus.returned: StatusColors(Color(0xFF2450A8), Color(0xFFDCE6FF)),
    },
  );

  static const dark = AppColors(
    sun: _sun,
    onSun: _ink,
    mascotLine: _inkDark,
    status: {
      DisplayStatus.assigned: StatusColors(Color(0xFFBCC8C2), Color(0xFF28302D)),
      DisplayStatus.missing: StatusColors(Color(0xFFFFB4AB), Color(0xFF690005)),
      DisplayStatus.turnedIn: StatusColors(Color(0xFF8CD9B2), Color(0xFF0F3D2A)),
      DisplayStatus.graded: StatusColors(Color(0xFFFFC870), Color(0xFF4A3200)),
      DisplayStatus.returned: StatusColors(Color(0xFFAFC6FF), Color(0xFF173064)),
    },
  );

  /// Label "terlambat" memakai warna teks status missing.
  Color get late => status[DisplayStatus.missing]!.foreground;

  @override
  AppColors copyWith({Color? sun, Color? onSun, Color? mascotLine, Map<DisplayStatus, StatusColors>? status}) =>
      AppColors(
        sun: sun ?? this.sun,
        onSun: onSun ?? this.onSun,
        mascotLine: mascotLine ?? this.mascotLine,
        status: status ?? this.status,
      );

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other == null) return this;
    return AppColors(
      sun: Color.lerp(sun, other.sun, t)!,
      onSun: Color.lerp(onSun, other.onSun, t)!,
      mascotLine: Color.lerp(mascotLine, other.mascotLine, t)!,
      status: {for (final key in DisplayStatus.values) key: StatusColors.lerp(status[key]!, other.status[key]!, t)},
    );
  }
}

@immutable
class StatusColors {
  const StatusColors(this.foreground, this.background);

  final Color foreground;
  final Color background;

  static StatusColors lerp(StatusColors a, StatusColors b, double t) =>
      StatusColors(Color.lerp(a.foreground, b.foreground, t)!, Color.lerp(a.background, b.background, t)!);
}

extension AppColorsContext on BuildContext {
  AppColors get appColors => Theme.of(this).extension<AppColors>()!;
}
