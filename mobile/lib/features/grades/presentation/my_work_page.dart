import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/copy/strings.dart';
import '../../../core/layout/breakpoints.dart';
import '../../../core/models/display_status.dart';
import '../../../core/models/post.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/async_view.dart';
import '../../../core/widgets/ruki_view.dart';
import '../../../core/widgets/staggered.dart';
import '../../../core/widgets/status_chip.dart';
import '../../../core/widgets/todo_item.dart';
import '../application/grades.dart';

/// Layar 16: Tugas Anda, semua tugas siswa di satu kelas beserta status dan nilainya.
class MyWorkPage extends ConsumerStatefulWidget {
  const MyWorkPage({super.key, required this.courseId});

  final int courseId;

  @override
  ConsumerState<MyWorkPage> createState() => _MyWorkPageState();
}

class _MyWorkPageState extends ConsumerState<MyWorkPage> {
  /// `null` = semua status. "Dinilai (draf)" tergabung dengan Diserahkan.
  DisplayStatus? _filter;

  static const _filters = [
    DisplayStatus.assigned,
    DisplayStatus.missing,
    DisplayStatus.turnedIn,
    DisplayStatus.returned,
  ];

  bool _matches(Post post) {
    final status = post.mySubmission?.displayStatus;
    if (_filter == null) return true;
    if (_filter == DisplayStatus.turnedIn) return status == DisplayStatus.turnedIn || status == DisplayStatus.graded;
    return status == _filter;
  }

  @override
  Widget build(BuildContext context) {
    final work = ref.watch(myWorkProvider(widget.courseId));

    Future<void> refresh() async {
      ref.invalidate(myWorkProvider(widget.courseId));
      await ref.read(myWorkProvider(widget.courseId).future);
    }

    return AsyncView(
      value: work,
      onRetry: refresh,
      data: (posts) {
        if (posts.isEmpty) return const RukiView(pose: RukiPose.read, message: S.emptyMyWork);
        final shown = posts.where(_matches).toList();

        return RefreshIndicator(
          onRefresh: refresh,
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: Sizes.contentMaxWidth),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(context.windowSize.pageGutter),
                children: [
                  Wrap(
                    spacing: Space.sm,
                    runSpacing: Space.sm,
                    children: [
                      ChoiceChip(
                        label: const Text(S.filterAll),
                        selected: _filter == null,
                        onSelected: (_) => setState(() => _filter = null),
                      ),
                      for (final status in _filters)
                        ChoiceChip(
                          label: Text(StatusChip.label(status)),
                          selected: _filter == status,
                          onSelected: (_) => setState(() => _filter = status),
                        ),
                    ],
                  ),
                  const SizedBox(height: Space.lg),
                  if (shown.isEmpty)
                    const RukiView(pose: RukiPose.sleep, message: S.emptyMyWorkFilter, size: Sizes.rukiSm),
                  for (final (i, post) in shown.indexed)
                    Padding(
                      padding: const EdgeInsets.only(bottom: Space.sm),
                      child: Staggered(
                        index: i,
                        child: TodoItem(post: post, showCourse: false, onTap: () => context.push('/p/${post.id}')),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
