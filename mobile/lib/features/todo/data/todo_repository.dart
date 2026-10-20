import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/models/paged.dart';
import '../../../core/models/post.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';

part 'todo_repository.g.dart';

/// Tab Daftar tugas siswa; nama enum sama dengan nilai `?tab=` di API.
enum TodoTab { assigned, missing, done }

class TodoRepository {
  TodoRepository(this._dio);

  final Dio _dio;

  /// Tugas siswa lintas kelas (layar 8).
  Future<Paged<Post>> todo(TodoTab tab, {int? courseId, int page = 1}) =>
      _posts('/todo', {'tab': tab.name, 'course_id': ?courseId, 'page': page});

  /// Tugas di kelas tempat pengguna mengajar, dengan hitungan per status (layar 9).
  Future<Paged<Post>> toReview({int? courseId, int page = 1}) =>
      _posts('/to-review', {'course_id': ?courseId, 'page': page});

  Future<Paged<Post>> _posts(String path, Map<String, dynamic> query) => apiCall(() async {
    final response = await _dio.get<Map<String, dynamic>>(path, queryParameters: query);
    return Paged.fromJson(response.data!, Post.fromJson);
  });
}

@Riverpod(keepAlive: true)
TodoRepository todoRepository(Ref ref) => TodoRepository(ref.watch(dioProvider));
