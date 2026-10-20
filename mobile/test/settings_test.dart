import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:ruangkelasku/core/copy/strings.dart';
import 'package:ruangkelasku/core/models/display_status.dart';
import 'package:ruangkelasku/core/theme/app_theme.dart';
import 'package:ruangkelasku/features/auth/application/session.dart';
import 'package:ruangkelasku/features/auth/data/auth_repository.dart';
import 'package:ruangkelasku/features/auth/data/user.dart';
import 'package:ruangkelasku/features/courses/data/course.dart';
import 'package:ruangkelasku/features/courses/data/course_repository.dart';
import 'package:ruangkelasku/features/courses/presentation/course_settings_page.dart';
import 'package:ruangkelasku/features/notifications/data/notification_repository.dart';
import 'package:ruangkelasku/features/settings/application/theme_mode.dart';
import 'package:ruangkelasku/features/settings/data/preferences_repository.dart';
import 'package:ruangkelasku/features/settings/presentation/settings_page.dart';

const _rina = User(id: 1, name: 'Rina Wulandari', email: 'rina@ruangkelasku.test');

class _FakeSession extends Session {
  @override
  Future<User?> build() async => _rina;
}

class _FakeCourseRepository implements CourseRepository {
  _FakeCourseRepository({this.archived = false});

  final bool archived;
  final updates = <Map<String, dynamic>>[];
  var code = 'k7m2xqa';

  Course get _course => Course(
    id: 1,
    name: 'Matematika Wajib',
    section: 'XI IPA 2',
    theme: 'ocean',
    code: code,
    codeEnabled: true,
    streamPermission: 'all',
    classworkOnStream: 'compact',
    isArchived: archived,
    myRole: CourseRole.teacher,
    isOwner: true,
  );

  @override
  Future<Course> get(int id) async => _course;

  @override
  Future<List<Course>> list({required bool archived}) async => [_course];

  @override
  Future<Course> update(int id, Map<String, dynamic> fields) async {
    updates.add(fields);
    return _course;
  }

