import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/models/paged.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';

part 'notification_repository.freezed.dart';
part 'notification_repository.g.dart';

/// Jenis notifikasi Fase UTS (docs/api.md, contoh Notification).
@JsonEnum(fieldRename: FieldRename.snake, alwaysCreate: true)
enum NotificationType { postPublished, submissionReturned, submissionTurnedIn, privateComment, courseInvitation }

/// Notifikasi in-app; diberi nama ini agar tidak bentrok dengan `Notification` milik Flutter.
@freezed
abstract class AppNotification with _$AppNotification {
  const AppNotification._();

  const factory AppNotification({
    required String id,
    @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) NotificationType? type,
    String? title,
    String? message,
    int? courseId,
    int? postId,
    DateTime? readAt,
    required DateTime createdAt,
  }) = _AppNotification;

  factory AppNotification.fromJson(Map<String, dynamic> json) => _$AppNotificationFromJson(json);

  bool get isUnread => readAt == null;
}

class NotificationRepository {
  NotificationRepository(this._dio);

  final Dio _dio;

  Future<Paged<AppNotification>> list({int page = 1}) => apiCall(() async {
    final response = await _dio.get<Map<String, dynamic>>('/notifications', queryParameters: {'page': page});
    return Paged.fromJson(response.data!, AppNotification.fromJson);
  });

  Future<int> unreadCount() => apiCall(() async {
    final response = await _dio.get<Map<String, dynamic>>('/notifications/unread-count');
    return (response.data!['data'] as Map<String, dynamic>)['count'] as int;
  });

  Future<void> markRead(String id) => apiCall(() => _dio.post<void>('/notifications/$id/read'));

  Future<void> markAllRead() => apiCall(() => _dio.post<void>('/notifications/read-all'));
}

@Riverpod(keepAlive: true)
NotificationRepository notificationRepository(Ref ref) => NotificationRepository(ref.watch(dioProvider));
