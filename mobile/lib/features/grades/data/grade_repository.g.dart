// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grade_repository.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GradeGrid _$GradeGridFromJson(Map<String, dynamic> json) => _GradeGrid(
  posts: (json['posts'] as List<dynamic>).map((e) => GradedPost.fromJson(e as Map<String, dynamic>)).toList(),
  students: (json['students'] as List<dynamic>).map((e) => StudentGrades.fromJson(e as Map<String, dynamic>)).toList(),
);

Map<String, dynamic> _$GradeGridToJson(_GradeGrid instance) => <String, dynamic>{
  'posts': instance.posts.map((e) => e.toJson()).toList(),
  'students': instance.students.map((e) => e.toJson()).toList(),
};

_GradedPost _$GradedPostFromJson(Map<String, dynamic> json) => _GradedPost(
  id: (json['id'] as num).toInt(),
  type: $enumDecode(_$PostTypeEnumMap, json['type']),
  title: json['title'] as String?,
  points: (json['points'] as num?)?.toInt(),
  dueAt: json['due_at'] == null ? null : DateTime.parse(json['due_at'] as String),
);

Map<String, dynamic> _$GradedPostToJson(_GradedPost instance) => <String, dynamic>{
  'id': instance.id,
  'type': _$PostTypeEnumMap[instance.type]!,
  'title': instance.title,
  'points': instance.points,
  'due_at': instance.dueAt?.toIso8601String(),
};

const _$PostTypeEnumMap = {
  PostType.announcement: 'announcement',
  PostType.material: 'material',
  PostType.assignment: 'assignment',
  PostType.quiz: 'quiz',
  PostType.question: 'question',
};

_StudentGrades _$StudentGradesFromJson(Map<String, dynamic> json) => _StudentGrades(
  user: UserSummary.fromJson(json['user'] as Map<String, dynamic>),
  grades:
      (json['grades'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e == null ? null : GradeCell.fromJson(e as Map<String, dynamic>)),
      ) ??
      const <String, GradeCell?>{},
);

Map<String, dynamic> _$StudentGradesToJson(_StudentGrades instance) => <String, dynamic>{
  'user': instance.user.toJson(),
  'grades': instance.grades.map((k, e) => MapEntry(k, e?.toJson())),
};

_GradeCell _$GradeCellFromJson(Map<String, dynamic> json) => _GradeCell(
  displayStatus: $enumDecode(_$DisplayStatusEnumMap, json['display_status']),
  grade: (json['grade'] as num?)?.toDouble(),
  draftGrade: (json['draft_grade'] as num?)?.toDouble(),
);

Map<String, dynamic> _$GradeCellToJson(_GradeCell instance) => <String, dynamic>{
  'display_status': _$DisplayStatusEnumMap[instance.displayStatus]!,
  'grade': instance.grade,
  'draft_grade': instance.draftGrade,
};

const _$DisplayStatusEnumMap = {
  DisplayStatus.assigned: 'assigned',
  DisplayStatus.missing: 'missing',
  DisplayStatus.turnedIn: 'turned_in',
  DisplayStatus.graded: 'graded',
  DisplayStatus.returned: 'returned',
};

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(gradeRepository)
final gradeRepositoryProvider = GradeRepositoryProvider._();

final class GradeRepositoryProvider extends $FunctionalProvider<GradeRepository, GradeRepository, GradeRepository>
    with $Provider<GradeRepository> {
  GradeRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gradeRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gradeRepositoryHash();

  @$internal
  @override
  $ProviderElement<GradeRepository> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  GradeRepository create(Ref ref) {
    return gradeRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GradeRepository value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<GradeRepository>(value));
  }
}

String _$gradeRepositoryHash() => r'4f816df28f36b85435b00245ea821eebe34096ec';
