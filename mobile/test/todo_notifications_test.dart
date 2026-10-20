import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:material_ui/material_ui.dart';
import 'package:ruangkelasku/core/copy/strings.dart';
import 'package:ruangkelasku/core/models/comment.dart';
import 'package:ruangkelasku/core/models/display_status.dart';
import 'package:ruangkelasku/core/models/paged.dart';
import 'package:ruangkelasku/core/models/post.dart';
import 'package:ruangkelasku/core/theme/app_theme.dart';
import 'package:ruangkelasku/core/utils/format.dart';
import 'package:ruangkelasku/features/auth/application/session.dart';
import 'package:ruangkelasku/features/auth/data/user.dart';
import 'package:ruangkelasku/features/classwork/data/classwork_repository.dart';
import 'package:ruangkelasku/features/courses/data/course.dart';
import 'package:ruangkelasku/features/courses/data/course_repository.dart';
import 'package:ruangkelasku/features/notifications/data/notification_repository.dart';
import 'package:ruangkelasku/features/notifications/presentation/notifications_page.dart';
import 'package:ruangkelasku/features/submissions/data/submission_repository.dart';
import 'package:ruangkelasku/features/todo/data/todo_repository.dart';
import 'package:ruangkelasku/features/todo/presentation/todo_page.dart';

class _FakeSession extends Session {
  @override
  Future<User?> build() async => const User(id: 2, name: 'Dimas Pratama', email: 'dimas@ruangkelasku.test');
}

class _FakeCourseRepository implements CourseRepository {
  @override
  Future<List<Course>> list({required bool archived}) async => [];

  @override
  Future<Course> get(int id) async => const Course(
    id: 1,
    name: 'Matematika Wajib',
    theme: 'ocean',
    codeEnabled: true,
    streamPermission: 'all',
    classworkOnStream: 'compact',
    isArchived: false,
    myRole: CourseRole.student,
    isOwner: false,
  );

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Post _work(int id, String title, {DateTime? dueAt, DisplayStatus status = DisplayStatus.assigned}) => Post(
  id: id,
  courseId: 1,
  course: const PostCourse(id: 1, name: 'Matematika Wajib', theme: 'ocean'),
  type: PostType.assignment,
  title: title,
  points: 100,
  dueAt: dueAt,
  status: PostStatus.published,
  mySubmission: MySubmission(id: id, displayStatus: status, isLate: false),
);

Paged<T> _page<T>(List<T> items) => Paged(items: items, currentPage: 1, lastPage: 1, total: items.length);

class _FakeTodoRepository implements TodoRepository {
  @override
  Future<Paged<Post>> todo(TodoTab tab, {int? courseId, int page = 1}) async => switch (tab) {
    TodoTab.assigned => _page([
      _work(1, 'Proyek Grafik Fungsi'),
      _work(2, 'Esai Akhir Semester', dueAt: DateTime.now().toUtc().add(const Duration(days: 60))),
    ]),
    TodoTab.missing => _page([
      _work(3, 'Rangkuman Bab 1', dueAt: DateTime.now().toUtc().subtract(const Duration(days: 2))),
    ]),
    TodoTab.done => _page(<Post>[]),
  };

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// Detail tugas di panel kanan (layar lebar).
class _FakeClassworkRepository implements ClassworkRepository {
  @override
  Future<Post> post(int postId) async => _work(postId, 'Proyek Grafik Fungsi');

