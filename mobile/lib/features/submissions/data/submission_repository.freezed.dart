// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'submission_repository.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QuizAnswerRef {

 int get questionId; int? get optionId; bool? get isCorrect;
/// Create a copy of QuizAnswerRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuizAnswerRefCopyWith<QuizAnswerRef> get copyWith => _$QuizAnswerRefCopyWithImpl<QuizAnswerRef>(this as QuizAnswerRef, _$identity);

  /// Serializes this QuizAnswerRef to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as QuizAnswerRef;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuizAnswerRef&&(identical(other.questionId, _this.questionId) || other.questionId == _this.questionId)&&(identical(other.optionId, _this.optionId) || other.optionId == _this.optionId)&&(identical(other.isCorrect, _this.isCorrect) || other.isCorrect == _this.isCorrect));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as QuizAnswerRef;
  return Object.hash(runtimeType,_this.questionId,_this.optionId,_this.isCorrect);
}

@override
String toString() {
  final _this = this as QuizAnswerRef;
  return 'QuizAnswerRef(questionId: ${_this.questionId}, optionId: ${_this.optionId}, isCorrect: ${_this.isCorrect})';
}


}

/// @nodoc
abstract mixin class $QuizAnswerRefCopyWith<$Res>  {
  factory $QuizAnswerRefCopyWith(QuizAnswerRef value, $Res Function(QuizAnswerRef) _then) = _$QuizAnswerRefCopyWithImpl;
@useResult
$Res call({
 int questionId, int? optionId, bool? isCorrect
});




}
/// @nodoc
class _$QuizAnswerRefCopyWithImpl<$Res>
    implements $QuizAnswerRefCopyWith<$Res> {
  _$QuizAnswerRefCopyWithImpl(this._self, this._then);

  final QuizAnswerRef _self;
  final $Res Function(QuizAnswerRef) _then;

/// Create a copy of QuizAnswerRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? questionId = null,Object? optionId = freezed,Object? isCorrect = freezed,}) {
  return _then(QuizAnswerRef(
questionId: null == questionId ? _self.questionId : questionId // ignore: cast_nullable_to_non_nullable
as int,optionId: freezed == optionId ? _self.optionId : optionId // ignore: cast_nullable_to_non_nullable
as int?,isCorrect: freezed == isCorrect ? _self.isCorrect : isCorrect // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [QuizAnswerRef].
extension QuizAnswerRefPatterns on QuizAnswerRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuizAnswerRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuizAnswerRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuizAnswerRef value)  $default,){
final _that = this;
switch (_that) {
case _QuizAnswerRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuizAnswerRef value)?  $default,){
final _that = this;
switch (_that) {
case _QuizAnswerRef() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int questionId,  int? optionId,  bool? isCorrect)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuizAnswerRef() when $default != null:
return $default(_that.questionId,_that.optionId,_that.isCorrect);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int questionId,  int? optionId,  bool? isCorrect)  $default,) {final _that = this;
switch (_that) {
case _QuizAnswerRef():
return $default(_that.questionId,_that.optionId,_that.isCorrect);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int questionId,  int? optionId,  bool? isCorrect)?  $default,) {final _that = this;
switch (_that) {
case _QuizAnswerRef() when $default != null:
return $default(_that.questionId,_that.optionId,_that.isCorrect);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuizAnswerRef implements QuizAnswerRef {
  const _QuizAnswerRef({required this.questionId, this.optionId, this.isCorrect});
  factory _QuizAnswerRef.fromJson(Map<String, dynamic> json) => _$QuizAnswerRefFromJson(json);

@override final  int questionId;
@override final  int? optionId;
@override final  bool? isCorrect;

/// Create a copy of QuizAnswerRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuizAnswerRefCopyWith<_QuizAnswerRef> get copyWith => __$QuizAnswerRefCopyWithImpl<_QuizAnswerRef>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuizAnswerRefToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuizAnswerRef&&(identical(other.questionId, questionId) || other.questionId == questionId)&&(identical(other.optionId, optionId) || other.optionId == optionId)&&(identical(other.isCorrect, isCorrect) || other.isCorrect == isCorrect));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,questionId,optionId,isCorrect);
}

@override
String toString() {
    return 'QuizAnswerRef(questionId: $questionId, optionId: $optionId, isCorrect: $isCorrect)';
}


}

/// @nodoc
abstract mixin class _$QuizAnswerRefCopyWith<$Res> implements $QuizAnswerRefCopyWith<$Res> {
  factory _$QuizAnswerRefCopyWith(_QuizAnswerRef value, $Res Function(_QuizAnswerRef) _then) = __$QuizAnswerRefCopyWithImpl;
@override @useResult
$Res call({
 int questionId, int? optionId, bool? isCorrect
});




}
/// @nodoc
class __$QuizAnswerRefCopyWithImpl<$Res>
    implements _$QuizAnswerRefCopyWith<$Res> {
  __$QuizAnswerRefCopyWithImpl(this._self, this._then);

  final _QuizAnswerRef _self;
  final $Res Function(_QuizAnswerRef) _then;

/// Create a copy of QuizAnswerRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? questionId = null,Object? optionId = freezed,Object? isCorrect = freezed,}) {
  return _then(_QuizAnswerRef(
questionId: null == questionId ? _self.questionId : questionId // ignore: cast_nullable_to_non_nullable
as int,optionId: freezed == optionId ? _self.optionId : optionId // ignore: cast_nullable_to_non_nullable
as int?,isCorrect: freezed == isCorrect ? _self.isCorrect : isCorrect // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}


/// @nodoc
mixin _$Submission {

 int get id; int get postId; UserSummary? get student; String get status; DisplayStatus get displayStatus; bool get isLate; double? get draftGrade; double? get grade; DateTime? get turnedInAt; DateTime? get returnedAt; List<Attachment> get attachments;/// Jawaban singkat Pertanyaan; pilihan ganda ada di [quizAnswers].
 String? get answerText; List<QuizAnswerRef>? get quizAnswers; int? get privateCommentCount;
/// Create a copy of Submission
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubmissionCopyWith<Submission> get copyWith => _$SubmissionCopyWithImpl<Submission>(this as Submission, _$identity);

  /// Serializes this Submission to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Submission;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Submission&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.postId, _this.postId) || other.postId == _this.postId)&&(identical(other.student, _this.student) || other.student == _this.student)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.displayStatus, _this.displayStatus) || other.displayStatus == _this.displayStatus)&&(identical(other.isLate, _this.isLate) || other.isLate == _this.isLate)&&(identical(other.draftGrade, _this.draftGrade) || other.draftGrade == _this.draftGrade)&&(identical(other.grade, _this.grade) || other.grade == _this.grade)&&(identical(other.turnedInAt, _this.turnedInAt) || other.turnedInAt == _this.turnedInAt)&&(identical(other.returnedAt, _this.returnedAt) || other.returnedAt == _this.returnedAt)&&const DeepCollectionEquality().equals(other.attachments, _this.attachments)&&(identical(other.answerText, _this.answerText) || other.answerText == _this.answerText)&&const DeepCollectionEquality().equals(other.quizAnswers, _this.quizAnswers)&&(identical(other.privateCommentCount, _this.privateCommentCount) || other.privateCommentCount == _this.privateCommentCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Submission;
  return Object.hash(runtimeType,_this.id,_this.postId,_this.student,_this.status,_this.displayStatus,_this.isLate,_this.draftGrade,_this.grade,_this.turnedInAt,_this.returnedAt,const DeepCollectionEquality().hash(_this.attachments),_this.answerText,const DeepCollectionEquality().hash(_this.quizAnswers),_this.privateCommentCount);
}

@override
String toString() {
  final _this = this as Submission;
  return 'Submission(id: ${_this.id}, postId: ${_this.postId}, student: ${_this.student}, status: ${_this.status}, displayStatus: ${_this.displayStatus}, isLate: ${_this.isLate}, draftGrade: ${_this.draftGrade}, grade: ${_this.grade}, turnedInAt: ${_this.turnedInAt}, returnedAt: ${_this.returnedAt}, attachments: ${_this.attachments}, answerText: ${_this.answerText}, quizAnswers: ${_this.quizAnswers}, privateCommentCount: ${_this.privateCommentCount})';
}


}

/// @nodoc
abstract mixin class $SubmissionCopyWith<$Res>  {
  factory $SubmissionCopyWith(Submission value, $Res Function(Submission) _then) = _$SubmissionCopyWithImpl;
@useResult
$Res call({
 int id, int postId, UserSummary? student, String status, DisplayStatus displayStatus, bool isLate, double? draftGrade, double? grade, DateTime? turnedInAt, DateTime? returnedAt, List<Attachment> attachments, String? answerText, List<QuizAnswerRef>? quizAnswers, int? privateCommentCount
});


$UserSummaryCopyWith<$Res>? get student;

}
/// @nodoc
class _$SubmissionCopyWithImpl<$Res>
    implements $SubmissionCopyWith<$Res> {
  _$SubmissionCopyWithImpl(this._self, this._then);

  final Submission _self;
  final $Res Function(Submission) _then;

/// Create a copy of Submission
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? postId = null,Object? student = freezed,Object? status = null,Object? displayStatus = null,Object? isLate = null,Object? draftGrade = freezed,Object? grade = freezed,Object? turnedInAt = freezed,Object? returnedAt = freezed,Object? attachments = null,Object? answerText = freezed,Object? quizAnswers = freezed,Object? privateCommentCount = freezed,}) {
  return _then(Submission(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,postId: null == postId ? _self.postId : postId // ignore: cast_nullable_to_non_nullable
as int,student: freezed == student ? _self.student : student // ignore: cast_nullable_to_non_nullable
as UserSummary?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,displayStatus: null == displayStatus ? _self.displayStatus : displayStatus // ignore: cast_nullable_to_non_nullable
as DisplayStatus,isLate: null == isLate ? _self.isLate : isLate // ignore: cast_nullable_to_non_nullable
as bool,draftGrade: freezed == draftGrade ? _self.draftGrade : draftGrade // ignore: cast_nullable_to_non_nullable
as double?,grade: freezed == grade ? _self.grade : grade // ignore: cast_nullable_to_non_nullable
as double?,turnedInAt: freezed == turnedInAt ? _self.turnedInAt : turnedInAt // ignore: cast_nullable_to_non_nullable
as DateTime?,returnedAt: freezed == returnedAt ? _self.returnedAt : returnedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,attachments: null == attachments ? _self.attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<Attachment>,answerText: freezed == answerText ? _self.answerText : answerText // ignore: cast_nullable_to_non_nullable
as String?,quizAnswers: freezed == quizAnswers ? _self.quizAnswers : quizAnswers // ignore: cast_nullable_to_non_nullable
as List<QuizAnswerRef>?,privateCommentCount: freezed == privateCommentCount ? _self.privateCommentCount : privateCommentCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of Submission
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserSummaryCopyWith<$Res>? get student {
    if (_self.student == null) {
    return null;
  }

  return $UserSummaryCopyWith<$Res>(_self.student!, (value) {
    return _then(_self.copyWith(student: value));
  });
}
}


/// Adds pattern-matching-related methods to [Submission].
extension SubmissionPatterns on Submission {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Submission value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Submission() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Submission value)  $default,){
final _that = this;
switch (_that) {
case _Submission():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Submission value)?  $default,){
final _that = this;
switch (_that) {
case _Submission() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int postId,  UserSummary? student,  String status,  DisplayStatus displayStatus,  bool isLate,  double? draftGrade,  double? grade,  DateTime? turnedInAt,  DateTime? returnedAt,  List<Attachment> attachments,  String? answerText,  List<QuizAnswerRef>? quizAnswers,  int? privateCommentCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Submission() when $default != null:
return $default(_that.id,_that.postId,_that.student,_that.status,_that.displayStatus,_that.isLate,_that.draftGrade,_that.grade,_that.turnedInAt,_that.returnedAt,_that.attachments,_that.answerText,_that.quizAnswers,_that.privateCommentCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int postId,  UserSummary? student,  String status,  DisplayStatus displayStatus,  bool isLate,  double? draftGrade,  double? grade,  DateTime? turnedInAt,  DateTime? returnedAt,  List<Attachment> attachments,  String? answerText,  List<QuizAnswerRef>? quizAnswers,  int? privateCommentCount)  $default,) {final _that = this;
switch (_that) {
case _Submission():
return $default(_that.id,_that.postId,_that.student,_that.status,_that.displayStatus,_that.isLate,_that.draftGrade,_that.grade,_that.turnedInAt,_that.returnedAt,_that.attachments,_that.answerText,_that.quizAnswers,_that.privateCommentCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int postId,  UserSummary? student,  String status,  DisplayStatus displayStatus,  bool isLate,  double? draftGrade,  double? grade,  DateTime? turnedInAt,  DateTime? returnedAt,  List<Attachment> attachments,  String? answerText,  List<QuizAnswerRef>? quizAnswers,  int? privateCommentCount)?  $default,) {final _that = this;
switch (_that) {
case _Submission() when $default != null:
return $default(_that.id,_that.postId,_that.student,_that.status,_that.displayStatus,_that.isLate,_that.draftGrade,_that.grade,_that.turnedInAt,_that.returnedAt,_that.attachments,_that.answerText,_that.quizAnswers,_that.privateCommentCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Submission implements Submission {
  const _Submission({required this.id, required this.postId, this.student, required this.status, required this.displayStatus, required this.isLate, this.draftGrade, this.grade, this.turnedInAt, this.returnedAt,  List<Attachment> attachments = const <Attachment>[], this.answerText,  List<QuizAnswerRef>? quizAnswers, this.privateCommentCount}): _attachments = attachments,_quizAnswers = quizAnswers;
  factory _Submission.fromJson(Map<String, dynamic> json) => _$SubmissionFromJson(json);

@override final  int id;
@override final  int postId;
@override final  UserSummary? student;
@override final  String status;
@override final  DisplayStatus displayStatus;
@override final  bool isLate;
@override final  double? draftGrade;
@override final  double? grade;
@override final  DateTime? turnedInAt;
@override final  DateTime? returnedAt;
 final  List<Attachment> _attachments;
@override@JsonKey() List<Attachment> get attachments {
  if (_attachments is EqualUnmodifiableListView) return _attachments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_attachments);
}

/// Jawaban singkat Pertanyaan; pilihan ganda ada di [quizAnswers].
@override final  String? answerText;
 final  List<QuizAnswerRef>? _quizAnswers;
@override List<QuizAnswerRef>? get quizAnswers {
  final value = _quizAnswers;
  if (value == null) return null;
  if (_quizAnswers is EqualUnmodifiableListView) return _quizAnswers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  int? privateCommentCount;

/// Create a copy of Submission
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubmissionCopyWith<_Submission> get copyWith => __$SubmissionCopyWithImpl<_Submission>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SubmissionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Submission&&(identical(other.id, id) || other.id == id)&&(identical(other.postId, postId) || other.postId == postId)&&(identical(other.student, student) || other.student == student)&&(identical(other.status, status) || other.status == status)&&(identical(other.displayStatus, displayStatus) || other.displayStatus == displayStatus)&&(identical(other.isLate, isLate) || other.isLate == isLate)&&(identical(other.draftGrade, draftGrade) || other.draftGrade == draftGrade)&&(identical(other.grade, grade) || other.grade == grade)&&(identical(other.turnedInAt, turnedInAt) || other.turnedInAt == turnedInAt)&&(identical(other.returnedAt, returnedAt) || other.returnedAt == returnedAt)&&const DeepCollectionEquality().equals(other.attachments, _attachments)&&(identical(other.answerText, answerText) || other.answerText == answerText)&&const DeepCollectionEquality().equals(other.quizAnswers, _quizAnswers)&&(identical(other.privateCommentCount, privateCommentCount) || other.privateCommentCount == privateCommentCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,postId,student,status,displayStatus,isLate,draftGrade,grade,turnedInAt,returnedAt,const DeepCollectionEquality().hash(_attachments),answerText,const DeepCollectionEquality().hash(_quizAnswers),privateCommentCount);
}

@override
String toString() {
    return 'Submission(id: $id, postId: $postId, student: $student, status: $status, displayStatus: $displayStatus, isLate: $isLate, draftGrade: $draftGrade, grade: $grade, turnedInAt: $turnedInAt, returnedAt: $returnedAt, attachments: $attachments, answerText: $answerText, quizAnswers: $quizAnswers, privateCommentCount: $privateCommentCount)';
}


}

/// @nodoc
abstract mixin class _$SubmissionCopyWith<$Res> implements $SubmissionCopyWith<$Res> {
  factory _$SubmissionCopyWith(_Submission value, $Res Function(_Submission) _then) = __$SubmissionCopyWithImpl;
@override @useResult
$Res call({
 int id, int postId, UserSummary? student, String status, DisplayStatus displayStatus, bool isLate, double? draftGrade, double? grade, DateTime? turnedInAt, DateTime? returnedAt, List<Attachment> attachments, String? answerText, List<QuizAnswerRef>? quizAnswers, int? privateCommentCount
});


@override $UserSummaryCopyWith<$Res>? get student;

}
/// @nodoc
class __$SubmissionCopyWithImpl<$Res>
    implements _$SubmissionCopyWith<$Res> {
  __$SubmissionCopyWithImpl(this._self, this._then);

  final _Submission _self;
  final $Res Function(_Submission) _then;

/// Create a copy of Submission
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? postId = null,Object? student = freezed,Object? status = null,Object? displayStatus = null,Object? isLate = null,Object? draftGrade = freezed,Object? grade = freezed,Object? turnedInAt = freezed,Object? returnedAt = freezed,Object? attachments = null,Object? answerText = freezed,Object? quizAnswers = freezed,Object? privateCommentCount = freezed,}) {
  return _then(_Submission(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,postId: null == postId ? _self.postId : postId // ignore: cast_nullable_to_non_nullable
as int,student: freezed == student ? _self.student : student // ignore: cast_nullable_to_non_nullable
as UserSummary?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,displayStatus: null == displayStatus ? _self.displayStatus : displayStatus // ignore: cast_nullable_to_non_nullable
as DisplayStatus,isLate: null == isLate ? _self.isLate : isLate // ignore: cast_nullable_to_non_nullable
as bool,draftGrade: freezed == draftGrade ? _self.draftGrade : draftGrade // ignore: cast_nullable_to_non_nullable
as double?,grade: freezed == grade ? _self.grade : grade // ignore: cast_nullable_to_non_nullable
as double?,turnedInAt: freezed == turnedInAt ? _self.turnedInAt : turnedInAt // ignore: cast_nullable_to_non_nullable
as DateTime?,returnedAt: freezed == returnedAt ? _self.returnedAt : returnedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,attachments: null == attachments ? _self._attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<Attachment>,answerText: freezed == answerText ? _self.answerText : answerText // ignore: cast_nullable_to_non_nullable
as String?,quizAnswers: freezed == quizAnswers ? _self._quizAnswers : quizAnswers // ignore: cast_nullable_to_non_nullable
as List<QuizAnswerRef>?,privateCommentCount: freezed == privateCommentCount ? _self.privateCommentCount : privateCommentCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of Submission
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserSummaryCopyWith<$Res>? get student {
    if (_self.student == null) {
    return null;
  }

  return $UserSummaryCopyWith<$Res>(_self.student!, (value) {
    return _then(_self.copyWith(student: value));
  });
}
}

// dart format on
