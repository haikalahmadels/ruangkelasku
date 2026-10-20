import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

import '../copy/strings.dart';
import '../models/post.dart';
import '../theme/tokens.dart';
import '../utils/format.dart';
import 'post_card.dart';
import 'status_chip.dart';

/// Item Tugas Kelas: ikon jenis, judul, tenggat atau tanggal posting.
/// Ketuk untuk meluas; guru melihat hitungan diserahkan/ditugaskan.
class ClassworkItem extends StatelessWidget {
  const ClassworkItem({super.key, required this.post, required this.onOpen, this.menu});

  final Post post;
  final VoidCallback onOpen;
  final Widget? menu;

  String get _trailing {
    if (post.status == PostStatus.draft) return S.draft;
    if (post.status == PostStatus.scheduled && post.scheduledAt != null) {
      return S.scheduledAt(formatWib(post.scheduledAt!, 'd MMM, HH.mm'));
    }
    if (post.dueAt != null) return formatDue(post.dueAt!);
    return post.publishedAt == null ? '' : S.postedOn(formatWib(post.publishedAt!, 'd MMM'));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final unpublished = post.status != PostStatus.published;
    final counts = post.submissionCounts;
    final mine = post.mySubmission;

    return ExpansionTile(
      leading: CircleAvatar(
        backgroundColor: unpublished ? scheme.surfaceContainerHighest : scheme.primary,
        foregroundColor: unpublished ? scheme.onSurfaceVariant : scheme.onPrimary,
        child: Icon(postTypeIcon(post.type)),
      ),
      title: Text(post.title ?? '', style: theme.textTheme.titleMedium),
      subtitle: Text(_trailing, style: theme.textTheme.labelMedium?.copyWith(color: scheme.onSurfaceVariant)),
      trailing: menu,
      shape: const RoundedRectangleBorder(borderRadius: Radii.mdAll),
      collapsedShape: const RoundedRectangleBorder(borderRadius: Radii.mdAll),
      childrenPadding: const EdgeInsets.fromLTRB(Space.lg, 0, Space.lg, Space.lg),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (mine != null) ...[
          StatusChip(status: mine.displayStatus, isLate: mine.isLate),
          const SizedBox(height: Space.sm),
        ],
        if (post.body != null) ...[
          Text(post.body!, maxLines: 3, overflow: TextOverflow.ellipsis, style: theme.textTheme.bodyMedium),
          const SizedBox(height: Space.sm),
        ],
        if (counts != null)
          Wrap(
            spacing: Space.xl,
            runSpacing: Space.sm,
            children: [
              _Count(S.countTurnedIn(counts.turnedIn + counts.graded)),
              _Count(S.countAssigned(counts.assigned)),
              _Count(S.countGraded(counts.returned)),
            ],
          ),
        const SizedBox(height: Space.sm),
        TextButton.icon(
          onPressed: onOpen,
          icon: const Icon(Symbols.open_in_new),
          label: const Text(S.viewInstructions),
        ),
      ],
    );
  }
}

class _Count extends StatelessWidget {
  const _Count(this.label);

  final String label;

  @override
  Widget build(BuildContext context) => Text(label, style: Theme.of(context).textTheme.labelLarge);
}
