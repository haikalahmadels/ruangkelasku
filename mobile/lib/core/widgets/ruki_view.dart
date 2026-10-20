import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_ui/material_ui.dart';

import '../layout/breakpoints.dart';
import '../theme/app_colors.dart';
import '../theme/tokens.dart';

/// Pose maskot Ruki (docs/design.md, bagian Maskot).
enum RukiPose { wave, read, cheer, sleep, worried, confused, think, proud }

/// Ruki + pesan + aksi opsional. Dipakai untuk layar kosong, galat, dan perayaan;
/// tidak dipakai di form dan tidak lebih dari satu kali per layar.
class RukiView extends StatelessWidget {
  const RukiView({
    super.key,
    required this.pose,
    this.message,
    this.actionLabel,
    this.onAction,
    this.size = Sizes.rukiMd,
  });

  final RukiPose pose;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final double size;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final reduceMotion = context.reduceMotion;

    Widget mascot = RukiImage(pose: pose, size: size);
    if (!reduceMotion) {
      // Memantul saat muncul; berayun sekali saat bersorak. Tidak ada animasi berulang.
      mascot = mascot
          .animate()
          .fadeIn(duration: Motion.medium, curve: Motion.enter)
          .scale(begin: const Offset(0.85, 0.85), duration: Motion.long, curve: Curves.elasticOut);
      if (pose == RukiPose.cheer || pose == RukiPose.wave) {
        mascot = mascot.animate(delay: Motion.long).shake(hz: 2, rotation: 0.06, duration: Motion.long);
      }
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Space.xl),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: Sizes.formMaxWidth),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              mascot,
              if (message != null) ...[
                const SizedBox(height: Space.lg),
                Text(message!, style: textTheme.bodyLarge, textAlign: TextAlign.center),
              ],
              if (actionLabel != null && onAction != null) ...[
                const SizedBox(height: Space.lg),
                FilledButton.tonal(onPressed: onAction, child: Text(actionLabel!)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Gambar Ruki saja; garis berganti ke brand.inkDark di mode gelap.
class RukiImage extends StatelessWidget {
  const RukiImage({super.key, required this.pose, this.size = Sizes.rukiMd});

  final RukiPose pose;
  final double size;

  static final Map<RukiPose, Future<String>> _cache = {};

  @override
  Widget build(BuildContext context) {
    final line = context.appColors.mascotLine;
    final source = _cache[pose] ??= rootBundle.loadString('assets/mascot/${pose.name}.svg');

    return ExcludeSemantics(
      child: SizedBox.square(
        dimension: size,
        child: FutureBuilder<String>(
          future: source,
          builder: (context, snapshot) {
            final svg = snapshot.data;
            if (svg == null) return const SizedBox.shrink();
            return SvgPicture.string(svg.replaceAll(AppColors.mascotLineInSvg, _hex(line)));
          },
        ),
      ),
    );
  }

  static String _hex(Color color) =>
      '#${color.toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
}
