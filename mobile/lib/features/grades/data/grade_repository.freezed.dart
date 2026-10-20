// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'grade_repository.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GradeGrid {

 List<GradedPost> get posts; List<StudentGrades> get students;
/// Create a copy of GradeGrid
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GradeGridCopyWith<GradeGrid> get copyWith => _$GradeGridCopyWithImpl<GradeGrid>(this as GradeGrid, _$identity);

  /// Serializes this GradeGrid to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as GradeGrid;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GradeGrid&&const DeepCollectionEquality().equals(other.posts, _this.posts)&&const DeepCollectionEquality().equals(other.students, _this.students));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as GradeGrid;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.posts),const DeepCollectionEquality().hash(_this.students));
}

@override
String toString() {
  final _this = this as GradeGrid;
  return 'GradeGrid(posts: ${_this.posts}, students: ${_this.students})';
}


}

/// @nodoc
abstract mixin class $GradeGridCopyWith<$Res>  {
  factory $GradeGridCopyWith(GradeGrid value, $Res Function(GradeGrid) _then) = _$GradeGridCopyWithImpl;
@useResult
$Res call({
 List<GradedPost> posts, List<StudentGrades> students
});




}
/// @nodoc
class _$GradeGridCopyWithImpl<$Res>
    implements $GradeGridCopyWith<$Res> {
  _$GradeGridCopyWithImpl(this._self, this._then);

  final GradeGrid _self;
  final $Res Function(GradeGrid) _then;

/// Create a copy of GradeGrid
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? posts = null,Object? students = null,}) {
  return _then(GradeGrid(
posts: null == posts ? _self.posts : posts // ignore: cast_nullable_to_non_nullable
as List<GradedPost>,students: null == students ? _self.students : students // ignore: cast_nullable_to_non_nullable
as List<StudentGrades>,
  ));
}

}


/// Adds pattern-matching-related methods to [GradeGrid].
extension GradeGridPatterns on GradeGrid {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GradeGrid value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GradeGrid() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GradeGrid value)  $default,){
final _that = this;
switch (_that) {
case _GradeGrid():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GradeGrid value)?  $default,){
final _that = this;
switch (_that) {
case _GradeGrid() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<GradedPost> posts,  List<StudentGrades> students)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GradeGrid() when $default != null:
return $default(_that.posts,_that.students);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<GradedPost> posts,  List<StudentGrades> students)  $default,) {final _that = this;
switch (_that) {
case _GradeGrid():
return $default(_that.posts,_that.students);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<GradedPost> posts,  List<StudentGrades> students)?  $default,) {final _that = this;
switch (_that) {
case _GradeGrid() when $default != null:
return $default(_that.posts,_that.students);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GradeGrid implements GradeGrid {
  const _GradeGrid({required  List<GradedPost> posts, required  List<StudentGrades> students}): _posts = posts,_students = students;
  factory _GradeGrid.fromJson(Map<String, dynamic> json) => _$GradeGridFromJson(json);

 final  List<GradedPost> _posts;
@override List<GradedPost> get posts {
  if (_posts is EqualUnmodifiableListView) return _posts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_posts);
}

 final  List<StudentGrades> _students;
@override List<StudentGrades> get students {
  if (_students is EqualUnmodifiableListView) return _students;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_students);
}


/// Create a copy of GradeGrid
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GradeGridCopyWith<_GradeGrid> get copyWith => __$GradeGridCopyWithImpl<_GradeGrid>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GradeGridToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GradeGrid&&const DeepCollectionEquality().equals(other.posts, _posts)&&const DeepCollectionEquality().equals(other.students, _students));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_posts),const DeepCollectionEquality().hash(_students));
}

@override
String toString() {
    return 'GradeGrid(posts: $posts, students: $students)';
}


}

