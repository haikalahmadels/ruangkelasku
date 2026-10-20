// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grades.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(gradeGrid)
final gradeGridProvider = GradeGridFamily._();

final class GradeGridProvider extends $FunctionalProvider<AsyncValue<GradeGrid>, GradeGrid, FutureOr<GradeGrid>>
    with $FutureModifier<GradeGrid>, $FutureProvider<GradeGrid> {
  GradeGridProvider._({required GradeGridFamily super.from, required int super.argument})
    : super(
        retry: null,
        name: r'gradeGridProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gradeGridHash();

  @override
  String toString() {
    return r'gradeGridProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<GradeGrid> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<GradeGrid> create(Ref ref) {
    final argument = this.argument as int;
    return gradeGrid(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GradeGridProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$gradeGridHash() => r'39d9f2249aa59d973a3fd42ea937a1466c95baa3';

final class GradeGridFamily extends $Family with $FunctionalFamilyOverride<FutureOr<GradeGrid>, int> {
  GradeGridFamily._()
    : super(
        retry: null,
        name: r'gradeGridProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GradeGridProvider call(int courseId) => GradeGridProvider._(argument: courseId, from: this);

  @override
  String toString() => r'gradeGridProvider';
}

@ProviderFor(myWork)
final myWorkProvider = MyWorkFamily._();

final class MyWorkProvider extends $FunctionalProvider<AsyncValue<List<Post>>, List<Post>, FutureOr<List<Post>>>
    with $FutureModifier<List<Post>>, $FutureProvider<List<Post>> {
  MyWorkProvider._({required MyWorkFamily super.from, required int super.argument})
    : super(
        retry: null,
        name: r'myWorkProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myWorkHash();

  @override
  String toString() {
    return r'myWorkProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Post>> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Post>> create(Ref ref) {
    final argument = this.argument as int;
    return myWork(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MyWorkProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$myWorkHash() => r'80a8bb675eab3c283efb472aea60ffc2e0148ea5';

final class MyWorkFamily extends $Family with $FunctionalFamilyOverride<FutureOr<List<Post>>, int> {
  MyWorkFamily._()
    : super(
        retry: null,
        name: r'myWorkProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MyWorkProvider call(int courseId) => MyWorkProvider._(argument: courseId, from: this);

  @override
  String toString() => r'myWorkProvider';
}

/// keepAlive: dipakai setelah `await` di widget, jadi tidak boleh ikut dibuang otomatis.

@ProviderFor(gradeActions)
final gradeActionsProvider = GradeActionsProvider._();

/// keepAlive: dipakai setelah `await` di widget, jadi tidak boleh ikut dibuang otomatis.

final class GradeActionsProvider extends $FunctionalProvider<GradeActions, GradeActions, GradeActions>
    with $Provider<GradeActions> {
  /// keepAlive: dipakai setelah `await` di widget, jadi tidak boleh ikut dibuang otomatis.
  GradeActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gradeActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gradeActionsHash();

  @$internal
  @override
  $ProviderElement<GradeActions> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  GradeActions create(Ref ref) {
    return gradeActions(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GradeActions value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<GradeActions>(value));
  }
}

String _$gradeActionsHash() => r'f36bbd9bff71b01f44ac108096ed20d67d62707d';
