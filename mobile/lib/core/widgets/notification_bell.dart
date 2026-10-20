import 'package:flutter_animate/flutter_animate.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

import '../copy/strings.dart';
import '../layout/breakpoints.dart';
import '../theme/app_colors.dart';
import '../theme/tokens.dart';

/// Lonceng dengan badge jumlah belum dibaca (brand.sun, teks brand.ink).
/// Bergoyang sekali saat jumlahnya bertambah; jumlah diumumkan lewat live region.
class NotificationBell extends StatefulWidget {
  const NotificationBell({super.key, required this.count, required this.onPressed});

  final int count;
  final VoidCallback onPressed;

  @override
  State<NotificationBell> createState() => _NotificationBellState();
}

class _NotificationBellState extends State<NotificationBell> {
  int _shakes = 0;

  @override
  void didUpdateWidget(NotificationBell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.count > oldWidget.count) _shakes++;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    Widget icon = Badge(
      isLabelVisible: widget.count > 0,
      backgroundColor: colors.sun,
      textColor: colors.onSun,
      label: Text(S.badgeCount(widget.count)),
      child: const Icon(Symbols.notifications),
    );
    if (_shakes > 0 && !context.reduceMotion) {
      icon = icon.animate(key: ValueKey(_shakes)).shake(hz: 4, rotation: 0.12, duration: Motion.long);
    }

    return Semantics(
      container: true,
      liveRegion: true,
      label: S.unreadNotifications(widget.count),
      child: IconButton(
        tooltip: S.navNotifications,
        onPressed: widget.onPressed,
        icon: ExcludeSemantics(child: icon),
      ),
    );
  }
}
