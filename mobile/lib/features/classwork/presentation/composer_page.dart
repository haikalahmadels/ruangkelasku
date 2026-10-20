import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/copy/strings.dart';
import '../../../core/layout/breakpoints.dart';
import '../../../core/models/post.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/utils/pick_datetime.dart';
import '../../../core/utils/uploads.dart';
import '../../../core/widgets/add_attachment_menu.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/widgets/form_widgets.dart';
import '../../../core/widgets/post_card.dart';
import '../application/classwork.dart';
import '../data/classwork_models.dart';

/// Layar 21: Buat tugas, materi, kuis, atau Pertanyaan (alur inti 6, stretch 1).
/// Expanded: form di kiri, panel pengaturan di kanan; Compact: panel di bawah form.
class ComposerPage extends ConsumerStatefulWidget {
  const ComposerPage({super.key, required this.courseId, required this.type});

  final int courseId;
  final PostType type;

  @override
  ConsumerState<ComposerPage> createState() => _ComposerPageState();
}

class _ComposerPageState extends ConsumerState<ComposerPage> {
  final _title = TextEditingController();
  final _body = TextEditingController();
  final _points = TextEditingController(text: '100');
  final _files = <PickedUpload>[];
  final _links = <String>[];
  DateTime? _dueAt;
  int? _topicId;

  /// Pertanyaan: jawaban singkat, atau pilihan ganda dengan 2-5 opsi.
  bool _shortAnswer = true;
  final _options = [TextEditingController(), TextEditingController()];
  bool _loading = false;
  ApiException? _error;

  bool get _isAssignment => widget.type == PostType.assignment;
  bool get _isQuiz => widget.type == PostType.quiz;
  bool get _isQuestion => widget.type == PostType.question;
  bool get _hasPoints => _isAssignment || _isQuestion;
  bool get _hasDue => widget.type.hasSubmissions;
  bool get _dirty =>
      _title.text.trim().isNotEmpty ||
      _body.text.trim().isNotEmpty ||
      _files.isNotEmpty ||
      _options.any((o) => o.text.trim().isNotEmpty);

