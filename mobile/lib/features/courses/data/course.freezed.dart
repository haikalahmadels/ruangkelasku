// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'course.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Course {

 int get id; String get name; String? get section; String? get subject; String? get room; String? get description; String get theme; String? get code; bool get codeEnabled; String get streamPermission; String get classworkOnStream; bool get isArchived; CourseRole? get myRole; bool get isOwner; UserSummary? get owner; int? get studentCount; DateTime? get createdAt;
/// Create a copy of Course
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CourseCopyWith<Course> get copyWith => _$CourseCopyWithImpl<Course>(this as Course, _$identity);

  /// Serializes this Course to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Course;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Course&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.section, _this.section) || other.section == _this.section)&&(identical(other.subject, _this.subject) || other.subject == _this.subject)&&(identical(other.room, _this.room) || other.room == _this.room)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.theme, _this.theme) || other.theme == _this.theme)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.codeEnabled, _this.codeEnabled) || other.codeEnabled == _this.codeEnabled)&&(identical(other.streamPermission, _this.streamPermission) || other.streamPermission == _this.streamPermission)&&(identical(other.classworkOnStream, _this.classworkOnStream) || other.classworkOnStream == _this.classworkOnStream)&&(identical(other.isArchived, _this.isArchived) || other.isArchived == _this.isArchived)&&(identical(other.myRole, _this.myRole) || other.myRole == _this.myRole)&&(identical(other.isOwner, _this.isOwner) || other.isOwner == _this.isOwner)&&(identical(other.owner, _this.owner) || other.owner == _this.owner)&&(identical(other.studentCount, _this.studentCount) || other.studentCount == _this.studentCount)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Course;
  return Object.hash(runtimeType,_this.id,_this.name,_this.section,_this.subject,_this.room,_this.description,_this.theme,_this.code,_this.codeEnabled,_this.streamPermission,_this.classworkOnStream,_this.isArchived,_this.myRole,_this.isOwner,_this.owner,_this.studentCount,_this.createdAt);
}

