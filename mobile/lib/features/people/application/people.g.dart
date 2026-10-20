// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'people.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(members)
final membersProvider = MembersFamily._();

final class MembersProvider extends $FunctionalProvider<AsyncValue<Members>, Members, FutureOr<Members>>
    with $FutureModifier<Members>, $FutureProvider<Members> {
  MembersProvider._({required MembersFamily super.from, required int super.argument})
    : super(
        retry: null,
        name: r'membersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$membersHash();

  @override
  String toString() {
    return r'membersProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Members> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<Members> create(Ref ref) {
    final argument = this.argument as int;
    return members(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MembersProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$membersHash() => r'3f1e8770ec2b36289096f317a2347d4894a71a87';

final class MembersFamily extends $Family with $FunctionalFamilyOverride<FutureOr<Members>, int> {
  MembersFamily._()
    : super(
        retry: null,
        name: r'membersProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MembersProvider call(int courseId) => MembersProvider._(argument: courseId, from: this);

  @override
  String toString() => r'membersProvider';
}

@ProviderFor(pendingInvitations)
final pendingInvitationsProvider = PendingInvitationsFamily._();

final class PendingInvitationsProvider
    extends $FunctionalProvider<AsyncValue<List<Invitation>>, List<Invitation>, FutureOr<List<Invitation>>>
    with $FutureModifier<List<Invitation>>, $FutureProvider<List<Invitation>> {
  PendingInvitationsProvider._({required PendingInvitationsFamily super.from, required int super.argument})
    : super(
        retry: null,
        name: r'pendingInvitationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pendingInvitationsHash();

  @override
  String toString() {
    return r'pendingInvitationsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Invitation>> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Invitation>> create(Ref ref) {
    final argument = this.argument as int;
    return pendingInvitations(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PendingInvitationsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$pendingInvitationsHash() => r'd72f23d939cf3baac7f240d458387896528aba3f';

final class PendingInvitationsFamily extends $Family with $FunctionalFamilyOverride<FutureOr<List<Invitation>>, int> {
  PendingInvitationsFamily._()
    : super(
        retry: null,
        name: r'pendingInvitationsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PendingInvitationsProvider call(int courseId) => PendingInvitationsProvider._(argument: courseId, from: this);

  @override
  String toString() => r'pendingInvitationsProvider';
}

/// keepAlive: dipakai setelah `await` di widget, jadi tidak boleh ikut dibuang otomatis.

@ProviderFor(peopleActions)
final peopleActionsProvider = PeopleActionsProvider._();

/// keepAlive: dipakai setelah `await` di widget, jadi tidak boleh ikut dibuang otomatis.

final class PeopleActionsProvider extends $FunctionalProvider<PeopleActions, PeopleActions, PeopleActions>
    with $Provider<PeopleActions> {
  /// keepAlive: dipakai setelah `await` di widget, jadi tidak boleh ikut dibuang otomatis.
  PeopleActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'peopleActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$peopleActionsHash();

  @$internal
  @override
  $ProviderElement<PeopleActions> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  PeopleActions create(Ref ref) {
    return peopleActions(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PeopleActions value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<PeopleActions>(value));
  }
}

String _$peopleActionsHash() => r'6447e65ca9156fe9144e71766ad70e049a59d755';
