import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/copy/strings.dart';
import '../../../core/layout/breakpoints.dart';
import '../../../core/models/display_status.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/async_view.dart';
import '../../../core/widgets/form_widgets.dart';
import '../../../core/widgets/post_card.dart';
import '../../../core/widgets/ruki_view.dart';
import '../../../core/widgets/user_avatar.dart';
import '../application/grades.dart';
import '../data/grade_repository.dart';

enum _GradeView { byStudent, byAssignment }

/// Layar 15: Nilai (guru). Grid siswa × tugas di layar lebar; di HP tampilan
/// per siswa atau per tugas (product brief, Penilaian). Alur inti 9.
class GradesPage extends ConsumerStatefulWidget {
  const GradesPage({super.key, required this.courseId});

  final int courseId;

  @override
  ConsumerState<GradesPage> createState() => _GradesPageState();
}

class _GradesPageState extends ConsumerState<GradesPage> {
  _GradeView _view = _GradeView.byStudent;
  bool _exporting = false;

  Future<void> _refresh() async {
    ref.invalidate(gradeGridProvider(widget.courseId));
    await ref.read(gradeGridProvider(widget.courseId).future);
  }

  Future<void> _export() async {
    setState(() => _exporting = true);
    try {
      final downloaded = await ref.read(gradeActionsProvider).exportCsv(widget.courseId);
      if (downloaded && mounted) showMessage(context, S.exportDownloaded);
    } on ApiException catch (e) {
      if (mounted) showMessage(context, e.message);
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final grid = ref.watch(gradeGridProvider(widget.courseId));
    final size = context.windowSize;
    final gutter = size.pageGutter;

    return AsyncView(
      value: grid,
      onRetry: _refresh,
      data: (data) {
        if (data.posts.isEmpty) return const RukiView(pose: RukiPose.read, message: S.emptyGrades);
        if (data.students.isEmpty) return const RukiView(pose: RukiPose.read, message: S.noStudents);

        final toolbar = Wrap(
          spacing: Space.md,
          runSpacing: Space.sm,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            if (!size.isAtLeastExpanded)
              SegmentedButton<_GradeView>(
                segments: const [
                  ButtonSegment(value: _GradeView.byStudent, label: Text(S.byStudent), icon: Icon(Symbols.person)),
                  ButtonSegment(
                    value: _GradeView.byAssignment,
                    label: Text(S.byAssignment),
                    icon: Icon(Symbols.assignment),
                  ),
                ],
                selected: {_view},
                onSelectionChanged: (s) => setState(() => _view = s.single),
              ),
            OutlinedButton.icon(
              onPressed: _exporting ? null : _export,
              icon: _exporting
                  ? const SizedBox.square(dimension: Sizes.iconInChip, child: CircularProgressIndicator())
                  : const Icon(Symbols.download),
              label: const Text(S.exportCsv),
            ),
          ],
        );

        if (size.isAtLeastExpanded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(padding: EdgeInsets.fromLTRB(gutter, gutter, gutter, Space.lg), child: toolbar),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _refresh,
                  child: _GradeTable(grid: data),
                ),
              ),
            ],
          );
        }

        return RefreshIndicator(
          onRefresh: _refresh,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(gutter),
            children: [
              toolbar,
              const SizedBox(height: Space.lg),
              if (_view == _GradeView.byStudent)
                for (final student in data.students) _StudentTile(student: student, posts: data.posts)
              else
                for (final post in data.posts) _AssignmentTile(post: post, students: data.students),
            ],
          ),
        );
      },
    );
  }
}

/// Teks nilai yang dibacakan pembaca layar; sama dengan isi visual [_GradeValue].
String _gradeText(GradeCell? cell) {
  if (cell == null) return S.notGraded;
  if (cell.displayStatus == DisplayStatus.returned && cell.grade != null) return formatGrade(cell.grade!);
  if (cell.draftGrade != null) return '${formatGrade(cell.draftGrade!)} ${S.draftShort}';
  return switch (cell.displayStatus) {
    DisplayStatus.assigned => S.notGraded,
    DisplayStatus.missing => S.statusLabels['missing']!,
    DisplayStatus.turnedIn || DisplayStatus.graded => S.statusLabels['turned_in']!,
    DisplayStatus.returned => S.statusLabels['returned']!,
  };
}

/// Isi satu sel: nilai dikembalikan, nilai draf (bertanda "Draf"), atau status.
class _GradeValue extends StatelessWidget {
  const _GradeValue({required this.cell});

  final GradeCell? cell;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = context.appColors;
    final c = cell;

    if (c == null || c.displayStatus == DisplayStatus.assigned) return const SizedBox.shrink();
    if (c.displayStatus == DisplayStatus.returned && c.grade != null) {
      return Text(formatGrade(c.grade!), style: textTheme.bodyLarge);
    }
    if (c.draftGrade != null) {
      final draftColor = colors.status[DisplayStatus.graded]!.foreground;
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(formatGrade(c.draftGrade!), style: textTheme.bodyLarge?.copyWith(fontStyle: FontStyle.italic)),
          Text(S.draftShort, style: textTheme.labelSmall?.copyWith(color: draftColor)),
        ],
      );
    }

    final status = c.displayStatus == DisplayStatus.graded ? DisplayStatus.turnedIn : c.displayStatus;
    return Text(
      _gradeText(c),
      textAlign: TextAlign.center,
      style: textTheme.labelMedium?.copyWith(color: colors.status[status]!.foreground),
    );
  }
}

/// Grid layar lebar: kolom nama tetap di kiri, kolom tugas bergulir mendatar.
class _GradeTable extends StatefulWidget {
  const _GradeTable({required this.grid});

  final GradeGrid grid;

  @override
  State<_GradeTable> createState() => _GradeTableState();
}

