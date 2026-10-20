import 'package:material_ui/material_ui.dart';

import '../copy/strings.dart';
import '../theme/tokens.dart';

/// Pola dua panel (docs/design.md): daftar di kiri, detail di kanan bila area konten
/// cukup lebar; di layar sempit hanya daftar, dan item dibuka sebagai halaman baru.
class ListDetailLayout extends StatelessWidget {
  const ListDetailLayout({super.key, required this.list, required this.detail});

  /// `twoPane` menentukan apakah ketukan item memilih detail atau membuka halaman.
  final Widget Function(BuildContext context, bool twoPane) list;

  /// `null` bila belum ada item yang dipilih.
  final Widget? detail;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < Sizes.listDetailMinWidth) return list(context, false);

        final theme = Theme.of(context);
        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(width: Sizes.listPaneWidth, child: list(context, true)),
            const VerticalDivider(width: 1),
            Expanded(
              child: detail == null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(Space.xl),
                        child: Text(
                          S.selectItem,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                        ),
                      ),
                    )
                  : _Pane(child: detail!),
            ),
          ],
        );
      },
    );
  }
}

/// Halaman detail di panel kanan melihat lebar panel, bukan lebar layar,
/// sehingga tata letaknya sendiri ikut menyesuaikan.
class _Pane extends StatelessWidget {
  const _Pane({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => MediaQuery(
        data: MediaQuery.of(context).copyWith(size: constraints.biggest),
        child: child,
      ),
    );
  }
}
