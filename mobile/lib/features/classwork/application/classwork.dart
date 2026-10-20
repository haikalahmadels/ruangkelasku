import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/models/comment.dart';
import '../../../core/models/post.dart';
import '../../../core/utils/uploads.dart';
import '../../auth/application/session.dart';
import '../../stream/application/stream.dart';
import '../data/classwork_models.dart';
import '../data/classwork_repository.dart';

part 'classwork.g.dart';

@riverpod
Future<ClassworkData> classwork(Ref ref, int courseId) {
  ref.watch(currentUserIdProvider);
  return ref.watch(classworkRepositoryProvider).classwork(courseId);
}

@riverpod
Future<List<Topic>> topics(Ref ref, int courseId) {
  ref.watch(currentUserIdProvider);
  return ref.watch(classworkRepositoryProvider).topics(courseId);
}

@riverpod
Future<Post> post(Ref ref, int postId) {
  ref.watch(currentUserIdProvider);
  return ref.watch(classworkRepositoryProvider).post(postId);
}

@riverpod
Future<List<Comment>> comments(Ref ref, int postId) {
  ref.watch(currentUserIdProvider);
  return ref.watch(classworkRepositoryProvider).comments(postId);
}

@riverpod
Future<List<QuizQuestion>> quiz(Ref ref, int postId) {
  ref.watch(currentUserIdProvider);
  return ref.watch(classworkRepositoryProvider).quiz(postId);
}

class ClassworkActions {
  ClassworkActions(this._ref);

  final Ref _ref;

  ClassworkRepository get _repo => _ref.read(classworkRepositoryProvider);

  Future<Post> createPost(
    int courseId,
    PostDraft draft, {
    List<PickedUpload> files = const [],
    List<String> links = const [],
  }) async {
    final post = await _repo.createPost(courseId, draft, files: files, links: links);
    _refreshCourse(courseId);
    return post;
  }

  /// Pertanyaan dibuat sebagai draf (atau terjadwal), bentuknya disimpan, lalu diterbitkan
  /// bila diminta, karena server menolak menerbitkan Pertanyaan tanpa bentuk.
  Future<Post> createQuestion(
    int courseId,
    PostDraft draft,
    List<String> options, {
    List<PickedUpload> files = const [],
    List<String> links = const [],
  }) async {
    final publishNow = draft.status == PostStatus.published;
    final created = await _repo.createPost(
      courseId,
      publishNow ? draft.withStatus(PostStatus.draft) : draft,
      files: files,
      links: links,
    );
    await _repo.saveQuestion(created.id, options);
    final post = publishNow ? await _repo.publish(created.id) : created;
    _refreshCourse(courseId);
    return post;
  }

  Future<Post> publish(Post post) async {
    final published = await _repo.publish(post.id);
    _ref.invalidate(postProvider(post.id));
    _refreshCourse(post.courseId);
    return published;
  }

  Future<void> deletePost(Post post) async {
    await _repo.deletePost(post.id);
    _refreshCourse(post.courseId);
  }

  Future<void> createTopic(int courseId, String name) => _topics(courseId, () => _repo.createTopic(courseId, name));

  Future<void> renameTopic(int courseId, int topicId, String name) =>
      _topics(courseId, () => _repo.renameTopic(topicId, name));

  Future<void> deleteTopic(int courseId, int topicId) => _topics(courseId, () => _repo.deleteTopic(topicId));

  Future<void> reorderTopics(int courseId, List<int> topicIds) =>
      _topics(courseId, () => _repo.reorderTopics(courseId, topicIds));

  Future<void> addComment(Post post, String body) async {
    await _repo.addComment(post.id, body);
    _ref
      ..invalidate(commentsProvider(post.id))
      ..invalidate(postProvider(post.id))
      ..invalidate(streamFeedProvider(post.courseId));
  }

  Future<void> saveQuiz(int postId, List<Map<String, dynamic>> questions) async {
    await _repo.saveQuiz(postId, questions);
    _ref
      ..invalidate(quizProvider(postId))
      ..invalidate(postProvider(postId));
  }

  Future<void> _topics(int courseId, Future<Object?> Function() action) async {
    await action();
    _ref
      ..invalidate(topicsProvider(courseId))
      ..invalidate(classworkProvider(courseId));
  }

  void _refreshCourse(int courseId) {
    _ref
      ..invalidate(classworkProvider(courseId))
      ..invalidate(streamFeedProvider(courseId))
      ..invalidate(upcomingProvider(courseId));
  }
}

/// keepAlive: dipakai setelah `await` di widget, jadi tidak boleh ikut dibuang otomatis.
@Riverpod(keepAlive: true)
ClassworkActions classworkActions(Ref ref) => ClassworkActions(ref);
