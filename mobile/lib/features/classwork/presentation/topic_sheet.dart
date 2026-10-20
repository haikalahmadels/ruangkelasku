import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/copy/strings.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/widgets/form_widgets.dart';
import '../application/classwork.dart';
import '../data/classwork_models.dart';

/// Layar 23: Kelola topik (bottom sheet). Urutan diubah dengan tombol, bukan seret,
/// agar tidak ada aksi yang hanya bisa dilakukan lewat gestur.
Future<void> showTopicSheet(BuildContext context, int courseId, {bool startAdding = false}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) => _TopicSheet(courseId: courseId, startAdding: startAdding),
  );
}

class _TopicSheet extends ConsumerStatefulWidget {
  const _TopicSheet({required this.courseId, required this.startAdding});

  final int courseId;
  final bool startAdding;

  @override
  ConsumerState<_TopicSheet> createState() => _TopicSheetState();
}

class _TopicSheetState extends ConsumerState<_TopicSheet> {
  final _name = TextEditingController();

  @override
  void initState() {
    super.initState();
    _name.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _run(Future<void> Function() action) async {
    try {
      await action();
    } on ApiException catch (e) {
      if (mounted) showMessage(context, e.message);
    }
  }

  Future<void> _rename(Topic topic) async {
    final controller = TextEditingController(text: topic.name);
    final name = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(S.rename),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(labelText: S.topicName),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text(S.cancel)),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, controller.text.trim()),
            child: const Text(S.save),
          ),
        ],
      ),
    );
    controller.dispose();
    if (name == null || name.isEmpty) return;
    await _run(() => ref.read(classworkActionsProvider).renameTopic(widget.courseId, topic.id, name));
  }

  @override
  Widget build(BuildContext context) {
    final topics = ref.watch(topicsProvider(widget.courseId)).value ?? const <Topic>[];
    final actions = ref.read(classworkActionsProvider);
    final ids = [for (final t in topics) t.id];

    Future<void> move(int index, int delta) {
      final reordered = [...ids];
      reordered[index] = ids[index + delta];
      reordered[index + delta] = ids[index];
      return _run(() => actions.reorderTopics(widget.courseId, reordered));
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(Space.xl, 0, Space.xl, Space.xl + MediaQuery.viewInsetsOf(context).bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(S.manageTopics, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: Space.lg),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _name,
                  autofocus: widget.startAdding,
                  decoration: const InputDecoration(labelText: S.topicName),
                  onSubmitted: (_) => _add(),
                ),
              ),
              const SizedBox(width: Space.sm),
              FilledButton(onPressed: _name.text.trim().isEmpty ? null : _add, child: const Text(S.addTopic)),
            ],
          ),
          const SizedBox(height: Space.md),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: [
                for (final (i, topic) in topics.indexed)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(topic.name),
                    trailing: Wrap(
                      children: [
                        IconButton(
                          tooltip: S.moveUp,
                          icon: const Icon(Symbols.arrow_upward),
                          onPressed: i == 0 ? null : () => move(i, -1),
                        ),
                        IconButton(
                          tooltip: S.moveDown,
                          icon: const Icon(Symbols.arrow_downward),
                          onPressed: i == topics.length - 1 ? null : () => move(i, 1),
                        ),
                        IconButton(tooltip: S.rename, icon: const Icon(Symbols.edit), onPressed: () => _rename(topic)),
                        IconButton(
                          tooltip: S.delete,
                          icon: const Icon(Symbols.delete),
                          onPressed: () async {
                            final ok = await showConfirmDialog(
                              context,
                              title: S.deleteTopicTitle(topic.name),
                              body: S.deleteTopicBody,
                              confirmLabel: S.delete,
                              destructive: true,
                            );
                            if (ok) await _run(() => actions.deleteTopic(widget.courseId, topic.id));
                          },
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _add() async {
    final name = _name.text.trim();
    if (name.isEmpty) return;
    await _run(() => ref.read(classworkActionsProvider).createTopic(widget.courseId, name));
    _name.clear();
  }
}
