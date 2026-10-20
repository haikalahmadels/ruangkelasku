import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/copy/strings.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/ruki_view.dart';

/// Layar 1: sambutan dengan Ruki melambai.
class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(Space.xl),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: Sizes.formMaxWidth),
              child: Column(
                children: [
                  const RukiView(pose: RukiPose.wave, size: Sizes.rukiLg),
                  Text(S.welcomeTitle, style: textTheme.headlineSmall, textAlign: TextAlign.center),
                  const SizedBox(height: Space.md),
                  Text(S.welcomeBody, style: textTheme.bodyLarge, textAlign: TextAlign.center),
                  const SizedBox(height: Space.xxl),
                  FilledButton(
                    onPressed: () => context.go('/login'),
                    style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(Sizes.touchTarget)),
                    child: const Text(S.signIn),
                  ),
                  const SizedBox(height: Space.md),
                  OutlinedButton(
                    onPressed: () => context.go('/register'),
                    style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(Sizes.touchTarget)),
                    child: const Text(S.signUp),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
