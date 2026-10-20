import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/models/post.dart';
import '../../../core/utils/save_file.dart';
import '../../auth/application/session.dart';
import '../data/grade_repository.dart';

part 'grades.g.dart';

@riverpod
Future<GradeGrid> gradeGrid(Ref ref, int courseId) {
  ref.watch(currentUserIdProvider);
  return ref.watch(gradeRepositoryProvider).grid(courseId);
}

@riverpod
Future<List<Post>> myWork(Ref ref, int courseId) {
  ref.watch(currentUserIdProvider);
  return ref.watch(gradeRepositoryProvider).myWork(courseId);
}

class GradeActions {
  GradeActions(this._ref);

  final Ref _ref;

  /// Unduh CSV dari server lalu simpan (web) atau bagikan (Android).
  /// `true` bila file langsung tersimpan sebagai unduhan browser.
  Future<bool> exportCsv(int courseId) async {
    final file = await _ref.read(gradeRepositoryProvider).exportCsv(courseId);
    return saveOrShareFile(bytes: file.bytes, name: file.name, mimeType: 'text/csv');
  }
}

/// keepAlive: dipakai setelah `await` di widget, jadi tidak boleh ikut dibuang otomatis.
@Riverpod(keepAlive: true)
GradeActions gradeActions(Ref ref) => GradeActions(ref);
