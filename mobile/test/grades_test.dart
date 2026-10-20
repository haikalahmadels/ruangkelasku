import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:material_ui/material_ui.dart';
import 'package:ruangkelasku/core/copy/strings.dart';
import 'package:ruangkelasku/core/models/display_status.dart';
import 'package:ruangkelasku/core/models/post.dart';
import 'package:ruangkelasku/core/theme/app_theme.dart';
import 'package:ruangkelasku/features/auth/application/session.dart';
import 'package:ruangkelasku/features/auth/data/user.dart';
import 'package:ruangkelasku/features/grades/application/grades.dart';
import 'package:ruangkelasku/features/grades/data/grade_repository.dart';
import 'package:ruangkelasku/features/grades/presentation/grades_page.dart';
import 'package:ruangkelasku/features/grades/presentation/my_work_page.dart';

class _FakeSession extends Session {
  @override
  Future<User?> build() async => const User(id: 1, name: 'Rina Wulandari', email: 'rina@ruangkelasku.test');
}

/// Bentuk persis respons GET /courses/{course}/grades dari Laravel.
const _gridJson = {
  'posts': [
    {'id': 12, 'type': 'quiz', 'title': 'Kuis Turunan Dasar', 'points': 30, 'due_at': '2026-10-16T16:59:00Z'},
    {'id': 9, 'type': 'assignment', 'title': 'Latihan Turunan Fungsi', 'points': 100, 'due_at': null},
  ],
  'students': [
    {
      'user': {'id': 2, 'name': 'Dimas Pratama', 'avatar_url': null},
      'grades': {
        '12': {'display_status': 'returned', 'grade': 25.0, 'draft_grade': 25.0},
        '9': {'display_status': 'graded', 'grade': null, 'draft_grade': 87.5},
      },
    },
    {
      'user': {'id': 3, 'name': 'Sari Lestari', 'avatar_url': null},
      'grades': {
        '12': {'display_status': 'missing', 'grade': null, 'draft_grade': null},
        '9': null,
      },
    },
  ],
};

class _FakeGradeRepository implements GradeRepository {
  @override
  Future<GradeGrid> grid(int courseId) async => GradeGrid.fromJson(_gridJson);

  @override
  Future<List<Post>> myWork(int courseId) async => [
    _work(1, 'Rangkuman Bab 1', DisplayStatus.missing),
    _work(2, 'Latihan Turunan Fungsi', DisplayStatus.assigned),
    _work(3, 'Kuis Limit', DisplayStatus.returned, grade: 45),
  ];

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeGradeActions implements GradeActions {
  final exported = <int>[];

  @override
  Future<bool> exportCsv(int courseId) async {
    exported.add(courseId);
    return true;
  }
}

Post _work(int id, String title, DisplayStatus status, {double? grade}) => Post(
  id: id,
  courseId: 1,
  type: PostType.assignment,
  title: title,
  points: 50,
  status: PostStatus.published,
  mySubmission: MySubmission(id: id, displayStatus: status, isLate: false, grade: grade),
);

Future<void> _pump(
  WidgetTester tester,
  Widget page, {
  double textScale = 1,
  Size size = const Size(400, 800),
  List<Override> extra = const [],
}) async {
  tester.view
    ..physicalSize = size
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (_, _) => Scaffold(body: page),
      ),
      GoRoute(path: '/p/:id/submissions', builder: (_, state) => Text('tugas siswa ${state.pathParameters['id']}')),
      GoRoute(path: '/p/:id', builder: (_, state) => Text('detail ${state.pathParameters['id']}')),
    ],
  );
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        sessionProvider.overrideWith(_FakeSession.new),
        gradeRepositoryProvider.overrideWithValue(_FakeGradeRepository()),
        ...extra,
      ],
      child: MaterialApp.router(
        theme: AppTheme.light(),
        routerConfig: router,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(textScale)),
          child: child!,
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));

  test('GradeGrid membaca kunci ID posting dan sel kosong', () {
    final grid = GradeGrid.fromJson(_gridJson);
    final dimas = grid.students.first;
    final sari = grid.students.last;

    expect(grid.posts.map((p) => p.type), [PostType.quiz, PostType.assignment]);
    expect(dimas.cellFor(12)?.grade, 25);
    expect(dimas.cellFor(9)?.displayStatus, DisplayStatus.graded);
    expect(dimas.cellFor(9)?.draftGrade, 87.5);
    expect(sari.cellFor(9), isNull);
    expect(sari.cellFor(99), isNull);
  });

  group('Tab Nilai', () {
    testWidgets('HP: per siswa lalu per tugas', (tester) async {
      await _pump(tester, const GradesPage(courseId: 1));

      await tester.tap(find.text('Dimas Pratama'));
      await tester.pumpAndSettle();
      expect(find.text('25'), findsOneWidget);
      expect(find.text('87,5'), findsOneWidget);
      expect(find.text(S.draftShort), findsOneWidget);

      await tester.tap(find.text(S.byAssignment));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Kuis Turunan Dasar'));
      await tester.pumpAndSettle();
      expect(find.text('Tidak diserahkan'), findsOneWidget);

      await tester.tap(find.text(S.tabStudentWork));
      await tester.pumpAndSettle();
      expect(find.text('tugas siswa 12'), findsOneWidget);
    });

    testWidgets('layar lebar: grid siswa × tugas dengan label pembaca layar', (tester) async {
      await _pump(tester, const GradesPage(courseId: 1), size: const Size(1100, 800));

      expect(find.text(S.byAssignment), findsNothing);
      expect(find.text('Kuis Turunan Dasar'), findsOneWidget);
      expect(find.text(S.outOf(30)), findsOneWidget);
      expect(find.text('25'), findsOneWidget);
      expect(find.text(S.draftShort), findsOneWidget);
      expect(
        find.bySemanticsLabel(S.gradeCellLabel('Sari Lestari', 'Kuis Turunan Dasar', 'Tidak diserahkan')),
        findsOneWidget,
      );

      await tester.tap(find.text('Latihan Turunan Fungsi'));
      await tester.pumpAndSettle();
      expect(find.text('tugas siswa 9'), findsOneWidget);
    });

    testWidgets('grid tetap utuh pada skala teks 200%', (tester) async {
      await _pump(tester, const GradesPage(courseId: 1), size: const Size(1100, 800), textScale: 2);

      expect(find.text('Dimas Pratama'), findsOneWidget);
      expect(find.text('87,5'), findsOneWidget);
    });

    testWidgets('ekspor CSV', (tester) async {
      final actions = _FakeGradeActions();
      await _pump(tester, const GradesPage(courseId: 1), extra: [gradeActionsProvider.overrideWithValue(actions)]);

      await tester.tap(find.text(S.exportCsv));
      await tester.pumpAndSettle();

      expect(actions.exported, [1]);
      expect(find.text(S.exportDownloaded), findsOneWidget);
    });
  });

  testWidgets('Tugas Anda menyaring menurut status', (tester) async {
    await _pump(tester, const MyWorkPage(courseId: 1));

    expect(find.text('Rangkuman Bab 1'), findsOneWidget);
    expect(find.text('Kuis Limit'), findsOneWidget);
    expect(find.text(S.gradeOutOf('45', 50)), findsOneWidget);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Tidak diserahkan'));
    await tester.pumpAndSettle();
    expect(find.text('Rangkuman Bab 1'), findsOneWidget);
    expect(find.text('Kuis Limit'), findsNothing);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Diserahkan'));
    await tester.pumpAndSettle();
    expect(find.text(S.emptyMyWorkFilter), findsOneWidget);
  });
}
