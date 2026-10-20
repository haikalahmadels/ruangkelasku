// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserSummary _$UserSummaryFromJson(Map<String, dynamic> json) => _UserSummary(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  avatarUrl: json['avatar_url'] as String?,
);

Map<String, dynamic> _$UserSummaryToJson(_UserSummary instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'avatar_url': instance.avatarUrl,
};
