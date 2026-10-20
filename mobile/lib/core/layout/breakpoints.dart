import 'package:flutter/widgets.dart';

import '../theme/tokens.dart';

/// Window size class Material 3 (docs/design.md, bagian Responsif dan platform).
enum WindowSize {
  compact,
  medium,
  expanded,
  large;

  static WindowSize fromWidth(double width) {
    if (width < 600) return compact;
    if (width < 840) return medium;
    if (width < 1200) return expanded;
    return large;
  }

  bool get isCompact => this == compact;
  bool get isAtLeastMedium => index >= medium.index;
  bool get isAtLeastExpanded => index >= expanded.index;

  /// Jumlah kolom grid kartu kelas.
  int get courseGridColumns => index + 1;

  double get pageGutter => isCompact ? Space.lg : Space.xl;
}

extension WindowSizeContext on BuildContext {
  WindowSize get windowSize => WindowSize.fromWidth(MediaQuery.sizeOf(this).width);

  bool get reduceMotion => MediaQuery.disableAnimationsOf(this);
}