@override
String toString() {
  final _this = this as Course;
  return 'Course(id: ${_this.id}, name: ${_this.name}, section: ${_this.section}, subject: ${_this.subject}, room: ${_this.room}, description: ${_this.description}, theme: ${_this.theme}, code: ${_this.code}, codeEnabled: ${_this.codeEnabled}, streamPermission: ${_this.streamPermission}, classworkOnStream: ${_this.classworkOnStream}, isArchived: ${_this.isArchived}, myRole: ${_this.myRole}, isOwner: ${_this.isOwner}, owner: ${_this.owner}, studentCount: ${_this.studentCount}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $CourseCopyWith<$Res>  {
  factory $CourseCopyWith(Course value, $Res Function(Course) _then) = _$CourseCopyWithImpl;
@useResult
$Res call({
 int id, String name, String? section, String? subject, String? room, String? description, String theme, String? code, bool codeEnabled, String streamPermission, String classworkOnStream, bool isArchived, CourseRole? myRole, bool isOwner, UserSummary? owner, int? studentCount, DateTime? createdAt
});


$UserSummaryCopyWith<$Res>? get owner;

}
/// @nodoc
class _$CourseCopyWithImpl<$Res>
    implements $CourseCopyWith<$Res> {
  _$CourseCopyWithImpl(this._self, this._then);

  final Course _self;
  final $Res Function(Course) _then;

/// Create a copy of Course
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? section = freezed,Object? subject = freezed,Object? room = freezed,Object? description = freezed,Object? theme = null,Object? code = freezed,Object? codeEnabled = null,Object? streamPermission = null,Object? classworkOnStream = null,Object? isArchived = null,Object? myRole = freezed,Object? isOwner = null,Object? owner = freezed,Object? studentCount = freezed,Object? createdAt = freezed,}) {
  return _then(Course(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,section: freezed == section ? _self.section : section // ignore: cast_nullable_to_non_nullable
as String?,subject: freezed == subject ? _self.subject : subject // ignore: cast_nullable_to_non_nullable
as String?,room: freezed == room ? _self.room : room // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,theme: null == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,codeEnabled: null == codeEnabled ? _self.codeEnabled : codeEnabled // ignore: cast_nullable_to_non_nullable
as bool,streamPermission: null == streamPermission ? _self.streamPermission : streamPermission // ignore: cast_nullable_to_non_nullable
as String,classworkOnStream: null == classworkOnStream ? _self.classworkOnStream : classworkOnStream // ignore: cast_nullable_to_non_nullable
as String,isArchived: null == isArchived ? _self.isArchived : isArchived // ignore: cast_nullable_to_non_nullable
as bool,myRole: freezed == myRole ? _self.myRole : myRole // ignore: cast_nullable_to_non_nullable
as CourseRole?,isOwner: null == isOwner ? _self.isOwner : isOwner // ignore: cast_nullable_to_non_nullable
as bool,owner: freezed == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as UserSummary?,studentCount: freezed == studentCount ? _self.studentCount : studentCount // ignore: cast_nullable_to_non_nullable
as int?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of Course
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserSummaryCopyWith<$Res>? get owner {
    if (_self.owner == null) {
    return null;
  }

  return $UserSummaryCopyWith<$Res>(_self.owner!, (value) {
    return _then(_self.copyWith(owner: value));
  });
}
}


/// Adds pattern-matching-related methods to [Course].
extension CoursePatterns on Course {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Course value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Course() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Course value)  $default,){
final _that = this;
switch (_that) {
case _Course():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Course value)?  $default,){
final _that = this;
switch (_that) {
case _Course() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String? section,  String? subject,  String? room,  String? description,  String theme,  String? code,  bool codeEnabled,  String streamPermission,  String classworkOnStream,  bool isArchived,  CourseRole? myRole,  bool isOwner,  UserSummary? owner,  int? studentCount,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Course() when $default != null:
return $default(_that.id,_that.name,_that.section,_that.subject,_that.room,_that.description,_that.theme,_that.code,_that.codeEnabled,_that.streamPermission,_that.classworkOnStream,_that.isArchived,_that.myRole,_that.isOwner,_that.owner,_that.studentCount,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String? section,  String? subject,  String? room,  String? description,  String theme,  String? code,  bool codeEnabled,  String streamPermission,  String classworkOnStream,  bool isArchived,  CourseRole? myRole,  bool isOwner,  UserSummary? owner,  int? studentCount,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _Course():
return $default(_that.id,_that.name,_that.section,_that.subject,_that.room,_that.description,_that.theme,_that.code,_that.codeEnabled,_that.streamPermission,_that.classworkOnStream,_that.isArchived,_that.myRole,_that.isOwner,_that.owner,_that.studentCount,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String? section,  String? subject,  String? room,  String? description,  String theme,  String? code,  bool codeEnabled,  String streamPermission,  String classworkOnStream,  bool isArchived,  CourseRole? myRole,  bool isOwner,  UserSummary? owner,  int? studentCount,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Course() when $default != null:
return $default(_that.id,_that.name,_that.section,_that.subject,_that.room,_that.description,_that.theme,_that.code,_that.codeEnabled,_that.streamPermission,_that.classworkOnStream,_that.isArchived,_that.myRole,_that.isOwner,_that.owner,_that.studentCount,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Course extends Course {
  const _Course({required this.id, required this.name, this.section, this.subject, this.room, this.description, required this.theme, this.code, required this.codeEnabled, required this.streamPermission, required this.classworkOnStream, required this.isArchived, this.myRole, required this.isOwner, this.owner, this.studentCount, this.createdAt}): super._();
  factory _Course.fromJson(Map<String, dynamic> json) => _$CourseFromJson(json);

@override final  int id;
@override final  String name;
@override final  String? section;
@override final  String? subject;
@override final  String? room;
@override final  String? description;
@override final  String theme;
@override final  String? code;
@override final  bool codeEnabled;
@override final  String streamPermission;
@override final  String classworkOnStream;
@override final  bool isArchived;
@override final  CourseRole? myRole;
@override final  bool isOwner;
@override final  UserSummary? owner;
@override final  int? studentCount;
@override final  DateTime? createdAt;

/// Create a copy of Course
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CourseCopyWith<_Course> get copyWith => __$CourseCopyWithImpl<_Course>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CourseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Course&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.section, section) || other.section == section)&&(identical(other.subject, subject) || other.subject == subject)&&(identical(other.room, room) || other.room == room)&&(identical(other.description, description) || other.description == description)&&(identical(other.theme, theme) || other.theme == theme)&&(identical(other.code, code) || other.code == code)&&(identical(other.codeEnabled, codeEnabled) || other.codeEnabled == codeEnabled)&&(identical(other.streamPermission, streamPermission) || other.streamPermission == streamPermission)&&(identical(other.classworkOnStream, classworkOnStream) || other.classworkOnStream == classworkOnStream)&&(identical(other.isArchived, isArchived) || other.isArchived == isArchived)&&(identical(other.myRole, myRole) || other.myRole == myRole)&&(identical(other.isOwner, isOwner) || other.isOwner == isOwner)&&(identical(other.owner, owner) || other.owner == owner)&&(identical(other.studentCount, studentCount) || other.studentCount == studentCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,section,subject,room,description,theme,code,codeEnabled,streamPermission,classworkOnStream,isArchived,myRole,isOwner,owner,studentCount,createdAt);
}

@override
String toString() {
    return 'Course(id: $id, name: $name, section: $section, subject: $subject, room: $room, description: $description, theme: $theme, code: $code, codeEnabled: $codeEnabled, streamPermission: $streamPermission, classworkOnStream: $classworkOnStream, isArchived: $isArchived, myRole: $myRole, isOwner: $isOwner, owner: $owner, studentCount: $studentCount, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$CourseCopyWith<$Res> implements $CourseCopyWith<$Res> {
  factory _$CourseCopyWith(_Course value, $Res Function(_Course) _then) = __$CourseCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String? section, String? subject, String? room, String? description, String theme, String? code, bool codeEnabled, String streamPermission, String classworkOnStream, bool isArchived, CourseRole? myRole, bool isOwner, UserSummary? owner, int? studentCount, DateTime? createdAt
});


@override $UserSummaryCopyWith<$Res>? get owner;

}
/// @nodoc
class __$CourseCopyWithImpl<$Res>
    implements _$CourseCopyWith<$Res> {
  __$CourseCopyWithImpl(this._self, this._then);

  final _Course _self;
  final $Res Function(_Course) _then;

/// Create a copy of Course
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? section = freezed,Object? subject = freezed,Object? room = freezed,Object? description = freezed,Object? theme = null,Object? code = freezed,Object? codeEnabled = null,Object? streamPermission = null,Object? classworkOnStream = null,Object? isArchived = null,Object? myRole = freezed,Object? isOwner = null,Object? owner = freezed,Object? studentCount = freezed,Object? createdAt = freezed,}) {
  return _then(_Course(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,section: freezed == section ? _self.section : section // ignore: cast_nullable_to_non_nullable
as String?,subject: freezed == subject ? _self.subject : subject // ignore: cast_nullable_to_non_nullable
as String?,room: freezed == room ? _self.room : room // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,theme: null == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,codeEnabled: null == codeEnabled ? _self.codeEnabled : codeEnabled // ignore: cast_nullable_to_non_nullable
as bool,streamPermission: null == streamPermission ? _self.streamPermission : streamPermission // ignore: cast_nullable_to_non_nullable
as String,classworkOnStream: null == classworkOnStream ? _self.classworkOnStream : classworkOnStream // ignore: cast_nullable_to_non_nullable
as String,isArchived: null == isArchived ? _self.isArchived : isArchived // ignore: cast_nullable_to_non_nullable
as bool,myRole: freezed == myRole ? _self.myRole : myRole // ignore: cast_nullable_to_non_nullable
as CourseRole?,isOwner: null == isOwner ? _self.isOwner : isOwner // ignore: cast_nullable_to_non_nullable
as bool,owner: freezed == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as UserSummary?,studentCount: freezed == studentCount ? _self.studentCount : studentCount // ignore: cast_nullable_to_non_nullable
as int?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of Course
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserSummaryCopyWith<$Res>? get owner {
    if (_self.owner == null) {
    return null;
  }

  return $UserSummaryCopyWith<$Res>(_self.owner!, (value) {
    return _then(_self.copyWith(owner: value));
  });
}
}


/// @nodoc
mixin _$Invitation {

 int get id; int get courseId; String get email; CourseRole get role; String get status; UserSummary? get invitedBy; InvitationCourse? get course;
/// Create a copy of Invitation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InvitationCopyWith<Invitation> get copyWith => _$InvitationCopyWithImpl<Invitation>(this as Invitation, _$identity);

  /// Serializes this Invitation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Invitation;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Invitation&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.courseId, _this.courseId) || other.courseId == _this.courseId)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.role, _this.role) || other.role == _this.role)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.invitedBy, _this.invitedBy) || other.invitedBy == _this.invitedBy)&&(identical(other.course, _this.course) || other.course == _this.course));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Invitation;
  return Object.hash(runtimeType,_this.id,_this.courseId,_this.email,_this.role,_this.status,_this.invitedBy,_this.course);
}

@override
String toString() {
  final _this = this as Invitation;
  return 'Invitation(id: ${_this.id}, courseId: ${_this.courseId}, email: ${_this.email}, role: ${_this.role}, status: ${_this.status}, invitedBy: ${_this.invitedBy}, course: ${_this.course})';
}


}

/// @nodoc
abstract mixin class $InvitationCopyWith<$Res>  {
  factory $InvitationCopyWith(Invitation value, $Res Function(Invitation) _then) = _$InvitationCopyWithImpl;
@useResult
$Res call({
 int id, int courseId, String email, CourseRole role, String status, UserSummary? invitedBy, InvitationCourse? course
});


$UserSummaryCopyWith<$Res>? get invitedBy;$InvitationCourseCopyWith<$Res>? get course;

}
/// @nodoc
class _$InvitationCopyWithImpl<$Res>
    implements $InvitationCopyWith<$Res> {
  _$InvitationCopyWithImpl(this._self, this._then);

  final Invitation _self;
  final $Res Function(Invitation) _then;

/// Create a copy of Invitation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? courseId = null,Object? email = null,Object? role = null,Object? status = null,Object? invitedBy = freezed,Object? course = freezed,}) {
  return _then(Invitation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,courseId: null == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as int,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as CourseRole,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,invitedBy: freezed == invitedBy ? _self.invitedBy : invitedBy // ignore: cast_nullable_to_non_nullable
as UserSummary?,course: freezed == course ? _self.course : course // ignore: cast_nullable_to_non_nullable
as InvitationCourse?,
  ));
}
/// Create a copy of Invitation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserSummaryCopyWith<$Res>? get invitedBy {
    if (_self.invitedBy == null) {
    return null;
  }

  return $UserSummaryCopyWith<$Res>(_self.invitedBy!, (value) {
    return _then(_self.copyWith(invitedBy: value));
  });
}/// Create a copy of Invitation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InvitationCourseCopyWith<$Res>? get course {
    if (_self.course == null) {
    return null;
  }

  return $InvitationCourseCopyWith<$Res>(_self.course!, (value) {
    return _then(_self.copyWith(course: value));
  });
}
}


