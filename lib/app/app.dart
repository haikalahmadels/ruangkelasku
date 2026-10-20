import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../core/copy/strings.dart';
import '../core/theme/app_theme.dart';
import '../core/widgets/async_view.dart';
import '../features/auth/application/session.dart';
import '../features/settings/application/theme_mode.dart';
import 'router.dart';

class RuangKelaskuApp extends ConsumerWidget {
  const RuangKelaskuApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: S.appName,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ref.watch(themeModeSettingProvider).value ?? ThemeMode.system,
      debugShowCheckedModeBanner: false,
      routerConfig: ref.watch(routerProvider),
      locale: const Locale('id', 'ID'),
      supportedLocales: const [Locale('id', 'ID')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      builder: (context, child) {
        // Satu router sejak awal agar URL (deep link) tidak hilang selama sesi dimuat.
        final session = ref.watch(sessionProvider);
        final Widget body = session.hasValue
            ? child!
            : Scaffold(
                body: session.hasError
                    ? ErrorView(error: session.error!, onRetry: () => ref.invalidate(sessionProvider))
                    : const Center(child: CircularProgressIndicator()),
              );
        // confetti masih memakai package:flutter/material.dart; hapus bila paket itu sudah bermigrasi.
        // ignore: deprecated_member_use
        return MaterialUiCompatibilityBridge(child: body);
      },
    );
  }
}
