import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/application/session.dart';
import '../data/course.dart';
import '../data/course_repository.dart';

part 'courses.g.dart';

@riverpod
Future<List<Course>> courseList(Ref ref, {required bool archived}) {
  ref.watch(currentUserIdProvider);
  return ref.watch(courseRepositoryProvider).list(archived: archived);
}

@riverpod
Future<List<Invitation>> myInvitations(Ref ref) {
  ref.watch(currentUserIdProvider);
  return ref.watch(courseRepositoryProvider).myInvitations();
}

@riverpod
Future<Course> course(Ref ref, int id) {
  ref.watch(currentUserIdProvider);
  return ref.watch(courseRepositoryProvider).get(id);
}

/// Mutasi kelas; setiap aksi memperbarui daftar yang terkait.
class CourseActions {
  CourseActions(this._ref);

  final Ref _ref;

  CourseRepository get _repo => _ref.read(courseRepositoryProvider);

  Future<Course> create(Map<String, dynamic> fields) async {
    final course = await _repo.create(fields);
    _ref.invalidate(courseListProvider);
    return course;
  }

  Future<Course> join(String code) async {
    final course = await _repo.join(code);
    _ref
      ..invalidate(courseListProvider)
      ..invalidate(myInvitationsProvider);
    return course;
  }

  Future<Course> update(int id, Map<String, dynamic> fields) => _refreshCourse(() => _repo.update(id, fields));

  Future<Course> resetCode(int id) => _refreshCourse(() => _repo.resetCode(id));

  Future<Course> archive(int id) => _refreshCourse(() => _repo.archive(id));

  Future<Course> restore(int id) => _refreshCourse(() => _repo.restore(id));

  Future<void> delete(int id) async {
    await _repo.delete(id);
    _ref.invalidate(courseListProvider);
  }

  Future<void> leave(int id) async {
    await _repo.leave(id);
    _ref.invalidate(courseListProvider);
  }

  Future<Course> acceptInvitation(int id) async {
    final course = await _repo.acceptInvitation(id);
    _ref
      ..invalidate(courseListProvider)
      ..invalidate(myInvitationsProvider);
    return course;
  }

  Future<void> declineInvitation(int id) async {
    await _repo.declineInvitation(id);
    _ref.invalidate(myInvitationsProvider);
  }

  Future<Course> _refreshCourse(Future<Course> Function() action) async {
    final course = await action();
    _ref
      ..invalidate(courseListProvider)
      ..invalidate(courseProvider(course.id));
    return course;
  }
}

/// keepAlive: dipakai setelah `await` di widget, jadi tidak boleh ikut dibuang otomatis.
@Riverpod(keepAlive: true)
CourseActions courseActions(Ref ref) => CourseActions(ref);
