// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stream_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(streamRepository)
final streamRepositoryProvider = StreamRepositoryProvider._();

final class StreamRepositoryProvider extends $FunctionalProvider<StreamRepository, StreamRepository, StreamRepository>
    with $Provider<StreamRepository> {
  StreamRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'streamRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$streamRepositoryHash();

  @$internal
  @override
  $ProviderElement<StreamRepository> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  StreamRepository create(Ref ref) {
    return streamRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StreamRepository value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<StreamRepository>(value));
  }
}

String _$streamRepositoryHash() => r'b7bfc1a95883e7503398c20a134a698055d57c8c';
