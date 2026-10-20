import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:ruangkelasku/core/models/display_status.dart';
import 'package:ruangkelasku/core/models/user_summary.dart';
import 'package:ruangkelasku/core/theme/app_theme.dart';
import 'package:ruangkelasku/features/auth/application/session.dart';
import 'package:ruangkelasku/features/auth/data/user.dart';
import 'package:ruangkelasku/features/courses/data/course.dart';
import 'package:ruangkelasku/features/courses/data/course_repository.dart';
import 'package:ruangkelasku/features/courses/presentation/home_page.dart';

class _FakeSession extends Session {
  @override
  Future<User?> build() async => const User(id: 2, name: 'Dimas Pratama', email: 'dimas@ruangkelasku.test');
}

class _FakeCourseRepository implements CourseRepository {
  final calls = <String>[];

  static const course = Course(
    id: 2,
    name: 'Bahasa Indonesia',
    theme: 'forest',
    codeEnabled: true,
    streamPermission: 'all',
    classworkOnStream: 'compact',
    isArchived: false,
    myRole: CourseRole.student,
    isOwner: false,
  );

  @override
  Future<List<Course>> list({required bool archived}) async => [];

  @override
  Future<List<Invitation>> myInvitations() async => calls.contains('accept') || calls.contains('decline')
      ? []
      : const [
          Invitation(
            id: 1,
            courseId: 2,
            email: 'dimas@ruangkelasku.test',
            role: CourseRole.student,
            status: 'pending',
            invitedBy: UserSummary(id: 1, name: 'Rina Wulandari'),
            course: InvitationCourse(id: 2, name: 'Bahasa Indonesia', theme: 'forest'),
          ),
        ];

  @override
  Future<Course> acceptInvitation(int id) async {
    calls.add('accept');
    return course;
  }

  @override
  Future<void> declineInvitation(int id) async => calls.add('decline');

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Future<_FakeCourseRepository> _pumpHome(WidgetTester tester) async {
  final repo = _FakeCourseRepository();
  final router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (_, _) => const HomePage()),
      GoRoute(path: '/c/:id/stream', builder: (_, _) => const Text('kelas dibuka')),
    ],
  );
  await tester.pumpWidget(
    ProviderScope(
      overrides: [sessionProvider.overrideWith(_FakeSession.new), courseRepositoryProvider.overrideWithValue(repo)],
      child: MaterialApp.router(theme: AppTheme.light(), routerConfig: router),
    ),
  );
  await tester.pumpAndSettle();
  return repo;
}

void main() {
  testWidgets('menerima undangan memanggil API dan menampilkan Ruki', (tester) async {
    final repo = await _pumpHome(tester);
    expect(find.text('Bahasa Indonesia'), findsOneWidget);

    await tester.tap(find.text('Terima'));
    await tester.pumpAndSettle();

    expect(repo.calls, ['accept']);
    expect(find.text('Hore, kamu sudah bergabung di Bahasa Indonesia!'), findsOneWidget);
  });

  testWidgets('menolak undangan memanggil API', (tester) async {
    final repo = await _pumpHome(tester);

    await tester.tap(find.text('Tolak'));
    await tester.pumpAndSettle();

    expect(repo.calls, ['decline']);
  });
}
