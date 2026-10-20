import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/models/paged.dart';
import '../../../core/models/post.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';

part 'stream_repository.g.dart';

class StreamRepository {
  StreamRepository(this._dio);

  final Dio _dio;

  Future<Paged<Post>> stream(int courseId, {int page = 1}) => apiCall(() async {
    final response = await _dio.get<Map<String, dynamic>>('/courses/$courseId/stream', queryParameters: {'page': page});
    return Paged.fromJson(response.data!, Post.fromJson);
  });

  Future<List<Post>> upcoming(int courseId) => apiCall(() async {
    final response = await _dio.get<Map<String, dynamic>>('/courses/$courseId/posts/upcoming');
    return (response.data!['data'] as List).map((e) => Post.fromJson(e as Map<String, dynamic>)).toList();
  });

  /// Pengumuman langsung atau terjadwal; [scheduledAt] dalam UTC.
  Future<Post> announce(int courseId, {required String body, DateTime? scheduledAt}) => apiCall(() async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/courses/$courseId/posts',
      data: {
        'type': 'announcement',
        'body': body,
        'status': scheduledAt == null ? 'published' : 'scheduled',
        if (scheduledAt != null) 'scheduled_at': scheduledAt.toUtc().toIso8601String(),
      },
    );
    return Post.fromJson(response.data!['data'] as Map<String, dynamic>);
  });
}

@Riverpod(keepAlive: true)
StreamRepository streamRepository(Ref ref) => StreamRepository(ref.watch(dioProvider));
