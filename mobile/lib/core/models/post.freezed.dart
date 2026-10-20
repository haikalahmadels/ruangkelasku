// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Post {

 int get id; int get courseId; PostCourse? get course; PostType get type; String? get title; String? get body; PostTopic? get topic; int? get points; DateTime? get dueAt; PostStatus get status; DateTime? get scheduledAt; DateTime? get publishedAt; UserSummary? get author; List<Attachment> get attachments; int? get commentCount; MySubmission? get mySubmission; SubmissionCounts? get submissionCounts;
/// Create a copy of Post
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostCopyWith<Post> get copyWith => _$PostCopyWithImpl<Post>(this as Post, _$identity);

  /// Serializes this Post to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Post;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Post&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.courseId, _this.courseId) || other.courseId == _this.courseId)&&(identical(other.course, _this.course) || other.course == _this.course)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.body, _this.body) || other.body == _this.body)&&(identical(other.topic, _this.topic) || other.topic == _this.topic)&&(identical(other.points, _this.points) || other.points == _this.points)&&(identical(other.dueAt, _this.dueAt) || other.dueAt == _this.dueAt)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.scheduledAt, _this.scheduledAt) || other.scheduledAt == _this.scheduledAt)&&(identical(other.publishedAt, _this.publishedAt) || other.publishedAt == _this.publishedAt)&&(identical(other.author, _this.author) || other.author == _this.author)&&const DeepCollectionEquality().equals(other.attachments, _this.attachments)&&(identical(other.commentCount, _this.commentCount) || other.commentCount == _this.commentCount)&&(identical(other.mySubmission, _this.mySubmission) || other.mySubmission == _this.mySubmission)&&(identical(other.submissionCounts, _this.submissionCounts) || other.submissionCounts == _this.submissionCounts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Post;
  return Object.hash(runtimeType,_this.id,_this.courseId,_this.course,_this.type,_this.title,_this.body,_this.topic,_this.points,_this.dueAt,_this.status,_this.scheduledAt,_this.publishedAt,_this.author,const DeepCollectionEquality().hash(_this.attachments),_this.commentCount,_this.mySubmission,_this.submissionCounts);
}

@override
String toString() {
  final _this = this as Post;
  return 'Post(id: ${_this.id}, courseId: ${_this.courseId}, course: ${_this.course}, type: ${_this.type}, title: ${_this.title}, body: ${_this.body}, topic: ${_this.topic}, points: ${_this.points}, dueAt: ${_this.dueAt}, status: ${_this.status}, scheduledAt: ${_this.scheduledAt}, publishedAt: ${_this.publishedAt}, author: ${_this.author}, attachments: ${_this.attachments}, commentCount: ${_this.commentCount}, mySubmission: ${_this.mySubmission}, submissionCounts: ${_this.submissionCounts})';
}


}

/// @nodoc
abstract mixin class $PostCopyWith<$Res>  {
  factory $PostCopyWith(Post value, $Res Function(Post) _then) = _$PostCopyWithImpl;
@useResult
$Res call({
 int id, int courseId, PostCourse? course, PostType type, String? title, String? body, PostTopic? topic, int? points, DateTime? dueAt, PostStatus status, DateTime? scheduledAt, DateTime? publishedAt, UserSummary? author, List<Attachment> attachments, int? commentCount, MySubmission? mySubmission, SubmissionCounts? submissionCounts
});


$PostCourseCopyWith<$Res>? get course;$PostTopicCopyWith<$Res>? get topic;$UserSummaryCopyWith<$Res>? get author;$MySubmissionCopyWith<$Res>? get mySubmission;$SubmissionCountsCopyWith<$Res>? get submissionCounts;

}
/// @nodoc
class _$PostCopyWithImpl<$Res>
    implements $PostCopyWith<$Res> {
  _$PostCopyWithImpl(this._self, this._then);

  final Post _self;
  final $Res Function(Post) _then;

/// Create a copy of Post
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? courseId = null,Object? course = freezed,Object? type = null,Object? title = freezed,Object? body = freezed,Object? topic = freezed,Object? points = freezed,Object? dueAt = freezed,Object? status = null,Object? scheduledAt = freezed,Object? publishedAt = freezed,Object? author = freezed,Object? attachments = null,Object? commentCount = freezed,Object? mySubmission = freezed,Object? submissionCounts = freezed,}) {
  return _then(Post(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,courseId: null == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as int,course: freezed == course ? _self.course : course // ignore: cast_nullable_to_non_nullable
as PostCourse?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as PostType,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,topic: freezed == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as PostTopic?,points: freezed == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int?,dueAt: freezed == dueAt ? _self.dueAt : dueAt // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PostStatus,scheduledAt: freezed == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as UserSummary?,attachments: null == attachments ? _self.attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<Attachment>,commentCount: freezed == commentCount ? _self.commentCount : commentCount // ignore: cast_nullable_to_non_nullable
as int?,mySubmission: freezed == mySubmission ? _self.mySubmission : mySubmission // ignore: cast_nullable_to_non_nullable
as MySubmission?,submissionCounts: freezed == submissionCounts ? _self.submissionCounts : submissionCounts // ignore: cast_nullable_to_non_nullable
as SubmissionCounts?,
  ));
}
/// Create a copy of Post
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostCourseCopyWith<$Res>? get course {
    if (_self.course == null) {
    return null;
  }

  return $PostCourseCopyWith<$Res>(_self.course!, (value) {
    return _then(_self.copyWith(course: value));
  });
}/// Create a copy of Post
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostTopicCopyWith<$Res>? get topic {
    if (_self.topic == null) {
    return null;
  }

  return $PostTopicCopyWith<$Res>(_self.topic!, (value) {
    return _then(_self.copyWith(topic: value));
  });
}/// Create a copy of Post
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserSummaryCopyWith<$Res>? get author {
    if (_self.author == null) {
    return null;
  }

  return $UserSummaryCopyWith<$Res>(_self.author!, (value) {
    return _then(_self.copyWith(author: value));
  });
}/// Create a copy of Post
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MySubmissionCopyWith<$Res>? get mySubmission {
    if (_self.mySubmission == null) {
    return null;
  }

  return $MySubmissionCopyWith<$Res>(_self.mySubmission!, (value) {
    return _then(_self.copyWith(mySubmission: value));
  });
}/// Create a copy of Post
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SubmissionCountsCopyWith<$Res>? get submissionCounts {
    if (_self.submissionCounts == null) {
    return null;
  }

  return $SubmissionCountsCopyWith<$Res>(_self.submissionCounts!, (value) {
    return _then(_self.copyWith(submissionCounts: value));
  });
}
}


