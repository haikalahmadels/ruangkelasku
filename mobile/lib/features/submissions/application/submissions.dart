import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/models/comment.dart';
import '../../../core/utils/uploads.dart';
import '../../auth/application/session.dart';
import '../../classwork/application/classwork.dart';
import '../../grades/application/grades.dart';
import '../../stream/application/stream.dart';
import '../../todo/application/todo.dart';
import '../data/submission_repository.dart';

part 'submissions.g.dart';

@riverpod
Future<Submission> mySubmission(Ref ref, int postId) {
  ref.watch(currentUserIdProvider);
  return ref.watch(submissionRepositoryProvider).mine(postId);
}

@riverpod
Future<SubmissionList> postSubmissions(Ref ref, int postId) {
  ref.watch(currentUserIdProvider);
  return ref.watch(submissionRepositoryProvider).forPost(postId);
}

@riverpod
Future<Submission> submission(Ref ref, int submissionId) {
  ref.watch(currentUserIdProvider);
  return ref.watch(submissionRepositoryProvider).get(submissionId);
}

@riverpod
Future<List<Comment>> privateComments(Ref ref, int submissionId) {
  ref.watch(currentUserIdProvider);
  return ref.watch(submissionRepositoryProvider).privateComments(submissionId);
}

class SubmissionActions {
  SubmissionActions(this._ref);

  final Ref _ref;

  SubmissionRepository get _repo => _ref.read(submissionRepositoryProvider);

  // Siswa

  Future<void> addFile(int postId, PickedUpload file) => _mine(postId, () => _repo.addFile(postId, file));

  Future<void> addLink(int postId, String url) => _mine(postId, () => _repo.addLink(postId, url));

  Future<void> removeAttachment(int postId, int attachmentId) =>
      _mine(postId, () => _repo.removeAttachment(postId, attachmentId));

  Future<void> turnIn(int postId) => _mine(postId, () => _repo.turnIn(postId));

  Future<void> unsubmit(int postId) => _mine(postId, () => _repo.unsubmit(postId));

  Future<void> submitQuiz(int postId, Map<int, int?> answers) => _mine(postId, () => _repo.submitQuiz(postId, answers));

  Future<void> answerQuestion(int postId, {String? answerText, int? optionId}) =>
      _mine(postId, () => _repo.answerQuestion(postId, answerText: answerText, optionId: optionId));

  // Guru

  Future<Submission> grade(Submission submission, num? draftGrade) async {
    final graded = await _repo.grade(submission.id, draftGrade);
    _ref
      ..invalidate(postSubmissionsProvider(submission.postId))
      ..invalidate(submissionProvider(submission.id))
      ..invalidate(toReviewFeedProvider)
      ..invalidate(gradeGridProvider);
    return graded;
  }

  Future<void> returnMany(int postId, List<int> submissionIds) async {
    await _repo.returnMany(postId, submissionIds);
    _ref
      ..invalidate(postSubmissionsProvider(postId))
      ..invalidate(postProvider(postId))
      ..invalidate(toReviewFeedProvider)
      ..invalidate(gradeGridProvider);
    for (final id in submissionIds) {
      _ref.invalidate(submissionProvider(id));
    }
  }

  // Komentar pribadi

  Future<void> addPrivateComment(int submissionId, String body) async {
    await _repo.addPrivateComment(submissionId, body);
    _ref.invalidate(privateCommentsProvider(submissionId));
  }

  Future<void> _mine(int postId, Future<Object?> Function() action) async {
    await action();
    final post = _ref.read(postProvider(postId)).value;
    _ref
      ..invalidate(mySubmissionProvider(postId))
      ..invalidate(postProvider(postId))
      // Semua tab dan filter Daftar tugas, karena tugas ini bisa pindah tab.
      ..invalidate(todoFeedProvider)
      ..invalidate(myWorkProvider);
    if (post != null) {
      _ref
        ..invalidate(classworkProvider(post.courseId))
        ..invalidate(upcomingProvider(post.courseId));
    }
  }
}

/// keepAlive: dipakai setelah `await` di widget, jadi tidak boleh ikut dibuang otomatis.
@Riverpod(keepAlive: true)
SubmissionActions submissionActions(Ref ref) => SubmissionActions(ref);
