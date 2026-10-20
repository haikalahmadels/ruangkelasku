import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/models/post.dart';

part 'classwork_models.freezed.dart';
part 'classwork_models.g.dart';

@freezed
abstract class Topic with _$Topic {
  const factory Topic({required int id, required String name, required int position}) = _Topic;

  factory Topic.fromJson(Map<String, dynamic> json) => _$TopicFromJson(json);
}

/// Tugas Kelas: posting dikelompokkan per topik, lalu yang tanpa topik.
class ClassworkData {
  const ClassworkData({required this.groups, required this.noTopic});

  factory ClassworkData.fromJson(Map<String, dynamic> json) => ClassworkData(
    groups: [
      for (final g in json['topics'] as List)
        (
          topic: Topic.fromJson((g as Map<String, dynamic>)['topic'] as Map<String, dynamic>),
          posts: (g['posts'] as List).map((p) => Post.fromJson(p as Map<String, dynamic>)).toList(),
        ),
    ],
    noTopic: (json['no_topic'] as List).map((p) => Post.fromJson(p as Map<String, dynamic>)).toList(),
  );

  final List<({Topic topic, List<Post> posts})> groups;
  final List<Post> noTopic;

  bool get hasNoPosts => noTopic.isEmpty && groups.every((g) => g.posts.isEmpty);
}

@freezed
abstract class QuizOption with _$QuizOption {
  const factory QuizOption({required int id, required String label, required int position, bool? isCorrect}) =
      _QuizOption;

  factory QuizOption.fromJson(Map<String, dynamic> json) => _$QuizOptionFromJson(json);
}

/// Soal kuis; `is_correct` hanya terisi untuk guru atau setelah dikembalikan.
@freezed
abstract class QuizQuestion with _$QuizQuestion {
  const factory QuizQuestion({
    required int id,
    required String prompt,
    required int points,
    required int position,
    required List<QuizOption> options,
  }) = _QuizQuestion;

  factory QuizQuestion.fromJson(Map<String, dynamic> json) => _$QuizQuestionFromJson(json);
}

/// Isian form composer untuk tugas, materi, atau kuis.
class PostDraft {
  const PostDraft({
    required this.type,
    required this.title,
    this.body,
    this.topicId,
    this.points,
    this.dueAt,
    required this.status,
    this.scheduledAt,
  });

  final PostType type;
  final String title;
  final String? body;
  final int? topicId;
  final int? points;
  final DateTime? dueAt;
  final PostStatus status;
  final DateTime? scheduledAt;

  PostDraft withStatus(PostStatus status) => PostDraft(
    type: type,
    title: title,
    body: body,
    topicId: topicId,
    points: points,
    dueAt: dueAt,
    status: status,
    scheduledAt: scheduledAt,
  );

  Map<String, dynamic> toFields() => {
    'type': type.name,
    'title': title,
    if (body != null && body!.isNotEmpty) 'body': body,
    if (topicId != null) 'topic_id': topicId,
    if (points != null) 'points': points,
    if (dueAt != null) 'due_at': dueAt!.toUtc().toIso8601String(),
    'status': status.name,
    if (scheduledAt != null) 'scheduled_at': scheduledAt!.toUtc().toIso8601String(),
  };
}
