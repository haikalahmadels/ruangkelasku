import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:material_ui/material_ui.dart';
import 'package:ruangkelasku/core/copy/strings.dart';
import 'package:ruangkelasku/core/models/comment.dart';
import 'package:ruangkelasku/core/models/display_status.dart';
import 'package:ruangkelasku/core/models/post.dart';
import 'package:ruangkelasku/core/models/user_summary.dart';
import 'package:ruangkelasku/core/theme/app_theme.dart';
import 'package:ruangkelasku/core/utils/uploads.dart';
import 'package:ruangkelasku/features/auth/application/session.dart';
import 'package:ruangkelasku/features/auth/data/user.dart';
import 'package:ruangkelasku/features/classwork/data/classwork_models.dart';
import 'package:ruangkelasku/features/classwork/data/classwork_repository.dart';
import 'package:ruangkelasku/features/classwork/presentation/composer_page.dart';
import 'package:ruangkelasku/features/courses/data/course.dart';
import 'package:ruangkelasku/features/submissions/data/submission_repository.dart';
import 'package:ruangkelasku/features/submissions/presentation/submission_panel.dart';
import 'package:ruangkelasku/features/submissions/presentation/submission_review.dart';

class _FakeSession extends Session {
  @override
  Future<User?> build() async => const User(id: 2, name: 'Dimas Pratama', email: 'dimas@ruangkelasku.test');
}

const _question = Post(
  id: 14,
  courseId: 1,
  type: PostType.question,
  title: 'Bagian mana yang paling membingungkan?',
  points: 10,
  status: PostStatus.published,
);

