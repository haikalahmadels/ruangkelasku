import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/global_scaffold.dart';
import '../../../core/copy/strings.dart';
import '../../../core/layout/breakpoints.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/widgets/async_view.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/widgets/form_widgets.dart';
import '../../../core/widgets/ruki_view.dart';
import '../application/courses.dart';
import 'course_card.dart';

/// Layar 7: Kelas yang diarsipkan (alur inti 10: pulihkan).
class ArchivedPage extends ConsumerWidget {
  const ArchivedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courses = ref.watch(courseListProvider(archived: true));
    final actions = ref.read(courseActionsProvider);

    Future<void> run(Future<void> Function() action, String? success) async {
      try {
        await action();
        if (success != null && context.mounted) showMessage(context, success);
      } on ApiException catch (e) {
        if (context.mounted) showMessage(context, e.message);
      }
    }

    return GlobalScaffold(
      location: '/archived',
      title: const Text(S.navArchived),
      body: AsyncView(
        value: courses,
        onRetry: () => ref.invalidate(courseListProvider(archived: true)),
        data: (list) {
          if (list.isEmpty) return const RukiView(pose: RukiPose.sleep, message: S.emptyArchived);
          return ListView(
            padding: EdgeInsets.all(context.windowSize.pageGutter),
            children: [
              CourseGrid(
                children: [
                  for (final course in list)
                    CourseCard(
                      course: course,
                      onTap: () => context.go('/c/${course.id}/stream'),
                      menu: [
                        if (course.isOwner) ...[
                          CourseMenuItem(S.restore, () => run(() => actions.restore(course.id), S.restored)),
                          CourseMenuItem(S.delete, () async {
                            final ok = await showConfirmDialog(
                              context,
                              title: S.deleteTitle(course.name),
                              body: S.deleteBody,
                              confirmLabel: S.delete,
                              destructive: true,
                            );
                            if (ok) await run(() => actions.delete(course.id), null);
                          }),
                        ],
                      ],
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
