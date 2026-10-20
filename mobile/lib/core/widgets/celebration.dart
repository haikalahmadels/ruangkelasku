import 'package:confetti/confetti.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

import '../layout/breakpoints.dart';
import '../network/api_exception.dart';
import '../theme/app_colors.dart';
import '../theme/tokens.dart';
import 'form_widgets.dart';
import 'ruki_view.dart';

/// Perayaan satu kali: getar ringan, konfeti hijau-kuning, Ruki bersorak; maksimal 2 detik.
/// Saat reduce motion, hanya Ruki tanpa konfeti.
Future<void> showCelebration(BuildContext context, {required String message, RukiPose pose = RukiPose.cheer}) async {
  HapticFeedback.mediumImpact();
  final reduceMotion = context.reduceMotion;

  await showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (dialogContext) {
      Future.delayed(Motion.celebration, () {
        if (dialogContext.mounted) Navigator.of(dialogContext).maybePop();
      });
      return _CelebrationDialog(message: message, pose: pose, confetti: !reduceMotion);
    },
  );
}

class _CelebrationDialog extends StatefulWidget {
  const _CelebrationDialog({required this.message, required this.pose, required this.confetti});

  final String message;
  final RukiPose pose;
  final bool confetti;

  @override
  State<_CelebrationDialog> createState() => _CelebrationDialogState();
}

class _CelebrationDialogState extends State<_CelebrationDialog> {
  final _controller = ConfettiController(duration: Motion.long * 2);

  @override
  void initState() {
    super.initState();
    if (widget.confetti) _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Stack(
      alignment: Alignment.center,
      children: [
        Dialog(
          // Column min agar dialog setinggi isinya, tidak memenuhi layar.
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [RukiView(pose: widget.pose, message: widget.message, size: Sizes.rukiSm)],
          ),
        ),
        if (widget.confetti)
          ExcludeSemantics(
            child: ConfettiWidget(
              confettiController: _controller,
              blastDirectionality: BlastDirectionality.explosive,
              numberOfParticles: 24,
              colors: [AppColors.seed, colors.sun],
            ),
          ),
      ],
    );
  }
}

/// Tombol "Serahkan": memuat, lalu berubah menjadi centang sebelum perayaan.
class TurnInButton extends StatefulWidget {
  const TurnInButton({super.key, required this.label, required this.onPressed, required this.successMessage});

  final String label;
  final Future<void> Function()? onPressed;
  final String successMessage;

  @override
  State<TurnInButton> createState() => _TurnInButtonState();
}

enum _TurnInState { idle, loading, done }

class _TurnInButtonState extends State<TurnInButton> {
  _TurnInState _state = _TurnInState.idle;

  Future<void> _press() async {
    setState(() => _state = _TurnInState.loading);
    try {
      await widget.onPressed!();
      if (!mounted) return;
      setState(() => _state = _TurnInState.done);
      await showCelebration(context, message: widget.successMessage);
    } on ApiException catch (e) {
      if (mounted) showMessage(context, e.message);
    } finally {
      if (mounted) setState(() => _state = _TurnInState.idle);
    }
  }

  @override
  Widget build(BuildContext context) {
    final child = switch (_state) {
      _TurnInState.idle => Text(widget.label, key: const ValueKey('label')),
      _TurnInState.loading => SizedBox.square(
        key: const ValueKey('loading'),
        dimension: Sizes.iconInChip,
        child: CircularProgressIndicator(strokeWidth: 2, semanticsLabel: widget.label),
      ),
      _TurnInState.done => const Icon(Symbols.check, key: ValueKey('done')),
    };

    return FilledButton(
      onPressed: widget.onPressed == null || _state != _TurnInState.idle ? null : _press,
      style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(Sizes.touchTarget)),
      child: AnimatedSwitcher(duration: Motion.short, child: child),
    );
  }
}
