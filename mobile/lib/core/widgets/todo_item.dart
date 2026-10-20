import 'package:material_ui/material_ui.dart';

import '../copy/strings.dart';
import '../models/display_status.dart';
import '../models/post.dart';
import '../theme/tokens.dart';
import '../utils/format.dart';
import 'post_card.dart';
import 'status_chip.dart';

/// Item Daftar tugas dan Tugas Anda: judul, nama kelas, tenggat, StatusChip.
/// Dibuka dengan ketuk; sengaja tanpa gestur geser (docs/design.md, Changelog 15 Okt).
class TodoItem extends StatelessWidget {
  const TodoItem({super.key, required this.post, required this.onTap, this.selected = false, this.showCourse = true});

  final Post post;
  final VoidCallback onTap;

  /// Disorot saat detailnya tampil di panel kanan.
  final bool selected;
  final bool showCourse;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final muted = theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant);
    final mine = post.mySubmission;
    final course = post.course;
    final grade = mine?.grade;

    return Semantics(
      selected: selected,
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: selected ? scheme.secondaryContainer : null,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(Space.lg),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: scheme.primary,
                  foregroundColor: scheme.onPrimary,
                  child: ExcludeSemantics(child: Icon(postTypeIcon(post.type))),
                ),
                const SizedBox(width: Space.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(post.title ?? '', style: theme.textTheme.titleMedium),
                      if (showCourse && course != null) Text(course.name, style: muted),
                      Text(post.dueAt == null ? S.noDue : formatDue(post.dueAt!), style: muted),
                      if (mine != null) ...[
                        const SizedBox(height: Space.sm),
                        Wrap(
                          spacing: Space.md,
                          runSpacing: Space.xs,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            StatusChip(status: mine.displayStatus, isLate: mine.isLate),
                            if (mine.displayStatus == DisplayStatus.returned && grade != null && post.points != null)
                              Text(S.gradeOutOf(formatGrade(grade), post.points!), style: theme.textTheme.labelLarge),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
