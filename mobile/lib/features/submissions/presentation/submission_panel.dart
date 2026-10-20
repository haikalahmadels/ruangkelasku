import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/copy/strings.dart';
import '../../../core/layout/breakpoints.dart';
import '../../../core/models/display_status.dart';
import '../../../core/models/post.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/add_attachment_menu.dart';
import '../../../core/widgets/async_view.dart';
import '../../../core/widgets/celebration.dart';
import '../../../core/widgets/form_widgets.dart';
import '../../../core/widgets/post_card.dart';
import '../../../core/widgets/status_chip.dart';
import '../../courses/data/course.dart';
import '../application/submissions.dart';
import '../data/submission_repository.dart';
import 'question_answer.dart';

/// Kartu "Tugas Anda" (komponen SubmissionSheet): status, nilai, lampiran,
/// tombol "+ Tambahkan atau buat", dan "Serahkan" (alur inti 7).
class SubmissionPanel extends ConsumerWidget {
  const SubmissionPanel({super.key, required this.post, required this.course, this.flat = false});

  final Post post;
  final Course course;

  /// Tanpa kartu saat sudah di dalam bottom sheet.
  final bool flat;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mine = ref.watch(mySubmissionProvider(post.id));
    final content = AsyncView(
      value: mine,
      onRetry: () => ref.invalidate(mySubmissionProvider(post.id)),
      skeleton: const SizedBox(height: Sizes.rukiMd, child: SkeletonList(itemCount: 2)),
      data: (submission) => _Content(post: post, course: course, submission: submission),
    );

    if (flat) return content;
    return Card(
      child: Padding(padding: const EdgeInsets.all(Space.lg), child: content),
    );
  }
}

class _Content extends ConsumerWidget {
  const _Content({required this.post, required this.course, required this.submission});

  final Post post;
  final Course course;
  final Submission submission;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final actions = ref.read(submissionActionsProvider);
    final turnedIn = submission.status == 'turned_in';
    final editable = !turnedIn && !course.isArchived;
    final isQuiz = post.type == PostType.quiz;

    Future<void> run(Future<void> Function() action) async {
      try {
        await action();
      } on ApiException catch (e) {
        if (context.mounted) showMessage(context, e.message);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: Text(S.yourWork, style: theme.textTheme.titleLarge)),
            StatusChip(status: submission.displayStatus, isLate: submission.isLate),
          ],
        ),
        if (submission.grade != null && post.points != null) ...[
          const SizedBox(height: Space.md),
          _CountUpGrade(grade: submission.grade!, points: post.points!),
        ],
        if (submission.turnedInAt != null && turnedIn) ...[
          const SizedBox(height: Space.sm),
          Text(S.turnedInAt(formatWib(submission.turnedInAt!, 'd MMM, HH.mm')), style: theme.textTheme.labelMedium),
        ],
        if (submission.attachments.isNotEmpty) ...[
          const SizedBox(height: Space.md),
          for (final a in submission.attachments)
            Padding(
              padding: const EdgeInsets.only(bottom: Space.sm),
              child: AttachmentTile(
                attachment: a,
                onRemove: editable ? () => run(() => actions.removeAttachment(post.id, a.id)) : null,
              ),
            ),
        ],
        const SizedBox(height: Space.lg),
        if (isQuiz)
          submission.displayStatus == DisplayStatus.assigned || submission.displayStatus == DisplayStatus.missing
              ? FilledButton.icon(
                  onPressed: course.isArchived ? null : () => context.push('/p/${post.id}/quiz'),
                  style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(Sizes.touchTarget)),
                  icon: const Icon(Symbols.quiz),
                  label: const Text(S.startQuiz),
                )
              : OutlinedButton(onPressed: () => context.push('/p/${post.id}/quiz'), child: const Text(S.reviewQuiz))
        else if (post.type == PostType.question)
          QuestionAnswerForm(
            key: ValueKey('question-${submission.status}'),
            post: post,
            course: course,
            submission: submission,
          )
        else ...[
          AddAttachmentMenu(
            label: S.addOrCreate,
            enabled: editable,
            onFiles: (files) async {
              for (final f in files) {
                await run(() => actions.addFile(post.id, f));
              }
            },
            onLink: (url) => run(() => actions.addLink(post.id, url)),
          ),
          const SizedBox(height: Space.sm),
          if (turnedIn)
            OutlinedButton(
              onPressed: course.isArchived ? null : () => run(() => actions.unsubmit(post.id)),
              style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(Sizes.touchTarget)),
              child: const Text(S.unsubmit),
            )
          else
            TurnInButton(
              label: submission.attachments.isEmpty ? S.markAsDone : S.turnIn,
              successMessage: S.turnedInCheer,
              onPressed: course.isArchived ? null : () => actions.turnIn(post.id),
            ),
        ],
        const Divider(height: Space.xxl),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Symbols.person),
          title: const Text(S.privateComments),
          trailing: (submission.privateCommentCount ?? 0) > 0 ? Text('${submission.privateCommentCount}') : null,
          onTap: () => context.push('/p/${post.id}/private'),
        ),
      ],
    );
  }
}

/// Nilai menghitung naik dari 0 selama motion.long saat pertama tampil.
class _CountUpGrade extends StatelessWidget {
  const _CountUpGrade({required this.grade, required this.points});

  final double grade;
  final int points;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.headlineMedium?.copyWith(color: Theme.of(context).colorScheme.primary);
    final label = S.gradeOutOf(formatGrade(grade), points);
    if (context.reduceMotion) return Text(label, style: style);

    return Semantics(
      label: label,
      child: ExcludeSemantics(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: grade),
          duration: Motion.long,
          curve: Motion.enter,
          // Angka bulat selama berjalan; nilai persis (mis. 87,5) di akhir.
          builder: (context, value, _) =>
              Text(S.gradeOutOf(formatGrade(value >= grade ? grade : value.roundToDouble()), points), style: style),
        ),
      ),
    );
  }
}
