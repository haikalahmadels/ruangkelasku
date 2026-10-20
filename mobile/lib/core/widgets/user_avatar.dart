import 'package:material_ui/material_ui.dart';

import '../copy/strings.dart';
import '../theme/tokens.dart';

/// Foto profil, atau inisial di atas warna tonal bila belum ada foto.
class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key, required this.name, this.url, this.size = Sizes.avatarMd});

  final String name;
  final String? url;
  final double size;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final initial = name.trim().isEmpty ? '?' : name.trim()[0].toUpperCase();

    return Semantics(
      label: S.avatarOf(name),
      image: true,
      child: CircleAvatar(
        radius: size / 2,
        backgroundColor: scheme.primaryContainer,
        foregroundColor: scheme.onPrimaryContainer,
        foregroundImage: url == null ? null : NetworkImage(url!),
        child: ExcludeSemantics(
          child: Text(
            initial,
            style: TextStyle(fontSize: size * 0.42, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
