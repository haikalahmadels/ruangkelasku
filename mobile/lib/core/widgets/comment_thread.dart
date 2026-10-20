import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

import '../copy/strings.dart';
import '../layout/breakpoints.dart';
import '../models/comment.dart';
import '../network/api_exception.dart';
import '../theme/tokens.dart';
import '../utils/format.dart';
import 'form_widgets.dart';
import 'user_avatar.dart';

/// Daftar komentar + kolom input satu baris yang membesar.
/// Komentar baru meluncur masuk; Ctrl+Enter mengirim di web.
class CommentThread extends StatefulWidget {
  const CommentThread({
    super.key,
    required this.comments,
    required this.onSend,
    required this.hint,
    this.enabled = true,
  });

  final List<Comment> comments;
  final Future<void> Function(String body) onSend;
  final String hint;
  final bool enabled;

  @override
  State<CommentThread> createState() => _CommentThreadState();
}

class _CommentThreadState extends State<CommentThread> {
  final _controller = TextEditingController();
  late final Set<int> _seen = {for (final c in widget.comments) c.id};
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final body = _controller.text.trim();
    if (body.isEmpty || _sending) return;
    setState(() => _sending = true);
    try {
      await widget.onSend(body);
      _controller.clear();
    } on ApiException catch (e) {
      if (mounted) showMessage(context, e.message);
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final animate = !context.reduceMotion;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.comments.isEmpty)
          Text(S.noComments, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        for (final comment in widget.comments)
          Builder(
            builder: (context) {
              final isNew = _seen.add(comment.id);
              final tile = _CommentTile(comment: comment);
              return isNew && animate
                  ? tile
                        .animate()
                        .fadeIn(duration: Motion.medium)
                        .moveY(begin: Motion.enterOffset, end: 0, duration: Motion.medium, curve: Motion.enter)
                  : tile;
            },
          ),
        if (widget.enabled) ...[
          const SizedBox(height: Space.md),
          CallbackShortcuts(
            bindings: {const SingleActivator(LogicalKeyboardKey.enter, control: true): _send},
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    minLines: 1,
                    maxLines: 5,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(labelText: widget.hint),
                  ),
                ),
                const SizedBox(width: Space.sm),
                IconButton.filledTonal(
                  tooltip: S.send,
                  onPressed: _controller.text.trim().isEmpty || _sending ? null : _send,
                  icon: _sending
                      ? const SizedBox.square(
                          dimension: Sizes.iconInChip,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Symbols.send),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _CommentTile extends StatelessWidget {
  const _CommentTile({required this.comment});

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final author = comment.author;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Space.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserAvatar(name: author?.name ?? '', url: author?.avatarUrl, size: Sizes.avatarSm),
          const SizedBox(width: Space.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: Space.sm,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(author?.name ?? '', style: theme.textTheme.labelLarge),
                    if (comment.createdAt != null)
                      Text(
                        formatRelative(comment.createdAt!),
                        style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                      ),
                  ],
                ),
                Text(comment.body, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
