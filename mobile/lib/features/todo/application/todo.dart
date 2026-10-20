import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/models/paged.dart';
import '../../../core/models/post.dart';
import '../../auth/application/session.dart';
import '../data/todo_repository.dart';

part 'todo.g.dart';

/// Satu tab Daftar tugas; [courseId] null berarti semua kelas.
@riverpod
class TodoFeed extends _$TodoFeed {
  @override
  Future<PagedState<Post>> build(TodoTab tab, int? courseId) async {
    ref.watch(currentUserIdProvider);
    return PagedState.first(await ref.watch(todoRepositoryProvider).todo(tab, courseId: courseId));
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.loadingMore) return;

    state = AsyncData(current.copyWith(loadingMore: true));
    final next = await ref.read(todoRepositoryProvider).todo(tab, courseId: courseId, page: current.page + 1);
    if (!ref.mounted) return;
    state = AsyncData(current.append(next));
  }
}

/// Perlu diperiksa (guru); [courseId] null berarti semua kelas.
@riverpod
class ToReviewFeed extends _$ToReviewFeed {
  @override
  Future<PagedState<Post>> build(int? courseId) async {
    ref.watch(currentUserIdProvider);
    return PagedState.first(await ref.watch(todoRepositoryProvider).toReview(courseId: courseId));
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.loadingMore) return;

    state = AsyncData(current.copyWith(loadingMore: true));
    final next = await ref.read(todoRepositoryProvider).toReview(courseId: courseId, page: current.page + 1);
    if (!ref.mounted) return;
    state = AsyncData(current.append(next));
  }
}
