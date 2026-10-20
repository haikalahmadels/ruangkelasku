import 'package:flutter/foundation.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

import '../copy/strings.dart';
import '../utils/uploads.dart';
import 'form_widgets.dart';

/// Menu "Tambahkan": unggah file, ambil foto (hanya Android), atau link.
/// File di atas 10 MB ditolak di sini sebelum dikirim.
class AddAttachmentMenu extends StatelessWidget {
  const AddAttachmentMenu({
    super.key,
    required this.label,
    required this.onFiles,
    required this.onLink,
    this.enabled = true,
  });

  final String label;
  final Future<void> Function(List<PickedUpload> files) onFiles;
  final Future<void> Function(String url) onLink;
  final bool enabled;

  Future<void> _deliver(BuildContext context, List<PickedUpload> files) async {
    final ok = [
      for (final f in files)
        if (f.size <= maxUploadBytes) f,
    ];
    for (final f in files.where((f) => f.size > maxUploadBytes)) {
      if (context.mounted) showMessage(context, S.fileTooLarge(f.name));
    }
    if (ok.isNotEmpty) await onFiles(ok);
  }

  Future<void> _askLink(BuildContext context) async {
    final controller = TextEditingController();
    final url = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(S.addLink),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: TextInputType.url,
          decoration: const InputDecoration(labelText: S.linkUrl, hintText: 'https://'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text(S.cancel)),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, controller.text.trim()),
            child: const Text(S.addLink),
          ),
        ],
      ),
    );
    controller.dispose();
    if (url == null || url.isEmpty) return;
    await onLink(url.startsWith('http') ? url : 'https://$url');
  }

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      menuChildren: [
        MenuItemButton(
          leadingIcon: const Icon(Symbols.upload_file),
          onPressed: () async {
            final files = await pickDocuments();
            if (context.mounted) await _deliver(context, files);
          },
          child: const Text(S.addFile),
        ),
        // Kamera hanya diandalkan di Android (docs/design.md, Catatan Chrome).
        if (!kIsWeb)
          MenuItemButton(
            leadingIcon: const Icon(Symbols.photo_camera),
            onPressed: () async {
              final photo = await takePhoto();
              if (photo != null && context.mounted) await _deliver(context, [photo]);
            },
            child: const Text(S.takePhoto),
          ),
        MenuItemButton(
          leadingIcon: const Icon(Symbols.link),
          onPressed: () => _askLink(context),
          child: const Text(S.addLink),
        ),
      ],
      builder: (context, controller, _) => OutlinedButton.icon(
        onPressed: enabled ? () => controller.isOpen ? controller.close() : controller.open() : null,
        icon: const Icon(Symbols.add),
        label: Text(label),
      ),
    );
  }
}