const _course = Course(
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

class _FakeClassworkRepository implements ClassworkRepository {
  _FakeClassworkRepository({this.options = const []});

  final List<String> options;
  final calls = <String>[];

  @override
  Future<List<Topic>> topics(int courseId) async => [];

  @override
  Future<Post> createPost(
    int courseId,
    PostDraft draft, {
    List<PickedUpload> files = const [],
    List<String> links = const [],
  }) async {
    calls.add('create:${draft.type.name}:${draft.status.name}:${draft.points}');
    return _question.copyWith(status: draft.status);
  }

  @override
  Future<void> saveQuestion(int postId, List<String> options) async => calls.add('question:${options.join('|')}');

  @override
  Future<Post> publish(int postId) async {
    calls.add('publish');
    return _question;
  }

  @override
  Future<Post> post(int postId) async => _question;

  @override
  Future<List<QuizQuestion>> quiz(int postId) async => [
    QuizQuestion(
      id: 1,
      prompt: _question.title!,
      points: 1,
      position: 0,
      options: [for (final (i, label) in options.indexed) QuizOption(id: 100 + i, label: label, position: i)],
    ),
  ];

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeSubmissionRepository implements SubmissionRepository {
  _FakeSubmissionRepository(this.current);

  Submission current;
  final answers = <String>[];

  @override
  Future<Submission> mine(int postId) async => current;

  @override
  Future<Submission> get(int submissionId) async => current;

  @override
  Future<List<Comment>> privateComments(int submissionId) async => [];

  @override
  Future<Submission> answerQuestion(int postId, {String? answerText, int? optionId}) async {
    answers.add(answerText ?? 'option:$optionId');
    return current = current.copyWith(
      status: 'turned_in',
      displayStatus: DisplayStatus.turnedIn,
      answerText: answerText,
      quizAnswers: optionId == null ? null : [QuizAnswerRef(questionId: 1, optionId: optionId)],
    );
  }

  @override
  Future<Submission> unsubmit(int postId) async =>
      current = current.copyWith(status: 'assigned', displayStatus: DisplayStatus.assigned);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

const _assigned = Submission(
  id: 7,
  postId: 14,
  student: UserSummary(id: 2, name: 'Dimas Pratama'),
  status: 'assigned',
  displayStatus: DisplayStatus.assigned,
  isLate: false,
);

Future<GoRouter> _pump(WidgetTester tester, Widget page, List<Override> overrides) async {
  tester.view
    ..physicalSize = const Size(400, 900)
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (_, _) => const Text('tugas kelas')),
      GoRoute(
        path: '/page',
        builder: (_, _) => Scaffold(body: page),
      ),
    ],
  );
  await tester.pumpWidget(
    ProviderScope(
      overrides: [sessionProvider.overrideWith(_FakeSession.new), ...overrides],
      child: MaterialApp.router(
        theme: AppTheme.light(),
        routerConfig: router,
        // Tanpa konfeti; perayaan tetap menutup sendiri setelah 2 detik.
        builder: (context, child) =>
            MediaQuery(data: MediaQuery.of(context).copyWith(disableAnimations: true), child: child!),
      ),
    ),
  );
  router.push('/page');
  await tester.pumpAndSettle();
  return router;
}

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));

  group('Composer Pertanyaan', () {
    testWidgets('pilihan ganda: draf, simpan bentuk, lalu terbitkan', (tester) async {
      final repo = _FakeClassworkRepository();
      await _pump(tester, const ComposerPage(courseId: 1, type: PostType.question), [
        classworkRepositoryProvider.overrideWithValue(repo),
      ]);

      await tester.enterText(find.widgetWithText(TextField, '${S.questionField} *'), 'Bagian tersulit?');
      await tester.tap(find.text(S.multipleChoice));
      await tester.pump();
      await tester.enterText(find.widgetWithText(TextField, S.optionLabel(0)), 'Aturan rantai');
      await tester.tap(find.text(S.ask));
      await tester.pump();

      // Opsi B masih kosong: ditolak sebelum memanggil API.
      expect(find.text(S.optionsIncomplete), findsOneWidget);
      expect(repo.calls, isEmpty);

      await tester.enterText(find.widgetWithText(TextField, S.optionLabel(1)), 'Soal cerita');
      await tester.tap(find.text(S.addOption));
      await tester.pump();
      await tester.enterText(find.widgetWithText(TextField, S.optionLabel(2)), 'Trigonometri');
      await tester.tap(find.text(S.ask));
      await tester.pumpAndSettle();

      expect(repo.calls, ['create:question:draft:100', 'question:Aturan rantai|Soal cerita|Trigonometri', 'publish']);
      expect(find.text('tugas kelas'), findsOneWidget);
    });

    testWidgets('jawaban singkat mengirim daftar opsi kosong', (tester) async {
      final repo = _FakeClassworkRepository();
      await _pump(tester, const ComposerPage(courseId: 1, type: PostType.question), [
        classworkRepositoryProvider.overrideWithValue(repo),
      ]);

      await tester.enterText(find.widgetWithText(TextField, '${S.questionField} *'), 'Apa arti turunan?');
      await tester.pump();
      await tester.tap(find.text(S.ask));
      await tester.pumpAndSettle();

      expect(repo.calls, ['create:question:draft:100', 'question:', 'publish']);
    });
  });

  group('Tugas Anda untuk Pertanyaan', () {
    testWidgets('siswa memilih opsi, menyerahkan, lalu membatalkan', (tester) async {
      final submissions = _FakeSubmissionRepository(_assigned);
      await _pump(tester, const SubmissionPanel(post: _question, course: _course), [
        classworkRepositoryProvider.overrideWithValue(
          _FakeClassworkRepository(options: ['Aturan rantai', 'Soal cerita']),
        ),
        submissionRepositoryProvider.overrideWithValue(submissions),
      ]);

      final turnIn = find.widgetWithText(FilledButton, S.turnIn);
      expect(tester.widget<FilledButton>(turnIn).onPressed, isNull);

      await tester.tap(find.text('Soal cerita'));
      await tester.pump();
      await tester.tap(turnIn);
      await tester.pump();
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      expect(submissions.answers, ['option:101']);
      expect(find.text(S.yourAnswer), findsOneWidget);
      expect(find.text('Soal cerita'), findsOneWidget);

      await tester.tap(find.text(S.unsubmit));
      await tester.pumpAndSettle();
      expect(find.widgetWithText(FilledButton, S.turnIn), findsOneWidget);
    });

    testWidgets('siswa menulis jawaban singkat', (tester) async {
      final submissions = _FakeSubmissionRepository(_assigned);
      await _pump(tester, const SubmissionPanel(post: _question, course: _course), [
        classworkRepositoryProvider.overrideWithValue(_FakeClassworkRepository()),
        submissionRepositoryProvider.overrideWithValue(submissions),
      ]);

      await tester.enterText(find.widgetWithText(TextField, S.yourAnswerHint), '  Laju perubahan fungsi.  ');
      await tester.pump();
      await tester.tap(find.widgetWithText(FilledButton, S.turnIn));
      await tester.pump();
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      expect(submissions.answers, ['Laju perubahan fungsi.']);
      expect(find.text('Laju perubahan fungsi.'), findsOneWidget);
    });
  });

  testWidgets('guru melihat jawaban tanpa hitungan benar', (tester) async {
    final answered = _assigned.copyWith(
      status: 'turned_in',
      displayStatus: DisplayStatus.turnedIn,
      quizAnswers: const [QuizAnswerRef(questionId: 1, optionId: 100)],
    );
    await _pump(tester, const SubmissionReview(submissionId: 7), [
      classworkRepositoryProvider.overrideWithValue(
        _FakeClassworkRepository(options: ['Aturan rantai', 'Soal cerita']),
      ),
      submissionRepositoryProvider.overrideWithValue(_FakeSubmissionRepository(answered)),
    ]);

    expect(find.text(S.answer), findsOneWidget);
    expect(find.text('Aturan rantai'), findsOneWidget);
    expect(find.textContaining(S.correct), findsNothing);
  });
}
