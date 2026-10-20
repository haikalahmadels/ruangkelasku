import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

import '../copy/strings.dart';
import '../theme/tokens.dart';
import 'form_widgets.dart';

/// Layar 18: kode kelas layar penuh untuk diproyeksikan di depan kelas.
Future<void> showClassCodeDialog(BuildContext context, {required String code, required String className}) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) {
      final theme = Theme.of(dialogContext);
      return Dialog.fullscreen(
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              tooltip: S.close,
              icon: const Icon(Symbols.close),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            title: Text(className),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(Space.xl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(S.classCode, style: theme.textTheme.titleLarge),
                  const SizedBox(height: Space.lg),
                  FittedBox(
                    child: SelectableText(
                      code,
                      style: theme.textTheme.displayLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w700,
                        letterSpacing: Space.md,
                      ),
                    ),
                  ),
                  const SizedBox(height: Space.xl),
                  FilledButton.tonalIcon(
                    icon: const Icon(Symbols.content_copy),
                    label: const Text(S.copy),
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(text: code));
                      if (dialogContext.mounted) showMessage(dialogContext, S.copied);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
