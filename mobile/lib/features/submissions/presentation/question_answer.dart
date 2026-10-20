import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/copy/strings.dart';
import '../../../core/models/post.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/celebration.dart';
import '../../../core/widgets/form_widgets.dart';
import '../../classwork/application/classwork.dart';
import '../../classwork/data/classwork_models.dart';
import '../../courses/data/course.dart';
import '../application/submissions.dart';
import '../data/submission_repository.dart';

/// Opsi Pertanyaan pilihan ganda; kosong berarti jawaban singkat.
List<QuizOption> _optionsOf(List<QuizQuestion>? questions) =>
    questions == null || questions.isEmpty ? const [] : questions.first.options;

/// Teks jawaban siswa: isian singkat atau label opsi yang dipilih.
String? _answerOf(Submission submission, List<QuizOption> options) {
  final text = submission.answerText;
  if (text != null && text.isNotEmpty) return text;
  final optionId = submission.quizAnswers?.firstOrNull?.optionId;
  return options.where((o) => o.id == optionId).firstOrNull?.label;
}

/// Jawaban Pertanyaan yang sudah dikirim (siswa setelah menyerahkan, guru saat menilai).
class QuestionAnswerView extends ConsumerWidget {
  const QuestionAnswerView({super.key, required this.postId, required this.submission, required this.label});

  final int postId;
  final Submission submission;
  final String label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final answer = _answerOf(submission, _optionsOf(ref.watch(quizProvider(postId)).value));

    return Card.filled(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(Space.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: theme.textTheme.labelLarge),
            const SizedBox(height: Space.xs),
            Text(
              answer ?? S.notAnswered,
              style: answer == null
                  ? theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant)
                  : theme.textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}

/// Bagian "Tugas Anda" untuk Pertanyaan: jawab lalu serahkan dalam satu langkah;
/// setelah diserahkan, jawaban tampil dan penyerahan bisa dibatalkan untuk menjawab ulang.
class QuestionAnswerForm extends ConsumerStatefulWidget {
  const QuestionAnswerForm({super.key, required this.post, required this.course, required this.submission});

  final Post post;
  final Course course;
  final Submission submission;

  @override
  ConsumerState<QuestionAnswerForm> createState() => _QuestionAnswerFormState();
}

class _QuestionAnswerFormState extends ConsumerState<QuestionAnswerForm> {
  // Jawaban sebelumnya (mis. setelah dikembalikan) menjadi isian awal.
  late final _text = TextEditingController(text: widget.submission.answerText ?? '');
  late int? _optionId = widget.submission.quizAnswers?.firstOrNull?.optionId;

  @override
  void initState() {
    super.initState();
    _text.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final questions = ref.watch(quizProvider(widget.post.id));
    final actions = ref.read(submissionActionsProvider);
    final archived = widget.course.isArchived;

    if (widget.submission.status == 'turned_in') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          QuestionAnswerView(postId: widget.post.id, submission: widget.submission, label: S.yourAnswer),
          const SizedBox(height: Space.md),
          OutlinedButton(
            onPressed: archived
                ? null
                : () async {
                    try {
                      await actions.unsubmit(widget.post.id);
                    } on ApiException catch (e) {
                      if (context.mounted) showMessage(context, e.message);
                    }
                  },
            style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(Sizes.touchTarget)),
            child: const Text(S.unsubmit),
          ),
        ],
      );
    }

    final options = _optionsOf(questions.value);
    final isChoice = options.isNotEmpty;
    final ready = isChoice ? _optionId != null : _text.text.trim().isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!questions.hasValue)
          const LinearProgressIndicator()
        else if (isChoice)
          RadioGroup<int>(
            groupValue: _optionId,
            onChanged: (id) => setState(() => _optionId = id),
            child: Column(
              children: [
                for (final option in options)
                  RadioListTile<int>(
                    value: option.id,
                    enabled: !archived,
                    title: Text(option.label),
                    contentPadding: EdgeInsets.zero,
                  ),
              ],
            ),
          )
        else
          TextField(
            controller: _text,
            enabled: !archived,
            minLines: 2,
            maxLines: 6,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(labelText: S.yourAnswerHint, alignLabelWithHint: true),
          ),
        const SizedBox(height: Space.md),
        TurnInButton(
          label: widget.submission.status == 'returned' ? S.answerAgain : S.turnIn,
          successMessage: S.turnedInCheer,
          onPressed: archived || !ready
              ? null
              : () => actions.answerQuestion(
                  widget.post.id,
                  answerText: isChoice ? null : _text.text.trim(),
                  optionId: isChoice ? _optionId : null,
                ),
        ),
      ],
    );
  }
}
