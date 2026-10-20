// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'classwork_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(classworkRepository)
final classworkRepositoryProvider = ClassworkRepositoryProvider._();

final class ClassworkRepositoryProvider
    extends $FunctionalProvider<ClassworkRepository, ClassworkRepository, ClassworkRepository>
    with $Provider<ClassworkRepository> {
  ClassworkRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'classworkRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$classworkRepositoryHash();

  @$internal
  @override
  $ProviderElement<ClassworkRepository> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  ClassworkRepository create(Ref ref) {
    return classworkRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ClassworkRepository value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<ClassworkRepository>(value));
  }
}

String _$classworkRepositoryHash() => r'68ab41245f5278f44724bf97b4dbe3bc6f0435d5';