/// Adds pattern-matching-related methods to [Post].
extension PostPatterns on Post {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Post value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Post() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Post value)  $default,){
final _that = this;
switch (_that) {
case _Post():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Post value)?  $default,){
final _that = this;
switch (_that) {
case _Post() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int courseId,  PostCourse? course,  PostType type,  String? title,  String? body,  PostTopic? topic,  int? points,  DateTime? dueAt,  PostStatus status,  DateTime? scheduledAt,  DateTime? publishedAt,  UserSummary? author,  List<Attachment> attachments,  int? commentCount,  MySubmission? mySubmission,  SubmissionCounts? submissionCounts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Post() when $default != null:
return $default(_that.id,_that.courseId,_that.course,_that.type,_that.title,_that.body,_that.topic,_that.points,_that.dueAt,_that.status,_that.scheduledAt,_that.publishedAt,_that.author,_that.attachments,_that.commentCount,_that.mySubmission,_that.submissionCounts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int courseId,  PostCourse? course,  PostType type,  String? title,  String? body,  PostTopic? topic,  int? points,  DateTime? dueAt,  PostStatus status,  DateTime? scheduledAt,  DateTime? publishedAt,  UserSummary? author,  List<Attachment> attachments,  int? commentCount,  MySubmission? mySubmission,  SubmissionCounts? submissionCounts)  $default,) {final _that = this;
switch (_that) {
case _Post():
return $default(_that.id,_that.courseId,_that.course,_that.type,_that.title,_that.body,_that.topic,_that.points,_that.dueAt,_that.status,_that.scheduledAt,_that.publishedAt,_that.author,_that.attachments,_that.commentCount,_that.mySubmission,_that.submissionCounts);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int courseId,  PostCourse? course,  PostType type,  String? title,  String? body,  PostTopic? topic,  int? points,  DateTime? dueAt,  PostStatus status,  DateTime? scheduledAt,  DateTime? publishedAt,  UserSummary? author,  List<Attachment> attachments,  int? commentCount,  MySubmission? mySubmission,  SubmissionCounts? submissionCounts)?  $default,) {final _that = this;
switch (_that) {
case _Post() when $default != null:
return $default(_that.id,_that.courseId,_that.course,_that.type,_that.title,_that.body,_that.topic,_that.points,_that.dueAt,_that.status,_that.scheduledAt,_that.publishedAt,_that.author,_that.attachments,_that.commentCount,_that.mySubmission,_that.submissionCounts);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Post implements Post {
  const _Post({required this.id, required this.courseId, this.course, required this.type, this.title, this.body, this.topic, this.points, this.dueAt, required this.status, this.scheduledAt, this.publishedAt, this.author,  List<Attachment> attachments = const <Attachment>[], this.commentCount, this.mySubmission, this.submissionCounts}): _attachments = attachments;
  factory _Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

@override final  int id;
@override final  int courseId;
@override final  PostCourse? course;
@override final  PostType type;
@override final  String? title;
@override final  String? body;
@override final  PostTopic? topic;
@override final  int? points;
@override final  DateTime? dueAt;
@override final  PostStatus status;
@override final  DateTime? scheduledAt;
@override final  DateTime? publishedAt;
@override final  UserSummary? author;
 final  List<Attachment> _attachments;
@override@JsonKey() List<Attachment> get attachments {
  if (_attachments is EqualUnmodifiableListView) return _attachments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_attachments);
}

@override final  int? commentCount;
@override final  MySubmission? mySubmission;
@override final  SubmissionCounts? submissionCounts;

/// Create a copy of Post
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostCopyWith<_Post> get copyWith => __$PostCopyWithImpl<_Post>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PostToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Post&&(identical(other.id, id) || other.id == id)&&(identical(other.courseId, courseId) || other.courseId == courseId)&&(identical(other.course, course) || other.course == course)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.points, points) || other.points == points)&&(identical(other.dueAt, dueAt) || other.dueAt == dueAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.author, author) || other.author == author)&&const DeepCollectionEquality().equals(other.attachments, _attachments)&&(identical(other.commentCount, commentCount) || other.commentCount == commentCount)&&(identical(other.mySubmission, mySubmission) || other.mySubmission == mySubmission)&&(identical(other.submissionCounts, submissionCounts) || other.submissionCounts == submissionCounts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,courseId,course,type,title,body,topic,points,dueAt,status,scheduledAt,publishedAt,author,const DeepCollectionEquality().hash(_attachments),commentCount,mySubmission,submissionCounts);
}

