import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/global_scaffold.dart';
import '../../../core/copy/strings.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/async_view.dart';
import '../../../core/widgets/form_widgets.dart';
import '../../../core/widgets/list_detail_layout.dart';
import '../../../core/widgets/ruki_view.dart';
import '../../../core/widgets/staggered.dart';
import '../../classwork/presentation/post_detail_page.dart';
import '../application/notifications.dart';
import '../data/notification_repository.dart';

/// Layar 10: Notifikasi. Setiap notifikasi membuka detail posting atau tugas terkait;
/// di layar lebar detailnya tampil di panel kanan.
class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({super.key});

  @override
  ConsumerState<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage> {
  AppNotification? _selected;

  Future<void> _run(Future<void> Function() action) async {
    try {
      await action();
    } on ApiException catch (e) {
      if (mounted) showMessage(context, e.message);
    }
  }

  void _open(AppNotification notification, {required bool twoPane}) {
    _run(() => ref.read(notificationFeedProvider.notifier).markRead(notification));

    final postId = notification.postId;
    final courseId = notification.courseId;
    if (notification.type == NotificationType.courseInvitation) {
      context.go('/');
    } else if (postId != null && twoPane) {
      setState(() => _selected = notification);
    } else if (postId != null) {
      context.push(_opensStudentWork(notification) ? '/p/$postId/submissions' : '/p/$postId');
    } else if (courseId != null) {
      context.go('/c/$courseId/stream');
    }
  }

  /// Guru langsung ke tab Tugas siswa; bagi siswa rute ini tetap membuka tugasnya sendiri.
  static bool _opensStudentWork(AppNotification n) =>
      n.type == NotificationType.submissionTurnedIn || n.type == NotificationType.privateComment;

  @override
  Widget build(BuildContext context) {
    final feed = ref.watch(notificationFeedProvider);
    final hasUnread = feed.value?.items.any((n) => n.isUnread) ?? false;
    final selected = _selected;

    Future<void> refresh() async {
      ref.invalidate(notificationFeedProvider);
      await ref.read(notificationFeedProvider.future);
      await ref.read(unreadCountProvider.notifier).refresh();
    }

    return GlobalScaffold(
      location: '/notifications',
      title: const Text(S.navNotifications),
      actions: [
        if (hasUnread)
          IconButton(
            tooltip: S.markAllRead,
            icon: const Icon(Symbols.done_all),
            onPressed: () => _run(() => ref.read(notificationFeedProvider.notifier).markAllRead()),
          ),
      ],
      body: ListDetailLayout(
        detail: selected == null
            ? null
            : PostDetailPage(
                key: ValueKey(selected.id),
                postId: selected.postId!,
                studentWork: _opensStudentWork(selected),
              ),
        list: (context, twoPane) => AsyncView(
          value: feed,
          onRetry: refresh,
          data: (state) => RefreshIndicator(
            onRefresh: refresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: Space.sm),
              children: [
                if (state.items.isEmpty) const RukiView(pose: RukiPose.sleep, message: S.emptyNotifications),
                for (final (i, n) in state.items.indexed)
                  Staggered(
                    index: i,
                    child: _NotificationTile(
                      notification: n,
                      selected: twoPane && n.id == selected?.id,
                      onTap: () => _open(n, twoPane: twoPane),
                    ),
                  ),
                if (state.hasMore)
                  Center(
                    child: state.loadingMore
                        ? const CircularProgressIndicator()
                        : TextButton(
                            onPressed: () => ref.read(notificationFeedProvider.notifier).loadMore(),
                            child: const Text(S.loadMore),
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

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.notification, required this.selected, required this.onTap});

  final AppNotification notification;
  final bool selected;
  final VoidCallback onTap;

  static IconData _icon(NotificationType? type) => switch (type) {
    NotificationType.postPublished => Symbols.assignment,
    NotificationType.submissionReturned => Symbols.assignment_return,
    NotificationType.submissionTurnedIn => Symbols.check_circle,
    NotificationType.privateComment => Symbols.chat,
    NotificationType.courseInvitation => Symbols.group_add,
    null => Symbols.notifications,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final unread = notification.isUnread;

    return ListTile(
      selected: selected,
      selectedTileColor: scheme.secondaryContainer,
      onTap: onTap,
      isThreeLine: true,
      leading: CircleAvatar(
        backgroundColor: unread ? scheme.primaryContainer : scheme.surfaceContainerHighest,
        foregroundColor: unread ? scheme.onPrimaryContainer : scheme.onSurfaceVariant,
        child: ExcludeSemantics(child: Icon(_icon(notification.type))),
      ),
      title: Text(notification.title ?? '', style: unread ? theme.textTheme.titleMedium : theme.textTheme.bodyLarge),
      subtitle: Text(
        [?notification.message, formatRelative(notification.createdAt)].join('\n'),
        style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
      ),
      trailing: unread
          ? Semantics(
              label: S.unread,
              child: Badge(backgroundColor: scheme.primary, smallSize: Space.sm),
            )
          : null,
    );
  }
}