  @override
  Future<List<Comment>> comments(int postId) async => [];

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeSubmissionRepository implements SubmissionRepository {
  @override
  Future<Submission> mine(int postId) async =>
      Submission(id: postId, postId: postId, status: 'assigned', displayStatus: DisplayStatus.assigned, isLate: false);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeNotificationRepository implements NotificationRepository {
  final calls = <String>[];
  var unread = 1;

  @override
  Future<Paged<AppNotification>> list({int page = 1}) async => _page([
    AppNotification(
      id: 'a',
      type: NotificationType.postPublished,
      title: 'Tugas baru',
      message: 'Matematika Wajib: Kuis Turunan Dasar',
      postId: 5,
      courseId: 1,
      createdAt: DateTime.now().toUtc(),
    ),
    AppNotification(
      id: 'b',
      type: NotificationType.submissionReturned,
      title: 'Tugas dikembalikan',
      message: 'Rangkuman Bab 1: nilai 45/50',
      postId: 7,
      courseId: 1,
      readAt: DateTime.now().toUtc(),
      createdAt: DateTime.now().toUtc(),
    ),
  ]);

  @override
  Future<int> unreadCount() async => unread;

  @override
  Future<void> markRead(String id) async {
    calls.add('read:$id');
    unread = 0;
  }

  @override
  Future<void> markAllRead() async {
    calls.add('readAll');
    unread = 0;
  }
}

/// Default lebar HP: satu panel, item dibuka sebagai halaman baru.
Future<void> _pump(
  WidgetTester tester,
  Widget page, {
  required List<Override> overrides,
  Size size = const Size(400, 800),
}) async {
  tester.view
    ..physicalSize = size
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (_, _) => page),
      GoRoute(path: '/p/:id', builder: (_, state) => Text('detail ${state.pathParameters['id']}')),
    ],
  );
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        sessionProvider.overrideWith(_FakeSession.new),
        courseRepositoryProvider.overrideWithValue(_FakeCourseRepository()),
        ...overrides,
      ],
      child: MaterialApp.router(theme: AppTheme.light(), routerConfig: router),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));

  test('tenggat dikelompokkan menurut minggu WIB', () {
    final now = DateTime.now().toUtc();
    expect(dueGroupOf(null), DueGroup.noDue);
    expect(dueGroupOf(now.subtract(const Duration(days: 1))), DueGroup.thisWeek);
    expect(dueGroupOf(now.add(const Duration(days: 30))), DueGroup.later);
  });

  group('Daftar tugas', () {
    final overrides = [
      todoRepositoryProvider.overrideWithValue(_FakeTodoRepository()),
      notificationRepositoryProvider.overrideWithValue(_FakeNotificationRepository()),
    ];

    testWidgets('tab Ditugaskan dikelompokkan per tenggat', (tester) async {
      await _pump(tester, const TodoPage(), overrides: overrides);

      // Judul kelompok dan keterangan tenggat item itu sendiri.
      expect(find.text('Tanpa tenggat'), findsNWidgets(2));
      expect(find.text('Nanti'), findsOneWidget);
      expect(find.text('Minggu ini'), findsNothing);
      expect(find.text('Proyek Grafik Fungsi'), findsOneWidget);
      expect(find.text('Esai Akhir Semester'), findsOneWidget);
    });

    testWidgets('tab Tidak diserahkan menampilkan Ruki khawatir dan tab Selesai kosong', (tester) async {
      await _pump(tester, const TodoPage(), overrides: overrides);

      await tester.tap(find.widgetWithText(Tab, S.todoMissing));
      await tester.pumpAndSettle();
      expect(find.text(S.missingWorried(1)), findsOneWidget);
      expect(find.text('Rangkuman Bab 1'), findsOneWidget);

      await tester.tap(find.widgetWithText(Tab, S.todoDone));
      await tester.pumpAndSettle();
      expect(find.text(S.emptyTodoDone), findsOneWidget);
    });

    testWidgets('ketuk tugas membuka detailnya', (tester) async {
      await _pump(tester, const TodoPage(), overrides: overrides);

      await tester.tap(find.text('Proyek Grafik Fungsi'));
      await tester.pumpAndSettle();
      expect(find.text('detail 1'), findsOneWidget);
    });

    testWidgets('di layar lebar detail tugas terbuka di panel kanan', (tester) async {
      await _pump(
        tester,
        const TodoPage(),
        size: const Size(1100, 900),
        overrides: [
          ...overrides,
          classworkRepositoryProvider.overrideWithValue(_FakeClassworkRepository()),
          submissionRepositoryProvider.overrideWithValue(_FakeSubmissionRepository()),
        ],
      );
      expect(find.text(S.selectItem), findsOneWidget);

      await tester.tap(find.text('Proyek Grafik Fungsi'));
      await tester.pumpAndSettle();

      // Tetap di halaman yang sama: daftar di kiri, detail dan "Tugas Anda" di kanan.
      expect(find.text('detail 1'), findsNothing);
      expect(find.text(S.selectItem), findsNothing);
      expect(find.text('Proyek Grafik Fungsi'), findsNWidgets(2));
      expect(find.text(S.yourWork), findsOneWidget);
    });
  });

  group('Notifikasi', () {
    testWidgets('badge lonceng dan tandai semua sudah dibaca', (tester) async {
      final repo = _FakeNotificationRepository();
      await _pump(
        tester,
        const NotificationsPage(),
        overrides: [notificationRepositoryProvider.overrideWithValue(repo)],
      );

      expect(find.bySemanticsLabel(S.unreadNotifications(1)), findsOneWidget);

      await tester.tap(find.byTooltip(S.markAllRead));
      await tester.pumpAndSettle();

      expect(repo.calls, ['readAll']);
      expect(find.byTooltip(S.markAllRead), findsNothing);
      expect(find.bySemanticsLabel(S.unreadNotifications(0)), findsOneWidget);
    });

    testWidgets('ketuk notifikasi menandainya dibaca dan membuka posting', (tester) async {
      final repo = _FakeNotificationRepository();
      await _pump(
        tester,
        const NotificationsPage(),
        overrides: [notificationRepositoryProvider.overrideWithValue(repo)],
      );

      await tester.tap(find.text('Tugas baru'));
      await tester.pumpAndSettle();

      expect(repo.calls, ['read:a']);
      expect(find.text('detail 5'), findsOneWidget);
    });
  });
}
