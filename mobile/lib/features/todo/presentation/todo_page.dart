import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/global_scaffold.dart';
import '../../../core/copy/strings.dart';
import '../../../core/layout/breakpoints.dart';
import '../../../core/models/paged.dart';
import '../../../core/models/post.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/async_view.dart';
import '../../../core/widgets/list_detail_layout.dart';
import '../../../core/widgets/ruki_view.dart';
import '../../../core/widgets/staggered.dart';
import '../../../core/widgets/todo_item.dart';
import '../../classwork/presentation/post_detail_page.dart';
import '../../courses/application/courses.dart';
import '../application/todo.dart';
import '../data/todo_repository.dart';
import 'course_filter.dart';

/// Layar 8: Daftar tugas siswa lintas kelas (alur inti 7). Di layar lebar,
/// detail tugas terbuka di panel kanan.
class TodoPage extends ConsumerStatefulWidget {
  const TodoPage({super.key});

  @override
  ConsumerState<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends ConsumerState<TodoPage> {
  int? _courseId;
  int? _selectedPostId;

  @override
  Widget build(BuildContext context) {
    final courses = ref.watch(courseListProvider(archived: false)).value ?? const [];
    final studentCourses = courses.where((c) => c.isStudent).toList();
    final selected = _selectedPostId;

    return GlobalScaffold(
      location: '/todo',
      title: const Text(S.navTodo),
      body: DefaultTabController(
        length: TodoTab.values.length,
        child: ListDetailLayout(
          detail: selected == null ? null : PostDetailPage(key: ValueKey(selected), postId: selected),
          list: (context, twoPane) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const TabBar(
                tabs: [
                  Tab(text: S.todoAssigned),
                  Tab(text: S.todoMissing),
                  Tab(text: S.todoDone),
                ],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(context.windowSize.pageGutter, Space.lg, context.windowSize.pageGutter, 0),
                child: CourseFilter(
                  courses: studentCourses,
                  value: _courseId,
                  onChanged: (id) => setState(() => _courseId = id),
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    for (final tab in TodoTab.values)
                      _TodoList(
                        tab: tab,
                        courseId: _courseId,
                        selectedPostId: twoPane ? selected : null,
                        onOpen: (post) =>
                            twoPane ? setState(() => _selectedPostId = post.id) : context.push('/p/${post.id}'),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TodoList extends ConsumerWidget {
  const _TodoList({required this.tab, required this.courseId, required this.selectedPostId, required this.onOpen});

  final TodoTab tab;
  final int? courseId;
  final int? selectedPostId;
  final ValueChanged<Post> onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = todoFeedProvider(tab, courseId);
    final feed = ref.watch(provider);
    final gutter = context.windowSize.pageGutter;

    Future<void> refresh() async {
      ref.invalidate(provider);
      await ref.read(provider.future);
    }

    return AsyncView(
      value: feed,
      onRetry: refresh,
      data: (state) {
        final children = state.items.isEmpty ? [_empty()] : _content(context, state);
        return RefreshIndicator(
          onRefresh: refresh,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(gutter),
            children: [
              ...children,
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
          ),
        );
      },
    );
  }

  Widget _empty() => switch (tab) {
    TodoTab.assigned => const RukiView(pose: RukiPose.sleep, message: S.emptyTodoAssigned),
    TodoTab.missing => const RukiView(pose: RukiPose.cheer, message: S.emptyTodoMissing),
    TodoTab.done => const RukiView(pose: RukiPose.read, message: S.emptyTodoDone),
  };

  List<Widget> _content(BuildContext context, PagedState<Post> state) {
    var index = 0;
    Widget item(Post post) => Padding(
      padding: const EdgeInsets.only(bottom: Space.sm),
      child: Staggered(
        index: index++,
        child: TodoItem(post: post, selected: post.id == selectedPostId, onTap: () => onOpen(post)),
      ),
    );

    if (tab == TodoTab.missing) {
      return [
        RukiView(pose: RukiPose.worried, message: S.missingWorried(state.total), size: Sizes.rukiSm),
        for (final post in state.items) item(post),
      ];
    }
    if (tab == TodoTab.done) return [for (final post in state.items) item(post)];

    // Ditugaskan: dikelompokkan per tenggat (docs/api.md, GET /todo).
    final textTheme = Theme.of(context).textTheme;
    return [
      for (final group in DueGroup.values)
        if (state.items.where((p) => dueGroupOf(p.dueAt) == group) case final posts when posts.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, Space.md, 0, Space.sm),
            child: Semantics(header: true, child: Text(S.dueGroups[group.name]!, style: textTheme.titleMedium)),
          ),
          for (final post in posts) item(post),
        ],
    ];
  }
}
