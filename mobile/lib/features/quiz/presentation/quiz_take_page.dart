import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/copy/strings.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/async_view.dart';
import '../../../core/widgets/celebration.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/widgets/form_widgets.dart';
import '../../../core/widgets/quiz_question_card.dart';
import '../../../core/widgets/status_chip.dart';
import '../../classwork/application/classwork.dart';
import '../../classwork/data/classwork_models.dart';
import '../../submissions/application/submissions.dart';
import '../../submissions/data/submission_repository.dart';

/// Layar 26: Kerjakan kuis (dinilai otomatis), atau tinjau jawaban setelah diserahkan.
class QuizTakePage extends ConsumerWidget {
  const QuizTakePage({super.key, required this.postId});

  final int postId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final post = ref.watch(postProvider(postId));
    final questions = ref.watch(quizProvider(postId));
    final mine = ref.watch(mySubmissionProvider(postId));

    if (post.hasValue && questions.hasValue && mine.hasValue) {
      return _Quiz(
        title: post.requireValue.title ?? '',
        points: post.requireValue.points,
        questions: questions.requireValue,
        submission: mine.requireValue,
        postId: postId,
      );
    }
    final error = post.error ?? questions.error ?? mine.error;
    return Scaffold(
      appBar: AppBar(),
      body: error != null
          ? ErrorView(
              error: error,
              onRetry: () => ref
                ..invalidate(postProvider(postId))
                ..invalidate(quizProvider(postId))
                ..invalidate(mySubmissionProvider(postId)),
            )
          : const SkeletonList(),
    );
  }
}

class _Quiz extends ConsumerStatefulWidget {
  const _Quiz({
    required this.title,
    required this.points,
    required this.questions,
    required this.submission,
    required this.postId,
  });

  final String title;
  final int? points;
  final List<QuizQuestion> questions;
  final Submission submission;
  final int postId;

  @override
  ConsumerState<_Quiz> createState() => _QuizState();
}

class _QuizState extends ConsumerState<_Quiz> {
  late final Map<int, int?> _answers = {
    for (final a in widget.submission.quizAnswers ?? const <QuizAnswerRef>[]) a.questionId: a.optionId,
  };
  bool _submitting = false;

  bool get _taking => widget.submission.status == 'assigned';

  Future<void> _submit() async {
    final unanswered = widget.questions.where((q) => _answers[q.id] == null).length;
    final ok = await showConfirmDialog(
      context,
      title: S.submitQuizConfirm,
      body: S.unansweredWarning(unanswered),
      confirmLabel: S.submitQuiz,
    );
    if (!ok) return;

    setState(() => _submitting = true);
    try {
      await ref.read(submissionActionsProvider).submitQuiz(widget.postId, {
        for (final q in widget.questions) q.id: _answers[q.id],
      });
      if (!mounted) return;
      await showCelebration(context, message: S.quizDoneCheer);
      if (mounted) context.pop();
    } on ApiException catch (e) {
      if (mounted) showMessage(context, e.message);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = widget.submission;
    final dirty = _taking && _answers.values.any((v) => v != null);

    return PopScope(
      canPop: !dirty,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final leave = await showConfirmDialog(
          context,
          title: S.discardTitle,
          body: S.discardBody,
          confirmLabel: S.discard,
          destructive: true,
        );
        if (leave && context.mounted) context.pop();
      },
      child: Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: Sizes.formMaxWidth + Space.xxl * 4),
            child: ListView(
              padding: const EdgeInsets.all(Space.lg),
              children: [
                if (!_taking) ...[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: StatusChip(status: s.displayStatus, isLate: s.isLate),
                  ),
                  if (s.grade != null && widget.points != null)
                    Padding(
                      padding: const EdgeInsets.only(top: Space.sm),
                      child: Text(
                        S.gradeOutOf(formatGrade(s.grade!), widget.points!),
                        style: theme.textTheme.headlineMedium?.copyWith(color: theme.colorScheme.primary),
                      ),
                    ),
                  const SizedBox(height: Space.lg),
                ],
                for (final (i, q) in widget.questions.indexed) ...[
                  QuizQuestionCard(
                    number: i + 1,
                    prompt: q.prompt,
                    points: q.points,
                    selected: _answers[q.id],
                    review: !_taking,
                    onSelected: _taking ? (v) => setState(() => _answers[q.id] = v) : null,
                    options: [
                      for (final o in q.options) QuizOptionView(id: o.id, label: o.label, isCorrect: o.isCorrect),
                    ],
                  ),
                  const SizedBox(height: Space.md),
                ],
              ],
            ),
          ),
        ),
        bottomNavigationBar: _taking
            ? SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(Space.lg),
                  child: SubmitButton(label: S.submitQuiz, loading: _submitting, onPressed: _submit),
                ),
              )
            : null,
      ),
    );
  }
}
