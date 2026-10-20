import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_summary.freezed.dart';
part 'user_summary.g.dart';

/// Bentuk ringkas pengguna: owner, author, student.
@freezed
abstract class UserSummary with _$UserSummary {
  const factory UserSummary({required int id, required String name, String? avatarUrl}) = _UserSummary;

  factory UserSummary.fromJson(Map<String, dynamic> json) => _$UserSummaryFromJson(json);
}