@override
String toString() {
    return 'Post(id: $id, courseId: $courseId, course: $course, type: $type, title: $title, body: $body, topic: $topic, points: $points, dueAt: $dueAt, status: $status, scheduledAt: $scheduledAt, publishedAt: $publishedAt, author: $author, attachments: $attachments, commentCount: $commentCount, mySubmission: $mySubmission, submissionCounts: $submissionCounts)';
}


}

/// @nodoc
abstract mixin class _$PostCopyWith<$Res> implements $PostCopyWith<$Res> {
  factory _$PostCopyWith(_Post value, $Res Function(_Post) _then) = __$PostCopyWithImpl;
@override @useResult
$Res call({
 int id, int courseId, PostCourse? course, PostType type, String? title, String? body, PostTopic? topic, int? points, DateTime? dueAt, PostStatus status, DateTime? scheduledAt, DateTime? publishedAt, UserSummary? author, List<Attachment> attachments, int? commentCount, MySubmission? mySubmission, SubmissionCounts? submissionCounts
});


@override $PostCourseCopyWith<$Res>? get course;@override $PostTopicCopyWith<$Res>? get topic;@override $UserSummaryCopyWith<$Res>? get author;@override $MySubmissionCopyWith<$Res>? get mySubmission;@override $SubmissionCountsCopyWith<$Res>? get submissionCounts;

}
/// @nodoc
class __$PostCopyWithImpl<$Res>
    implements _$PostCopyWith<$Res> {
  __$PostCopyWithImpl(this._self, this._then);

  final _Post _self;
  final $Res Function(_Post) _then;

/// Create a copy of Post
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? courseId = null,Object? course = freezed,Object? type = null,Object? title = freezed,Object? body = freezed,Object? topic = freezed,Object? points = freezed,Object? dueAt = freezed,Object? status = null,Object? scheduledAt = freezed,Object? publishedAt = freezed,Object? author = freezed,Object? attachments = null,Object? commentCount = freezed,Object? mySubmission = freezed,Object? submissionCounts = freezed,}) {
  return _then(_Post(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,courseId: null == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as int,course: freezed == course ? _self.course : course // ignore: cast_nullable_to_non_nullable
as PostCourse?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as PostType,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,topic: freezed == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as PostTopic?,points: freezed == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int?,dueAt: freezed == dueAt ? _self.dueAt : dueAt // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PostStatus,scheduledAt: freezed == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as UserSummary?,attachments: null == attachments ? _self._attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<Attachment>,commentCount: freezed == commentCount ? _self.commentCount : commentCount // ignore: cast_nullable_to_non_nullable
as int?,mySubmission: freezed == mySubmission ? _self.mySubmission : mySubmission // ignore: cast_nullable_to_non_nullable
as MySubmission?,submissionCounts: freezed == submissionCounts ? _self.submissionCounts : submissionCounts // ignore: cast_nullable_to_non_nullable
as SubmissionCounts?,
  ));
}

