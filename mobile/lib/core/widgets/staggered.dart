import 'package:flutter_animate/flutter_animate.dart';
import 'package:material_ui/material_ui.dart';

import '../layout/breakpoints.dart';
import '../theme/tokens.dart';

/// Item daftar masuk berurutan: fade + naik 12 dp, 40 ms per item, maksimal 8 item.
class Staggered extends StatelessWidget {
  const Staggered({super.key, required this.index, required this.child});

  final int index;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (context.reduceMotion || index >= Motion.staggerMaxItems) return child;
    return child
        .animate(delay: Motion.stagger * index)
        .fadeIn(duration: Motion.medium, curve: Motion.enter)
        .moveY(begin: Motion.enterOffset, end: 0, duration: Motion.medium, curve: Motion.enter);
  }
}
