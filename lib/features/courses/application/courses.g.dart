// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'courses.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(courseList)
final courseListProvider = CourseListFamily._();

final class CourseListProvider
    extends $FunctionalProvider<AsyncValue<List<Course>>, List<Course>, FutureOr<List<Course>>>
    with $FutureModifier<List<Course>>, $FutureProvider<List<Course>> {
  CourseListProvider._({required CourseListFamily super.from, required bool super.argument})
    : super(
        retry: null,
        name: r'courseListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$courseListHash();

  @override
  String toString() {
    return r'courseListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Course>> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Course>> create(Ref ref) {
    final argument = this.argument as bool;
    return courseList(ref, archived: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CourseListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$courseListHash() => r'83dd686fadf76bede5b0ba61fdc219a49de04e76';

final class CourseListFamily extends $Family with $FunctionalFamilyOverride<FutureOr<List<Course>>, bool> {
  CourseListFamily._()
    : super(
        retry: null,
        name: r'courseListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CourseListProvider call({required bool archived}) => CourseListProvider._(argument: archived, from: this);

  @override
  String toString() => r'courseListProvider';
}

@ProviderFor(myInvitations)
final myInvitationsProvider = MyInvitationsProvider._();

final class MyInvitationsProvider
    extends $FunctionalProvider<AsyncValue<List<Invitation>>, List<Invitation>, FutureOr<List<Invitation>>>
    with $FutureModifier<List<Invitation>>, $FutureProvider<List<Invitation>> {
  MyInvitationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myInvitationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myInvitationsHash();

  @$internal
  @override
  $FutureProviderElement<List<Invitation>> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Invitation>> create(Ref ref) {
    return myInvitations(ref);
  }
}

String _$myInvitationsHash() => r'db1748e17bf3fc00735f4f689e73578dcd052dec';

@ProviderFor(course)
final courseProvider = CourseFamily._();

final class CourseProvider extends $FunctionalProvider<AsyncValue<Course>, Course, FutureOr<Course>>
    with $FutureModifier<Course>, $FutureProvider<Course> {
  CourseProvider._({required CourseFamily super.from, required int super.argument})
    : super(
        retry: null,
        name: r'courseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$courseHash();

  @override
  String toString() {
    return r'courseProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Course> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<Course> create(Ref ref) {
    final argument = this.argument as int;
    return course(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CourseProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$courseHash() => r'55fc404152b5944196cbcda14b7384190d8db3ea';

final class CourseFamily extends $Family with $FunctionalFamilyOverride<FutureOr<Course>, int> {
  CourseFamily._()
    : super(
        retry: null,
        name: r'courseProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CourseProvider call(int id) => CourseProvider._(argument: id, from: this);

  @override
  String toString() => r'courseProvider';
}

/// keepAlive: dipakai setelah `await` di widget, jadi tidak boleh ikut dibuang otomatis.

@ProviderFor(courseActions)
final courseActionsProvider = CourseActionsProvider._();

/// keepAlive: dipakai setelah `await` di widget, jadi tidak boleh ikut dibuang otomatis.

final class CourseActionsProvider extends $FunctionalProvider<CourseActions, CourseActions, CourseActions>
    with $Provider<CourseActions> {
  /// keepAlive: dipakai setelah `await` di widget, jadi tidak boleh ikut dibuang otomatis.
  CourseActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'courseActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$courseActionsHash();

  @$internal
  @override
  $ProviderElement<CourseActions> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  CourseActions create(Ref ref) {
    return courseActions(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CourseActions value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<CourseActions>(value));
  }
}

String _$courseActionsHash() => r'6e0dd20cc7b057c4e6e96723cd0bab09026f67b3';