/// Adds pattern-matching-related methods to [Invitation].
extension InvitationPatterns on Invitation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Invitation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Invitation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Invitation value)  $default,){
final _that = this;
switch (_that) {
case _Invitation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Invitation value)?  $default,){
final _that = this;
switch (_that) {
case _Invitation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int courseId,  String email,  CourseRole role,  String status,  UserSummary? invitedBy,  InvitationCourse? course)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Invitation() when $default != null:
return $default(_that.id,_that.courseId,_that.email,_that.role,_that.status,_that.invitedBy,_that.course);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int courseId,  String email,  CourseRole role,  String status,  UserSummary? invitedBy,  InvitationCourse? course)  $default,) {final _that = this;
switch (_that) {
case _Invitation():
return $default(_that.id,_that.courseId,_that.email,_that.role,_that.status,_that.invitedBy,_that.course);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int courseId,  String email,  CourseRole role,  String status,  UserSummary? invitedBy,  InvitationCourse? course)?  $default,) {final _that = this;
switch (_that) {
case _Invitation() when $default != null:
return $default(_that.id,_that.courseId,_that.email,_that.role,_that.status,_that.invitedBy,_that.course);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Invitation implements Invitation {
  const _Invitation({required this.id, required this.courseId, required this.email, required this.role, required this.status, this.invitedBy, this.course});
  factory _Invitation.fromJson(Map<String, dynamic> json) => _$InvitationFromJson(json);

@override final  int id;
@override final  int courseId;
@override final  String email;
@override final  CourseRole role;
@override final  String status;
@override final  UserSummary? invitedBy;
@override final  InvitationCourse? course;

/// Create a copy of Invitation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InvitationCopyWith<_Invitation> get copyWith => __$InvitationCopyWithImpl<_Invitation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InvitationToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Invitation&&(identical(other.id, id) || other.id == id)&&(identical(other.courseId, courseId) || other.courseId == courseId)&&(identical(other.email, email) || other.email == email)&&(identical(other.role, role) || other.role == role)&&(identical(other.status, status) || other.status == status)&&(identical(other.invitedBy, invitedBy) || other.invitedBy == invitedBy)&&(identical(other.course, course) || other.course == course));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,courseId,email,role,status,invitedBy,course);
}

@override
String toString() {
    return 'Invitation(id: $id, courseId: $courseId, email: $email, role: $role, status: $status, invitedBy: $invitedBy, course: $course)';
}


}

/// @nodoc
abstract mixin class _$InvitationCopyWith<$Res> implements $InvitationCopyWith<$Res> {
  factory _$InvitationCopyWith(_Invitation value, $Res Function(_Invitation) _then) = __$InvitationCopyWithImpl;
@override @useResult
$Res call({
 int id, int courseId, String email, CourseRole role, String status, UserSummary? invitedBy, InvitationCourse? course
});


@override $UserSummaryCopyWith<$Res>? get invitedBy;@override $InvitationCourseCopyWith<$Res>? get course;

}
/// @nodoc
class __$InvitationCopyWithImpl<$Res>
    implements _$InvitationCopyWith<$Res> {
  __$InvitationCopyWithImpl(this._self, this._then);

  final _Invitation _self;
  final $Res Function(_Invitation) _then;

/// Create a copy of Invitation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? courseId = null,Object? email = null,Object? role = null,Object? status = null,Object? invitedBy = freezed,Object? course = freezed,}) {
  return _then(_Invitation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,courseId: null == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as int,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as CourseRole,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,invitedBy: freezed == invitedBy ? _self.invitedBy : invitedBy // ignore: cast_nullable_to_non_nullable
as UserSummary?,course: freezed == course ? _self.course : course // ignore: cast_nullable_to_non_nullable
as InvitationCourse?,
  ));
}

