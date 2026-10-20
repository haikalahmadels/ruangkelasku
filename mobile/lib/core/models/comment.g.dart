// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Comment _$CommentFromJson(Map<String, dynamic> json) => _Comment(
  id: (json['id'] as num).toInt(),
  body: json['body'] as String,
  author: json['author'] == null ? null : UserSummary.fromJson(json['author'] as Map<String, dynamic>),
  createdAt: json['created_at'] == null ? null : DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$CommentToJson(_Comment instance) => <String, dynamic>{
  'id': instance.id,
  'body': instance.body,
  'author': instance.author?.toJson(),
  'created_at': instance.createdAt?.toIso8601String(),
};
