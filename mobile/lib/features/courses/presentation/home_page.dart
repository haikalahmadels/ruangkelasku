import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/global_scaffold.dart';
import '../../../core/copy/strings.dart';
import '../../../core/layout/breakpoints.dart';
import '../../../core/models/display_status.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/async_view.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/widgets/course_banner.dart';
import '../../../core/widgets/form_widgets.dart';
import '../../../core/widgets/ruki_view.dart';
import '../../../core/widgets/staggered.dart';
import '../application/courses.dart';
import '../data/course.dart';
import 'course_card.dart';

/// Layar 4: Beranda (daftar kelas dan undangan).
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courses = ref.watch(courseListProvider(archived: false));
    final invitations = ref.watch(myInvitationsProvider).value ?? const [];

    Future<void> refresh() async {
      ref.invalidate(myInvitationsProvider);
      ref.invalidate(courseListProvider(archived: false));
      await ref.read(courseListProvider(archived: false).future);
    }

    return GlobalScaffold(
      location: '/',
      title: const Text(S.appName),
      actions: const [_AddClassMenu()],
      body: AsyncView(
        value: courses,
        onRetry: refresh,
        skeleton: const _CourseGridSkeleton(),
        data: (list) {
          if (list.isEmpty && invitations.isEmpty) {
            return RukiView(
              pose: RukiPose.read,
              message: S.emptyClasses,
              actionLabel: S.joinClass,
              onAction: () => context.push('/join'),
            );
          }
          return RefreshIndicator(
            onRefresh: refresh,
            child: ListView(
              padding: EdgeInsets.all(context.windowSize.pageGutter),
              children: [
                if (invitations.isNotEmpty) ...[
                  _InvitationList(invitations: invitations),
                  const SizedBox(height: Space.xl),
                ],
                CourseGrid(
                  children: [
                    for (final (i, course) in list.indexed)
                      Staggered(
                        index: i,
                        child: _HomeCourseCard(course: course),
                      ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _HomeCourseCard extends ConsumerWidget {
  const _HomeCourseCard({required this.course});

  final Course course;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actions = ref.read(courseActionsProvider);

    Future<void> run(Future<void> Function() action, String? success) async {
      try {
        await action();
        if (success != null && context.mounted) showMessage(context, success);
      } on ApiException catch (e) {
        if (context.mounted) showMessage(context, e.message);
      }
    }

    return CourseCard(
      course: course,
      onTap: () => context.go('/c/${course.id}/stream'),
      menu: [
        if (course.isOwner)
          CourseMenuItem(S.archive, () async {
            final ok = await showConfirmDialog(
              context,
              title: S.archiveTitle(course.name),
              body: S.archiveBody,
              confirmLabel: S.archive,
            );
            if (ok) await run(() => actions.archive(course.id), S.archived);
          })
        else
          CourseMenuItem(S.leaveClass, () async {
            final ok = await showConfirmDialog(
              context,
              title: S.leaveTitle(course.name),
              body: S.leaveBody,
              confirmLabel: S.leaveClass,
              destructive: true,
            );
            if (ok) await run(() => actions.leave(course.id), null);
          }),
      ],
    );
  }
}

class _InvitationList extends ConsumerWidget {
  const _InvitationList({required this.invitations});

  final List<Invitation> invitations;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final actions = ref.read(courseActionsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(S.invitationsTitle, style: textTheme.titleMedium),
        const SizedBox(height: Space.sm),
        for (final invitation in invitations)
          Padding(
            padding: const EdgeInsets.only(bottom: Space.sm),
            child: Card(
              child: Row(
                children: [
                  CourseBanner(
                    themeKey: invitation.course?.theme ?? 'forest',
                    child: const SizedBox(width: Space.sm, height: Sizes.courseCardHeader),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(Space.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(invitation.course?.name ?? '', style: textTheme.titleMedium),
                          Text(
                            S.invitedAs(invitation.invitedBy?.name ?? '', invitation.role == CourseRole.teacher),
                            style: textTheme.bodyMedium,
                          ),
                          const SizedBox(height: Space.sm),
                          Wrap(
                            spacing: Space.sm,
                            children: [
                              FilledButton(
                                onPressed: () async {
                                  try {
                                    final course = await actions.acceptInvitation(invitation.id);
                                    if (context.mounted) await showJoinedDialog(context, course);
                                  } on ApiException catch (e) {
                                    if (context.mounted) showMessage(context, e.message);
                                  }
                                },
                                child: const Text(S.accept),
                              ),
                              TextButton(
                                onPressed: () async {
                                  try {
                                    await actions.declineInvitation(invitation.id);
                                  } on ApiException catch (e) {
                                    if (context.mounted) showMessage(context, e.message);
                                  }
                                },
                                child: const Text(S.decline),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// Perayaan bergabung: Ruki melambai, lalu buka kelas.
Future<void> showJoinedDialog(BuildContext context, Course course) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) => Dialog(
      child: Padding(
        padding: const EdgeInsets.all(Space.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RukiView(pose: RukiPose.wave, message: S.joinedTitle(course.name), size: Sizes.rukiSm),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.go('/c/${course.id}/stream');
              },
              child: const Text(S.openClassButton),
            ),
          ],
        ),
      ),
    ),
  );
}

class _AddClassMenu extends StatelessWidget {
  const _AddClassMenu();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: S.addClass,
      icon: const Icon(Symbols.add),
      onSelected: context.push,
      itemBuilder: (_) => const [
        PopupMenuItem(value: '/join', child: Text(S.joinClass)),
        PopupMenuItem(value: '/courses/new', child: Text(S.createClass)),
      ],
    );
  }
}

class _CourseGridSkeleton extends StatelessWidget {
  const _CourseGridSkeleton();

  @override
  Widget build(BuildContext context) => const SkeletonList(itemCount: 4);
}
