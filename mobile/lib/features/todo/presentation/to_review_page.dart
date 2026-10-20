import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/global_scaffold.dart';
import '../../../core/copy/strings.dart';
import '../../../core/layout/breakpoints.dart';
import '../../../core/models/post.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/async_view.dart';
import '../../../core/widgets/post_card.dart';
import '../../../core/widgets/ruki_view.dart';
import '../../../core/widgets/staggered.dart';
import '../../courses/application/courses.dart';
import '../application/todo.dart';
import 'course_filter.dart';

/// Layar 9: Perlu diperiksa, tugas di semua kelas tempat pengguna mengajar (alur inti 8).
class ToReviewPage extends ConsumerStatefulWidget {
  const ToReviewPage({super.key});

  @override
  ConsumerState<ToReviewPage> createState() => _ToReviewPageState();
}

class _ToReviewPageState extends ConsumerState<ToReviewPage> {
  int? _courseId;

  @override
  Widget build(BuildContext context) {
    final courses = ref.watch(courseListProvider(archived: false)).value ?? const [];
    final provider = toReviewFeedProvider(_courseId);
    final feed = ref.watch(provider);
    final gutter = context.windowSize.pageGutter;

    Future<void> refresh() async {
      ref.invalidate(provider);
      await ref.read(provider.future);
    }

    return GlobalScaffold(
      location: '/to-review',
      title: const Text(S.navToReview),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(gutter),
          children: [
            CourseFilter(
              courses: courses.where((c) => c.isTeacher).toList(),
              value: _courseId,
              onChanged: (id) => setState(() => _courseId = id),
            ),
            const SizedBox(height: Space.lg),
            AsyncView(
              value: feed,
              onRetry: refresh,
              skeleton: const SizedBox(height: Sizes.rukiLg * 2, child: SkeletonList(itemCount: 4)),
              data: (state) {
                if (state.items.isEmpty) return const RukiView(pose: RukiPose.read, message: S.emptyToReview);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final (i, post) in state.items.indexed)
                      Padding(
                        padding: const EdgeInsets.only(bottom: Space.sm),
                        child: Staggered(
                          index: i,
                          child: _ReviewCard(post: post, onTap: () => context.push('/p/${post.id}/submissions')),
                        ),
                      ),
                    if (state.hasMore)
                      Center(
                        child: state.loadingMore
                            ? const CircularProgressIndicator()
                            : TextButton(
                                onPressed: () => ref.read(provider.notifier).loadMore(),
                                child: const Text(S.loadMore),
                              ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Judul tugas dan kelasnya, lalu tiga hitungan besar seperti Google Classroom.
class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.post, required this.onTap});

  final Post post;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final muted = theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant);
    final counts = post.submissionCounts;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(Space.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
                        if (post.course != null) Text(post.course!.name, style: muted),
                        Text(post.dueAt == null ? S.noDue : formatDue(post.dueAt!), style: muted),
                      ],
                    ),
                  ),
                ],
              ),
              if (counts != null) ...[
                const SizedBox(height: Space.lg),
                Wrap(
                  spacing: Space.xxl,
                  runSpacing: Space.md,
                  children: [
                    _Count(counts.turnedIn + counts.graded, S.countTurnedInLabel),
                    _Count(counts.assigned, S.countAssignedLabel),
                    _Count(counts.returned, S.countGradedLabel),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Count extends StatelessWidget {
  const _Count(this.value, this.label);

  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return MergeSemantics(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$value', style: textTheme.headlineSmall),
          Text(label, style: textTheme.labelMedium),
        ],
      ),
    );
  }
}