class _GradeTableState extends State<_GradeTable> {
  final _horizontal = ScrollController();

  @override
  void dispose() {
    _horizontal.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final border = BorderSide(color: theme.colorScheme.outlineVariant);
    // Tinggi baris ikut membesar bersama skala teks agar tidak terpotong.
    final scaler = MediaQuery.textScalerOf(context);
    final rowHeight = scaler.scale(Sizes.gradeRowHeight);
    final headerHeight = scaler.scale(Sizes.gradeHeaderHeight);
    final posts = widget.grid.posts;
    final students = widget.grid.students;

    Widget cell({required Widget child, double? width, required double height, bool right = true}) => Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border(bottom: border, right: right ? border : BorderSide.none),
      ),
      child: child,
    );

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: Sizes.gradeNameColumnWidth,
            child: Column(
              children: [
                cell(
                  height: headerHeight,
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(Space.md),
                      child: Text(S.students, style: theme.textTheme.titleSmall),
                    ),
                  ),
                ),
                for (final s in students)
                  cell(
                    height: rowHeight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Space.md),
                      child: Row(
                        children: [
                          UserAvatar(name: s.user.name, url: s.user.avatarUrl, size: Sizes.avatarSm),
                          const SizedBox(width: Space.sm),
                          Expanded(child: Text(s.user.name, maxLines: 2, overflow: TextOverflow.ellipsis)),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Scrollbar(
              controller: _horizontal,
              thumbVisibility: true,
              child: SingleChildScrollView(
                controller: _horizontal,
                scrollDirection: Axis.horizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        for (final p in posts)
                          cell(
                            width: Sizes.gradeColumnWidth,
                            height: headerHeight,
                            child: _PostHeader(post: p),
                          ),
                      ],
                    ),
                    for (final s in students)
                      Row(
                        children: [
                          for (final p in posts)
                            cell(
                              width: Sizes.gradeColumnWidth,
                              height: rowHeight,
                              child: Semantics(
                                label: S.gradeCellLabel(s.user.name, p.title ?? '', _gradeText(s.cellFor(p.id))),
                                child: ExcludeSemantics(
                                  // Tinggi baris tetap agar sejajar dengan kolom nama; isi mengecil bila perlu.
                                  child: Padding(
                                    padding: const EdgeInsets.all(Space.xs),
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: _GradeValue(cell: s.cellFor(p.id)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Judul kolom: tenggat, judul tugas, poin maksimal. Ketuk untuk membuka Tugas siswa.
class _PostHeader extends StatelessWidget {
  const _PostHeader({required this.post});

  final GradedPost post;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final muted = textTheme.labelSmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant);

    return Tooltip(
      message: post.title ?? '',
      child: InkWell(
        onTap: () => context.push('/p/${post.id}/submissions'),
        child: Padding(
          padding: const EdgeInsets.all(Space.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(post.dueAt == null ? S.noDue : formatWib(post.dueAt!, 'd MMM'), style: muted),
              // Judul mengalah bila ruang sempit (mis. skala teks besar); judul lengkap ada di tooltip.
              Flexible(
                child: Text(
                  post.title ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleSmall,
                ),
              ),
              Text(post.points == null ? S.noGradePoints : S.outOf(post.points!), style: muted),
            ],
          ),
        ),
      ),
    );
  }
}

/// Tampilan per siswa (HP): semua nilai satu siswa.
class _StudentTile extends StatelessWidget {
  const _StudentTile({required this.student, required this.posts});

  final StudentGrades student;
  final List<GradedPost> posts;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: UserAvatar(name: student.user.name, url: student.user.avatarUrl),
      title: Text(student.user.name),
      shape: const RoundedRectangleBorder(borderRadius: Radii.mdAll),
      collapsedShape: const RoundedRectangleBorder(borderRadius: Radii.mdAll),
      children: [
        for (final post in posts)
          _GradeRow(
            title: post.title ?? '',
            subtitle: post.points == null ? S.noGradePoints : S.outOf(post.points!),
            cell: student.cellFor(post.id),
            onTap: () => context.push('/p/${post.id}/submissions'),
          ),
      ],
    );
  }
}

/// Tampilan per tugas (HP): nilai semua siswa untuk satu tugas.
class _AssignmentTile extends StatelessWidget {
  const _AssignmentTile({required this.post, required this.students});

  final GradedPost post;
  final List<StudentGrades> students;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ExpansionTile(
      leading: CircleAvatar(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        child: ExcludeSemantics(child: Icon(postTypeIcon(post.type))),
      ),
      title: Text(post.title ?? ''),
      subtitle: Text(
        [
          if (post.dueAt != null) formatDue(post.dueAt!),
          post.points == null ? S.noGradePoints : S.outOf(post.points!),
        ].join(', '),
      ),
      shape: const RoundedRectangleBorder(borderRadius: Radii.mdAll),
      collapsedShape: const RoundedRectangleBorder(borderRadius: Radii.mdAll),
      children: [
        for (final s in students) _GradeRow(title: s.user.name, cell: s.cellFor(post.id)),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () => context.push('/p/${post.id}/submissions'),
            icon: const Icon(Symbols.open_in_new),
            label: const Text(S.tabStudentWork),
          ),
        ),
      ],
    );
  }
}

class _GradeRow extends StatelessWidget {
  const _GradeRow({required this.title, required this.cell, this.subtitle, this.onTap});

  final String title;
  final String? subtitle;
  final GradeCell? cell;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: ListTile(
        onTap: onTap,
        title: Text(title),
        subtitle: subtitle == null ? null : Text(subtitle!),
        trailing: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: Sizes.gradeColumnWidth),
          child: _GradeValue(cell: cell),
        ),
      ),
    );
  }
}
