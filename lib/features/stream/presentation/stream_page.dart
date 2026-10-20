import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/copy/strings.dart';
import '../../../core/layout/breakpoints.dart';
import '../../../core/models/post.dart';
import '../../../core/theme/course_themes.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/async_view.dart';
import '../../../core/widgets/class_code_display.dart';
import '../../../core/widgets/course_banner.dart';
import '../../../core/widgets/post_card.dart';
import '../../../core/widgets/ruki_view.dart';
import '../../../core/widgets/user_avatar.dart';
import '../../auth/application/session.dart';
import '../../courses/application/courses.dart';
import '../../courses/data/course.dart';
import '../application/stream.dart';

/// Layar 12: Forum kelas.
class StreamPage extends ConsumerWidget {
  const StreamPage({super.key, required this.courseId});

  final int courseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final course = ref.watch(courseProvider(courseId)).value;
    final feed = ref.watch(streamFeedProvider(courseId));
    if (course == null) return const SkeletonList();

    final size = context.windowSize;
    final gutter = size.pageGutter;

    Future<void> refresh() async {
      ref.invalidate(upcomingProvider(courseId));
      ref.invalidate(streamFeedProvider(courseId));
      await ref.read(streamFeedProvider(courseId).future);
    }

    final feedColumn = <Widget>[
      if (course.canPostToStream && !course.isArchived) _ComposerPrompt(courseId: courseId),
      // Data lama tetap tampil selama Forum dimuat ulang.
      if (feed.hasValue && feed.requireValue.posts.isEmpty)
        const RukiView(pose: RukiPose.read, message: S.emptyStream, size: Sizes.rukiSm)
      else if (feed.hasValue) ...[
        for (final post in feed.requireValue.posts) PostCard(post: post, onTap: () => context.push('/p/${post.id}')),
        if (feed.requireValue.hasMore)
          Center(
            child: feed.requireValue.loadingMore
                ? const CircularProgressIndicator()
                : TextButton(
                    onPressed: () => ref.read(streamFeedProvider(courseId).notifier).loadMore(),
                    child: const Text(S.loadMore),
                  ),
          ),
      ] else if (feed.hasError)
        ErrorView(error: feed.error!, onRetry: refresh)
      else
        const SizedBox(height: Sizes.rukiLg, child: SkeletonList(itemCount: 3)),
    ];

    return RefreshIndicator(
      onRefresh: refresh,
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: Sizes.contentMaxWidth),
          child: ListView(
            padding: EdgeInsets.all(gutter),
            children: [
              _CourseHeader(course: course),
              if (course.isArchived) ...[
                const SizedBox(height: Space.lg),
                const Card.filled(
                  child: ListTile(leading: Icon(Symbols.archive), title: Text(S.archivedBanner)),
                ),
              ],
              const SizedBox(height: Space.xl),
              if (size.isAtLeastExpanded)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: Sizes.sidePanelWidth,
                      child: _UpcomingCard(courseId: courseId),
                    ),
                    const SizedBox(width: Space.xl),
                    Expanded(child: _spaced(feedColumn)),
                  ],
                )
              else
                _spaced([_UpcomingCard(courseId: courseId), ...feedColumn]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _spaced(List<Widget> children) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      for (final (i, child) in children.indexed) ...[if (i > 0) const SizedBox(height: Space.md), child],
    ],
  );
}

/// Banner tema besar dengan nama kelas; guru melihat kode kelas.
class _CourseHeader extends StatelessWidget {
  const _CourseHeader({required this.course});

  final Course course;

  @override
  Widget build(BuildContext context) {
    final onHeader = CourseTheme.of(course.theme).onHeader;
    final text = Theme.of(context).textTheme.apply(bodyColor: onHeader, displayColor: onHeader);

    return Hero(
      tag: 'course-banner-${course.id}',
      child: CourseBanner(
        themeKey: course.theme,
        borderRadius: Radii.lgAll,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: Sizes.courseHeaderExpanded),
          child: Padding(
            padding: const EdgeInsets.all(Space.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(course.name, style: text.headlineMedium),
                if (course.section != null) Text(course.section!, style: text.titleMedium),
                if (course.room != null) Text(course.room!, style: text.bodyMedium),
                if (course.code != null) ...[
                  const SizedBox(height: Space.md),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: onHeader,
                      side: BorderSide(color: onHeader),
                    ),
                    icon: const Icon(Symbols.fullscreen),
                    label: Text('${S.classCode}: ${course.code}'),
                    onPressed: () => showClassCodeDialog(context, code: course.code!, className: course.name),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ComposerPrompt extends ConsumerWidget {
  const _ComposerPrompt({required this.courseId});

  final int courseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(sessionProvider).value;
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        onTap: () => context.push('/c/$courseId/announce'),
        child: Padding(
          padding: const EdgeInsets.all(Space.lg),
          child: Row(
            children: [
              if (user != null) UserAvatar(name: user.name, url: user.avatarUrl),
              const SizedBox(width: Space.md),
              Expanded(
                child: Text(
                  S.announceHint,
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Kartu "Mendatang": maksimal 3 tenggat terdekat.
class _UpcomingCard extends ConsumerWidget {
  const _UpcomingCard({required this.courseId});

  final int courseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final upcoming = ref.watch(upcomingProvider(courseId)).value ?? const <Post>[];
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Space.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(S.upcoming, style: theme.textTheme.titleMedium),
            const SizedBox(height: Space.sm),
            if (upcoming.isEmpty)
              Text(S.upcomingEmpty, style: theme.textTheme.bodyMedium)
            else
              for (final post in upcoming)
                Padding(
                  padding: const EdgeInsets.only(bottom: Space.sm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (post.dueAt != null)
                        Text(
                          formatDue(post.dueAt!),
                          style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                        ),
                      Text(post.title ?? '', style: theme.textTheme.bodyMedium),
                    ],
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
