import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/copy/strings.dart';
import '../../../core/layout/breakpoints.dart';
import '../../../core/models/post.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/async_view.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/widgets/form_widgets.dart';
import '../../../core/widgets/grade_input.dart';
import '../../../core/widgets/status_chip.dart';
import '../../../core/widgets/user_avatar.dart';
import '../application/submissions.dart';
import '../data/submission_repository.dart';
import 'submission_review.dart';

/// Layar 28, tab "Tugas siswa": nilai draf per siswa, kembalikan satu per satu atau massal.
/// Expanded ke atas: daftar di kiri, nilai satu siswa (layar 29) di kanan.
class StudentWorkView extends ConsumerStatefulWidget {
  const StudentWorkView({super.key, required this.post});

  final Post post;

  @override
  ConsumerState<StudentWorkView> createState() => _StudentWorkViewState();
}

class _StudentWorkViewState extends ConsumerState<StudentWorkView> {
  final _selected = <int>{};
  int? _focused;
  bool _returning = false;

  Future<void> _return(List<int> ids) async {
    final ok = await showConfirmDialog(
      context,
      title: S.returnTitle(ids.length),
      body: S.returnBody,
      confirmLabel: S.returnWork,
    );
    if (!ok) return;
    setState(() => _returning = true);
    try {
      await ref.read(submissionActionsProvider).returnMany(widget.post.id, ids);
      if (!mounted) return;
      setState(_selected.clear);
      showMessage(context, S.returned);
    } on ApiException catch (e) {
      if (mounted) showMessage(context, e.message);
    } finally {
      if (mounted) setState(() => _returning = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final list = ref.watch(postSubmissionsProvider(widget.post.id));
    final wide = context.windowSize.isAtLeastExpanded;

    return AsyncView(
      value: list,
      onRetry: () => ref.invalidate(postSubmissionsProvider(widget.post.id)),
      data: (data) {
        final listView = _List(
          post: widget.post,
          data: data,
          selected: _selected,
          focused: _focused,
          returning: _returning,
          onToggle: (id) => setState(() => _selected.contains(id) ? _selected.remove(id) : _selected.add(id)),
          onToggleAll: (all) => setState(() => all ? _selected.addAll(data.items.map((s) => s.id)) : _selected.clear()),
          onOpen: (s) => wide ? setState(() => _focused = s.id) : context.push('/s/${s.id}'),
          onReturn: () => _return(_selected.toList()),
        );
        if (!wide) return listView;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 5, child: listView),
            const VerticalDivider(width: 1),
            Expanded(
              flex: 6,
              child: _focused == null
                  ? Center(child: Text(S.selectStudent, style: Theme.of(context).textTheme.bodyLarge))
                  : SubmissionReview(key: ValueKey(_focused), submissionId: _focused!),
            ),
          ],
        );
      },
    );
  }
}

class _List extends ConsumerWidget {
  const _List({
    required this.post,
    required this.data,
    required this.selected,
    required this.focused,
    required this.returning,
    required this.onToggle,
    required this.onToggleAll,
    required this.onOpen,
    required this.onReturn,
  });

  final Post post;
  final SubmissionList data;
  final Set<int> selected;
  final int? focused;
  final bool returning;
  final ValueChanged<int> onToggle;
  final ValueChanged<bool> onToggleAll;
  final ValueChanged<Submission> onOpen;
  final VoidCallback onReturn;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final counts = data.counts;
    final allSelected = data.items.isNotEmpty && selected.length == data.items.length;

    return ListView(
      padding: EdgeInsets.all(context.windowSize.pageGutter),
      children: [
        Wrap(
          spacing: Space.xxl,
          runSpacing: Space.md,
          children: [
            _Stat(value: counts.turnedIn + counts.graded, label: S.statusLabels['turned_in']!),
            _Stat(value: counts.assigned, label: S.statusLabels['assigned']!),
            _Stat(value: counts.returned, label: S.statusLabels['returned']!),
          ],
        ),
        const SizedBox(height: Space.lg),
        Row(
          children: [
            Checkbox(
              value: allSelected,
              onChanged: data.items.isEmpty ? null : (v) => onToggleAll(v ?? false),
              semanticLabel: S.selectAll,
            ),
            const Text(S.selectAll),
            const Spacer(),
            FilledButton(
              onPressed: selected.isEmpty || returning ? null : onReturn,
              child: Text(selected.isEmpty ? S.returnWork : S.returnSelected(selected.length)),
            ),
          ],
        ),
        const Divider(),
        for (final s in data.items)
          ListTile(
            selected: s.id == focused,
            contentPadding: EdgeInsets.zero,
            onTap: () => onOpen(s),
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                  value: selected.contains(s.id),
                  onChanged: (_) => onToggle(s.id),
                  semanticLabel: s.student?.name,
                ),
                UserAvatar(name: s.student?.name ?? '', url: s.student?.avatarUrl, size: Sizes.avatarSm),
              ],
            ),
            title: Text(s.student?.name ?? ''),
            subtitle: Align(
              alignment: Alignment.centerLeft,
              child: StatusChip(status: s.displayStatus, isLate: s.isLate),
            ),
            trailing: post.points == null
                ? null
                : SizedBox(
                    width: Sizes.avatarLg + Space.xxl + Space.lg,
                    child: GradeInput(
                      key: ValueKey('grade-${s.id}'),
                      initial: s.draftGrade ?? s.grade,
                      maxPoints: post.points!,
                      label: S.gradeFor(s.student?.name ?? ''),
                      onSave: (value) => ref.read(submissionActionsProvider).grade(s, value),
                    ),
                  ),
          ),
        if (data.items.isEmpty) Text(S.noSubmissionYet, style: theme.textTheme.bodyMedium),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$value', style: theme.textTheme.headlineMedium),
        Text(label, style: theme.textTheme.labelMedium),
      ],
    );
  }
}