  @override
  Future<Course> resetCode(int id) async {
    code = 'baru123';
    return _course;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeAuthRepository implements AuthRepository {
  final names = <String>[];

  @override
  Future<User> updateName(String name) async {
    names.add(name);
    return _rina.copyWith(name: name);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakePreferences implements PreferencesRepository {
  ThemeMode saved = ThemeMode.system;

  @override
  Future<ThemeMode> themeMode() async => saved;

  @override
  Future<void> setThemeMode(ThemeMode mode) async => saved = mode;
}

class _FakeNotificationRepository implements NotificationRepository {
  @override
  Future<int> unreadCount() async => 0;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Future<ProviderContainer> _pump(
  WidgetTester tester,
  String initial, {
  required List<Override> overrides,
  Size size = const Size(400, 800),
  double textScale = 1,
}) async {
  tester.view
    ..physicalSize = size
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final router = GoRouter(
    initialLocation: initial,
    routes: [
      GoRoute(path: '/', builder: (_, _) => const Text('beranda')),
      GoRoute(path: '/settings', builder: (_, _) => const SettingsPage()),
      GoRoute(path: '/c/:id/stream', builder: (_, _) => const Text('forum')),
      GoRoute(path: '/c/:id/settings', builder: (_, _) => const CourseSettingsPage(courseId: 1)),
    ],
  );
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        sessionProvider.overrideWith(_FakeSession.new),
        notificationRepositoryProvider.overrideWithValue(_FakeNotificationRepository()),
        ...overrides,
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
  return ProviderScope.containerOf(tester.element(find.byType(MaterialApp)));
}

void main() {
  group('Setelan kelas', () {
    testWidgets('hanya field yang berubah yang dikirim', (tester) async {
      final repo = _FakeCourseRepository();
      // Layar tinggi agar seluruh form (termasuk menu izin Forum) terbangun tanpa digulir.
      await _pump(
        tester,
        '/c/1/settings',
        size: const Size(400, 2000),
        overrides: [courseRepositoryProvider.overrideWithValue(repo)],
      );

      final save = find.widgetWithText(FilledButton, S.save);
      expect(tester.widget<FilledButton>(save).onPressed, isNull);

      await tester.enterText(find.widgetWithText(TextField, S.className), 'Matematika Peminatan');
      await tester.pump();
      final permission = find.byType(DropdownMenu<String>).first;
      await tester.tap(permission);
      await tester.pumpAndSettle();
      await tester.tap(find.text(S.streamPermissions['comment_only']!).last);
      await tester.pumpAndSettle();
      await tester.tap(save);
      await tester.pumpAndSettle();

      expect(repo.updates, [
        {'name': 'Matematika Peminatan', 'stream_permission': 'comment_only'},
      ]);
      // Setelah disimpan, kembali ke kelas.
      expect(find.text('forum'), findsOneWidget);
    });

    testWidgets('reset kode setelah konfirmasi', (tester) async {
      final repo = _FakeCourseRepository();
      await _pump(tester, '/c/1/settings', overrides: [courseRepositoryProvider.overrideWithValue(repo)]);
      expect(find.text('k7m2xqa'), findsOneWidget);

      await tester.ensureVisible(find.text(S.resetCode));
      await tester.pumpAndSettle();
      await tester.tap(find.text(S.resetCode));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, S.resetCode));
      await tester.pumpAndSettle();

      expect(find.text('baru123'), findsOneWidget);
      expect(find.text(S.codeReset), findsOneWidget);
    });

    testWidgets('kelas terarsip hanya bisa dibaca', (tester) async {
      await _pump(
        tester,
        '/c/1/settings',
        overrides: [courseRepositoryProvider.overrideWithValue(_FakeCourseRepository(archived: true))],
      );

      expect(find.text(S.archivedBanner), findsOneWidget);
      expect(tester.widget<TextField>(find.widgetWithText(TextField, S.className)).enabled, isFalse);
    });

    testWidgets('menutup dengan perubahan meminta konfirmasi', (tester) async {
      await _pump(
        tester,
        '/c/1/settings',
        overrides: [courseRepositoryProvider.overrideWithValue(_FakeCourseRepository())],
      );

      await tester.enterText(find.widgetWithText(TextField, S.room), 'R. 301');
      await tester.tap(find.byTooltip(S.close));
      await tester.pumpAndSettle();
      expect(find.text(S.discardTitle), findsOneWidget);

      await tester.tap(find.text(S.discard));
      await tester.pumpAndSettle();
      expect(find.text('forum'), findsOneWidget);
    });
  });

  group('Setelan profil', () {
    testWidgets('mengganti nama dan mode tampilan', (tester) async {
      final auth = _FakeAuthRepository();
      final prefs = _FakePreferences();
      final container = await _pump(
        tester,
        '/settings',
        overrides: [
          courseRepositoryProvider.overrideWithValue(_FakeCourseRepository()),
          authRepositoryProvider.overrideWithValue(auth),
          preferencesRepositoryProvider.overrideWithValue(prefs),
        ],
      );

      await tester.enterText(find.widgetWithText(TextField, S.name), 'Rina W.');
      await tester.pump();
      await tester.tap(find.widgetWithText(FilledButton, S.save));
      await tester.pumpAndSettle();
      expect(auth.names, ['Rina W.']);
      expect(container.read(sessionProvider).value?.name, 'Rina W.');

      await tester.tap(find.text(S.themeDark));
      await tester.pumpAndSettle();
      expect(prefs.saved, ThemeMode.dark);
      expect(container.read(themeModeSettingProvider).value, ThemeMode.dark);
    });

    for (final (label, size) in [
      ('rail diperluas', const Size(1000, 900)),
      ('drawer permanen', const Size(1400, 900)),
    ]) {
      testWidgets('navigasi global utuh pada skala teks 200% ($label)', (tester) async {
        await _pump(
          tester,
          '/settings',
          size: size,
          textScale: 2,
          overrides: [
            courseRepositoryProvider.overrideWithValue(_FakeCourseRepository()),
            preferencesRepositoryProvider.overrideWithValue(_FakePreferences()),
          ],
        );

        expect(find.text(S.navArchived), findsOneWidget);
      });
    }
  });
}
