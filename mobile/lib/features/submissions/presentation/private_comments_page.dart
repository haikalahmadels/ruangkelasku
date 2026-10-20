import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/copy/strings.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/async_view.dart';
import '../../../core/widgets/comment_thread.dart';
import '../application/submissions.dart';

/// Layar 27: Komentar pribadi siswa dengan guru untuk satu tugas.
class PrivateCommentsPage extends ConsumerWidget {
  const PrivateCommentsPage({super.key, required this.postId});

  final int postId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mine = ref.watch(mySubmissionProvider(postId));

    return Scaffold(
      appBar: AppBar(title: const Text(S.privateComments)),
      body: AsyncView(
        value: mine,
        onRetry: () => ref.invalidate(mySubmissionProvider(postId)),
        data: (submission) {
          final comments = ref.watch(privateCommentsProvider(submission.id));
          return Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: Sizes.formMaxWidth + Space.xxl * 4),
              child: ListView(
                padding: const EdgeInsets.all(Space.lg),
                children: [
                  AsyncView(
                    value: comments,
                    onRetry: () => ref.invalidate(privateCommentsProvider(submission.id)),
                    data: (list) => CommentThread(
                      comments: list,
                      hint: S.addPrivateComment,
                      onSend: (body) => ref.read(submissionActionsProvider).addPrivateComment(submission.id, body),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
