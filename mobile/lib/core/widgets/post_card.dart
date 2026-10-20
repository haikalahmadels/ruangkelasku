import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../copy/strings.dart';
import '../models/post.dart';
import '../theme/tokens.dart';
import '../utils/format.dart';
import 'user_avatar.dart';

IconData postTypeIcon(PostType type) => switch (type) {
  PostType.announcement => Symbols.campaign,
  PostType.material => Symbols.menu_book,
  PostType.assignment => Symbols.assignment,
  PostType.quiz => Symbols.quiz,
  PostType.question => Symbols.help,
};

String postTypeName(PostType type) => S.postTypeNames[type.name]!;

/// Kartu Forum. Pengumuman tampil penuh; item Tugas Kelas tampil ringkas
/// ("Rina memposting tugas baru: ...") seperti Google Classroom.
class PostCard extends StatelessWidget {
  const PostCard({super.key, required this.post, this.onTap});

  final Post post;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return post.type == PostType.announcement ? _announcement(context) : _classwork(context);
  }

  String _timeLabel() {
    if (post.status == PostStatus.scheduled && post.scheduledAt != null) {
      return S.scheduledAt(formatWib(post.scheduledAt!, 'd MMM, HH.mm'));
    }
    final at = post.publishedAt;
    return at == null ? '' : formatRelative(at);
  }

  Widget _announcement(BuildContext context) {
    final theme = Theme.of(context);
    final author = post.author;

    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(Space.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (author != null) UserAvatar(name: author.name, url: author.avatarUrl),
                  const SizedBox(width: Space.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(author?.name ?? '', style: theme.textTheme.titleMedium),
                        Text(
                          _timeLabel(),
                          style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (post.body != null) ...[const SizedBox(height: Space.md), ExpandableText(post.body!)],
              if (post.attachments.isNotEmpty) ...[
                const SizedBox(height: Space.md),
                Wrap(
                  spacing: Space.sm,
                  runSpacing: Space.sm,
                  children: [for (final a in post.attachments) AttachmentTile(attachment: a)],
                ),
              ],
              if ((post.commentCount ?? 0) > 0) ...[
                const Divider(height: Space.xl),
                Row(
                  children: [
                    Icon(Symbols.group, size: Sizes.iconInChip, color: theme.colorScheme.onSurfaceVariant),
                    const SizedBox(width: Space.sm),
                    Text(S.commentCount(post.commentCount!), style: theme.textTheme.labelLarge),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _classwork(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Card(
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: Space.lg, vertical: Space.sm),
        leading: CircleAvatar(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          child: Icon(postTypeIcon(post.type)),
        ),
        title: Text(S.postedNew(post.author?.name ?? '', postTypeName(post.type), post.title ?? '')),
        subtitle: Text(_timeLabel()),
      ),
    );
  }
}

/// Isi panjang dipotong 5 baris dengan tombol "Lihat selengkapnya".
class ExpandableText extends StatefulWidget {
  const ExpandableText(this.text, {super.key});

  final String text;

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyLarge;

    return LayoutBuilder(
      builder: (context, constraints) {
        final painter = TextPainter(
          text: TextSpan(text: widget.text, style: style),
          maxLines: Sizes.postPreviewLines,
          textDirection: Directionality.of(context),
          textScaler: MediaQuery.textScalerOf(context),
        )..layout(maxWidth: constraints.maxWidth);
        final overflows = painter.didExceedMaxLines;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.text,
              style: style,
              maxLines: _expanded ? null : Sizes.postPreviewLines,
              overflow: _expanded ? null : TextOverflow.fade,
            ),
            if (overflows && !_expanded)
              TextButton(onPressed: () => setState(() => _expanded = true), child: const Text(S.seeMore)),
          ],
        );
      },
    );
  }
}

/// Lampiran ringkas: ikon jenis, nama, ukuran; ketuk untuk membuka.
class AttachmentTile extends StatelessWidget {
  const AttachmentTile({super.key, required this.attachment, this.onRemove});

  final Attachment attachment;
  final VoidCallback? onRemove;

  IconData get _icon {
    if (!attachment.isFile) return Symbols.link;
    if (attachment.isImage) return Symbols.image;
    if (attachment.mimeType == 'application/pdf') return Symbols.picture_as_pdf;
    return Symbols.description;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = attachment.sizeBytes;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: Sizes.attachmentMaxWidth),
      child: Card.outlined(
        margin: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(borderRadius: Radii.mdAll),
        child: InkWell(
          onTap: () => launchUrl(Uri.parse(attachment.url), mode: LaunchMode.externalApplication),
          child: Padding(
            padding: const EdgeInsets.all(Space.sm),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(_icon, color: theme.colorScheme.primary),
                const SizedBox(width: Space.sm),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        attachment.displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelLarge,
                      ),
                      if (size != null) Text(formatFileSize(size), style: theme.textTheme.labelSmall),
                    ],
                  ),
                ),
                if (onRemove != null)
                  IconButton(tooltip: S.delete, icon: const Icon(Symbols.close), onPressed: onRemove),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
