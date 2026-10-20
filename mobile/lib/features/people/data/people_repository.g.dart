// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'people_repository.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Member _$MemberFromJson(Map<String, dynamic> json) => _Member(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  email: json['email'] as String?,
  avatarUrl: json['avatar_url'] as String?,
  isOwner: json['is_owner'] as bool,
);

Map<String, dynamic> _$MemberToJson(_Member instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'avatar_url': instance.avatarUrl,
  'is_owner': instance.isOwner,
};

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(peopleRepository)
final peopleRepositoryProvider = PeopleRepositoryProvider._();

final class PeopleRepositoryProvider extends $FunctionalProvider<PeopleRepository, PeopleRepository, PeopleRepository>
    with $Provider<PeopleRepository> {
  PeopleRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'peopleRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$peopleRepositoryHash();

  @$internal
  @override
  $ProviderElement<PeopleRepository> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  PeopleRepository create(Ref ref) {
    return peopleRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PeopleRepository value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<PeopleRepository>(value));
  }
}

String _$peopleRepositoryHash() => r'5e98be1bb4c7b91ab2cc45f4f0fb4f45a69ae535';
