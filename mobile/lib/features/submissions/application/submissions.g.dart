// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submissions.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(mySubmission)
final mySubmissionProvider = MySubmissionFamily._();

final class MySubmissionProvider extends $FunctionalProvider<AsyncValue<Submission>, Submission, FutureOr<Submission>>
    with $FutureModifier<Submission>, $FutureProvider<Submission> {
  MySubmissionProvider._({required MySubmissionFamily super.from, required int super.argument})
    : super(
        retry: null,
        name: r'mySubmissionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mySubmissionHash();

  @override
  String toString() {
    return r'mySubmissionProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Submission> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<Submission> create(Ref ref) {
    final argument = this.argument as int;
    return mySubmission(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MySubmissionProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$mySubmissionHash() => r'ca3b743d1a42dfdcd0bb6421967d6802ac8b4441';

final class MySubmissionFamily extends $Family with $FunctionalFamilyOverride<FutureOr<Submission>, int> {
  MySubmissionFamily._()
    : super(
        retry: null,
        name: r'mySubmissionProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MySubmissionProvider call(int postId) => MySubmissionProvider._(argument: postId, from: this);

  @override
  String toString() => r'mySubmissionProvider';
}

@ProviderFor(postSubmissions)
final postSubmissionsProvider = PostSubmissionsFamily._();

final class PostSubmissionsProvider
    extends $FunctionalProvider<AsyncValue<SubmissionList>, SubmissionList, FutureOr<SubmissionList>>
    with $FutureModifier<SubmissionList>, $FutureProvider<SubmissionList> {
  PostSubmissionsProvider._({required PostSubmissionsFamily super.from, required int super.argument})
    : super(
        retry: null,
        name: r'postSubmissionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$postSubmissionsHash();

  @override
  String toString() {
    return r'postSubmissionsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<SubmissionList> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<SubmissionList> create(Ref ref) {
    final argument = this.argument as int;
    return postSubmissions(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PostSubmissionsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$postSubmissionsHash() => r'cb880a9cd7039a9f1d1a57bb54b1f66c7d1c4c5c';

final class PostSubmissionsFamily extends $Family with $FunctionalFamilyOverride<FutureOr<SubmissionList>, int> {
  PostSubmissionsFamily._()
    : super(
        retry: null,
        name: r'postSubmissionsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PostSubmissionsProvider call(int postId) => PostSubmissionsProvider._(argument: postId, from: this);

  @override
  String toString() => r'postSubmissionsProvider';
}

@ProviderFor(submission)
final submissionProvider = SubmissionFamily._();

final class SubmissionProvider extends $FunctionalProvider<AsyncValue<Submission>, Submission, FutureOr<Submission>>
    with $FutureModifier<Submission>, $FutureProvider<Submission> {
  SubmissionProvider._({required SubmissionFamily super.from, required int super.argument})
    : super(
        retry: null,
        name: r'submissionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$submissionHash();

  @override
  String toString() {
    return r'submissionProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Submission> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<Submission> create(Ref ref) {
    final argument = this.argument as int;
    return submission(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SubmissionProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$submissionHash() => r'82443ef4d70ac64e76667324a3a131812bffab59';

final class SubmissionFamily extends $Family with $FunctionalFamilyOverride<FutureOr<Submission>, int> {
  SubmissionFamily._()
    : super(
        retry: null,
        name: r'submissionProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SubmissionProvider call(int submissionId) => SubmissionProvider._(argument: submissionId, from: this);

  @override
  String toString() => r'submissionProvider';
}

@ProviderFor(privateComments)
final privateCommentsProvider = PrivateCommentsFamily._();

final class PrivateCommentsProvider
    extends $FunctionalProvider<AsyncValue<List<Comment>>, List<Comment>, FutureOr<List<Comment>>>
    with $FutureModifier<List<Comment>>, $FutureProvider<List<Comment>> {
  PrivateCommentsProvider._({required PrivateCommentsFamily super.from, required int super.argument})
    : super(
        retry: null,
        name: r'privateCommentsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$privateCommentsHash();

  @override
  String toString() {
    return r'privateCommentsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Comment>> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Comment>> create(Ref ref) {
    final argument = this.argument as int;
    return privateComments(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PrivateCommentsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$privateCommentsHash() => r'ecc6158ec37b449c8ac61a97190d70a801a55344';

final class PrivateCommentsFamily extends $Family with $FunctionalFamilyOverride<FutureOr<List<Comment>>, int> {
  PrivateCommentsFamily._()
    : super(
        retry: null,
        name: r'privateCommentsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PrivateCommentsProvider call(int submissionId) => PrivateCommentsProvider._(argument: submissionId, from: this);

  @override
  String toString() => r'privateCommentsProvider';
}

/// keepAlive: dipakai setelah `await` di widget, jadi tidak boleh ikut dibuang otomatis.

@ProviderFor(submissionActions)
final submissionActionsProvider = SubmissionActionsProvider._();

/// keepAlive: dipakai setelah `await` di widget, jadi tidak boleh ikut dibuang otomatis.

final class SubmissionActionsProvider
    extends $FunctionalProvider<SubmissionActions, SubmissionActions, SubmissionActions>
    with $Provider<SubmissionActions> {
  /// keepAlive: dipakai setelah `await` di widget, jadi tidak boleh ikut dibuang otomatis.
  SubmissionActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'submissionActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$submissionActionsHash();

  @$internal
  @override
  $ProviderElement<SubmissionActions> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  SubmissionActions create(Ref ref) {
    return submissionActions(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SubmissionActions value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<SubmissionActions>(value));
  }
}

String _$submissionActionsHash() => r'a2af512b04b333209f22a01f7d0100a1b1823895';
