// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Pengguna yang sedang login; `null` berarti belum login.

@ProviderFor(Session)
final sessionProvider = SessionProvider._();

/// Pengguna yang sedang login; `null` berarti belum login.
final class SessionProvider extends $AsyncNotifierProvider<Session, User?> {
  /// Pengguna yang sedang login; `null` berarti belum login.
  SessionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionHash();

  @$internal
  @override
  Session create() => Session();
}

String _$sessionHash() => r'a66b63257036843dee903cd62aba3b19f0bae5ab';

/// Pengguna yang sedang login; `null` berarti belum login.

abstract class _$Session extends $AsyncNotifier<User?> {
  FutureOr<User?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<User?>, User?>;
    final element =
        ref.element
            as $ClassProviderElement<AnyNotifier<AsyncValue<User?>, User?>, AsyncValue<User?>, Object?, Object?>;
    return element.handleCreate(ref, build);
  }
}

/// ID pengguna aktif; provider data lain mengawasinya agar cache direset saat ganti akun.

@ProviderFor(currentUserId)
final currentUserIdProvider = CurrentUserIdProvider._();

/// ID pengguna aktif; provider data lain mengawasinya agar cache direset saat ganti akun.

final class CurrentUserIdProvider extends $FunctionalProvider<int?, int?, int?> with $Provider<int?> {
  /// ID pengguna aktif; provider data lain mengawasinya agar cache direset saat ganti akun.
  CurrentUserIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentUserIdProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentUserIdHash();

  @$internal
  @override
  $ProviderElement<int?> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  int? create(Ref ref) {
    return currentUserId(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int? value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<int?>(value));
  }
}

String _$currentUserIdHash() => r'7ee68d365025dac838da120424230b814ae1c6c6';