/// Create a copy of Post
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostCourseCopyWith<$Res>? get course {
    if (_self.course == null) {
    return null;
  }

  return $PostCourseCopyWith<$Res>(_self.course!, (value) {
    return _then(_self.copyWith(course: value));
  });
}/// Create a copy of Post
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostTopicCopyWith<$Res>? get topic {
    if (_self.topic == null) {
    return null;
  }

  return $PostTopicCopyWith<$Res>(_self.topic!, (value) {
    return _then(_self.copyWith(topic: value));
  });
}/// Create a copy of Post
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserSummaryCopyWith<$Res>? get author {
    if (_self.author == null) {
    return null;
  }

  return $UserSummaryCopyWith<$Res>(_self.author!, (value) {
    return _then(_self.copyWith(author: value));
  });
}/// Create a copy of Post
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MySubmissionCopyWith<$Res>? get mySubmission {
    if (_self.mySubmission == null) {
    return null;
  }

  return $MySubmissionCopyWith<$Res>(_self.mySubmission!, (value) {
    return _then(_self.copyWith(mySubmission: value));
  });
}/// Create a copy of Post
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SubmissionCountsCopyWith<$Res>? get submissionCounts {
    if (_self.submissionCounts == null) {
    return null;
  }

  return $SubmissionCountsCopyWith<$Res>(_self.submissionCounts!, (value) {
    return _then(_self.copyWith(submissionCounts: value));
  });
}
}


/// @nodoc
mixin _$PostCourse {

 int get id; String get name; String get theme;
/// Create a copy of PostCourse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostCourseCopyWith<PostCourse> get copyWith => _$PostCourseCopyWithImpl<PostCourse>(this as PostCourse, _$identity);

  /// Serializes this PostCourse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PostCourse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostCourse&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.theme, _this.theme) || other.theme == _this.theme));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PostCourse;
  return Object.hash(runtimeType,_this.id,_this.name,_this.theme);
}

@override
String toString() {
  final _this = this as PostCourse;
  return 'PostCourse(id: ${_this.id}, name: ${_this.name}, theme: ${_this.theme})';
}


}

