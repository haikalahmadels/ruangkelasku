import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/models/post.dart';
import '../../auth/application/session.dart';
import '../data/stream_repository.dart';

part 'stream.g.dart';

class StreamState {
  const StreamState({required this.posts, required this.page, required this.hasMore, this.loadingMore = false});

  final List<Post> posts;
  final int page;
  final bool hasMore;
  final bool loadingMore;

  StreamState copyWith({List<Post>? posts, int? page, bool? hasMore, bool? loadingMore}) => StreamState(
    posts: posts ?? this.posts,
    page: page ?? this.page,
    hasMore: hasMore ?? this.hasMore,
    loadingMore: loadingMore ?? this.loadingMore,
  );
}

/// Forum kelas berpaginasi; halaman berikutnya dimuat lewat tombol "Muat lainnya".
@riverpod
class StreamFeed extends _$StreamFeed {
  @override
  Future<StreamState> build(int courseId) async {
    ref.watch(currentUserIdProvider);
    final first = await ref.watch(streamRepositoryProvider).stream(courseId);
    return StreamState(posts: first.items, page: 1, hasMore: first.hasMore);
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.loadingMore) return;

    state = AsyncData(current.copyWith(loadingMore: true));
    final next = await ref.read(streamRepositoryProvider).stream(courseId, page: current.page + 1);
    if (!ref.mounted) return;
    state = AsyncData(
      StreamState(posts: [...current.posts, ...next.items], page: next.currentPage, hasMore: next.hasMore),
    );
  }
}

@riverpod
Future<List<Post>> upcoming(Ref ref, int courseId) {
  ref.watch(currentUserIdProvider);
  return ref.watch(streamRepositoryProvider).upcoming(courseId);
}

class StreamActions {
  StreamActions(this._ref);

  final Ref _ref;

  Future<void> announce(int courseId, {required String body, DateTime? scheduledAt}) async {
    await _ref.read(streamRepositoryProvider).announce(courseId, body: body, scheduledAt: scheduledAt);
    _ref.invalidate(streamFeedProvider(courseId));
  }
}

/// keepAlive: dipakai setelah `await` di widget, jadi tidak boleh ikut dibuang otomatis.
@Riverpod(keepAlive: true)
StreamActions streamActions(Ref ref) => StreamActions(ref);
