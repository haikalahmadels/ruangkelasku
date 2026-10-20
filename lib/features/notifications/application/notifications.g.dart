// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UnreadCount)
final unreadCountProvider = UnreadCountProvider._();

final class UnreadCountProvider extends $NotifierProvider<UnreadCount, int> {
  UnreadCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'unreadCountProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$unreadCountHash();

  @$internal
  @override
  UnreadCount create() => UnreadCount();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<int>(value));
  }
}

String _$unreadCountHash() => r'ee77a7b05b8fc78a9a0bb6c4fc4b93ad81402251';

abstract class _$UnreadCount extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<int, int>, int, Object?, Object?>;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(NotificationFeed)
final notificationFeedProvider = NotificationFeedProvider._();

final class NotificationFeedProvider extends $AsyncNotifierProvider<NotificationFeed, PagedState<AppNotification>> {
  NotificationFeedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationFeedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationFeedHash();

  @$internal
  @override
  NotificationFeed create() => NotificationFeed();
}

String _$notificationFeedHash() => r'971f0a5f5c9c522bdc706ea7faabc54c8ff25539';

abstract class _$NotificationFeed extends $AsyncNotifier<PagedState<AppNotification>> {
  FutureOr<PagedState<AppNotification>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<PagedState<AppNotification>>, PagedState<AppNotification>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PagedState<AppNotification>>, PagedState<AppNotification>>,
              AsyncValue<PagedState<AppNotification>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
