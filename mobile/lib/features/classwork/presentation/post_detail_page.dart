import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/copy/strings.dart';
import '../../../core/layout/breakpoints.dart';
import '../../../core/models/post.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/async_view.dart';
import '../../../core/widgets/comment_thread.dart';
import '../../../core/widgets/post_card.dart';
import '../../../core/widgets/status_chip.dart';
import '../../courses/application/courses.dart';
import '../../courses/data/course.dart';
import '../../submissions/application/submissions.dart';
import '../../submissions/presentation/student_work_view.dart';
import '../../submissions/presentation/submission_panel.dart';
import '../application/classwork.dart';

/// Layar 24, 25, dan 28 berbagi rute `/p/:postId`; isinya bercabang menurut peran.
class PostDetailPage extends ConsumerWidget {
  const PostDetailPage({super.key, required this.postId, this.studentWork = false});

  final int postId;

  /// Tab "Tugas siswa" untuk guru (`/p/:postId/submissions`).
  final bool studentWork;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final post = ref.watch(postProvider(postId));
    final course = post.hasValue ? ref.watch(courseProvider(post.requireValue.courseId)) : null;

    if (post.hasError) {
      return Scaffold(
        appBar: AppBar(),
        body: ErrorView(error: post.error!, onRetry: () => ref.invalidate(postProvider(postId))),
      );
    }
    if (!post.hasValue || course == null || !course.hasValue) {
      return Scaffold(appBar: AppBar(), body: const SkeletonList());
    }

    final p = post.requireValue;
    final c = course.requireValue;
    final title = Text(postTypeName(p.type));

    if (c.isTeacher && p.type.hasSubmissions) {
      return DefaultTabController(
        key: ValueKey(studentWork),
        length: 2,
        initialIndex: studentWork ? 1 : 0,
        child: Scaffold(
          appBar: AppBar(
            title: title,
            bottom: TabBar(
              onTap: (i) => context.replace(i == 0 ? '/p/$postId' : '/p/$postId/submissions'),
              tabs: const [
                Tab(text: S.tabInstructions),
                Tab(text: S.tabStudentWork),
              ],
            ),
          ),
          body: studentWork ? StudentWorkView(post: p) : _Instructions(post: p, course: c),
        ),
      );
    }

    if (c.isStudent && p.type.hasSubmissions) {
      if (context.windowSize.isAtLeastExpanded) {
        return Scaffold(
          appBar: AppBar(title: title),
          body: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: Sizes.contentMaxWidth),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _Instructions(post: p, course: c),
                  ),
                  SizedBox(
                    width: Sizes.sidePanelWidth + Space.xxl * 2,
                    child: ListView(
                      padding: const EdgeInsets.all(Space.lg),
                      children: [SubmissionPanel(post: p, course: c)],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
      return Scaffold(
        appBar: AppBar(title: title),
        body: _Instructions(post: p, course: c),
        bottomNavigationBar: _YourWorkBar(post: p, course: c),
      );
    }

    return Scaffold(
      appBar: AppBar(title: title),
      body: _Instructions(post: p, course: c),
    );
  }
}

/// Petunjuk: judul, info poin dan tenggat, isi, lampiran, komentar kelas.
class _Instructions extends ConsumerWidget {
  const _Instructions({required this.post, required this.course});

  final Post post;
  final Course course;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final comments = ref.watch(commentsProvider(post.id));
    final canComment =
        post.status == PostStatus.published &&
        !course.isArchived &&
        (course.isTeacher || course.streamPermission != 'teacher_only');
    final meta = theme.textTheme.labelLarge?.copyWith(color: scheme.onSurfaceVariant);

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: Sizes.contentMaxWidth),
        child: ListView(
          padding: EdgeInsets.all(context.windowSize.pageGutter),
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: scheme.primary,
                  foregroundColor: scheme.onPrimary,
                  child: Icon(postTypeIcon(post.type)),
                ),
                const SizedBox(width: Space.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(post.title ?? post.author?.name ?? '', style: theme.textTheme.headlineSmall),
                      Text(
                        [
                          post.author?.name,
                          if (post.publishedAt != null) formatWib(post.publishedAt!, 'd MMM'),
                        ].whereType<String>().join(', '),
                        style: meta,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (post.points != null || post.dueAt != null) ...[
              const SizedBox(height: Space.md),
              Wrap(
                spacing: Space.xl,
                runSpacing: Space.xs,
                children: [
                  if (post.points != null) Text(S.pointsLabel(post.points!), style: meta),
                  if (post.dueAt != null) Text(formatDue(post.dueAt!), style: meta),
                ],
              ),
            ],
            if (post.mySubmission != null && context.windowSize.isCompact) ...[
              const SizedBox(height: Space.md),
              Align(
                alignment: Alignment.centerLeft,
                child: StatusChip(status: post.mySubmission!.displayStatus, isLate: post.mySubmission!.isLate),
              ),
            ],
            Divider(height: Space.xxl, color: scheme.primary),
            if (post.body != null) SelectableText(post.body!, style: theme.textTheme.bodyLarge),
            if (post.attachments.isNotEmpty) ...[
              const SizedBox(height: Space.lg),
              Wrap(
                spacing: Space.sm,
                runSpacing: Space.sm,
                children: [for (final a in post.attachments) AttachmentTile(attachment: a)],
              ),
            ],
            const Divider(height: Space.xxl),
            Row(
              children: [
                Icon(Symbols.group, color: scheme.onSurfaceVariant),
                const SizedBox(width: Space.sm),
                Text(S.classComments, style: theme.textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: Space.sm),
            AsyncView(
              value: comments,
              onRetry: () => ref.invalidate(commentsProvider(post.id)),
              skeleton: const SizedBox.shrink(),
              data: (list) => CommentThread(
                comments: list,
                hint: S.addClassComment,
                enabled: canComment,
                onSend: (body) => ref.read(classworkActionsProvider).addComment(post, body),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Compact: ringkasan "Tugas Anda" di bawah; ketuk untuk membuka panel lengkap.
class _YourWorkBar extends ConsumerWidget {
  const _YourWorkBar({required this.post, required this.course});

  final Post post;
  final Course course;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mine = ref.watch(mySubmissionProvider(post.id)).value;
    final theme = Theme.of(context);

    return SafeArea(
      child: Material(
        color: theme.colorScheme.surfaceContainer,
        child: InkWell(
          onTap: () => showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            builder: (_) => DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.6,
              maxChildSize: 0.95,
              builder: (context, controller) => ListView(
                controller: controller,
                // Kolom jawaban Pertanyaan tidak tertutup keyboard.
                padding: EdgeInsets.fromLTRB(Space.lg, 0, Space.lg, Space.lg + MediaQuery.viewInsetsOf(context).bottom),
                children: [SubmissionPanel(post: post, course: course, flat: true)],
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(Space.lg),
            child: Row(
              children: [
                Expanded(child: Text(S.yourWork, style: theme.textTheme.titleMedium)),
                if (mine != null) StatusChip(status: mine.displayStatus, isLate: mine.isLate),
                const SizedBox(width: Space.sm),
                const Icon(Symbols.expand_less),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