/// @nodoc
abstract mixin class $PostCourseCopyWith<$Res>  {
  factory $PostCourseCopyWith(PostCourse value, $Res Function(PostCourse) _then) = _$PostCourseCopyWithImpl;
@useResult
$Res call({
 int id, String name, String theme
});




}
/// @nodoc
class _$PostCourseCopyWithImpl<$Res>
    implements $PostCourseCopyWith<$Res> {
  _$PostCourseCopyWithImpl(this._self, this._then);

  final PostCourse _self;
  final $Res Function(PostCourse) _then;

/// Create a copy of PostCourse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? theme = null,}) {
  return _then(PostCourse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,theme: null == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PostCourse].
extension PostCoursePatterns on PostCourse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PostCourse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PostCourse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PostCourse value)  $default,){
final _that = this;
switch (_that) {
case _PostCourse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PostCourse value)?  $default,){
final _that = this;
switch (_that) {
case _PostCourse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String theme)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PostCourse() when $default != null:
return $default(_that.id,_that.name,_that.theme);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String theme)  $default,) {final _that = this;
switch (_that) {
case _PostCourse():
return $default(_that.id,_that.name,_that.theme);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String theme)?  $default,) {final _that = this;
switch (_that) {
case _PostCourse() when $default != null:
return $default(_that.id,_that.name,_that.theme);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PostCourse implements PostCourse {
  const _PostCourse({required this.id, required this.name, required this.theme});
  factory _PostCourse.fromJson(Map<String, dynamic> json) => _$PostCourseFromJson(json);

@override final  int id;
@override final  String name;
@override final  String theme;

/// Create a copy of PostCourse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostCourseCopyWith<_PostCourse> get copyWith => __$PostCourseCopyWithImpl<_PostCourse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PostCourseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostCourse&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.theme, theme) || other.theme == theme));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,theme);
}

@override
String toString() {
    return 'PostCourse(id: $id, name: $name, theme: $theme)';
}


}

/// @nodoc
abstract mixin class _$PostCourseCopyWith<$Res> implements $PostCourseCopyWith<$Res> {
  factory _$PostCourseCopyWith(_PostCourse value, $Res Function(_PostCourse) _then) = __$PostCourseCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String theme
});




}
/// @nodoc
class __$PostCourseCopyWithImpl<$Res>
    implements _$PostCourseCopyWith<$Res> {
  __$PostCourseCopyWithImpl(this._self, this._then);

  final _PostCourse _self;
  final $Res Function(_PostCourse) _then;

/// Create a copy of PostCourse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? theme = null,}) {
  return _then(_PostCourse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,theme: null == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$PostTopic {

 int get id; String get name;
/// Create a copy of PostTopic
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostTopicCopyWith<PostTopic> get copyWith => _$PostTopicCopyWithImpl<PostTopic>(this as PostTopic, _$identity);

  /// Serializes this PostTopic to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PostTopic;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostTopic&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PostTopic;
  return Object.hash(runtimeType,_this.id,_this.name);
}

@override
String toString() {
  final _this = this as PostTopic;
  return 'PostTopic(id: ${_this.id}, name: ${_this.name})';
}


}

/// @nodoc
abstract mixin class $PostTopicCopyWith<$Res>  {
  factory $PostTopicCopyWith(PostTopic value, $Res Function(PostTopic) _then) = _$PostTopicCopyWithImpl;
@useResult
$Res call({
 int id, String name
});




}
/// @nodoc
class _$PostTopicCopyWithImpl<$Res>
    implements $PostTopicCopyWith<$Res> {
  _$PostTopicCopyWithImpl(this._self, this._then);

  final PostTopic _self;
  final $Res Function(PostTopic) _then;

/// Create a copy of PostTopic
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,}) {
  return _then(PostTopic(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PostTopic].
extension PostTopicPatterns on PostTopic {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PostTopic value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PostTopic() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PostTopic value)  $default,){
final _that = this;
switch (_that) {
case _PostTopic():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PostTopic value)?  $default,){
final _that = this;
switch (_that) {
case _PostTopic() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PostTopic() when $default != null:
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name)  $default,) {final _that = this;
switch (_that) {
case _PostTopic():
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name)?  $default,) {final _that = this;
switch (_that) {
case _PostTopic() when $default != null:
return $default(_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PostTopic implements PostTopic {
  const _PostTopic({required this.id, required this.name});
  factory _PostTopic.fromJson(Map<String, dynamic> json) => _$PostTopicFromJson(json);

@override final  int id;
@override final  String name;

/// Create a copy of PostTopic
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostTopicCopyWith<_PostTopic> get copyWith => __$PostTopicCopyWithImpl<_PostTopic>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PostTopicToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostTopic&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name);
}

@override
String toString() {
    return 'PostTopic(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$PostTopicCopyWith<$Res> implements $PostTopicCopyWith<$Res> {
  factory _$PostTopicCopyWith(_PostTopic value, $Res Function(_PostTopic) _then) = __$PostTopicCopyWithImpl;
@override @useResult
$Res call({
 int id, String name
});




}
/// @nodoc
class __$PostTopicCopyWithImpl<$Res>
    implements _$PostTopicCopyWith<$Res> {
  __$PostTopicCopyWithImpl(this._self, this._then);

  final _PostTopic _self;
  final $Res Function(_PostTopic) _then;

/// Create a copy of PostTopic
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,}) {
  return _then(_PostTopic(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$Attachment {

 int get id; String get kind; String? get originalName; String? get mimeType; int? get sizeBytes; String? get title; String get url;
/// Create a copy of Attachment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttachmentCopyWith<Attachment> get copyWith => _$AttachmentCopyWithImpl<Attachment>(this as Attachment, _$identity);

  /// Serializes this Attachment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Attachment;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Attachment&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.originalName, _this.originalName) || other.originalName == _this.originalName)&&(identical(other.mimeType, _this.mimeType) || other.mimeType == _this.mimeType)&&(identical(other.sizeBytes, _this.sizeBytes) || other.sizeBytes == _this.sizeBytes)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.url, _this.url) || other.url == _this.url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Attachment;
  return Object.hash(runtimeType,_this.id,_this.kind,_this.originalName,_this.mimeType,_this.sizeBytes,_this.title,_this.url);
}

@override
String toString() {
  final _this = this as Attachment;
  return 'Attachment(id: ${_this.id}, kind: ${_this.kind}, originalName: ${_this.originalName}, mimeType: ${_this.mimeType}, sizeBytes: ${_this.sizeBytes}, title: ${_this.title}, url: ${_this.url})';
}


}

/// @nodoc
abstract mixin class $AttachmentCopyWith<$Res>  {
  factory $AttachmentCopyWith(Attachment value, $Res Function(Attachment) _then) = _$AttachmentCopyWithImpl;
@useResult
$Res call({
 int id, String kind, String? originalName, String? mimeType, int? sizeBytes, String? title, String url
});




}
/// @nodoc
class _$AttachmentCopyWithImpl<$Res>
    implements $AttachmentCopyWith<$Res> {
  _$AttachmentCopyWithImpl(this._self, this._then);

  final Attachment _self;
  final $Res Function(Attachment) _then;

/// Create a copy of Attachment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? kind = null,Object? originalName = freezed,Object? mimeType = freezed,Object? sizeBytes = freezed,Object? title = freezed,Object? url = null,}) {
  return _then(Attachment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,originalName: freezed == originalName ? _self.originalName : originalName // ignore: cast_nullable_to_non_nullable
as String?,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,sizeBytes: freezed == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Attachment].
extension AttachmentPatterns on Attachment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Attachment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Attachment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Attachment value)  $default,){
final _that = this;
switch (_that) {
case _Attachment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Attachment value)?  $default,){
final _that = this;
switch (_that) {
case _Attachment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String kind,  String? originalName,  String? mimeType,  int? sizeBytes,  String? title,  String url)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Attachment() when $default != null:
return $default(_that.id,_that.kind,_that.originalName,_that.mimeType,_that.sizeBytes,_that.title,_that.url);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String kind,  String? originalName,  String? mimeType,  int? sizeBytes,  String? title,  String url)  $default,) {final _that = this;
switch (_that) {
case _Attachment():
return $default(_that.id,_that.kind,_that.originalName,_that.mimeType,_that.sizeBytes,_that.title,_that.url);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String kind,  String? originalName,  String? mimeType,  int? sizeBytes,  String? title,  String url)?  $default,) {final _that = this;
switch (_that) {
case _Attachment() when $default != null:
return $default(_that.id,_that.kind,_that.originalName,_that.mimeType,_that.sizeBytes,_that.title,_that.url);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Attachment extends Attachment {
  const _Attachment({required this.id, required this.kind, this.originalName, this.mimeType, this.sizeBytes, this.title, required this.url}): super._();
  factory _Attachment.fromJson(Map<String, dynamic> json) => _$AttachmentFromJson(json);

@override final  int id;
@override final  String kind;
@override final  String? originalName;
@override final  String? mimeType;
@override final  int? sizeBytes;
@override final  String? title;
@override final  String url;

/// Create a copy of Attachment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttachmentCopyWith<_Attachment> get copyWith => __$AttachmentCopyWithImpl<_Attachment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AttachmentToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Attachment&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.originalName, originalName) || other.originalName == originalName)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.sizeBytes, sizeBytes) || other.sizeBytes == sizeBytes)&&(identical(other.title, title) || other.title == title)&&(identical(other.url, url) || other.url == url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,kind,originalName,mimeType,sizeBytes,title,url);
}

@override
String toString() {
    return 'Attachment(id: $id, kind: $kind, originalName: $originalName, mimeType: $mimeType, sizeBytes: $sizeBytes, title: $title, url: $url)';
}


}

/// @nodoc
abstract mixin class _$AttachmentCopyWith<$Res> implements $AttachmentCopyWith<$Res> {
  factory _$AttachmentCopyWith(_Attachment value, $Res Function(_Attachment) _then) = __$AttachmentCopyWithImpl;
@override @useResult
$Res call({
 int id, String kind, String? originalName, String? mimeType, int? sizeBytes, String? title, String url
});




}
/// @nodoc
class __$AttachmentCopyWithImpl<$Res>
    implements _$AttachmentCopyWith<$Res> {
  __$AttachmentCopyWithImpl(this._self, this._then);

  final _Attachment _self;
  final $Res Function(_Attachment) _then;

/// Create a copy of Attachment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? kind = null,Object? originalName = freezed,Object? mimeType = freezed,Object? sizeBytes = freezed,Object? title = freezed,Object? url = null,}) {
  return _then(_Attachment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,originalName: freezed == originalName ? _self.originalName : originalName // ignore: cast_nullable_to_non_nullable
as String?,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,sizeBytes: freezed == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$MySubmission {

 int get id; DisplayStatus get displayStatus; bool get isLate; double? get grade;
/// Create a copy of MySubmission
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MySubmissionCopyWith<MySubmission> get copyWith => _$MySubmissionCopyWithImpl<MySubmission>(this as MySubmission, _$identity);

  /// Serializes this MySubmission to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MySubmission;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MySubmission&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.displayStatus, _this.displayStatus) || other.displayStatus == _this.displayStatus)&&(identical(other.isLate, _this.isLate) || other.isLate == _this.isLate)&&(identical(other.grade, _this.grade) || other.grade == _this.grade));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MySubmission;
  return Object.hash(runtimeType,_this.id,_this.displayStatus,_this.isLate,_this.grade);
}

@override
String toString() {
  final _this = this as MySubmission;
  return 'MySubmission(id: ${_this.id}, displayStatus: ${_this.displayStatus}, isLate: ${_this.isLate}, grade: ${_this.grade})';
}


}

/// @nodoc
abstract mixin class $MySubmissionCopyWith<$Res>  {
  factory $MySubmissionCopyWith(MySubmission value, $Res Function(MySubmission) _then) = _$MySubmissionCopyWithImpl;
@useResult
$Res call({
 int id, DisplayStatus displayStatus, bool isLate, double? grade
});




}
/// @nodoc
class _$MySubmissionCopyWithImpl<$Res>
    implements $MySubmissionCopyWith<$Res> {
  _$MySubmissionCopyWithImpl(this._self, this._then);

  final MySubmission _self;
  final $Res Function(MySubmission) _then;

/// Create a copy of MySubmission
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? displayStatus = null,Object? isLate = null,Object? grade = freezed,}) {
  return _then(MySubmission(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,displayStatus: null == displayStatus ? _self.displayStatus : displayStatus // ignore: cast_nullable_to_non_nullable
as DisplayStatus,isLate: null == isLate ? _self.isLate : isLate // ignore: cast_nullable_to_non_nullable
as bool,grade: freezed == grade ? _self.grade : grade // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [MySubmission].
extension MySubmissionPatterns on MySubmission {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MySubmission value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MySubmission() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MySubmission value)  $default,){
final _that = this;
switch (_that) {
case _MySubmission():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MySubmission value)?  $default,){
final _that = this;
switch (_that) {
case _MySubmission() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  DisplayStatus displayStatus,  bool isLate,  double? grade)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MySubmission() when $default != null:
return $default(_that.id,_that.displayStatus,_that.isLate,_that.grade);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  DisplayStatus displayStatus,  bool isLate,  double? grade)  $default,) {final _that = this;
switch (_that) {
case _MySubmission():
return $default(_that.id,_that.displayStatus,_that.isLate,_that.grade);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  DisplayStatus displayStatus,  bool isLate,  double? grade)?  $default,) {final _that = this;
switch (_that) {
case _MySubmission() when $default != null:
return $default(_that.id,_that.displayStatus,_that.isLate,_that.grade);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MySubmission implements MySubmission {
  const _MySubmission({required this.id, required this.displayStatus, required this.isLate, this.grade});
  factory _MySubmission.fromJson(Map<String, dynamic> json) => _$MySubmissionFromJson(json);

@override final  int id;
@override final  DisplayStatus displayStatus;
@override final  bool isLate;
@override final  double? grade;

/// Create a copy of MySubmission
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MySubmissionCopyWith<_MySubmission> get copyWith => __$MySubmissionCopyWithImpl<_MySubmission>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MySubmissionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MySubmission&&(identical(other.id, id) || other.id == id)&&(identical(other.displayStatus, displayStatus) || other.displayStatus == displayStatus)&&(identical(other.isLate, isLate) || other.isLate == isLate)&&(identical(other.grade, grade) || other.grade == grade));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,displayStatus,isLate,grade);
}

@override
String toString() {
    return 'MySubmission(id: $id, displayStatus: $displayStatus, isLate: $isLate, grade: $grade)';
}


}

/// @nodoc
abstract mixin class _$MySubmissionCopyWith<$Res> implements $MySubmissionCopyWith<$Res> {
  factory _$MySubmissionCopyWith(_MySubmission value, $Res Function(_MySubmission) _then) = __$MySubmissionCopyWithImpl;
@override @useResult
$Res call({
 int id, DisplayStatus displayStatus, bool isLate, double? grade
});




}
/// @nodoc
class __$MySubmissionCopyWithImpl<$Res>
    implements _$MySubmissionCopyWith<$Res> {
  __$MySubmissionCopyWithImpl(this._self, this._then);

  final _MySubmission _self;
  final $Res Function(_MySubmission) _then;

/// Create a copy of MySubmission
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? displayStatus = null,Object? isLate = null,Object? grade = freezed,}) {
  return _then(_MySubmission(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,displayStatus: null == displayStatus ? _self.displayStatus : displayStatus // ignore: cast_nullable_to_non_nullable
as DisplayStatus,isLate: null == isLate ? _self.isLate : isLate // ignore: cast_nullable_to_non_nullable
as bool,grade: freezed == grade ? _self.grade : grade // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}


/// @nodoc
mixin _$SubmissionCounts {

 int get assigned; int get turnedIn; int get graded; int get returned;
/// Create a copy of SubmissionCounts
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubmissionCountsCopyWith<SubmissionCounts> get copyWith => _$SubmissionCountsCopyWithImpl<SubmissionCounts>(this as SubmissionCounts, _$identity);

  /// Serializes this SubmissionCounts to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SubmissionCounts;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubmissionCounts&&(identical(other.assigned, _this.assigned) || other.assigned == _this.assigned)&&(identical(other.turnedIn, _this.turnedIn) || other.turnedIn == _this.turnedIn)&&(identical(other.graded, _this.graded) || other.graded == _this.graded)&&(identical(other.returned, _this.returned) || other.returned == _this.returned));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SubmissionCounts;
  return Object.hash(runtimeType,_this.assigned,_this.turnedIn,_this.graded,_this.returned);
}

@override
String toString() {
  final _this = this as SubmissionCounts;
  return 'SubmissionCounts(assigned: ${_this.assigned}, turnedIn: ${_this.turnedIn}, graded: ${_this.graded}, returned: ${_this.returned})';
}


}

/// @nodoc
abstract mixin class $SubmissionCountsCopyWith<$Res>  {
  factory $SubmissionCountsCopyWith(SubmissionCounts value, $Res Function(SubmissionCounts) _then) = _$SubmissionCountsCopyWithImpl;
@useResult
$Res call({
 int assigned, int turnedIn, int graded, int returned
});




}
/// @nodoc
class _$SubmissionCountsCopyWithImpl<$Res>
    implements $SubmissionCountsCopyWith<$Res> {
  _$SubmissionCountsCopyWithImpl(this._self, this._then);

  final SubmissionCounts _self;
  final $Res Function(SubmissionCounts) _then;

/// Create a copy of SubmissionCounts
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? assigned = null,Object? turnedIn = null,Object? graded = null,Object? returned = null,}) {
  return _then(SubmissionCounts(
assigned: null == assigned ? _self.assigned : assigned // ignore: cast_nullable_to_non_nullable
as int,turnedIn: null == turnedIn ? _self.turnedIn : turnedIn // ignore: cast_nullable_to_non_nullable
as int,graded: null == graded ? _self.graded : graded // ignore: cast_nullable_to_non_nullable
as int,returned: null == returned ? _self.returned : returned // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SubmissionCounts].
extension SubmissionCountsPatterns on SubmissionCounts {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SubmissionCounts value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SubmissionCounts() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SubmissionCounts value)  $default,){
final _that = this;
switch (_that) {
case _SubmissionCounts():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SubmissionCounts value)?  $default,){
final _that = this;
switch (_that) {
case _SubmissionCounts() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int assigned,  int turnedIn,  int graded,  int returned)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SubmissionCounts() when $default != null:
return $default(_that.assigned,_that.turnedIn,_that.graded,_that.returned);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int assigned,  int turnedIn,  int graded,  int returned)  $default,) {final _that = this;
switch (_that) {
case _SubmissionCounts():
return $default(_that.assigned,_that.turnedIn,_that.graded,_that.returned);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int assigned,  int turnedIn,  int graded,  int returned)?  $default,) {final _that = this;
switch (_that) {
case _SubmissionCounts() when $default != null:
return $default(_that.assigned,_that.turnedIn,_that.graded,_that.returned);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SubmissionCounts implements SubmissionCounts {
  const _SubmissionCounts({required this.assigned, required this.turnedIn, required this.graded, required this.returned});
  factory _SubmissionCounts.fromJson(Map<String, dynamic> json) => _$SubmissionCountsFromJson(json);

@override final  int assigned;
@override final  int turnedIn;
@override final  int graded;
@override final  int returned;

/// Create a copy of SubmissionCounts
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubmissionCountsCopyWith<_SubmissionCounts> get copyWith => __$SubmissionCountsCopyWithImpl<_SubmissionCounts>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SubmissionCountsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubmissionCounts&&(identical(other.assigned, assigned) || other.assigned == assigned)&&(identical(other.turnedIn, turnedIn) || other.turnedIn == turnedIn)&&(identical(other.graded, graded) || other.graded == graded)&&(identical(other.returned, returned) || other.returned == returned));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,assigned,turnedIn,graded,returned);
}

@override
String toString() {
    return 'SubmissionCounts(assigned: $assigned, turnedIn: $turnedIn, graded: $graded, returned: $returned)';
}


}

/// @nodoc
abstract mixin class _$SubmissionCountsCopyWith<$Res> implements $SubmissionCountsCopyWith<$Res> {
  factory _$SubmissionCountsCopyWith(_SubmissionCounts value, $Res Function(_SubmissionCounts) _then) = __$SubmissionCountsCopyWithImpl;
@override @useResult
$Res call({
 int assigned, int turnedIn, int graded, int returned
});




}
/// @nodoc
class __$SubmissionCountsCopyWithImpl<$Res>
    implements _$SubmissionCountsCopyWith<$Res> {
  __$SubmissionCountsCopyWithImpl(this._self, this._then);

  final _SubmissionCounts _self;
  final $Res Function(_SubmissionCounts) _then;

/// Create a copy of SubmissionCounts
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? assigned = null,Object? turnedIn = null,Object? graded = null,Object? returned = null,}) {
  return _then(_SubmissionCounts(
assigned: null == assigned ? _self.assigned : assigned // ignore: cast_nullable_to_non_nullable
as int,turnedIn: null == turnedIn ? _self.turnedIn : turnedIn // ignore: cast_nullable_to_non_nullable
as int,graded: null == graded ? _self.graded : graded // ignore: cast_nullable_to_non_nullable
as int,returned: null == returned ? _self.returned : returned // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
