import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/copy/strings.dart';
import '../../../core/layout/breakpoints.dart';
import '../../../core/models/display_status.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/async_view.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/widgets/form_widgets.dart';
import '../../../core/widgets/user_avatar.dart';
import '../../courses/application/courses.dart';
import '../../courses/data/course.dart';
import '../application/people.dart';
import '../data/people_repository.dart';

/// Layar 14: Anggota (Pengajar dan Siswa).
class PeoplePage extends ConsumerWidget {
  const PeoplePage({super.key, required this.courseId});

  final int courseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final course = ref.watch(courseProvider(courseId)).value;
    final members = ref.watch(membersProvider(courseId));
    if (course == null) return const SkeletonList();

    final canManage = course.isTeacher && !course.isArchived;

    return AsyncView(
      value: members,
      onRetry: () => ref.invalidate(membersProvider(courseId)),
      data: (data) => RefreshIndicator(
        onRefresh: () => ref.refresh(membersProvider(courseId).future),
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: Sizes.contentMaxWidth),
            child: ListView(
              padding: EdgeInsets.all(context.windowSize.pageGutter),
              children: [
                _SectionHeader(
                  title: S.teachers,
                  inviteLabel: S.inviteTeacher,
                  onInvite: course.isOwner && !course.isArchived
                      ? () => context.push('/c/$courseId/people/invite?role=teacher')
                      : null,
                ),
                for (final m in data.teachers)
                  _MemberTile(
                    course: course,
                    member: m,
                    isTeacher: true,
                    canRemove: course.isOwner && !m.isOwner && canManage,
                  ),
                const SizedBox(height: Space.xxl),
                _SectionHeader(
                  title: S.students,
                  trailing: data.students.isEmpty ? null : S.studentCount(data.students.length),
                  inviteLabel: S.inviteStudent,
                  onInvite: canManage ? () => context.push('/c/$courseId/people/invite?role=student') : null,
                ),
                if (data.students.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: Space.lg),
                    child: Text(S.noStudents, style: Theme.of(context).textTheme.bodyMedium),
                  ),
                for (final m in data.students)
                  _MemberTile(course: course, member: m, isTeacher: false, canRemove: canManage),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.inviteLabel, this.onInvite, this.trailing});

  final String title;
  final String inviteLabel;
  final VoidCallback? onInvite;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Semantics(
                header: true,
                child: Text(title, style: theme.textTheme.headlineSmall?.copyWith(color: primary)),
              ),
            ),
            if (trailing != null) Text(trailing!, style: theme.textTheme.labelLarge?.copyWith(color: primary)),
            if (onInvite != null)
              IconButton(
                tooltip: inviteLabel,
                icon: Icon(Symbols.person_add, color: primary),
                onPressed: onInvite,
              ),
          ],
        ),
        Divider(color: primary),
      ],
    );
  }
}

class _MemberTile extends ConsumerWidget {
  const _MemberTile({required this.course, required this.member, required this.isTeacher, required this.canRemove});

  final Course course;
  final Member member;
  final bool isTeacher;
  final bool canRemove;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subtitle = member.isOwner ? S.owner : member.email;

    return ListTile(
      leading: UserAvatar(name: member.name, url: member.avatarUrl),
      title: Text(member.name),
      subtitle: subtitle == null ? null : Text(subtitle),
      trailing: canRemove
          ? PopupMenuButton<void>(
              tooltip: S.more,
              icon: const Icon(Symbols.more_vert),
              itemBuilder: (_) => [
                PopupMenuItem(
                  onTap: () async {
                    final ok = await showConfirmDialog(
                      context,
                      title: S.removeTitle(member.name),
                      body: isTeacher ? S.removeTeacherBody : S.removeStudentBody,
                      confirmLabel: S.remove,
                      destructive: true,
                    );
                    if (!ok) return;
                    try {
                      await ref.read(peopleActionsProvider).remove(course.id, member.id);
                    } on ApiException catch (e) {
                      if (context.mounted) showMessage(context, e.message);
                    }
                  },
                  child: const Text(S.remove),
                ),
              ],
            )
          : null,
    );
  }
}

/// Layar 19: Undang siswa atau pengajar lewat email (undangan di dalam aplikasi).
class InvitePage extends ConsumerStatefulWidget {
  const InvitePage({super.key, required this.courseId, required this.role});

  final int courseId;
  final CourseRole role;

  @override
  ConsumerState<InvitePage> createState() => _InvitePageState();
}

class _InvitePageState extends ConsumerState<InvitePage> {
  final _email = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _email.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _invite() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await ref.read(peopleActionsProvider).invite(widget.courseId, email: _email.text.trim(), role: widget.role);
      if (!mounted) return;
      _email.clear();
      showMessage(context, S.invitationSent);
    } on ApiException catch (e) {
      // already_member dan already_invited (409) juga tampil di bawah kolom.
      if (mounted) setState(() => _error = e.fieldError('email') ?? e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pending = ref.watch(pendingInvitationsProvider(widget.courseId)).value ?? const <Invitation>[];
    final isTeacher = widget.role == CourseRole.teacher;
    final canInvite = _email.text.contains('@') && !_loading;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(tooltip: S.close, icon: const Icon(Symbols.close), onPressed: () => context.pop()),
        title: Text(S.invitePageTitle(isTeacher)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: Space.sm),
            child: FilledButton(onPressed: canInvite ? _invite : null, child: const Text(S.invite)),
          ),
        ],
      ),
      body: FormBody(
        children: [
          TextField(
            controller: _email,
            autofocus: true,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            textInputAction: TextInputAction.send,
            onSubmitted: (_) => canInvite ? _invite() : null,
            decoration: InputDecoration(labelText: S.email, helperText: S.inviteEmailHelp, errorText: _error),
          ),
          if (pending.isNotEmpty) ...[
            const SizedBox(height: Space.xxl),
            Text(S.pendingInvitations, style: theme.textTheme.titleMedium),
            const SizedBox(height: Space.sm),
            for (final invitation in pending)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(invitation.role == CourseRole.teacher ? Symbols.school : Symbols.person),
                title: Text(invitation.email),
                trailing: IconButton(
                  tooltip: S.cancelInvitation,
                  icon: const Icon(Symbols.close),
                  onPressed: () => ref.read(peopleActionsProvider).cancelInvitation(widget.courseId, invitation.id),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