/// Create a copy of Invitation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserSummaryCopyWith<$Res>? get invitedBy {
    if (_self.invitedBy == null) {
    return null;
  }

  return $UserSummaryCopyWith<$Res>(_self.invitedBy!, (value) {
    return _then(_self.copyWith(invitedBy: value));
  });
}/// Create a copy of Invitation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InvitationCourseCopyWith<$Res>? get course {
    if (_self.course == null) {
    return null;
  }

  return $InvitationCourseCopyWith<$Res>(_self.course!, (value) {
    return _then(_self.copyWith(course: value));
  });
}
}


/// @nodoc
mixin _$InvitationCourse {

 int get id; String get name; String? get section; String get theme; UserSummary? get owner;
/// Create a copy of InvitationCourse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InvitationCourseCopyWith<InvitationCourse> get copyWith => _$InvitationCourseCopyWithImpl<InvitationCourse>(this as InvitationCourse, _$identity);

  /// Serializes this InvitationCourse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as InvitationCourse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InvitationCourse&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.section, _this.section) || other.section == _this.section)&&(identical(other.theme, _this.theme) || other.theme == _this.theme)&&(identical(other.owner, _this.owner) || other.owner == _this.owner));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as InvitationCourse;
  return Object.hash(runtimeType,_this.id,_this.name,_this.section,_this.theme,_this.owner);
}

