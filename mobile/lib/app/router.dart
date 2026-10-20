import 'package:animations/animations.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/models/display_status.dart';
import '../core/models/post.dart';
import '../core/theme/tokens.dart';
import '../features/auth/application/session.dart';
import '../features/auth/presentation/auth_forms.dart';
import '../features/auth/presentation/welcome_page.dart';
import '../features/classwork/presentation/classwork_page.dart';
import '../features/classwork/presentation/composer_page.dart';
import '../features/classwork/presentation/post_detail_page.dart';
import '../features/classwork/presentation/quiz_editor_page.dart';
import '../features/courses/presentation/archived_page.dart';
import '../features/courses/presentation/class_shell.dart';
import '../features/courses/presentation/course_settings_page.dart';
import '../features/courses/presentation/home_page.dart';
import '../features/courses/presentation/join_create_pages.dart';
import '../features/grades/presentation/grades_page.dart';
import '../features/grades/presentation/my_work_page.dart';
import '../features/notifications/presentation/notifications_page.dart';
import '../features/people/presentation/people_pages.dart';
import '../features/quiz/presentation/quiz_take_page.dart';
import '../features/settings/presentation/settings_page.dart';
import '../features/stream/presentation/announce_page.dart';
import '../features/stream/presentation/stream_page.dart';
import '../features/submissions/presentation/private_comments_page.dart';
import '../features/submissions/presentation/submission_review.dart';
import '../features/todo/presentation/to_review_page.dart';
import '../features/todo/presentation/todo_page.dart';

part 'router.g.dart';

const _publicPaths = {'/welcome', '/login', '/register'};

/// Rute mengikuti Peta Layar di docs/design.md.
@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  final refresh = ValueNotifier(0);
  ref
    ..listen(sessionProvider, (_, _) => refresh.value++)
    ..onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: refresh,
    redirect: (context, state) {
      final session = ref.read(sessionProvider);
      // Tunggu sesi diketahui; refreshListenable memicu redirect lagi setelahnya.
      if (!session.hasValue) return null;
      final loggedIn = session.value != null;
      final atPublic = _publicPaths.contains(state.matchedLocation);
      if (!loggedIn) return atPublic ? null : '/welcome';
      if (atPublic) return '/';
      return null;
    },
    routes: [
      GoRoute(path: '/welcome', builder: (_, _) => const WelcomePage()),
      GoRoute(path: '/login', builder: (_, _) => const LoginPage()),
      GoRoute(path: '/register', builder: (_, _) => const RegisterPage()),
      GoRoute(path: '/', builder: (_, _) => const HomePage()),
      GoRoute(path: '/join', builder: (_, _) => const JoinCoursePage()),
      GoRoute(path: '/courses/new', builder: (_, _) => const CreateCoursePage()),
      GoRoute(path: '/archived', builder: (_, _) => const ArchivedPage()),
      GoRoute(path: '/todo', builder: (_, _) => const TodoPage()),
      GoRoute(path: '/to-review', builder: (_, _) => const ToReviewPage()),
      GoRoute(path: '/notifications', builder: (_, _) => const NotificationsPage()),
      GoRoute(path: '/settings', builder: (_, _) => const SettingsPage()),

      // Layar penuh di atas kelas (tanpa tab).
      GoRoute(
        path: '/c/:courseId/announce',
        builder: (_, state) => AnnouncePage(courseId: _courseId(state)),
      ),
      GoRoute(
        path: '/c/:courseId/settings',
        builder: (_, state) => CourseSettingsPage(courseId: _courseId(state)),
      ),
      GoRoute(
        path: '/c/:courseId/people/invite',
        builder: (_, state) => InvitePage(
          courseId: _courseId(state),
          role: state.uri.queryParameters['role'] == 'teacher' ? CourseRole.teacher : CourseRole.student,
        ),
      ),
      GoRoute(
        path: '/c/:courseId/classwork/new',
        builder: (_, state) => ComposerPage(
          courseId: _courseId(state),
          type: PostType.values.asNameMap()[state.uri.queryParameters['type']] ?? PostType.assignment,
        ),
      ),

      // Posting, tugas, kuis, dan penilaian.
      GoRoute(
        path: '/p/:postId',
        builder: (_, state) => PostDetailPage(postId: _postId(state)),
      ),
      GoRoute(
        path: '/p/:postId/submissions',
        builder: (_, state) => PostDetailPage(postId: _postId(state), studentWork: true),
      ),
      GoRoute(
        path: '/p/:postId/quiz',
        builder: (_, state) => QuizTakePage(postId: _postId(state)),
      ),
      GoRoute(
        path: '/p/:postId/quiz/edit',
        builder: (_, state) => QuizEditorPage(postId: _postId(state)),
      ),
      GoRoute(
        path: '/p/:postId/private',
        builder: (_, state) => PrivateCommentsPage(postId: _postId(state)),
      ),
      GoRoute(
        path: '/s/:submissionId',
        builder: (_, state) => SubmissionReviewPage(submissionId: int.parse(state.pathParameters['submissionId']!)),
      ),
      GoRoute(path: '/c/:courseId', redirect: (_, state) => '/c/${state.pathParameters['courseId']}/stream'),

      // Empat tab kelas berbagi satu kerangka; perpindahan tab memakai fade through.
      ShellRoute(
        builder: (context, state, child) =>
            ClassShell(courseId: _courseId(state), location: state.matchedLocation, child: child),
        routes: [
          _tab('/c/:courseId/stream', (id) => StreamPage(courseId: id)),
          _tab('/c/:courseId/classwork', (id) => ClassworkPage(courseId: id)),
          _tab('/c/:courseId/people', (id) => PeoplePage(courseId: id)),
          _tab('/c/:courseId/grades', (id) => GradesPage(courseId: id)),
          _tab('/c/:courseId/my-work', (id) => MyWorkPage(courseId: id)),
        ],
      ),
    ],
  );
}

int _courseId(GoRouterState state) => int.parse(state.pathParameters['courseId']!);

int _postId(GoRouterState state) => int.parse(state.pathParameters['postId']!);

GoRoute _tab(String path, Widget Function(int courseId) build) => GoRoute(
  path: path,
  pageBuilder: (context, state) => CustomTransitionPage(
    key: state.pageKey,
    child: build(_courseId(state)),
    transitionDuration: Motion.medium,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      if (MediaQuery.disableAnimationsOf(context)) return child;
      return FadeThroughTransition(animation: animation, secondaryAnimation: secondaryAnimation, child: child);
    },
  ),
);
