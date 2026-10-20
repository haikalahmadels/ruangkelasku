import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/copy/strings.dart';
import '../../../core/layout/breakpoints.dart';
import '../../../core/theme/course_themes.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/course_banner.dart';
import '../../../core/widgets/user_avatar.dart';
import '../data/course.dart';

class CourseMenuItem {
  const CourseMenuItem(this.label, this.onSelected);

  final String label;
  final VoidCallback onSelected;
}

/// Kartu kelas di beranda dan arsip (docs/design.md, komponen CourseCard).
class CourseCard extends StatefulWidget {
  const CourseCard({super.key, required this.course, required this.onTap, this.menu = const []});

  final Course course;
  final VoidCallback onTap;
  final List<CourseMenuItem> menu;

  @override
  State<CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final course = widget.course;
    final theme = Theme.of(context);
    final onHeader = CourseTheme.of(course.theme).onHeader;
    final headerText = theme.textTheme.apply(bodyColor: onHeader, displayColor: onHeader);
    final reduceMotion = context.reduceMotion;

    // Siswa melihat nama pengajar; pengajar melihat jumlah siswa.
    final subtitle = course.isTeacher
        ? (course.studentCount == null ? null : S.studentCount(course.studentCount!))
        : course.owner?.name;

    return AnimatedScale(
      scale: _pressed && !reduceMotion ? Motion.pressedScale : 1,
      duration: Motion.short,
      curve: Motion.standard,
      child: Card(
        elevation: _hovered ? 2 : 1,
        child: Semantics(
          button: true,
          // Satu label ringkas; teks dan avatar di dalam kartu tidak dibacakan ulang.
          label: [S.openClass(course.name), course.section, subtitle].whereType<String>().join(', '),
          child: InkWell(
            onTap: widget.onTap,
            onHover: (v) => setState(() => _hovered = v),
            onHighlightChanged: (v) => setState(() => _pressed = v),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Hero(
                  tag: 'course-banner-${course.id}',
                  child: CourseBanner(
                    themeKey: course.theme,
                    child: ConstrainedBox(
                      // Bertambah tinggi saat teks diperbesar, tidak memotong nama kelas.
                      constraints: const BoxConstraints(minHeight: Sizes.courseCardHeader),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(Space.lg, Space.md, Space.xs, Space.md),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ExcludeSemantics(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      course.name,
                                      style: headerText.titleLarge,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    if (course.section != null) Text(course.section!, style: headerText.bodyMedium),
                                    if (subtitle != null) ...[
                                      const SizedBox(height: Space.xs),
                                      Text(subtitle, style: headerText.bodyMedium),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                            if (widget.menu.isNotEmpty)
                              PopupMenuButton<int>(
                                tooltip: S.more,
                                iconColor: onHeader,
                                icon: const Icon(Symbols.more_vert),
                                onSelected: (i) => widget.menu[i].onSelected(),
                                itemBuilder: (_) => [
                                  for (final (i, item) in widget.menu.indexed)
                                    PopupMenuItem(value: i, child: Text(item.label)),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                ExcludeSemantics(
                  child: Padding(
                    padding: const EdgeInsets.all(Space.md),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            course.subject ?? course.room ?? '',
                            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (course.owner != null)
                          UserAvatar(name: course.owner!.name, url: course.owner!.avatarUrl, size: Sizes.avatarSm),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Grid kartu: 1 sampai 4 kolom menurut lebar; tinggi kartu mengikuti isinya.
class CourseGrid extends StatelessWidget {
  const CourseGrid({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final columns = context.windowSize.courseGridColumns;
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = (constraints.maxWidth - Space.lg * (columns - 1)) / columns;
        return Wrap(
          spacing: Space.lg,
          runSpacing: Space.lg,
          children: [for (final child in children) SizedBox(width: width, child: child)],
        );
      },
    );
  }
}
