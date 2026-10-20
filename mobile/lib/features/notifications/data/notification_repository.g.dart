// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_repository.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppNotification _$AppNotificationFromJson(Map<String, dynamic> json) => _AppNotification(
  id: json['id'] as String,
  type: $enumDecodeNullable(_$NotificationTypeEnumMap, json['type'], unknownValue: JsonKey.nullForUndefinedEnumValue),
  title: json['title'] as String?,
  message: json['message'] as String?,
  courseId: (json['course_id'] as num?)?.toInt(),
  postId: (json['post_id'] as num?)?.toInt(),
  readAt: json['read_at'] == null ? null : DateTime.parse(json['read_at'] as String),
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$AppNotificationToJson(_AppNotification instance) => <String, dynamic>{
  'id': instance.id,
  'type': _$NotificationTypeEnumMap[instance.type],
  'title': instance.title,
  'message': instance.message,
  'course_id': instance.courseId,
  'post_id': instance.postId,
  'read_at': instance.readAt?.toIso8601String(),
  'created_at': instance.createdAt.toIso8601String(),
};

const _$NotificationTypeEnumMap = {
  NotificationType.postPublished: 'post_published',
  NotificationType.submissionReturned: 'submission_returned',
  NotificationType.submissionTurnedIn: 'submission_turned_in',
  NotificationType.privateComment: 'private_comment',
  NotificationType.courseInvitation: 'course_invitation',
};

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(notificationRepository)
final notificationRepositoryProvider = NotificationRepositoryProvider._();

final class NotificationRepositoryProvider
    extends $FunctionalProvider<NotificationRepository, NotificationRepository, NotificationRepository>
    with $Provider<NotificationRepository> {
  NotificationRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationRepositoryHash();

  @$internal
  @override
  $ProviderElement<NotificationRepository> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  NotificationRepository create(Ref ref) {
    return notificationRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NotificationRepository value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<NotificationRepository>(value));
  }
}

String _$notificationRepositoryHash() => r'22c28a14c145eab87ace3fb6c72c9623b75b6f1a';
