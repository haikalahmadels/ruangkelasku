import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/copy/strings.dart';
import '../../../core/models/post.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/async_view.dart';
import '../../../core/widgets/form_widgets.dart';
import '../application/classwork.dart';
import '../data/classwork_models.dart';

/// Satu soal yang sedang diedit.
class _QuestionDraft {
  _QuestionDraft({String prompt = '', int points = 10, List<String>? options, this.correct = 0})
    : prompt = TextEditingController(text: prompt),
      points = TextEditingController(text: '$points'),
      options = [
        for (final o in options ?? ['', '']) TextEditingController(text: o),
      ];

  factory _QuestionDraft.from(QuizQuestion q) => _QuestionDraft(
    prompt: q.prompt,
    points: q.points,
    options: [for (final o in q.options) o.label],
    correct: q.options.indexWhere((o) => o.isCorrect ?? false).clamp(0, q.options.length - 1),
  );

  final TextEditingController prompt;
  final TextEditingController points;
  final List<TextEditingController> options;
  int correct;

  bool get isComplete => prompt.text.trim().isNotEmpty && options.every((o) => o.text.trim().isNotEmpty);

  Map<String, dynamic> toJson() => {
    'prompt': prompt.text.trim(),
    'points': int.tryParse(points.text) ?? 1,
    'options': [
      for (final (i, o) in options.indexed) {'label': o.text.trim(), 'is_correct': i == correct},
    ],
  };

  void dispose() {
    prompt.dispose();
    points.dispose();
    for (final o in options) {
      o.dispose();
    }
  }
}

/// Layar 22: Editor soal kuis pilihan ganda (1-50 soal, 2-5 opsi, tepat satu benar).
class QuizEditorPage extends ConsumerWidget {
  const QuizEditorPage({super.key, required this.postId});

  final int postId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final post = ref.watch(postProvider(postId));
    final questions = ref.watch(quizProvider(postId));

    return switch ((post, questions)) {
      (AsyncData(value: final p), AsyncData(value: final q)) => _Editor(post: p, initial: q),
      (AsyncError(:final error), _) || (_, AsyncError(:final error)) => Scaffold(
        appBar: AppBar(),
        body: ErrorView(
          error: error,
          onRetry: () => ref
            ..invalidate(postProvider(postId))
            ..invalidate(quizProvider(postId)),
        ),
      ),
      _ => Scaffold(appBar: AppBar(), body: const SkeletonList()),
    };
  }
}

class _Editor extends ConsumerStatefulWidget {
  const _Editor({required this.post, required this.initial});

  final Post post;
  final List<QuizQuestion> initial;

  @override
  ConsumerState<_Editor> createState() => _EditorState();
}

class _EditorState extends ConsumerState<_Editor> {
  late final List<_QuestionDraft> _questions = widget.initial.isEmpty
      ? [_QuestionDraft()]
      : [for (final q in widget.initial) _QuestionDraft.from(q)];
  bool _saving = false;

  @override
  void dispose() {
    for (final q in _questions) {
      q.dispose();
    }
    super.dispose();
  }

  int get _total => _questions.fold(0, (sum, q) => sum + (int.tryParse(q.points.text) ?? 0));

  /// Simpan soal; bila [publish], terbitkan kuis sesudahnya.
  Future<void> _save({required bool publish}) async {
    if (!_questions.every((q) => q.isComplete)) {
      showMessage(context, S.quizIncomplete);
      return;
    }
    setState(() => _saving = true);
    final actions = ref.read(classworkActionsProvider);
    try {
      await actions.saveQuiz(widget.post.id, [for (final q in _questions) q.toJson()]);
      if (publish) await actions.publish(widget.post);
      if (!mounted) return;
      showMessage(context, publish ? S.assignmentCreated : S.quizSaved);
      if (publish) context.pop();
    } on ApiException catch (e) {
      if (mounted) showMessage(context, e.message);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final unpublished = widget.post.status != PostStatus.published;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(tooltip: S.close, icon: const Icon(Symbols.close), onPressed: () => context.pop()),
        title: Text(widget.post.title ?? S.questions),
        actions: [
          TextButton(onPressed: _saving ? null : () => _save(publish: false), child: const Text(S.save)),
          if (unpublished)
            Padding(
              padding: const EdgeInsets.only(right: Space.sm),
              child: FilledButton(onPressed: _saving ? null : () => _save(publish: true), child: const Text(S.assign)),
            ),
        ],
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: Sizes.formMaxWidth + Space.xxl * 4),
          child: ListView(
            padding: const EdgeInsets.all(Space.lg),
            children: [
              Text(S.totalPoints(_total), style: theme.textTheme.titleMedium),
              const SizedBox(height: Space.md),
              for (final (i, q) in _questions.indexed) ...[
                _QuestionEditor(
                  number: i + 1,
                  draft: q,
                  onChanged: () => setState(() {}),
                  onRemove: _questions.length == 1
                      ? null
                      : () => setState(() {
                          _questions.removeAt(i).dispose();
                        }),
                ),
                const SizedBox(height: Space.md),
              ],
              if (_questions.length < 50)
                OutlinedButton.icon(
                  onPressed: () => setState(() => _questions.add(_QuestionDraft())),
                  icon: const Icon(Symbols.add),
                  label: const Text(S.addQuestion),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuestionEditor extends StatelessWidget {
  const _QuestionEditor({required this.number, required this.draft, required this.onChanged, this.onRemove});

  final int number;
  final _QuestionDraft draft;
  final VoidCallback onChanged;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Space.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(child: Text(S.questionNumber(number), style: theme.textTheme.titleMedium)),
                SizedBox(
                  width: Sizes.avatarLg + Space.xl,
                  child: TextField(
                    controller: draft.points,
                    onChanged: (_) => onChanged(),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(labelText: S.points, isDense: true),
                  ),
                ),
                if (onRemove != null)
                  IconButton(tooltip: S.removeQuestion, icon: const Icon(Symbols.delete), onPressed: onRemove),
              ],
            ),
            const SizedBox(height: Space.md),
            TextField(
              controller: draft.prompt,
              onChanged: (_) => onChanged(),
              minLines: 1,
              maxLines: null,
              decoration: const InputDecoration(labelText: S.questionPrompt),
            ),
            const SizedBox(height: Space.sm),
            Text(S.correctAnswer, style: theme.textTheme.labelMedium),
            RadioGroup<int>(
              groupValue: draft.correct,
              onChanged: (v) {
                draft.correct = v ?? 0;
                onChanged();
              },
              child: Column(
                children: [
                  for (final (i, option) in draft.options.indexed)
                    Row(
                      children: [
                        Radio<int>(value: i),
                        Expanded(
                          child: TextField(
                            controller: option,
                            onChanged: (_) => onChanged(),
                            decoration: InputDecoration(labelText: S.optionLabel(i), isDense: true),
                          ),
                        ),
                        IconButton(
                          tooltip: S.removeOption,
                          icon: const Icon(Symbols.close),
                          onPressed: draft.options.length <= 2
                              ? null
                              : () {
                                  draft.options.removeAt(i).dispose();
                                  if (draft.correct >= draft.options.length) draft.correct = 0;
                                  onChanged();
                                },
                        ),
                      ],
                    ),
                ],
              ),
            ),
            if (draft.options.length < 5)
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () {
                    draft.options.add(TextEditingController());
                    onChanged();
                  },
                  icon: const Icon(Symbols.add),
                  label: const Text(S.addOption),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