  @override
  void initState() {
    super.initState();
    _title.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    for (final c in [_title, _body, _points, ..._options]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit(PostStatus status) async {
    final options = _isQuestion && !_shortAnswer ? [for (final o in _options) o.text.trim()] : <String>[];
    if (options.any((o) => o.isEmpty)) {
      showMessage(context, S.optionsIncomplete);
      return;
    }
    DateTime? scheduledAt;
    if (status == PostStatus.scheduled) {
      scheduledAt = await pickWibDateTime(context);
      if (scheduledAt == null) return;
    }
    final points = _hasPoints ? int.tryParse(_points.text.trim()) : null;

    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final draft = PostDraft(
        type: widget.type,
        title: _title.text.trim(),
        body: _body.text.trim(),
        topicId: _topicId,
        points: points,
        dueAt: _dueAt,
        // Kuis disimpan sebagai draf dulu; diterbitkan dari editor soal.
        status: _isQuiz ? PostStatus.draft : status,
        scheduledAt: scheduledAt,
      );
      final actions = ref.read(classworkActionsProvider);
      final post = _isQuestion
          ? await actions.createQuestion(widget.courseId, draft, options, files: _files, links: _links)
          : await actions.createPost(widget.courseId, draft, files: _files, links: _links);
      if (!mounted) return;
      if (_isQuiz) {
        context.pushReplacement('/p/${post.id}/quiz/edit');
        return;
      }
      showMessage(context, switch (status) {
        PostStatus.draft => S.draftSaved,
        PostStatus.scheduled => S.postScheduled,
        PostStatus.published => _isQuestion ? S.questionPosted : S.assignmentCreated,
      });
      context.pop();
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _error = e);
      if (!e.isValidation) showMessage(context, e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _close() async {
    if (!_dirty) {
      context.pop();
      return;
    }
    final discard = await showConfirmDialog(
      context,
      title: S.discardTitle,
      body: S.discardBody,
      confirmLabel: S.discard,
      destructive: true,
    );
    if (discard && mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final canSubmit = _title.text.trim().isNotEmpty && !_loading;
    final primaryLabel = switch (widget.type) {
      PostType.quiz => S.continueToQuestions,
      PostType.material => S.postMaterial,
      PostType.question => S.ask,
      _ => S.assign,
    };
    final wide = context.windowSize.isAtLeastExpanded;

    final form = [
      TextField(
        controller: _title,
        autofocus: true,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          labelText: '${_isQuestion ? S.questionField : S.title} *',
          errorText: _error?.fieldError('title'),
        ),
      ),
      const SizedBox(height: Space.lg),
      TextField(
        controller: _body,
        minLines: 4,
        maxLines: null,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          labelText: widget.type == PostType.material ? S.materialDescription : S.instructions,
          alignLabelWithHint: true,
        ),
      ),
      if (_isQuestion) ...[
        const SizedBox(height: Space.xl),
        _QuestionForm(
          shortAnswer: _shortAnswer,
          options: _options,
          error: _error?.fieldError('options'),
          onKindChanged: (shortAnswer) => setState(() => _shortAnswer = shortAnswer),
          onAdd: () => setState(() => _options.add(TextEditingController())),
          onRemove: (i) => setState(() => _options.removeAt(i).dispose()),
        ),
      ],
      const SizedBox(height: Space.xl),
      Text(S.attachments, style: Theme.of(context).textTheme.titleMedium),
      const SizedBox(height: Space.sm),
      Wrap(
        spacing: Space.sm,
        runSpacing: Space.sm,
        children: [
          for (final (i, file) in _files.indexed)
            _PendingAttachment(
              icon: Symbols.description,
              label: file.name,
              detail: formatFileSize(file.size),
              onRemove: () => setState(() => _files.removeAt(i)),
            ),
          for (final (i, link) in _links.indexed)
            _PendingAttachment(icon: Symbols.link, label: link, onRemove: () => setState(() => _links.removeAt(i))),
        ],
      ),
      const SizedBox(height: Space.sm),
      AddAttachmentMenu(
        label: S.attachments,
        onFiles: (files) async => setState(() => _files.addAll(files)),
        onLink: (url) async => setState(() => _links.add(url)),
      ),
      if (_error?.fieldErrors.keys.any((k) => k.startsWith('files')) ?? false) ...[
        const SizedBox(height: Space.sm),
        Text(
          _error!.fieldErrors.entries.firstWhere((e) => e.key.startsWith('files')).value.first,
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      ],
    ];

    final settings = _Settings(
      courseId: widget.courseId,
      showPoints: _hasPoints,
      showDue: _hasDue,
      points: _points,
      pointsError: _error?.fieldError('points'),
      dueAt: _dueAt,
      dueError: _error?.fieldError('due_at'),
      onDueChanged: (v) => setState(() => _dueAt = v),
      topicId: _topicId,
      onTopicChanged: (v) => setState(() => _topicId = v),
    );

    return PopScope(
      canPop: !_dirty,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _close();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(tooltip: S.close, icon: const Icon(Symbols.close), onPressed: _close),
          title: Text(postTypeName(widget.type)),
          actions: [
            FilledButton(
              onPressed: canSubmit ? () => _submit(PostStatus.published) : null,
              child: _loading
                  ? const SizedBox.square(dimension: Sizes.iconInChip, child: CircularProgressIndicator(strokeWidth: 2))
                  : Text(primaryLabel),
            ),
            if (!_isQuiz)
              PopupMenuButton<PostStatus>(
                tooltip: S.moreActions,
                enabled: canSubmit,
                icon: const Icon(Symbols.arrow_drop_down),
                onSelected: _submit,
                itemBuilder: (_) => const [
                  PopupMenuItem(value: PostStatus.scheduled, child: Text(S.schedule)),
                  PopupMenuItem(value: PostStatus.draft, child: Text(S.saveDraft)),
                ],
              ),
            const SizedBox(width: Space.sm),
          ],
        ),
        body: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: Sizes.contentMaxWidth),
            child: wide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ListView(padding: const EdgeInsets.all(Space.xl), children: form),
                      ),
                      const VerticalDivider(width: 1),
                      SizedBox(
                        width: Sizes.sidePanelWidth + Space.xxl,
                        child: ListView(padding: const EdgeInsets.all(Space.xl), children: [settings]),
                      ),
                    ],
                  )
                : ListView(
                    padding: const EdgeInsets.all(Space.lg),
                    children: [
                      ...form,
                      const Divider(height: Space.xxl),
                      settings,
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

/// Panel pengaturan: poin, tenggat (WIB), topik.
class _Settings extends ConsumerWidget {
  const _Settings({
    required this.courseId,
    required this.showPoints,
    required this.showDue,
    required this.points,
    required this.pointsError,
    required this.dueAt,
    required this.dueError,
    required this.onDueChanged,
    required this.topicId,
    required this.onTopicChanged,
  });

  final int courseId;
  final bool showPoints;
  final bool showDue;
  final TextEditingController points;
  final String? pointsError;
  final DateTime? dueAt;
  final String? dueError;
  final ValueChanged<DateTime?> onDueChanged;
  final int? topicId;
  final ValueChanged<int?> onTopicChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topics = ref.watch(topicsProvider(courseId)).value ?? const <Topic>[];
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(S.forStudents, style: theme.textTheme.labelLarge),
        Text(S.allStudents, style: theme.textTheme.bodyMedium),
        if (showPoints) ...[
          const SizedBox(height: Space.xl),
          TextField(
            controller: points,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(labelText: S.points, helperText: S.noPoints, errorText: pointsError),
          ),
        ],
        if (showDue) ...[
          const SizedBox(height: Space.xl),
          Text(S.due, style: theme.textTheme.labelLarge),
          const SizedBox(height: Space.xs),
          if (dueAt == null)
            OutlinedButton.icon(
              onPressed: () async {
                final picked = await pickWibDateTime(context, defaultTime: const TimeOfDay(hour: 23, minute: 59));
                if (picked != null) onDueChanged(picked);
              },
              icon: const Icon(Symbols.event),
              label: const Text(S.noDue),
            )
          else
            InputChip(
              avatar: const Icon(Symbols.event),
              label: Text('${formatWib(dueAt!, 'EEE, d MMM, HH.mm')} WIB'),
              onPressed: () async {
                final picked = await pickWibDateTime(context, initialUtc: dueAt);
                if (picked != null) onDueChanged(picked);
              },
              onDeleted: () => onDueChanged(null),
              deleteButtonTooltipMessage: S.noDue,
            ),
          if (dueError != null)
            Text(dueError!, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.error)),
        ],
        const SizedBox(height: Space.xl),
        DropdownMenu<int?>(
          label: const Text(S.topic),
          expandedInsets: EdgeInsets.zero,
          initialSelection: topicId,
          onSelected: onTopicChanged,
          dropdownMenuEntries: [
            const DropdownMenuEntry(value: null, label: S.noTopic),
            for (final t in topics) DropdownMenuEntry(value: t.id, label: t.name),
          ],
        ),
      ],
    );
  }
}

