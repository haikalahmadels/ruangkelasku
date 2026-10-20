import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/copy/strings.dart';
import '../../../core/layout/breakpoints.dart';
import '../../../core/models/post.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/async_view.dart';
import '../../../core/widgets/comment_thread.dart';
import '../../../core/widgets/form_widgets.dart';
import '../../../core/widgets/grade_input.dart';
import '../../../core/widgets/post_card.dart';
import '../../../core/widgets/status_chip.dart';
import '../../../core/widgets/user_avatar.dart';
import '../../classwork/application/classwork.dart';
import '../application/submissions.dart';
import 'question_answer.dart';

/// Layar 29: tugas satu siswa, nilai draf, kembalikan, dan komentar pribadi.
class SubmissionReview extends ConsumerWidget {
  const SubmissionReview({super.key, required this.submissionId});

  final int submissionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final submission = ref.watch(submissionProvider(submissionId));
    final comments = ref.watch(privateCommentsProvider(submissionId));
    final theme = Theme.of(context);

    return AsyncView(
      value: submission,
      onRetry: () => ref.invalidate(submissionProvider(submissionId)),
      data: (s) {
        final post = ref.watch(postProvider(s.postId)).value;
        final correct = s.quizAnswers?.where((a) => a.isCorrect ?? false).length;

        return ListView(
          padding: EdgeInsets.all(context.windowSize.pageGutter),
          children: [
            Row(
              children: [
                UserAvatar(name: s.student?.name ?? '', url: s.student?.avatarUrl),
                const SizedBox(width: Space.md),
                Expanded(child: Text(s.student?.name ?? '', style: theme.textTheme.titleLarge)),
              ],
            ),
            const SizedBox(height: Space.md),
            Align(
              alignment: Alignment.centerLeft,
              child: StatusChip(status: s.displayStatus, isLate: s.isLate),
            ),
            if (s.turnedInAt != null) ...[
              const SizedBox(height: Space.xs),
              Text(S.turnedInAt(formatWib(s.turnedInAt!, 'd MMM, HH.mm')), style: theme.textTheme.labelMedium),
            ],
            // Pertanyaan tidak punya kunci jawaban; hitungan benar hanya untuk kuis.
            if (post?.type == PostType.quiz && s.quizAnswers != null) ...[
              const SizedBox(height: Space.md),
              Text('${S.correct}: $correct/${s.quizAnswers!.length}', style: theme.textTheme.titleMedium),
            ],
            if (post?.type == PostType.question) ...[
              const SizedBox(height: Space.lg),
              QuestionAnswerView(postId: s.postId, submission: s, label: S.answer),
            ],
            if (s.attachments.isNotEmpty) ...[
              const SizedBox(height: Space.lg),
              Wrap(
                spacing: Space.sm,
                runSpacing: Space.sm,
                children: [for (final a in s.attachments) AttachmentTile(attachment: a)],
              ),
            ],
            if (post?.points != null) ...[
              const SizedBox(height: Space.xl),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: GradeInput(
                      key: ValueKey('review-grade-${s.id}'),
                      initial: s.draftGrade ?? s.grade,
                      maxPoints: post!.points!,
                      onSave: (value) => ref.read(submissionActionsProvider).grade(s, value),
                    ),
                  ),
                  const SizedBox(width: Space.md),
                  FilledButton(
                    onPressed: () async {
                      try {
                        await ref.read(submissionActionsProvider).returnMany(s.postId, [s.id]);
                        if (context.mounted) showMessage(context, S.returned);
                      } on ApiException catch (e) {
                        if (context.mounted) showMessage(context, e.message);
                      }
                    },
                    child: const Text(S.returnWork),
                  ),
                ],
              ),
            ],
            const Divider(height: Space.xxl),
            Text(S.privateComments, style: theme.textTheme.titleMedium),
            const SizedBox(height: Space.sm),
            AsyncView(
              value: comments,
              onRetry: () => ref.invalidate(privateCommentsProvider(submissionId)),
              skeleton: const SizedBox.shrink(),
              data: (list) => CommentThread(
                comments: list,
                hint: S.addPrivateComment,
                onSend: (body) => ref.read(submissionActionsProvider).addPrivateComment(submissionId, body),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Layar 29 sebagai halaman sendiri di Compact.
class SubmissionReviewPage extends StatelessWidget {
  const SubmissionReviewPage({super.key, required this.submissionId});

  final int submissionId;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text(S.tabStudentWork)),
    body: SubmissionReview(submissionId: submissionId),
  );
}
