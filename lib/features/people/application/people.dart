import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/models/display_status.dart';
import '../../auth/application/session.dart';
import '../../courses/application/courses.dart';
import '../../courses/data/course.dart';
import '../data/people_repository.dart';

part 'people.g.dart';

@riverpod
Future<Members> members(Ref ref, int courseId) {
  ref.watch(currentUserIdProvider);
  return ref.watch(peopleRepositoryProvider).members(courseId);
}

@riverpod
Future<List<Invitation>> pendingInvitations(Ref ref, int courseId) {
  ref.watch(currentUserIdProvider);
  return ref.watch(peopleRepositoryProvider).pendingInvitations(courseId);
}

class PeopleActions {
  PeopleActions(this._ref);

  final Ref _ref;

  PeopleRepository get _repo => _ref.read(peopleRepositoryProvider);

  Future<void> remove(int courseId, int userId) async {
    await _repo.remove(courseId, userId);
    _ref
      ..invalidate(membersProvider(courseId))
      ..invalidate(courseProvider(courseId));
  }

  Future<void> invite(int courseId, {required String email, required CourseRole role}) async {
    await _repo.invite(courseId, email: email, role: role);
    _ref.invalidate(pendingInvitationsProvider(courseId));
  }

  Future<void> cancelInvitation(int courseId, int invitationId) async {
    await _repo.cancelInvitation(invitationId);
    _ref.invalidate(pendingInvitationsProvider(courseId));
  }
}

/// keepAlive: dipakai setelah `await` di widget, jadi tidak boleh ikut dibuang otomatis.
@Riverpod(keepAlive: true)
PeopleActions peopleActions(Ref ref) => PeopleActions(ref);
