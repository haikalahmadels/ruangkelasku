import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

import '../copy/strings.dart';
import '../models/display_status.dart';
import '../theme/app_colors.dart';
import '../theme/tokens.dart';

/// Ikon + label status submission; warna tidak pernah menjadi satu-satunya penanda.
class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status, this.isLate = false});

  final DisplayStatus status;
  final bool isLate;

  static const _icons = {
    DisplayStatus.assigned: Symbols.assignment,
    DisplayStatus.missing: Symbols.error,
    DisplayStatus.turnedIn: Symbols.check_circle,
    DisplayStatus.graded: Symbols.edit_note,
    DisplayStatus.returned: Symbols.assignment_return,
  };

  static String label(DisplayStatus status) => S.statusLabels[_key(status)]!;

  static String _key(DisplayStatus status) => switch (status) {
    DisplayStatus.turnedIn => 'turned_in',
    _ => status.name,
  };

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final palette = colors.status[status]!;
    final textTheme = Theme.of(context).textTheme;

    final chip = AnimatedSwitcher(
      duration: Motion.short,
      switchInCurve: Motion.standard,
      child: DecoratedBox(
        key: ValueKey(status),
        decoration: BoxDecoration(color: palette.background, borderRadius: Radii.smAll),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Space.sm, vertical: Space.xs),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(_icons[status], size: Sizes.iconInChip, color: palette.foreground, fill: 1),
              const SizedBox(width: Space.xs),
              Flexible(
                child: Text(label(status), style: textTheme.labelMedium?.copyWith(color: palette.foreground)),
              ),
            ],
          ),
        ),
      ),
    );

    if (!isLate) return chip;

    // "Terlambat" sebagai teks kecil berwarna missing, bukan chip terpisah.
    return Wrap(
      spacing: Space.sm,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        chip,
        Text(S.late, style: textTheme.labelMedium?.copyWith(color: colors.late)),
      ],
    );
  }
}
