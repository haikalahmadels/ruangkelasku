// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Satu tab Daftar tugas; [courseId] null berarti semua kelas.

@ProviderFor(TodoFeed)
final todoFeedProvider = TodoFeedFamily._();

/// Satu tab Daftar tugas; [courseId] null berarti semua kelas.
final class TodoFeedProvider extends $AsyncNotifierProvider<TodoFeed, PagedState<Post>> {
  /// Satu tab Daftar tugas; [courseId] null berarti semua kelas.
  TodoFeedProvider._({required TodoFeedFamily super.from, required (TodoTab, int?) super.argument})
    : super(
        retry: null,
        name: r'todoFeedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todoFeedHash();

  @override
  String toString() {
    return r'todoFeedProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  TodoFeed create() => TodoFeed();

  @override
  bool operator ==(Object other) {
    return other is TodoFeedProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$todoFeedHash() => r'b256e6c5da50afe045b75d6de511be8535782798';

/// Satu tab Daftar tugas; [courseId] null berarti semua kelas.

final class TodoFeedFamily extends $Family
    with
        $ClassFamilyOverride<
          TodoFeed,
          AsyncValue<PagedState<Post>>,
          PagedState<Post>,
          FutureOr<PagedState<Post>>,
          (TodoTab, int?)
        > {
  TodoFeedFamily._()
    : super(
        retry: null,
        name: r'todoFeedProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Satu tab Daftar tugas; [courseId] null berarti semua kelas.

  TodoFeedProvider call(TodoTab tab, int? courseId) => TodoFeedProvider._(argument: (tab, courseId), from: this);

  @override
  String toString() => r'todoFeedProvider';
}

/// Satu tab Daftar tugas; [courseId] null berarti semua kelas.

abstract class _$TodoFeed extends $AsyncNotifier<PagedState<Post>> {
  late final _$args = ref.$arg as (TodoTab, int?);
  TodoTab get tab => _$args.$1;
  int? get courseId => _$args.$2;

  FutureOr<PagedState<Post>> build(TodoTab tab, int? courseId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<PagedState<Post>>, PagedState<Post>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PagedState<Post>>, PagedState<Post>>,
              AsyncValue<PagedState<Post>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args.$1, _$args.$2));
  }
}

/// Perlu diperiksa (guru); [courseId] null berarti semua kelas.

@ProviderFor(ToReviewFeed)
final toReviewFeedProvider = ToReviewFeedFamily._();

/// Perlu diperiksa (guru); [courseId] null berarti semua kelas.
final class ToReviewFeedProvider extends $AsyncNotifierProvider<ToReviewFeed, PagedState<Post>> {
  /// Perlu diperiksa (guru); [courseId] null berarti semua kelas.
  ToReviewFeedProvider._({required ToReviewFeedFamily super.from, required int? super.argument})
    : super(
        retry: null,
        name: r'toReviewFeedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$toReviewFeedHash();

  @override
  String toString() {
    return r'toReviewFeedProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ToReviewFeed create() => ToReviewFeed();

  @override
  bool operator ==(Object other) {
    return other is ToReviewFeedProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$toReviewFeedHash() => r'e975829928571dde0273aa22c528959bdd3d779a';

/// Perlu diperiksa (guru); [courseId] null berarti semua kelas.

final class ToReviewFeedFamily extends $Family
    with
        $ClassFamilyOverride<
          ToReviewFeed,
          AsyncValue<PagedState<Post>>,
          PagedState<Post>,
          FutureOr<PagedState<Post>>,
          int?
        > {
  ToReviewFeedFamily._()
    : super(
        retry: null,
        name: r'toReviewFeedProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Perlu diperiksa (guru); [courseId] null berarti semua kelas.

  ToReviewFeedProvider call(int? courseId) => ToReviewFeedProvider._(argument: courseId, from: this);

  @override
  String toString() => r'toReviewFeedProvider';
}

/// Perlu diperiksa (guru); [courseId] null berarti semua kelas.

abstract class _$ToReviewFeed extends $AsyncNotifier<PagedState<Post>> {
  late final _$args = ref.$arg as int?;
  int? get courseId => _$args;

  FutureOr<PagedState<Post>> build(int? courseId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<PagedState<Post>>, PagedState<Post>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PagedState<Post>>, PagedState<Post>>,
              AsyncValue<PagedState<Post>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
