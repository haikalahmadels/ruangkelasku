import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/models/display_status.dart';
import '../../../core/models/post.dart';
import '../../../core/models/user_summary.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';

part 'grade_repository.freezed.dart';
part 'grade_repository.g.dart';

/// Grid Tab Nilai (docs/api.md, GET /courses/{course}/grades).
@freezed
abstract class GradeGrid with _$GradeGrid {
  const factory GradeGrid({required List<GradedPost> posts, required List<StudentGrades> students}) = _GradeGrid;

  factory GradeGrid.fromJson(Map<String, dynamic> json) => _$GradeGridFromJson(json);
}

/// Ringkasan tugas untuk kolom grid.
@freezed
abstract class GradedPost with _$GradedPost {
  const factory GradedPost({required int id, required PostType type, String? title, int? points, DateTime? dueAt}) =
      _GradedPost;

  factory GradedPost.fromJson(Map<String, dynamic> json) => _$GradedPostFromJson(json);
}

@freezed
abstract class StudentGrades with _$StudentGrades {
  const StudentGrades._();

  const factory StudentGrades({
    required UserSummary user,

    /// Kunci objek JSON adalah ID posting.
    @Default(<String, GradeCell?>{}) Map<String, GradeCell?> grades,
  }) = _StudentGrades;

  factory StudentGrades.fromJson(Map<String, dynamic> json) => _$StudentGradesFromJson(json);

  GradeCell? cellFor(int postId) => grades['$postId'];
}

@freezed
abstract class GradeCell with _$GradeCell {
  const factory GradeCell({required DisplayStatus displayStatus, double? grade, double? draftGrade}) = _GradeCell;

  factory GradeCell.fromJson(Map<String, dynamic> json) => _$GradeCellFromJson(json);
}

/// Isi file ekspor beserta nama file dari server, mis. `nilai-k7m2xqa.csv`.
class ExportedFile {
  const ExportedFile({required this.bytes, required this.name});

  final Uint8List bytes;
  final String name;
}

class GradeRepository {
  GradeRepository(this._dio);

  final Dio _dio;

  Future<GradeGrid> grid(int courseId) => apiCall(() async {
    final response = await _dio.get<Map<String, dynamic>>('/courses/$courseId/grades');
    return GradeGrid.fromJson(response.data!['data'] as Map<String, dynamic>);
  });

  Future<ExportedFile> exportCsv(int courseId) => apiCall(() async {
    final response = await _dio.get<List<int>>(
      '/courses/$courseId/grades/export',
      options: Options(responseType: ResponseType.bytes),
    );
    final disposition = response.headers.value('content-disposition') ?? '';
    final name = RegExp(r'filename="?([^";]+)"?').firstMatch(disposition)?.group(1) ?? 'nilai.csv';
    return ExportedFile(bytes: Uint8List.fromList(response.data!), name: name);
  });

  /// Semua tugas siswa di satu kelas, dengan `my_submission` (layar Tugas Anda).
  Future<List<Post>> myWork(int courseId) => apiCall(() async {
    final response = await _dio.get<Map<String, dynamic>>('/courses/$courseId/my-work');
    return (response.data!['data'] as List).map((e) => Post.fromJson(e as Map<String, dynamic>)).toList();
  });
}

@Riverpod(keepAlive: true)
GradeRepository gradeRepository(Ref ref) => GradeRepository(ref.watch(dioProvider));
