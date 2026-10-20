// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stream.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Forum kelas berpaginasi; halaman berikutnya dimuat lewat tombol "Muat lainnya".

@ProviderFor(StreamFeed)
final streamFeedProvider = StreamFeedFamily._();

/// Forum kelas berpaginasi; halaman berikutnya dimuat lewat tombol "Muat lainnya".
final class StreamFeedProvider extends $AsyncNotifierProvider<StreamFeed, StreamState> {
  /// Forum kelas berpaginasi; halaman berikutnya dimuat lewat tombol "Muat lainnya".
  StreamFeedProvider._({required StreamFeedFamily super.from, required int super.argument})
    : super(
        retry: null,
        name: r'streamFeedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$streamFeedHash();

  @override
  String toString() {
    return r'streamFeedProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  StreamFeed create() => StreamFeed();

  @override
  bool operator ==(Object other) {
    return other is StreamFeedProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$streamFeedHash() => r'b59a9ccce73a264a391588f7ddd29c7e62cb72a0';

/// Forum kelas berpaginasi; halaman berikutnya dimuat lewat tombol "Muat lainnya".

final class StreamFeedFamily extends $Family
    with $ClassFamilyOverride<StreamFeed, AsyncValue<StreamState>, StreamState, FutureOr<StreamState>, int> {
  StreamFeedFamily._()
    : super(
        retry: null,
        name: r'streamFeedProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Forum kelas berpaginasi; halaman berikutnya dimuat lewat tombol "Muat lainnya".

  StreamFeedProvider call(int courseId) => StreamFeedProvider._(argument: courseId, from: this);

  @override
  String toString() => r'streamFeedProvider';
}

/// Forum kelas berpaginasi; halaman berikutnya dimuat lewat tombol "Muat lainnya".

abstract class _$StreamFeed extends $AsyncNotifier<StreamState> {
  late final _$args = ref.$arg as int;
  int get courseId => _$args;

  FutureOr<StreamState> build(int courseId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<StreamState>, StreamState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<StreamState>, StreamState>,
              AsyncValue<StreamState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(upcoming)
final upcomingProvider = UpcomingFamily._();

final class UpcomingProvider extends $FunctionalProvider<AsyncValue<List<Post>>, List<Post>, FutureOr<List<Post>>>
    with $FutureModifier<List<Post>>, $FutureProvider<List<Post>> {
  UpcomingProvider._({required UpcomingFamily super.from, required int super.argument})
    : super(
        retry: null,
        name: r'upcomingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$upcomingHash();

  @override
  String toString() {
    return r'upcomingProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Post>> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Post>> create(Ref ref) {
    final argument = this.argument as int;
    return upcoming(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is UpcomingProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$upcomingHash() => r'5e7293963a0cec0fbb71b63848cca794dd7389e0';

final class UpcomingFamily extends $Family with $FunctionalFamilyOverride<FutureOr<List<Post>>, int> {
  UpcomingFamily._()
    : super(
        retry: null,
        name: r'upcomingProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UpcomingProvider call(int courseId) => UpcomingProvider._(argument: courseId, from: this);

  @override
  String toString() => r'upcomingProvider';
}

/// keepAlive: dipakai setelah `await` di widget, jadi tidak boleh ikut dibuang otomatis.

@ProviderFor(streamActions)
final streamActionsProvider = StreamActionsProvider._();

/// keepAlive: dipakai setelah `await` di widget, jadi tidak boleh ikut dibuang otomatis.

final class StreamActionsProvider extends $FunctionalProvider<StreamActions, StreamActions, StreamActions>
    with $Provider<StreamActions> {
  /// keepAlive: dipakai setelah `await` di widget, jadi tidak boleh ikut dibuang otomatis.
  StreamActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'streamActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$streamActionsHash();

  @$internal
  @override
  $ProviderElement<StreamActions> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  StreamActions create(Ref ref) {
    return streamActions(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StreamActions value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<StreamActions>(value));
  }
}

String _$streamActionsHash() => r'95108054eb0f42a002c45e4e1ff70160a33cbe0a';
