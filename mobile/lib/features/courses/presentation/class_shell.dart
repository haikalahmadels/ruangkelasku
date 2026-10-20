import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/copy/strings.dart';
import '../../../core/layout/breakpoints.dart';
import '../../../core/widgets/async_view.dart';
import '../application/courses.dart';
import '../data/course.dart';

class _ClassTab {
  const _ClassTab(this.label, this.icon, this.segment);

  final String label;
  final IconData icon;
  final String segment;
}

/// Kerangka di dalam kelas: Forum, Tugas Kelas, Anggota, dan Nilai (guru) atau
/// Tugas Anda (siswa). Bottom navigation di Compact, tab di bawah app bar di Medium ke atas.
class ClassShell extends ConsumerWidget {
  const ClassShell({super.key, required this.courseId, required this.location, required this.child});

  final int courseId;
  final String location;
  final Widget child;

  static List<_ClassTab> _tabs(Course course) => [
    const _ClassTab(S.tabStream, Symbols.forum, 'stream'),
    const _ClassTab(S.tabClasswork, Symbols.assignment, 'classwork'),
    const _ClassTab(S.tabPeople, Symbols.group, 'people'),
    course.isTeacher
        ? const _ClassTab(S.tabGrades, Symbols.grading, 'grades')
        : const _ClassTab(S.tabMyWork, Symbols.assignment_ind, 'my-work'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final course = ref.watch(courseProvider(courseId));
    final backButton = IconButton(
      tooltip: S.backToClasses,
      icon: const Icon(Symbols.arrow_back),
      onPressed: () => context.go('/'),
    );

    if (course.hasValue) {
      return _ClassScaffold(course: course.requireValue, location: location, back: backButton, child: child);
    }
    return Scaffold(
      appBar: AppBar(leading: backButton),
      body: course.hasError
          ? ErrorView(error: course.error!, onRetry: () => ref.invalidate(courseProvider(courseId)))
          : const SkeletonList(),
    );
  }
}

class _ClassScaffold extends StatelessWidget {
  const _ClassScaffold({required this.course, required this.location, required this.back, required this.child});

  final Course course;
  final String location;
  final Widget back;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tabs = ClassShell._tabs(course);
    final index = tabs.indexWhere((t) => location.endsWith('/${t.segment}'));
    final selected = index < 0 ? 0 : index;
    void go(int i) => context.go('/c/${course.id}/${tabs[i].segment}');
    final actions = [
      if (course.isTeacher)
        IconButton(
          tooltip: S.classSettings,
          icon: const Icon(Symbols.settings),
          onPressed: () => context.push('/c/${course.id}/settings'),
        ),
    ];

    if (context.windowSize.isCompact) {
      return Scaffold(
        appBar: AppBar(leading: back, title: Text(course.name), actions: actions),
        body: child,
        bottomNavigationBar: NavigationBar(
          selectedIndex: selected,
          onDestinationSelected: go,
          destinations: [
            for (final t in tabs)
              NavigationDestination(icon: Icon(t.icon), selectedIcon: Icon(t.icon, fill: 1), label: t.label),
          ],
        ),
      );
    }

    return DefaultTabController(
      // Kunci per tab terpilih agar indikator selalu mengikuti URL.
      key: ValueKey(selected),
      length: tabs.length,
      initialIndex: selected,
      child: Scaffold(
        appBar: AppBar(
          leading: back,
          title: Text(course.name),
          actions: actions,
          bottom: TabBar(
            onTap: go,
            isScrollable: true,
            tabAlignment: TabAlignment.center,
            tabs: [for (final t in tabs) Tab(text: t.label)],
          ),
        ),
        body: child,
      ),
    );
  }
}