@override
String toString() {
  final _this = this as InvitationCourse;
  return 'InvitationCourse(id: ${_this.id}, name: ${_this.name}, section: ${_this.section}, theme: ${_this.theme}, owner: ${_this.owner})';
}


}

/// @nodoc
abstract mixin class $InvitationCourseCopyWith<$Res>  {
  factory $InvitationCourseCopyWith(InvitationCourse value, $Res Function(InvitationCourse) _then) = _$InvitationCourseCopyWithImpl;
@useResult
$Res call({
 int id, String name, String? section, String theme, UserSummary? owner
});


$UserSummaryCopyWith<$Res>? get owner;

}
/// @nodoc
class _$InvitationCourseCopyWithImpl<$Res>
    implements $InvitationCourseCopyWith<$Res> {
  _$InvitationCourseCopyWithImpl(this._self, this._then);

  final InvitationCourse _self;
  final $Res Function(InvitationCourse) _then;

/// Create a copy of InvitationCourse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? section = freezed,Object? theme = null,Object? owner = freezed,}) {
  return _then(InvitationCourse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,section: freezed == section ? _self.section : section // ignore: cast_nullable_to_non_nullable
as String?,theme: null == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as String,owner: freezed == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as UserSummary?,
  ));
}
/// Create a copy of InvitationCourse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserSummaryCopyWith<$Res>? get owner {
    if (_self.owner == null) {
    return null;
  }

  return $UserSummaryCopyWith<$Res>(_self.owner!, (value) {
    return _then(_self.copyWith(owner: value));
  });
}
}


