import 'package:freezed_annotation/freezed_annotation.dart';

import 'user_summary.dart';

part 'comment.freezed.dart';
part 'comment.g.dart';

/// Komentar kelas dan komentar pribadi punya bentuk yang sama.
@freezed
abstract class Comment with _$Comment {
  const factory Comment({required int id, required String body, UserSummary? author, DateTime? createdAt}) = _Comment;

  factory Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);
}
