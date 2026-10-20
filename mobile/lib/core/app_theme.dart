import 'package:animations/animations.dart';
import 'package:material_ui/material_ui.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'tokens.dart';

/// ThemeData terang dan gelap dari seed RuangKelasku (docs/design.md).
abstract final class AppTheme {
  static ThemeData light() => _build(Brightness.light, AppColors.light);
  static ThemeData dark() => _build(Brightness.dark, AppColors.dark);

  static ThemeData _build(Brightness brightness, AppColors colors) {
    final scheme = ColorScheme.fromSeed(seedColor: AppColors.seed, brightness: brightness);
    final base = ThemeData(colorScheme: scheme, brightness: brightness);
    final textTheme = GoogleFonts.plusJakartaSansTextTheme(_typeScale(base.textTheme));

    return base.copyWith(
      textTheme: textTheme,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      extensions: [colors],
      pageTransitionsTheme: PageTransitionsTheme(
        builders: {
          for (final platform in TargetPlatform.values)
            platform: const _MotionAwareTransitionsBuilder(
              SharedAxisPageTransitionsBuilder(transitionType: SharedAxisTransitionType.horizontal),
            ),
        },
      ),
      cardTheme: const CardThemeData(
        elevation: 1,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: Radii.lgAll),
      ),
      chipTheme: base.chipTheme.copyWith(shape: const RoundedRectangleBorder(borderRadius: Radii.smAll)),
      inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder(borderRadius: Radii.smAll)),
      dialogTheme: const DialogThemeData(shape: RoundedRectangleBorder(borderRadius: Radii.xlAll)),
      bottomSheetTheme: const BottomSheetThemeData(
        showDragHandle: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(Radii.xl))),
      ),
      listTileTheme: const ListTileThemeData(shape: RoundedRectangleBorder(borderRadius: Radii.mdAll)),
      snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(color: scheme.onSurface),
      ),
    );
  }

  /// Skala tipe M3 dengan berat dari tabel Tipografi di docs/design.md.
  static TextTheme _typeScale(TextTheme base) {
    TextStyle? style(TextStyle? s, double size, double lineHeight, FontWeight weight) =>
        s?.copyWith(fontSize: size, height: lineHeight / size, fontWeight: weight);

    return base.copyWith(
      headlineMedium: style(base.headlineMedium, 28, 36, FontWeight.w700),
      headlineSmall: style(base.headlineSmall, 24, 32, FontWeight.w700),
      titleLarge: style(base.titleLarge, 22, 28, FontWeight.w600),
      titleMedium: style(base.titleMedium, 16, 24, FontWeight.w600),
      bodyLarge: style(base.bodyLarge, 16, 24, FontWeight.w400),
      bodyMedium: style(base.bodyMedium, 14, 20, FontWeight.w400),
      labelLarge: style(base.labelLarge, 14, 20, FontWeight.w600),
      labelMedium: style(base.labelMedium, 12, 16, FontWeight.w600),
      labelSmall: style(base.labelSmall, 11, 16, FontWeight.w500),
    );
  }
}

/// Transisi halaman dimatikan bila pengguna meminta reduce motion.
class _MotionAwareTransitionsBuilder extends PageTransitionsBuilder {
  const _MotionAwareTransitionsBuilder(this.inner);

  final PageTransitionsBuilder inner;

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (MediaQuery.disableAnimationsOf(context)) return child;
    return inner.buildTransitions(route, context, animation, secondaryAnimation, child);
  }
}
