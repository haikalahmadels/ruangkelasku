// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'classwork.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(classwork)
final classworkProvider = ClassworkFamily._();

final class ClassworkProvider
    extends $FunctionalProvider<AsyncValue<ClassworkData>, ClassworkData, FutureOr<ClassworkData>>
    with $FutureModifier<ClassworkData>, $FutureProvider<ClassworkData> {
  ClassworkProvider._({required ClassworkFamily super.from, required int super.argument})
    : super(
        retry: null,
        name: r'classworkProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$classworkHash();

  @override
  String toString() {
    return r'classworkProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ClassworkData> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<ClassworkData> create(Ref ref) {
    final argument = this.argument as int;
    return classwork(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ClassworkProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$classworkHash() => r'a0804d194af698e2a944cb3ada888a1536d05c5d';

final class ClassworkFamily extends $Family with $FunctionalFamilyOverride<FutureOr<ClassworkData>, int> {
  ClassworkFamily._()
    : super(
        retry: null,
        name: r'classworkProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ClassworkProvider call(int courseId) => ClassworkProvider._(argument: courseId, from: this);

  @override
  String toString() => r'classworkProvider';
}

@ProviderFor(topics)
final topicsProvider = TopicsFamily._();

final class TopicsProvider extends $FunctionalProvider<AsyncValue<List<Topic>>, List<Topic>, FutureOr<List<Topic>>>
    with $FutureModifier<List<Topic>>, $FutureProvider<List<Topic>> {
  TopicsProvider._({required TopicsFamily super.from, required int super.argument})
    : super(
        retry: null,
        name: r'topicsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$topicsHash();

  @override
  String toString() {
    return r'topicsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Topic>> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Topic>> create(Ref ref) {
    final argument = this.argument as int;
    return topics(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TopicsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$topicsHash() => r'c1fb104f46577d7f84297e5eac0568b8f967368b';

final class TopicsFamily extends $Family with $FunctionalFamilyOverride<FutureOr<List<Topic>>, int> {
  TopicsFamily._()
    : super(
        retry: null,
        name: r'topicsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TopicsProvider call(int courseId) => TopicsProvider._(argument: courseId, from: this);

  @override
  String toString() => r'topicsProvider';
}

@ProviderFor(post)
final postProvider = PostFamily._();

final class PostProvider extends $FunctionalProvider<AsyncValue<Post>, Post, FutureOr<Post>>
    with $FutureModifier<Post>, $FutureProvider<Post> {
  PostProvider._({required PostFamily super.from, required int super.argument})
    : super(
        retry: null,
        name: r'postProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$postHash();

  @override
  String toString() {
    return r'postProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Post> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<Post> create(Ref ref) {
    final argument = this.argument as int;
    return post(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PostProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$postHash() => r'd88a806936c07a7384dc49724bcf58f61a933290';

final class PostFamily extends $Family with $FunctionalFamilyOverride<FutureOr<Post>, int> {
  PostFamily._()
    : super(
        retry: null,
        name: r'postProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PostProvider call(int postId) => PostProvider._(argument: postId, from: this);

  @override
  String toString() => r'postProvider';
}

@ProviderFor(comments)
final commentsProvider = CommentsFamily._();

final class CommentsProvider
    extends $FunctionalProvider<AsyncValue<List<Comment>>, List<Comment>, FutureOr<List<Comment>>>
    with $FutureModifier<List<Comment>>, $FutureProvider<List<Comment>> {
  CommentsProvider._({required CommentsFamily super.from, required int super.argument})
    : super(
        retry: null,
        name: r'commentsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$commentsHash();

  @override
  String toString() {
    return r'commentsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Comment>> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Comment>> create(Ref ref) {
    final argument = this.argument as int;
    return comments(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CommentsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$commentsHash() => r'64fcd444cfae6eba7a46d0b35d43c18d599bc5b5';

final class CommentsFamily extends $Family with $FunctionalFamilyOverride<FutureOr<List<Comment>>, int> {
  CommentsFamily._()
    : super(
        retry: null,
        name: r'commentsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CommentsProvider call(int postId) => CommentsProvider._(argument: postId, from: this);

  @override
  String toString() => r'commentsProvider';
}

@ProviderFor(quiz)
final quizProvider = QuizFamily._();

final class QuizProvider
    extends $FunctionalProvider<AsyncValue<List<QuizQuestion>>, List<QuizQuestion>, FutureOr<List<QuizQuestion>>>
    with $FutureModifier<List<QuizQuestion>>, $FutureProvider<List<QuizQuestion>> {
  QuizProvider._({required QuizFamily super.from, required int super.argument})
    : super(
        retry: null,
        name: r'quizProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$quizHash();

  @override
  String toString() {
    return r'quizProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<QuizQuestion>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<QuizQuestion>> create(Ref ref) {
    final argument = this.argument as int;
    return quiz(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is QuizProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$quizHash() => r'a0091fc1a602e87c2a62db87806ade50af45f9ce';

final class QuizFamily extends $Family with $FunctionalFamilyOverride<FutureOr<List<QuizQuestion>>, int> {
  QuizFamily._()
    : super(
        retry: null,
        name: r'quizProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  QuizProvider call(int postId) => QuizProvider._(argument: postId, from: this);

  @override
  String toString() => r'quizProvider';
}

/// keepAlive: dipakai setelah `await` di widget, jadi tidak boleh ikut dibuang otomatis.

@ProviderFor(classworkActions)
final classworkActionsProvider = ClassworkActionsProvider._();

/// keepAlive: dipakai setelah `await` di widget, jadi tidak boleh ikut dibuang otomatis.

final class ClassworkActionsProvider extends $FunctionalProvider<ClassworkActions, ClassworkActions, ClassworkActions>
    with $Provider<ClassworkActions> {
  /// keepAlive: dipakai setelah `await` di widget, jadi tidak boleh ikut dibuang otomatis.
  ClassworkActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'classworkActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$classworkActionsHash();

  @$internal
  @override
  $ProviderElement<ClassworkActions> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  ClassworkActions create(Ref ref) {
    return classworkActions(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ClassworkActions value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<ClassworkActions>(value));
  }
}

String _$classworkActionsHash() => r'f35b26a30954c628bc2ba584441ba1aa39a2441f';
