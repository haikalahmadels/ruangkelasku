import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/models/display_status.dart';
import '../../../core/models/user_summary.dart';

part 'course.freezed.dart';
part 'course.g.dart';

/// Kelas (docs/api.md, contoh Course). `code` hanya terisi untuk guru.
@freezed
abstract class Course with _$Course {
  const Course._();

  const factory Course({
    required int id,
    required String name,
    String? section,
    String? subject,
    String? room,
    String? description,
    required String theme,
    String? code,
    required bool codeEnabled,
    required String streamPermission,
    required String classworkOnStream,
    required bool isArchived,
    CourseRole? myRole,
    required bool isOwner,
    UserSummary? owner,
    int? studentCount,
    DateTime? createdAt,
  }) = _Course;

  factory Course.fromJson(Map<String, dynamic> json) => _$CourseFromJson(json);

  bool get isTeacher => myRole == CourseRole.teacher;
  bool get isStudent => myRole == CourseRole.student;

  /// Siswa boleh memposting pengumuman hanya bila stream_permission = all.
  bool get canPostToStream => isTeacher || streamPermission == 'all';
}

@freezed
abstract class Invitation with _$Invitation {
  const factory Invitation({
    required int id,
    required int courseId,
    required String email,
    required CourseRole role,
    required String status,
    UserSummary? invitedBy,
    InvitationCourse? course,
  }) = _Invitation;

  factory Invitation.fromJson(Map<String, dynamic> json) => _$InvitationFromJson(json);
}

@freezed
abstract class InvitationCourse with _$InvitationCourse {
  const factory InvitationCourse({
    required int id,
    required String name,
    String? section,
    required String theme,
    UserSummary? owner,
  }) = _InvitationCourse;

  factory InvitationCourse.fromJson(Map<String, dynamic> json) => _$InvitationCourseFromJson(json);
}
