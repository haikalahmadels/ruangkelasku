// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submission_repository.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_QuizAnswerRef _$QuizAnswerRefFromJson(Map<String, dynamic> json) => _QuizAnswerRef(
  questionId: (json['question_id'] as num).toInt(),
  optionId: (json['option_id'] as num?)?.toInt(),
  isCorrect: json['is_correct'] as bool?,
);

Map<String, dynamic> _$QuizAnswerRefToJson(_QuizAnswerRef instance) => <String, dynamic>{
  'question_id': instance.questionId,
  'option_id': instance.optionId,
  'is_correct': instance.isCorrect,
};

_Submission _$SubmissionFromJson(Map<String, dynamic> json) => _Submission(
  id: (json['id'] as num).toInt(),
  postId: (json['post_id'] as num).toInt(),
  student: json['student'] == null ? null : UserSummary.fromJson(json['student'] as Map<String, dynamic>),
  status: json['status'] as String,
  displayStatus: $enumDecode(_$DisplayStatusEnumMap, json['display_status']),
  isLate: json['is_late'] as bool,
  draftGrade: (json['draft_grade'] as num?)?.toDouble(),
  grade: (json['grade'] as num?)?.toDouble(),
  turnedInAt: json['turned_in_at'] == null ? null : DateTime.parse(json['turned_in_at'] as String),
  returnedAt: json['returned_at'] == null ? null : DateTime.parse(json['returned_at'] as String),
  attachments:
      (json['attachments'] as List<dynamic>?)?.map((e) => Attachment.fromJson(e as Map<String, dynamic>)).toList() ??
      const <Attachment>[],
  answerText: json['answer_text'] as String?,
  quizAnswers: (json['quiz_answers'] as List<dynamic>?)
      ?.map((e) => QuizAnswerRef.fromJson(e as Map<String, dynamic>))
      .toList(),
  privateCommentCount: (json['private_comment_count'] as num?)?.toInt(),
);

Map<String, dynamic> _$SubmissionToJson(_Submission instance) => <String, dynamic>{
  'id': instance.id,
  'post_id': instance.postId,
  'student': instance.student?.toJson(),
  'status': instance.status,
  'display_status': _$DisplayStatusEnumMap[instance.displayStatus]!,
  'is_late': instance.isLate,
  'draft_grade': instance.draftGrade,
  'grade': instance.grade,
  'turned_in_at': instance.turnedInAt?.toIso8601String(),
  'returned_at': instance.returnedAt?.toIso8601String(),
  'attachments': instance.attachments.map((e) => e.toJson()).toList(),
  'answer_text': instance.answerText,
  'quiz_answers': instance.quizAnswers?.map((e) => e.toJson()).toList(),
  'private_comment_count': instance.privateCommentCount,
};

const _$DisplayStatusEnumMap = {
  DisplayStatus.assigned: 'assigned',
  DisplayStatus.missing: 'missing',
  DisplayStatus.turnedIn: 'turned_in',
  DisplayStatus.graded: 'graded',
  DisplayStatus.returned: 'returned',
};

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(submissionRepository)
final submissionRepositoryProvider = SubmissionRepositoryProvider._();

final class SubmissionRepositoryProvider
    extends $FunctionalProvider<SubmissionRepository, SubmissionRepository, SubmissionRepository>
    with $Provider<SubmissionRepository> {
  SubmissionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'submissionRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$submissionRepositoryHash();

  @$internal
  @override
  $ProviderElement<SubmissionRepository> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  SubmissionRepository create(Ref ref) {
    return submissionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SubmissionRepository value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<SubmissionRepository>(value));
  }
}

String _$submissionRepositoryHash() => r'9a67141fffa7afa5467ede5663d7ca34e166bee7';
