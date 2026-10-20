// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Course _$CourseFromJson(Map<String, dynamic> json) => _Course(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  section: json['section'] as String?,
  subject: json['subject'] as String?,
  room: json['room'] as String?,
  description: json['description'] as String?,
  theme: json['theme'] as String,
  code: json['code'] as String?,
  codeEnabled: json['code_enabled'] as bool,
  streamPermission: json['stream_permission'] as String,
  classworkOnStream: json['classwork_on_stream'] as String,
  isArchived: json['is_archived'] as bool,
  myRole: $enumDecodeNullable(_$CourseRoleEnumMap, json['my_role']),
  isOwner: json['is_owner'] as bool,
  owner: json['owner'] == null ? null : UserSummary.fromJson(json['owner'] as Map<String, dynamic>),
  studentCount: (json['student_count'] as num?)?.toInt(),
  createdAt: json['created_at'] == null ? null : DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$CourseToJson(_Course instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'section': instance.section,
  'subject': instance.subject,
  'room': instance.room,
  'description': instance.description,
  'theme': instance.theme,
  'code': instance.code,
  'code_enabled': instance.codeEnabled,
  'stream_permission': instance.streamPermission,
  'classwork_on_stream': instance.classworkOnStream,
  'is_archived': instance.isArchived,
  'my_role': _$CourseRoleEnumMap[instance.myRole],
  'is_owner': instance.isOwner,
  'owner': instance.owner?.toJson(),
  'student_count': instance.studentCount,
  'created_at': instance.createdAt?.toIso8601String(),
};

const _$CourseRoleEnumMap = {CourseRole.teacher: 'teacher', CourseRole.student: 'student'};

_Invitation _$InvitationFromJson(Map<String, dynamic> json) => _Invitation(
  id: (json['id'] as num).toInt(),
  courseId: (json['course_id'] as num).toInt(),
  email: json['email'] as String,
  role: $enumDecode(_$CourseRoleEnumMap, json['role']),
  status: json['status'] as String,
  invitedBy: json['invited_by'] == null ? null : UserSummary.fromJson(json['invited_by'] as Map<String, dynamic>),
  course: json['course'] == null ? null : InvitationCourse.fromJson(json['course'] as Map<String, dynamic>),
);

Map<String, dynamic> _$InvitationToJson(_Invitation instance) => <String, dynamic>{
  'id': instance.id,
  'course_id': instance.courseId,
  'email': instance.email,
  'role': _$CourseRoleEnumMap[instance.role]!,
  'status': instance.status,
  'invited_by': instance.invitedBy?.toJson(),
  'course': instance.course?.toJson(),
};

_InvitationCourse _$InvitationCourseFromJson(Map<String, dynamic> json) => _InvitationCourse(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  section: json['section'] as String?,
  theme: json['theme'] as String,
  owner: json['owner'] == null ? null : UserSummary.fromJson(json['owner'] as Map<String, dynamic>),
);

Map<String, dynamic> _$InvitationCourseToJson(_InvitationCourse instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'section': instance.section,
  'theme': instance.theme,
  'owner': instance.owner?.toJson(),
};