/// Jenis jawaban Pertanyaan dan, untuk pilihan ganda, isian 2-5 opsi.
class _QuestionForm extends StatelessWidget {
  const _QuestionForm({
    required this.shortAnswer,
    required this.options,
    required this.error,
    required this.onKindChanged,
    required this.onAdd,
    required this.onRemove,
  });

  static const _maxOptions = 5;
  static const _minOptions = 2;

  final bool shortAnswer;
  final List<TextEditingController> options;
  final String? error;
  final ValueChanged<bool> onKindChanged;
  final VoidCallback onAdd;
  final ValueChanged<int> onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(S.questionKind, style: theme.textTheme.titleMedium),
        const SizedBox(height: Space.sm),
        SegmentedButton<bool>(
          segments: const [
            ButtonSegment(value: true, label: Text(S.shortAnswer), icon: Icon(Symbols.short_text)),
            ButtonSegment(value: false, label: Text(S.multipleChoice), icon: Icon(Symbols.radio_button_checked)),
          ],
          selected: {shortAnswer},
          onSelectionChanged: (s) => onKindChanged(s.single),
        ),
        if (!shortAnswer) ...[
          const SizedBox(height: Space.lg),
          for (final (i, option) in options.indexed)
            Padding(
              padding: const EdgeInsets.only(bottom: Space.sm),
              child: TextField(
                controller: option,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: S.optionLabel(i),
                  prefixIcon: const Icon(Symbols.radio_button_unchecked),
                  suffixIcon: options.length > _minOptions
                      ? IconButton(
                          tooltip: S.removeOption,
                          icon: const Icon(Symbols.close),
                          onPressed: () => onRemove(i),
                        )
                      : null,
                ),
              ),
            ),
          if (options.length < _maxOptions)
            TextButton.icon(onPressed: onAdd, icon: const Icon(Symbols.add), label: const Text(S.addOption)),
        ],
        if (error != null) Text(error!, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.error)),
      ],
    );
  }
}

class _PendingAttachment extends StatelessWidget {
  const _PendingAttachment({required this.icon, required this.label, required this.onRemove, this.detail});

  final IconData icon;
  final String label;
  final String? detail;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return InputChip(
      avatar: Icon(icon),
      label: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: Sizes.attachmentMaxWidth),
        child: Text(detail == null ? label : '$label ($detail)', overflow: TextOverflow.ellipsis),
      ),
      onDeleted: onRemove,
      deleteButtonTooltipMessage: S.delete,
    );
  }
}
