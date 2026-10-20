// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Post _$PostFromJson(Map<String, dynamic> json) => _Post(
  id: (json['id'] as num).toInt(),
  courseId: (json['course_id'] as num).toInt(),
  course: json['course'] == null ? null : PostCourse.fromJson(json['course'] as Map<String, dynamic>),
  type: $enumDecode(_$PostTypeEnumMap, json['type']),
  title: json['title'] as String?,
  body: json['body'] as String?,
  topic: json['topic'] == null ? null : PostTopic.fromJson(json['topic'] as Map<String, dynamic>),
  points: (json['points'] as num?)?.toInt(),
  dueAt: json['due_at'] == null ? null : DateTime.parse(json['due_at'] as String),
  status: $enumDecode(_$PostStatusEnumMap, json['status']),
  scheduledAt: json['scheduled_at'] == null ? null : DateTime.parse(json['scheduled_at'] as String),
  publishedAt: json['published_at'] == null ? null : DateTime.parse(json['published_at'] as String),
  author: json['author'] == null ? null : UserSummary.fromJson(json['author'] as Map<String, dynamic>),
  attachments:
      (json['attachments'] as List<dynamic>?)?.map((e) => Attachment.fromJson(e as Map<String, dynamic>)).toList() ??
      const <Attachment>[],
  commentCount: (json['comment_count'] as num?)?.toInt(),
  mySubmission: json['my_submission'] == null
      ? null
      : MySubmission.fromJson(json['my_submission'] as Map<String, dynamic>),
  submissionCounts: json['submission_counts'] == null
      ? null
      : SubmissionCounts.fromJson(json['submission_counts'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PostToJson(_Post instance) => <String, dynamic>{
  'id': instance.id,
  'course_id': instance.courseId,
  'course': instance.course?.toJson(),
  'type': _$PostTypeEnumMap[instance.type]!,
  'title': instance.title,
  'body': instance.body,
  'topic': instance.topic?.toJson(),
  'points': instance.points,
  'due_at': instance.dueAt?.toIso8601String(),
  'status': _$PostStatusEnumMap[instance.status]!,
  'scheduled_at': instance.scheduledAt?.toIso8601String(),
  'published_at': instance.publishedAt?.toIso8601String(),
  'author': instance.author?.toJson(),
  'attachments': instance.attachments.map((e) => e.toJson()).toList(),
  'comment_count': instance.commentCount,
  'my_submission': instance.mySubmission?.toJson(),
  'submission_counts': instance.submissionCounts?.toJson(),
};

const _$PostTypeEnumMap = {
  PostType.announcement: 'announcement',
  PostType.material: 'material',
  PostType.assignment: 'assignment',
  PostType.quiz: 'quiz',
  PostType.question: 'question',
};

const _$PostStatusEnumMap = {
  PostStatus.draft: 'draft',
  PostStatus.scheduled: 'scheduled',
  PostStatus.published: 'published',
};

_PostCourse _$PostCourseFromJson(Map<String, dynamic> json) =>
    _PostCourse(id: (json['id'] as num).toInt(), name: json['name'] as String, theme: json['theme'] as String);

Map<String, dynamic> _$PostCourseToJson(_PostCourse instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'theme': instance.theme,
};

_PostTopic _$PostTopicFromJson(Map<String, dynamic> json) =>
    _PostTopic(id: (json['id'] as num).toInt(), name: json['name'] as String);

Map<String, dynamic> _$PostTopicToJson(_PostTopic instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
};

_Attachment _$AttachmentFromJson(Map<String, dynamic> json) => _Attachment(
  id: (json['id'] as num).toInt(),
  kind: json['kind'] as String,
  originalName: json['original_name'] as String?,
  mimeType: json['mime_type'] as String?,
  sizeBytes: (json['size_bytes'] as num?)?.toInt(),
  title: json['title'] as String?,
  url: json['url'] as String,
);

Map<String, dynamic> _$AttachmentToJson(_Attachment instance) => <String, dynamic>{
  'id': instance.id,
  'kind': instance.kind,
  'original_name': instance.originalName,
  'mime_type': instance.mimeType,
  'size_bytes': instance.sizeBytes,
  'title': instance.title,
  'url': instance.url,
};

_MySubmission _$MySubmissionFromJson(Map<String, dynamic> json) => _MySubmission(
  id: (json['id'] as num).toInt(),
  displayStatus: $enumDecode(_$DisplayStatusEnumMap, json['display_status']),
  isLate: json['is_late'] as bool,
  grade: (json['grade'] as num?)?.toDouble(),
);

Map<String, dynamic> _$MySubmissionToJson(_MySubmission instance) => <String, dynamic>{
  'id': instance.id,
  'display_status': _$DisplayStatusEnumMap[instance.displayStatus]!,
  'is_late': instance.isLate,
  'grade': instance.grade,
};

const _$DisplayStatusEnumMap = {
  DisplayStatus.assigned: 'assigned',
  DisplayStatus.missing: 'missing',
  DisplayStatus.turnedIn: 'turned_in',
  DisplayStatus.graded: 'graded',
  DisplayStatus.returned: 'returned',
};

_SubmissionCounts _$SubmissionCountsFromJson(Map<String, dynamic> json) => _SubmissionCounts(
  assigned: (json['assigned'] as num).toInt(),
  turnedIn: (json['turned_in'] as num).toInt(),
  graded: (json['graded'] as num).toInt(),
  returned: (json['returned'] as num).toInt(),
);

Map<String, dynamic> _$SubmissionCountsToJson(_SubmissionCounts instance) => <String, dynamic>{
  'assigned': instance.assigned,
  'turned_in': instance.turnedIn,
  'graded': instance.graded,
  'returned': instance.returned,
};
