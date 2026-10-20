import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/models/display_status.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';
import '../../courses/data/course.dart';

part 'people_repository.freezed.dart';
part 'people_repository.g.dart';

/// Anggota kelas; `email` hanya dikirim server bila yang melihat adalah guru.
@freezed
abstract class Member with _$Member {
  const factory Member({
    required int id,
    required String name,
    String? email,
    String? avatarUrl,
    required bool isOwner,
  }) = _Member;

  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);
}

class Members {
  const Members({required this.teachers, required this.students});

  final List<Member> teachers;
  final List<Member> students;
}

class PeopleRepository {
  PeopleRepository(this._dio);

  final Dio _dio;

  Future<Members> members(int courseId) => apiCall(() async {
    final response = await _dio.get<Map<String, dynamic>>('/courses/$courseId/members');
    final data = response.data!['data'] as Map<String, dynamic>;
    List<Member> parse(String key) =>
        (data[key] as List).map((e) => Member.fromJson(e as Map<String, dynamic>)).toList();
    return Members(teachers: parse('teachers'), students: parse('students'));
  });

  Future<void> remove(int courseId, int userId) =>
      apiCall(() => _dio.delete<void>('/courses/$courseId/members/$userId'));

  Future<void> invite(int courseId, {required String email, required CourseRole role}) =>
      apiCall(() => _dio.post<void>('/courses/$courseId/invitations', data: {'email': email, 'role': role.name}));

  Future<List<Invitation>> pendingInvitations(int courseId) => apiCall(() async {
    final response = await _dio.get<Map<String, dynamic>>('/courses/$courseId/invitations');
    return (response.data!['data'] as List).map((e) => Invitation.fromJson(e as Map<String, dynamic>)).toList();
  });

  Future<void> cancelInvitation(int id) => apiCall(() => _dio.delete<void>('/invitations/$id'));
}

@Riverpod(keepAlive: true)
PeopleRepository peopleRepository(Ref ref) => PeopleRepository(ref.watch(dioProvider));
