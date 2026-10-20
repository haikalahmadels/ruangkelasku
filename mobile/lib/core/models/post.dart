import 'package:freezed_annotation/freezed_annotation.dart';

import 'display_status.dart';
import 'user_summary.dart';

part 'post.freezed.dart';
part 'post.g.dart';

@JsonEnum(fieldRename: FieldRename.snake)
enum PostType {
  announcement,
  material,
  assignment,
  quiz,
  question;

  bool get hasSubmissions => this == assignment || this == quiz || this == question;
}

@JsonEnum(fieldRename: FieldRename.snake)
enum PostStatus { draft, scheduled, published }

/// Posting untuk Forum, Tugas Kelas, dan To-do (docs/api.md, contoh Post).
@freezed
abstract class Post with _$Post {
  const factory Post({
    required int id,
    required int courseId,
    PostCourse? course,
    required PostType type,
    String? title,
    String? body,
    PostTopic? topic,
    int? points,
    DateTime? dueAt,
    required PostStatus status,
    DateTime? scheduledAt,
    DateTime? publishedAt,
    UserSummary? author,
    @Default(<Attachment>[]) List<Attachment> attachments,
    int? commentCount,
    MySubmission? mySubmission,
    SubmissionCounts? submissionCounts,
  }) = _Post;

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
}

@freezed
abstract class PostCourse with _$PostCourse {
  const factory PostCourse({required int id, required String name, required String theme}) = _PostCourse;

  factory PostCourse.fromJson(Map<String, dynamic> json) => _$PostCourseFromJson(json);
}

@freezed
abstract class PostTopic with _$PostTopic {
  const factory PostTopic({required int id, required String name}) = _PostTopic;

  factory PostTopic.fromJson(Map<String, dynamic> json) => _$PostTopicFromJson(json);
}

@freezed
abstract class Attachment with _$Attachment {
  const Attachment._();

  const factory Attachment({
    required int id,
    required String kind,
    String? originalName,
    String? mimeType,
    int? sizeBytes,
    String? title,
    required String url,
  }) = _Attachment;

  factory Attachment.fromJson(Map<String, dynamic> json) => _$AttachmentFromJson(json);

  bool get isFile => kind == 'file';
  bool get isImage => mimeType?.startsWith('image/') ?? false;
  String get displayName => (isFile ? originalName : title) ?? url;
}

/// Ringkasan submission milik siswa yang sedang login.
@freezed
abstract class MySubmission with _$MySubmission {
  const factory MySubmission({
    required int id,
    required DisplayStatus displayStatus,
    required bool isLate,
    double? grade,
  }) = _MySubmission;

  factory MySubmission.fromJson(Map<String, dynamic> json) => _$MySubmissionFromJson(json);
}

/// Hitungan untuk guru; jumlahnya sama dengan jumlah siswa.
@freezed
abstract class SubmissionCounts with _$SubmissionCounts {
  const factory SubmissionCounts({
    required int assigned,
    required int turnedIn,
    required int graded,
    required int returned,
  }) = _SubmissionCounts;

  factory SubmissionCounts.fromJson(Map<String, dynamic> json) => _$SubmissionCountsFromJson(json);
}