/// @nodoc
abstract mixin class _$GradeGridCopyWith<$Res> implements $GradeGridCopyWith<$Res> {
  factory _$GradeGridCopyWith(_GradeGrid value, $Res Function(_GradeGrid) _then) = __$GradeGridCopyWithImpl;
@override @useResult
$Res call({
 List<GradedPost> posts, List<StudentGrades> students
});




}
/// @nodoc
class __$GradeGridCopyWithImpl<$Res>
    implements _$GradeGridCopyWith<$Res> {
  __$GradeGridCopyWithImpl(this._self, this._then);

  final _GradeGrid _self;
  final $Res Function(_GradeGrid) _then;

/// Create a copy of GradeGrid
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? posts = null,Object? students = null,}) {
  return _then(_GradeGrid(
posts: null == posts ? _self._posts : posts // ignore: cast_nullable_to_non_nullable
as List<GradedPost>,students: null == students ? _self._students : students // ignore: cast_nullable_to_non_nullable
as List<StudentGrades>,
  ));
}


}


/// @nodoc
mixin _$GradedPost {

 int get id; PostType get type; String? get title; int? get points; DateTime? get dueAt;
/// Create a copy of GradedPost
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GradedPostCopyWith<GradedPost> get copyWith => _$GradedPostCopyWithImpl<GradedPost>(this as GradedPost, _$identity);

  /// Serializes this GradedPost to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as GradedPost;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GradedPost&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.points, _this.points) || other.points == _this.points)&&(identical(other.dueAt, _this.dueAt) || other.dueAt == _this.dueAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as GradedPost;
  return Object.hash(runtimeType,_this.id,_this.type,_this.title,_this.points,_this.dueAt);
}

@override
String toString() {
  final _this = this as GradedPost;
  return 'GradedPost(id: ${_this.id}, type: ${_this.type}, title: ${_this.title}, points: ${_this.points}, dueAt: ${_this.dueAt})';
}


}

