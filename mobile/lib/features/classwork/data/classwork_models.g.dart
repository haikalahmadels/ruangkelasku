// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'classwork_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Topic _$TopicFromJson(Map<String, dynamic> json) =>
    _Topic(id: (json['id'] as num).toInt(), name: json['name'] as String, position: (json['position'] as num).toInt());

Map<String, dynamic> _$TopicToJson(_Topic instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'position': instance.position,
};

_QuizOption _$QuizOptionFromJson(Map<String, dynamic> json) => _QuizOption(
  id: (json['id'] as num).toInt(),
  label: json['label'] as String,
  position: (json['position'] as num).toInt(),
  isCorrect: json['is_correct'] as bool?,
);

Map<String, dynamic> _$QuizOptionToJson(_QuizOption instance) => <String, dynamic>{
  'id': instance.id,
  'label': instance.label,
  'position': instance.position,
  'is_correct': instance.isCorrect,
};

_QuizQuestion _$QuizQuestionFromJson(Map<String, dynamic> json) => _QuizQuestion(
  id: (json['id'] as num).toInt(),
  prompt: json['prompt'] as String,
  points: (json['points'] as num).toInt(),
  position: (json['position'] as num).toInt(),
  options: (json['options'] as List<dynamic>).map((e) => QuizOption.fromJson(e as Map<String, dynamic>)).toList(),
);

Map<String, dynamic> _$QuizQuestionToJson(_QuizQuestion instance) => <String, dynamic>{
  'id': instance.id,
  'prompt': instance.prompt,
  'points': instance.points,
  'position': instance.position,
  'options': instance.options.map((e) => e.toJson()).toList(),
};
