import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';
import 'course.dart';

part 'course_repository.g.dart';

class CourseRepository {
  CourseRepository(this._dio);

  final Dio _dio;

  /// Daftar kelas pengguna; satu halaman 50 sudah cukup untuk satu sekolah.
  Future<List<Course>> list({required bool archived}) => apiCall(() async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/courses',
      queryParameters: {'archived': archived ? 1 : 0, 'per_page': 50},
    );
    return _courses(response.data!['data'] as List);
  });

  Future<Course> get(int id) => _course(() => _dio.get('/courses/$id'));

  Future<Course> create(Map<String, dynamic> fields) => _course(() => _dio.post('/courses', data: fields));

  Future<Course> update(int id, Map<String, dynamic> fields) => _course(() => _dio.patch('/courses/$id', data: fields));

  Future<Course> join(String code) => _course(() => _dio.post('/courses/join', data: {'code': code}));

  Future<Course> resetCode(int id) => _course(() => _dio.post('/courses/$id/code/reset'));

  Future<Course> archive(int id) => _course(() => _dio.post('/courses/$id/archive'));

  Future<Course> restore(int id) => _course(() => _dio.post('/courses/$id/restore'));

  Future<void> delete(int id) => apiCall(() => _dio.delete<void>('/courses/$id'));

  Future<void> leave(int id) => apiCall(() => _dio.delete<void>('/courses/$id/membership'));

  Future<List<Invitation>> myInvitations() => apiCall(() async {
    final response = await _dio.get<Map<String, dynamic>>('/me/invitations');
    return (response.data!['data'] as List).map((e) => Invitation.fromJson(e as Map<String, dynamic>)).toList();
  });

  Future<Course> acceptInvitation(int id) => _course(() => _dio.post('/invitations/$id/accept'));

  Future<void> declineInvitation(int id) => apiCall(() => _dio.post<void>('/invitations/$id/decline'));

  Future<Course> _course(Future<Response<dynamic>> Function() request) => apiCall(() async {
    final response = await request();
    return Course.fromJson((response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>);
  });

  List<Course> _courses(List<dynamic> data) => data.map((e) => Course.fromJson(e as Map<String, dynamic>)).toList();
}

@Riverpod(keepAlive: true)
CourseRepository courseRepository(Ref ref) => CourseRepository(ref.watch(dioProvider));