/// @nodoc
abstract mixin class $GradedPostCopyWith<$Res>  {
  factory $GradedPostCopyWith(GradedPost value, $Res Function(GradedPost) _then) = _$GradedPostCopyWithImpl;
@useResult
$Res call({
 int id, PostType type, String? title, int? points, DateTime? dueAt
});




}
/// @nodoc
class _$GradedPostCopyWithImpl<$Res>
    implements $GradedPostCopyWith<$Res> {
  _$GradedPostCopyWithImpl(this._self, this._then);

  final GradedPost _self;
  final $Res Function(GradedPost) _then;

/// Create a copy of GradedPost
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? title = freezed,Object? points = freezed,Object? dueAt = freezed,}) {
  return _then(GradedPost(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as PostType,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,points: freezed == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int?,dueAt: freezed == dueAt ? _self.dueAt : dueAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [GradedPost].
extension GradedPostPatterns on GradedPost {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GradedPost value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GradedPost() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GradedPost value)  $default,){
final _that = this;
switch (_that) {
case _GradedPost():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GradedPost value)?  $default,){
final _that = this;
switch (_that) {
case _GradedPost() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  PostType type,  String? title,  int? points,  DateTime? dueAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GradedPost() when $default != null:
return $default(_that.id,_that.type,_that.title,_that.points,_that.dueAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  PostType type,  String? title,  int? points,  DateTime? dueAt)  $default,) {final _that = this;
switch (_that) {
case _GradedPost():
return $default(_that.id,_that.type,_that.title,_that.points,_that.dueAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  PostType type,  String? title,  int? points,  DateTime? dueAt)?  $default,) {final _that = this;
switch (_that) {
case _GradedPost() when $default != null:
return $default(_that.id,_that.type,_that.title,_that.points,_that.dueAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GradedPost implements GradedPost {
  const _GradedPost({required this.id, required this.type, this.title, this.points, this.dueAt});
  factory _GradedPost.fromJson(Map<String, dynamic> json) => _$GradedPostFromJson(json);

@override final  int id;
@override final  PostType type;
@override final  String? title;
@override final  int? points;
@override final  DateTime? dueAt;

/// Create a copy of GradedPost
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GradedPostCopyWith<_GradedPost> get copyWith => __$GradedPostCopyWithImpl<_GradedPost>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GradedPostToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GradedPost&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.points, points) || other.points == points)&&(identical(other.dueAt, dueAt) || other.dueAt == dueAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,type,title,points,dueAt);
}

@override
String toString() {
    return 'GradedPost(id: $id, type: $type, title: $title, points: $points, dueAt: $dueAt)';
}


}

/// @nodoc
abstract mixin class _$GradedPostCopyWith<$Res> implements $GradedPostCopyWith<$Res> {
  factory _$GradedPostCopyWith(_GradedPost value, $Res Function(_GradedPost) _then) = __$GradedPostCopyWithImpl;
@override @useResult
$Res call({
 int id, PostType type, String? title, int? points, DateTime? dueAt
});




}
/// @nodoc
class __$GradedPostCopyWithImpl<$Res>
    implements _$GradedPostCopyWith<$Res> {
  __$GradedPostCopyWithImpl(this._self, this._then);

  final _GradedPost _self;
  final $Res Function(_GradedPost) _then;

/// Create a copy of GradedPost
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? title = freezed,Object? points = freezed,Object? dueAt = freezed,}) {
  return _then(_GradedPost(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as PostType,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,points: freezed == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int?,dueAt: freezed == dueAt ? _self.dueAt : dueAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$StudentGrades {

 UserSummary get user;/// Kunci objek JSON adalah ID posting.
 Map<String, GradeCell?> get grades;
/// Create a copy of StudentGrades
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudentGradesCopyWith<StudentGrades> get copyWith => _$StudentGradesCopyWithImpl<StudentGrades>(this as StudentGrades, _$identity);

  /// Serializes this StudentGrades to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as StudentGrades;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudentGrades&&(identical(other.user, _this.user) || other.user == _this.user)&&const DeepCollectionEquality().equals(other.grades, _this.grades));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as StudentGrades;
  return Object.hash(runtimeType,_this.user,const DeepCollectionEquality().hash(_this.grades));
}

@override
String toString() {
  final _this = this as StudentGrades;
  return 'StudentGrades(user: ${_this.user}, grades: ${_this.grades})';
}


}

/// @nodoc
abstract mixin class $StudentGradesCopyWith<$Res>  {
  factory $StudentGradesCopyWith(StudentGrades value, $Res Function(StudentGrades) _then) = _$StudentGradesCopyWithImpl;
@useResult
$Res call({
 UserSummary user, Map<String, GradeCell?> grades
});


$UserSummaryCopyWith<$Res> get user;

}
/// @nodoc
class _$StudentGradesCopyWithImpl<$Res>
    implements $StudentGradesCopyWith<$Res> {
  _$StudentGradesCopyWithImpl(this._self, this._then);

  final StudentGrades _self;
  final $Res Function(StudentGrades) _then;

/// Create a copy of StudentGrades
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? user = null,Object? grades = null,}) {
  return _then(StudentGrades(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserSummary,grades: null == grades ? _self.grades : grades // ignore: cast_nullable_to_non_nullable
as Map<String, GradeCell?>,
  ));
}
/// Create a copy of StudentGrades
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserSummaryCopyWith<$Res> get user {
  
  return $UserSummaryCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// Adds pattern-matching-related methods to [StudentGrades].
extension StudentGradesPatterns on StudentGrades {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StudentGrades value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StudentGrades() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StudentGrades value)  $default,){
final _that = this;
switch (_that) {
case _StudentGrades():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StudentGrades value)?  $default,){
final _that = this;
switch (_that) {
case _StudentGrades() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( UserSummary user,  Map<String, GradeCell?> grades)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StudentGrades() when $default != null:
return $default(_that.user,_that.grades);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( UserSummary user,  Map<String, GradeCell?> grades)  $default,) {final _that = this;
switch (_that) {
case _StudentGrades():
return $default(_that.user,_that.grades);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( UserSummary user,  Map<String, GradeCell?> grades)?  $default,) {final _that = this;
switch (_that) {
case _StudentGrades() when $default != null:
return $default(_that.user,_that.grades);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StudentGrades extends StudentGrades {
  const _StudentGrades({required this.user,  Map<String, GradeCell?> grades = const <String, GradeCell?>{}}): _grades = grades,super._();
  factory _StudentGrades.fromJson(Map<String, dynamic> json) => _$StudentGradesFromJson(json);

@override final  UserSummary user;
/// Kunci objek JSON adalah ID posting.
 final  Map<String, GradeCell?> _grades;
/// Kunci objek JSON adalah ID posting.
@override@JsonKey() Map<String, GradeCell?> get grades {
  if (_grades is EqualUnmodifiableMapView) return _grades;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_grades);
}


/// Create a copy of StudentGrades
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudentGradesCopyWith<_StudentGrades> get copyWith => __$StudentGradesCopyWithImpl<_StudentGrades>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StudentGradesToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StudentGrades&&(identical(other.user, user) || other.user == user)&&const DeepCollectionEquality().equals(other.grades, _grades));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,user,const DeepCollectionEquality().hash(_grades));
}

@override
String toString() {
    return 'StudentGrades(user: $user, grades: $grades)';
}


}

/// @nodoc
abstract mixin class _$StudentGradesCopyWith<$Res> implements $StudentGradesCopyWith<$Res> {
  factory _$StudentGradesCopyWith(_StudentGrades value, $Res Function(_StudentGrades) _then) = __$StudentGradesCopyWithImpl;
@override @useResult
$Res call({
 UserSummary user, Map<String, GradeCell?> grades
});


@override $UserSummaryCopyWith<$Res> get user;

}
/// @nodoc
class __$StudentGradesCopyWithImpl<$Res>
    implements _$StudentGradesCopyWith<$Res> {
  __$StudentGradesCopyWithImpl(this._self, this._then);

  final _StudentGrades _self;
  final $Res Function(_StudentGrades) _then;

/// Create a copy of StudentGrades
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? user = null,Object? grades = null,}) {
  return _then(_StudentGrades(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserSummary,grades: null == grades ? _self._grades : grades // ignore: cast_nullable_to_non_nullable
as Map<String, GradeCell?>,
  ));
}

/// Create a copy of StudentGrades
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserSummaryCopyWith<$Res> get user {
  
  return $UserSummaryCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// @nodoc
mixin _$GradeCell {

 DisplayStatus get displayStatus; double? get grade; double? get draftGrade;
/// Create a copy of GradeCell
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GradeCellCopyWith<GradeCell> get copyWith => _$GradeCellCopyWithImpl<GradeCell>(this as GradeCell, _$identity);

  /// Serializes this GradeCell to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as GradeCell;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GradeCell&&(identical(other.displayStatus, _this.displayStatus) || other.displayStatus == _this.displayStatus)&&(identical(other.grade, _this.grade) || other.grade == _this.grade)&&(identical(other.draftGrade, _this.draftGrade) || other.draftGrade == _this.draftGrade));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as GradeCell;
  return Object.hash(runtimeType,_this.displayStatus,_this.grade,_this.draftGrade);
}

@override
String toString() {
  final _this = this as GradeCell;
  return 'GradeCell(displayStatus: ${_this.displayStatus}, grade: ${_this.grade}, draftGrade: ${_this.draftGrade})';
}


}

/// @nodoc
abstract mixin class $GradeCellCopyWith<$Res>  {
  factory $GradeCellCopyWith(GradeCell value, $Res Function(GradeCell) _then) = _$GradeCellCopyWithImpl;
@useResult
$Res call({
 DisplayStatus displayStatus, double? grade, double? draftGrade
});




}
/// @nodoc
class _$GradeCellCopyWithImpl<$Res>
    implements $GradeCellCopyWith<$Res> {
  _$GradeCellCopyWithImpl(this._self, this._then);

  final GradeCell _self;
  final $Res Function(GradeCell) _then;

/// Create a copy of GradeCell
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? displayStatus = null,Object? grade = freezed,Object? draftGrade = freezed,}) {
  return _then(GradeCell(
displayStatus: null == displayStatus ? _self.displayStatus : displayStatus // ignore: cast_nullable_to_non_nullable
as DisplayStatus,grade: freezed == grade ? _self.grade : grade // ignore: cast_nullable_to_non_nullable
as double?,draftGrade: freezed == draftGrade ? _self.draftGrade : draftGrade // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [GradeCell].
extension GradeCellPatterns on GradeCell {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GradeCell value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GradeCell() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GradeCell value)  $default,){
final _that = this;
switch (_that) {
case _GradeCell():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GradeCell value)?  $default,){
final _that = this;
switch (_that) {
case _GradeCell() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DisplayStatus displayStatus,  double? grade,  double? draftGrade)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GradeCell() when $default != null:
return $default(_that.displayStatus,_that.grade,_that.draftGrade);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DisplayStatus displayStatus,  double? grade,  double? draftGrade)  $default,) {final _that = this;
switch (_that) {
case _GradeCell():
return $default(_that.displayStatus,_that.grade,_that.draftGrade);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DisplayStatus displayStatus,  double? grade,  double? draftGrade)?  $default,) {final _that = this;
switch (_that) {
case _GradeCell() when $default != null:
return $default(_that.displayStatus,_that.grade,_that.draftGrade);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GradeCell implements GradeCell {
  const _GradeCell({required this.displayStatus, this.grade, this.draftGrade});
  factory _GradeCell.fromJson(Map<String, dynamic> json) => _$GradeCellFromJson(json);

@override final  DisplayStatus displayStatus;
@override final  double? grade;
@override final  double? draftGrade;

/// Create a copy of GradeCell
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GradeCellCopyWith<_GradeCell> get copyWith => __$GradeCellCopyWithImpl<_GradeCell>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GradeCellToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GradeCell&&(identical(other.displayStatus, displayStatus) || other.displayStatus == displayStatus)&&(identical(other.grade, grade) || other.grade == grade)&&(identical(other.draftGrade, draftGrade) || other.draftGrade == draftGrade));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,displayStatus,grade,draftGrade);
}

@override
String toString() {
    return 'GradeCell(displayStatus: $displayStatus, grade: $grade, draftGrade: $draftGrade)';
}


}

/// @nodoc
abstract mixin class _$GradeCellCopyWith<$Res> implements $GradeCellCopyWith<$Res> {
  factory _$GradeCellCopyWith(_GradeCell value, $Res Function(_GradeCell) _then) = __$GradeCellCopyWithImpl;
@override @useResult
$Res call({
 DisplayStatus displayStatus, double? grade, double? draftGrade
});




}
/// @nodoc
class __$GradeCellCopyWithImpl<$Res>
    implements _$GradeCellCopyWith<$Res> {
  __$GradeCellCopyWithImpl(this._self, this._then);

  final _GradeCell _self;
  final $Res Function(_GradeCell) _then;

/// Create a copy of GradeCell
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? displayStatus = null,Object? grade = freezed,Object? draftGrade = freezed,}) {
  return _then(_GradeCell(
displayStatus: null == displayStatus ? _self.displayStatus : displayStatus // ignore: cast_nullable_to_non_nullable
as DisplayStatus,grade: freezed == grade ? _self.grade : grade // ignore: cast_nullable_to_non_nullable
as double?,draftGrade: freezed == draftGrade ? _self.draftGrade : draftGrade // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
