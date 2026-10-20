import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/copy/strings.dart';
import '../../../core/layout/breakpoints.dart';
import '../../../core/models/post.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/async_view.dart';
import '../../../core/widgets/classwork_item.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/widgets/form_widgets.dart';
import '../../../core/widgets/ruki_view.dart';
import '../../courses/application/courses.dart';
import '../../courses/data/course.dart';
import '../application/classwork.dart';
import 'topic_sheet.dart';

/// Layar 13: Tugas Kelas.
class ClassworkPage extends ConsumerWidget {
  const ClassworkPage({super.key, required this.courseId});

  final int courseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final course = ref.watch(courseProvider(courseId)).value;
    final classwork = ref.watch(classworkProvider(courseId));
    if (course == null) return const SkeletonList();

    final canCreate = course.isTeacher && !course.isArchived;
    final theme = Theme.of(context);

    return AsyncView(
      value: classwork,
      onRetry: () => ref.invalidate(classworkProvider(courseId)),
      data: (data) => RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(classworkProvider(courseId));
          await ref.read(classworkProvider(courseId).future);
        },
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: Sizes.contentMaxWidth),
            child: ListView(
              padding: EdgeInsets.all(context.windowSize.pageGutter),
              children: [
                if (canCreate) ...[
                  Wrap(
                    spacing: Space.sm,
                    runSpacing: Space.sm,
                    children: [
                      _CreateMenu(courseId: courseId),
                      TextButton.icon(
                        onPressed: () => showTopicSheet(context, courseId),
                        icon: const Icon(Symbols.label),
                        label: const Text(S.manageTopics),
                      ),
                    ],
                  ),
                  const SizedBox(height: Space.lg),
                ],
                if (data.hasNoPosts && data.groups.isEmpty)
                  RukiView(pose: RukiPose.read, message: course.isTeacher ? S.emptyClassworkTeacher : S.emptyClasswork),
                for (final post in data.noTopic) _Item(course: course, post: post),
                for (final group in data.groups) ...[
                  const SizedBox(height: Space.xl),
                  Semantics(
                    header: true,
                    child: Text(
                      group.topic.name,
                      style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.primary),
                    ),
                  ),
                  Divider(color: theme.colorScheme.primary),
                  for (final post in group.posts) _Item(course: course, post: post),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CreateMenu extends StatelessWidget {
  const _CreateMenu({required this.courseId});

  final int courseId;

  @override
  Widget build(BuildContext context) {
    void open(String type) => context.push('/c/$courseId/classwork/new?type=$type');

    return MenuAnchor(
      menuChildren: [
        MenuItemButton(
          leadingIcon: const Icon(Symbols.assignment),
          onPressed: () => open('assignment'),
          child: const Text(S.createAssignment),
        ),
        MenuItemButton(
          leadingIcon: const Icon(Symbols.quiz),
          onPressed: () => open('quiz'),
          child: const Text(S.createQuiz),
        ),
        MenuItemButton(
          leadingIcon: const Icon(Symbols.help),
          onPressed: () => open('question'),
          child: const Text(S.createQuestion),
        ),
        MenuItemButton(
          leadingIcon: const Icon(Symbols.menu_book),
          onPressed: () => open('material'),
          child: const Text(S.createMaterial),
        ),
        const Divider(),
        MenuItemButton(
          leadingIcon: const Icon(Symbols.label),
          onPressed: () => showTopicSheet(context, courseId, startAdding: true),
          child: const Text(S.createTopic),
        ),
      ],
      builder: (context, controller, _) => FilledButton.icon(
        onPressed: () => controller.isOpen ? controller.close() : controller.open(),
        icon: const Icon(Symbols.add),
        label: const Text(S.create),
      ),
    );
  }
}

class _Item extends ConsumerWidget {
  const _Item({required this.course, required this.post});

  final Course course;
  final Post post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actions = ref.read(classworkActionsProvider);

    Future<void> run(Future<void> Function() action, String? success) async {
      try {
        await action();
        if (success != null && context.mounted) showMessage(context, success);
      } on ApiException catch (e) {
        if (context.mounted) showMessage(context, e.message);
      }
    }

    final menu = course.isTeacher && !course.isArchived
        ? PopupMenuButton<void>(
            tooltip: S.more,
            icon: const Icon(Symbols.more_vert),
            itemBuilder: (_) => [
              if (post.status != PostStatus.published)
                PopupMenuItem(
                  onTap: () => run(() => actions.publish(post), S.assignmentCreated),
                  child: const Text(S.assignNow),
                ),
              PopupMenuItem(
                onTap: () async {
                  final ok = await showConfirmDialog(
                    context,
                    title: S.deletePostTitle(post.title ?? ''),
                    body: S.deletePostBody,
                    confirmLabel: S.delete,
                    destructive: true,
                  );
                  if (ok) await run(() => actions.deletePost(post), S.postDeleted);
                },
                child: const Text(S.delete),
              ),
            ],
          )
        : null;

    return ClassworkItem(post: post, menu: menu, onOpen: () => context.push('/p/${post.id}'));
  }
}
