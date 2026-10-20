import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/models/comment.dart';
import '../../../core/models/post.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/utils/uploads.dart';
import 'classwork_models.dart';

part 'classwork_repository.g.dart';

/// Tugas Kelas, topik, detail posting, komentar kelas, dan soal kuis.
class ClassworkRepository {
  ClassworkRepository(this._dio);

  final Dio _dio;

  Future<ClassworkData> classwork(int courseId) => apiCall(() async {
    final response = await _dio.get<Map<String, dynamic>>('/courses/$courseId/classwork');
    return ClassworkData.fromJson(response.data!['data'] as Map<String, dynamic>);
  });

  Future<List<Topic>> topics(int courseId) => apiCall(() async {
    final response = await _dio.get<Map<String, dynamic>>('/courses/$courseId/topics');
    return (response.data!['data'] as List).map((e) => Topic.fromJson(e as Map<String, dynamic>)).toList();
  });

  Future<Topic> createTopic(int courseId, String name) => apiCall(() async {
    final response = await _dio.post<Map<String, dynamic>>('/courses/$courseId/topics', data: {'name': name});
    return Topic.fromJson(response.data!['data'] as Map<String, dynamic>);
  });

  Future<void> renameTopic(int topicId, String name) =>
      apiCall(() => _dio.patch<void>('/topics/$topicId', data: {'name': name}));

  Future<void> deleteTopic(int topicId) => apiCall(() => _dio.delete<void>('/topics/$topicId'));

  Future<void> reorderTopics(int courseId, List<int> topicIds) =>
      apiCall(() => _dio.put<void>('/courses/$courseId/topics/order', data: {'topic_ids': topicIds}));

  /// Multipart: field posting + `files[]` + `links[]` (docs/api.md).
  Future<Post> createPost(
    int courseId,
    PostDraft draft, {
    List<PickedUpload> files = const [],
    List<String> links = const [],
  }) => apiCall(() async {
    final form = FormData.fromMap({...draft.toFields(), for (final (i, link) in links.indexed) 'links[$i]': link});
    for (final file in files) {
      form.files.add(MapEntry('files[]', file.toMultipart()));
    }
    final response = await _dio.post<Map<String, dynamic>>('/courses/$courseId/posts', data: form);
    return Post.fromJson(response.data!['data'] as Map<String, dynamic>);
  });

  Future<Post> post(int postId) => apiCall(() async {
    final response = await _dio.get<Map<String, dynamic>>('/posts/$postId');
    return Post.fromJson(response.data!['data'] as Map<String, dynamic>);
  });

  Future<Post> publish(int postId) => apiCall(() async {
    final response = await _dio.post<Map<String, dynamic>>('/posts/$postId/publish');
    return Post.fromJson(response.data!['data'] as Map<String, dynamic>);
  });

  Future<void> deletePost(int postId) => apiCall(() => _dio.delete<void>('/posts/$postId'));

  Future<List<Comment>> comments(int postId) => apiCall(() async {
    final response = await _dio.get<Map<String, dynamic>>('/posts/$postId/comments');
    return (response.data!['data'] as List).map((e) => Comment.fromJson(e as Map<String, dynamic>)).toList();
  });

  Future<Comment> addComment(int postId, String body) => apiCall(() async {
    final response = await _dio.post<Map<String, dynamic>>('/posts/$postId/comments', data: {'body': body});
    return Comment.fromJson(response.data!['data'] as Map<String, dynamic>);
  });

  Future<List<QuizQuestion>> quiz(int postId) => apiCall(() async {
    final response = await _dio.get<Map<String, dynamic>>('/posts/$postId/quiz');
    return (response.data!['data'] as List).map((e) => QuizQuestion.fromJson(e as Map<String, dynamic>)).toList();
  });

  /// Mengganti seluruh soal; 409 quiz_locked bila sudah ada yang menyerahkan.
  Future<List<QuizQuestion>> saveQuiz(int postId, List<Map<String, dynamic>> questions) => apiCall(() async {
    final response = await _dio.put<Map<String, dynamic>>('/posts/$postId/quiz', data: {'questions': questions});
    return (response.data!['data'] as List).map((e) => QuizQuestion.fromJson(e as Map<String, dynamic>)).toList();
  });

  /// Bentuk Pertanyaan (stretch): [options] kosong = jawaban singkat, 2–5 = pilihan ganda.
  Future<void> saveQuestion(int postId, List<String> options) =>
      apiCall(() => _dio.put<void>('/posts/$postId/question', data: {'options': options}));
}

@Riverpod(keepAlive: true)
ClassworkRepository classworkRepository(Ref ref) => ClassworkRepository(ref.watch(dioProvider));
