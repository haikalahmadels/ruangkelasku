import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/models/paged.dart';
import '../../../core/network/api_exception.dart';
import '../../auth/application/session.dart';
import '../data/notification_repository.dart';

part 'notifications.g.dart';

/// Tanpa push di Fase UTS: jumlah belum dibaca diambil ulang tiap 60 detik
/// dan saat aplikasi kembali ke foreground (docs/api.md, Notifikasi).
const _pollInterval = Duration(seconds: 60);

@Riverpod(keepAlive: true)
class UnreadCount extends _$UnreadCount {
  @override
  int build() {
    if (ref.watch(currentUserIdProvider) == null) return 0;

    final timer = Timer.periodic(_pollInterval, (_) => refresh());
    final lifecycle = AppLifecycleListener(onResume: refresh);
    ref.onDispose(() {
      timer.cancel();
      lifecycle.dispose();
    });

    Future.microtask(refresh);
    return 0;
  }

  /// Galat jaringan diabaikan; angka lama tetap tampil sampai polling berikutnya.
  Future<void> refresh() async {
    try {
      final count = await ref.read(notificationRepositoryProvider).unreadCount();
      if (ref.mounted) state = count;
    } on ApiException {
      // Dicoba lagi pada polling berikutnya.
    }
  }
}

@riverpod
class NotificationFeed extends _$NotificationFeed {
  @override
  Future<PagedState<AppNotification>> build() async {
    ref.watch(currentUserIdProvider);
    return PagedState.first(await ref.watch(notificationRepositoryProvider).list());
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.loadingMore) return;

    state = AsyncData(current.copyWith(loadingMore: true));
    final next = await ref.read(notificationRepositoryProvider).list(page: current.page + 1);
    if (!ref.mounted) return;
    state = AsyncData(current.append(next));
  }

  /// Ditandai langsung di layar; server diberi tahu di belakang.
  Future<void> markRead(AppNotification notification) async {
    if (!notification.isUnread) return;
    _replace((n) => n.id == notification.id ? n.copyWith(readAt: DateTime.now().toUtc()) : n);
    await ref.read(notificationRepositoryProvider).markRead(notification.id);
    await ref.read(unreadCountProvider.notifier).refresh();
  }

  Future<void> markAllRead() async {
    final now = DateTime.now().toUtc();
    _replace((n) => n.isUnread ? n.copyWith(readAt: now) : n);
    await ref.read(notificationRepositoryProvider).markAllRead();
    await ref.read(unreadCountProvider.notifier).refresh();
  }

  void _replace(AppNotification Function(AppNotification) update) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(current.copyWith(items: current.items.map(update).toList()));
  }
}