/// Adds pattern-matching-related methods to [InvitationCourse].
extension InvitationCoursePatterns on InvitationCourse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InvitationCourse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InvitationCourse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InvitationCourse value)  $default,){
final _that = this;
switch (_that) {
case _InvitationCourse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InvitationCourse value)?  $default,){
final _that = this;
switch (_that) {
case _InvitationCourse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String? section,  String theme,  UserSummary? owner)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InvitationCourse() when $default != null:
return $default(_that.id,_that.name,_that.section,_that.theme,_that.owner);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String? section,  String theme,  UserSummary? owner)  $default,) {final _that = this;
switch (_that) {
case _InvitationCourse():
return $default(_that.id,_that.name,_that.section,_that.theme,_that.owner);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String? section,  String theme,  UserSummary? owner)?  $default,) {final _that = this;
switch (_that) {
case _InvitationCourse() when $default != null:
return $default(_that.id,_that.name,_that.section,_that.theme,_that.owner);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InvitationCourse implements InvitationCourse {
  const _InvitationCourse({required this.id, required this.name, this.section, required this.theme, this.owner});
  factory _InvitationCourse.fromJson(Map<String, dynamic> json) => _$InvitationCourseFromJson(json);

@override final  int id;
@override final  String name;
@override final  String? section;
@override final  String theme;
@override final  UserSummary? owner;

/// Create a copy of InvitationCourse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InvitationCourseCopyWith<_InvitationCourse> get copyWith => __$InvitationCourseCopyWithImpl<_InvitationCourse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InvitationCourseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _InvitationCourse&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.section, section) || other.section == section)&&(identical(other.theme, theme) || other.theme == theme)&&(identical(other.owner, owner) || other.owner == owner));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,section,theme,owner);
}

@override
String toString() {
    return 'InvitationCourse(id: $id, name: $name, section: $section, theme: $theme, owner: $owner)';
}


}

/// @nodoc
abstract mixin class _$InvitationCourseCopyWith<$Res> implements $InvitationCourseCopyWith<$Res> {
  factory _$InvitationCourseCopyWith(_InvitationCourse value, $Res Function(_InvitationCourse) _then) = __$InvitationCourseCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String? section, String theme, UserSummary? owner
});


@override $UserSummaryCopyWith<$Res>? get owner;

}
/// @nodoc
class __$InvitationCourseCopyWithImpl<$Res>
    implements _$InvitationCourseCopyWith<$Res> {
  __$InvitationCourseCopyWithImpl(this._self, this._then);

  final _InvitationCourse _self;
  final $Res Function(_InvitationCourse) _then;

/// Create a copy of InvitationCourse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? section = freezed,Object? theme = null,Object? owner = freezed,}) {
  return _then(_InvitationCourse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,section: freezed == section ? _self.section : section // ignore: cast_nullable_to_non_nullable
as String?,theme: null == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as String,owner: freezed == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as UserSummary?,
  ));
}

/// Create a copy of InvitationCourse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserSummaryCopyWith<$Res>? get owner {
    if (_self.owner == null) {
    return null;
  }

  return $UserSummaryCopyWith<$Res>(_self.owner!, (value) {
    return _then(_self.copyWith(owner: value));
  });
}
}

// dart format on
