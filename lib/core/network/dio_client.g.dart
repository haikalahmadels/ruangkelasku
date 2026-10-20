// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dio_client.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Bertambah setiap kali API membalas 401; sesi mendengarkan ini untuk keluar.

@ProviderFor(UnauthorizedSignal)
final unauthorizedSignalProvider = UnauthorizedSignalProvider._();

/// Bertambah setiap kali API membalas 401; sesi mendengarkan ini untuk keluar.
final class UnauthorizedSignalProvider extends $NotifierProvider<UnauthorizedSignal, int> {
  /// Bertambah setiap kali API membalas 401; sesi mendengarkan ini untuk keluar.
  UnauthorizedSignalProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'unauthorizedSignalProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$unauthorizedSignalHash();

  @$internal
  @override
  UnauthorizedSignal create() => UnauthorizedSignal();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<int>(value));
  }
}

String _$unauthorizedSignalHash() => r'e3b1fc5c6a3b244d435eff62d5fc18acf693be6f';

/// Bertambah setiap kali API membalas 401; sesi mendengarkan ini untuk keluar.

abstract class _$UnauthorizedSignal extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<int, int>, int, Object?, Object?>;
    return element.handleCreate(ref, build);
  }
}

/// Satu instance Dio dengan header token dan penanganan 401 (docs/architecture.md).

@ProviderFor(dio)
final dioProvider = DioProvider._();

/// Satu instance Dio dengan header token dan penanganan 401 (docs/architecture.md).

final class DioProvider extends $FunctionalProvider<Dio, Dio, Dio> with $Provider<Dio> {
  /// Satu instance Dio dengan header token dan penanganan 401 (docs/architecture.md).
  DioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dioProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dioHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return dio(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<Dio>(value));
  }
}

String _$dioHash() => r'a4d90798f8b80b7fc69a36c100f921a86fabe0cd';
