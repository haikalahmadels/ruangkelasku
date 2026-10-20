import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

import '../core/copy/strings.dart';
import '../core/theme/tokens.dart';
import '../core/widgets/adaptive_scaffold.dart';
import '../core/widgets/notification_bell.dart';
import '../core/widgets/user_avatar.dart';
import '../features/auth/application/session.dart';
import '../features/courses/application/courses.dart';
import '../features/notifications/application/notifications.dart';

/// Kerangka halaman tingkat atas dengan navigasi global (drawer/rail).
/// "Daftar tugas" hanya muncul bila pengguna siswa di suatu kelas,
/// "Perlu diperiksa" bila pengajar, seperti Google Classroom.
class GlobalScaffold extends ConsumerWidget {
  const GlobalScaffold({
    super.key,
    required this.location,
    required this.title,
    required this.body,
    this.actions = const [],
    this.floatingActionButton,
  });

  final String location;
  final Widget title;
  final Widget body;
  final List<Widget> actions;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courses = ref.watch(courseListProvider(archived: false)).value;
    final teaches = courses == null || courses.any((c) => c.isTeacher);
    final studies = courses == null || courses.any((c) => c.isStudent);

    final destinations = [
      const AdaptiveDestination(icon: Symbols.home, selectedIcon: Symbols.home, label: S.navClasses, path: '/'),
      if (studies)
        const AdaptiveDestination(
          icon: Symbols.assignment,
          selectedIcon: Symbols.assignment,
          label: S.navTodo,
          path: '/todo',
        ),
      if (teaches)
        const AdaptiveDestination(
          icon: Symbols.fact_check,
          selectedIcon: Symbols.fact_check,
          label: S.navToReview,
          path: '/to-review',
        ),
      const AdaptiveDestination(
        icon: Symbols.notifications,
        selectedIcon: Symbols.notifications,
        label: S.navNotifications,
        path: '/notifications',
      ),
      const AdaptiveDestination(
        icon: Symbols.archive,
        selectedIcon: Symbols.archive,
        label: S.navArchived,
        path: '/archived',
      ),
      const AdaptiveDestination(
        icon: Symbols.settings,
        selectedIcon: Symbols.settings,
        label: S.navSettings,
        path: '/settings',
      ),
    ];
    final selected = destinations.indexWhere((d) => d.path == location);

    return AdaptiveScaffold(
      title: title,
      body: body,
      destinations: destinations,
      selectedIndex: selected < 0 ? null : selected,
      onDestinationSelected: (i) => context.go(destinations[i].path),
      actions: [
        ...actions,
        NotificationBell(count: ref.watch(unreadCountProvider), onPressed: () => context.go('/notifications')),
        const _AccountMenu(),
      ],
      floatingActionButton: floatingActionButton,
    );
  }
}

class _AccountMenu extends ConsumerWidget {
  const _AccountMenu();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(sessionProvider).value;
    if (user == null) return const SizedBox.shrink();

    return PopupMenuButton<void>(
      tooltip: user.name,
      icon: ExcludeSemantics(
        child: UserAvatar(name: user.name, url: user.avatarUrl, size: Sizes.avatarSm),
      ),
      itemBuilder: (_) => [
        PopupMenuItem(
          enabled: false,
          child: ListTile(title: Text(user.name), subtitle: Text(user.email), contentPadding: EdgeInsets.zero),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          onTap: () => ref.read(sessionProvider.notifier).logout(),
          child: const ListTile(leading: Icon(Symbols.logout), title: Text(S.signOut), contentPadding: EdgeInsets.zero),
        ),
      ],
    );
  }
}
