import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/models/comment.dart';
import '../../../core/models/display_status.dart';
import '../../../core/models/post.dart';
import '../../../core/models/user_summary.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/utils/uploads.dart';

part 'submission_repository.freezed.dart';
part 'submission_repository.g.dart';

@freezed
abstract class QuizAnswerRef with _$QuizAnswerRef {
  const factory QuizAnswerRef({required int questionId, int? optionId, bool? isCorrect}) = _QuizAnswerRef;

  factory QuizAnswerRef.fromJson(Map<String, dynamic> json) => _$QuizAnswerRefFromJson(json);
}

/// Submission lengkap (docs/api.md). `draftGrade` tidak pernah dikirim ke siswa.
@freezed
abstract class Submission with _$Submission {
  const factory Submission({
    required int id,
    required int postId,
    UserSummary? student,
    required String status,
    required DisplayStatus displayStatus,
    required bool isLate,
    double? draftGrade,
    double? grade,
    DateTime? turnedInAt,
    DateTime? returnedAt,
    @Default(<Attachment>[]) List<Attachment> attachments,

    /// Jawaban singkat Pertanyaan; pilihan ganda ada di [quizAnswers].
    String? answerText,
    List<QuizAnswerRef>? quizAnswers,
    int? privateCommentCount,
  }) = _Submission;

  factory Submission.fromJson(Map<String, dynamic> json) => _$SubmissionFromJson(json);
}

class SubmissionList {
  const SubmissionList({required this.items, required this.counts});

  final List<Submission> items;
  final SubmissionCounts counts;
}

class SubmissionRepository {
  SubmissionRepository(this._dio);

  final Dio _dio;

  // Sisi siswa

  Future<Submission> mine(int postId) => _one(() => _dio.get('/posts/$postId/my-submission'));

  Future<Attachment> addFile(int postId, PickedUpload file) => apiCall(() async {
    final form = FormData()..files.add(MapEntry('file', file.toMultipart()));
    final response = await _dio.post<Map<String, dynamic>>('/posts/$postId/my-submission/attachments', data: form);
    return Attachment.fromJson(response.data!['data'] as Map<String, dynamic>);
  });

  Future<Attachment> addLink(int postId, String url) => apiCall(() async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/posts/$postId/my-submission/attachments',
      data: {'url': url},
    );
    return Attachment.fromJson(response.data!['data'] as Map<String, dynamic>);
  });

  Future<void> removeAttachment(int postId, int attachmentId) =>
      apiCall(() => _dio.delete<void>('/posts/$postId/my-submission/attachments/$attachmentId'));

  Future<Submission> turnIn(int postId) => _one(() => _dio.post('/posts/$postId/my-submission/turn-in'));

  Future<Submission> unsubmit(int postId) => _one(() => _dio.post('/posts/$postId/my-submission/unsubmit'));

  /// Jawaban kuis sekaligus menyerahkan; nilai otomatis masuk ke nilai draf.
  Future<Submission> submitQuiz(int postId, Map<int, int?> answers) => _one(
    () => _dio.post(
      '/posts/$postId/my-submission/quiz',
      data: {
        'answers': [
          for (final e in answers.entries) {'question_id': e.key, 'option_id': e.value},
        ],
      },
    ),
  );

  /// Menjawab Pertanyaan sekaligus menyerahkan: [answerText] atau [optionId].
  Future<Submission> answerQuestion(int postId, {String? answerText, int? optionId}) => _one(
    () => _dio.post('/posts/$postId/my-submission/answer', data: {'answer_text': ?answerText, 'option_id': ?optionId}),
  );

  // Sisi guru

  Future<SubmissionList> forPost(int postId) => apiCall(() async {
    final response = await _dio.get<Map<String, dynamic>>('/posts/$postId/submissions');
    final body = response.data!;
    return SubmissionList(
      items: (body['data'] as List).map((e) => Submission.fromJson(e as Map<String, dynamic>)).toList(),
      counts: SubmissionCounts.fromJson((body['meta'] as Map<String, dynamic>)['counts'] as Map<String, dynamic>),
    );
  });

  Future<Submission> get(int submissionId) => _one(() => _dio.get('/submissions/$submissionId'));

  Future<Submission> grade(int submissionId, num? draftGrade) =>
      _one(() => _dio.patch('/submissions/$submissionId/grade', data: {'draft_grade': draftGrade}));

  Future<void> returnMany(int postId, List<int> submissionIds) =>
      apiCall(() => _dio.post<void>('/posts/$postId/return', data: {'submission_ids': submissionIds}));

  // Komentar pribadi

  Future<List<Comment>> privateComments(int submissionId) => apiCall(() async {
    final response = await _dio.get<Map<String, dynamic>>('/submissions/$submissionId/comments');
    return (response.data!['data'] as List).map((e) => Comment.fromJson(e as Map<String, dynamic>)).toList();
  });

  Future<Comment> addPrivateComment(int submissionId, String body) => apiCall(() async {
    final response = await _dio.post<Map<String, dynamic>>('/submissions/$submissionId/comments', data: {'body': body});
    return Comment.fromJson(response.data!['data'] as Map<String, dynamic>);
  });

  Future<Submission> _one(Future<Response<dynamic>> Function() request) => apiCall(() async {
    final response = await request();
    return Submission.fromJson((response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>);
  });
}

@Riverpod(keepAlive: true)
SubmissionRepository submissionRepository(Ref ref) => SubmissionRepository(ref.watch(dioProvider));
