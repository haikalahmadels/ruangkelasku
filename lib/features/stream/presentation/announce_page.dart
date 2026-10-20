import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/copy/strings.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/utils/pick_datetime.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/widgets/form_widgets.dart';
import '../../courses/application/courses.dart';
import '../application/stream.dart';

/// Layar 20: Tulis pengumuman, langsung atau terjadwal (alur inti 5).
class AnnouncePage extends ConsumerStatefulWidget {
  const AnnouncePage({super.key, required this.courseId});

  final int courseId;

  @override
  ConsumerState<AnnouncePage> createState() => _AnnouncePageState();
}

class _AnnouncePageState extends ConsumerState<AnnouncePage> {
  final _body = TextEditingController();

  /// Jadwal dalam UTC; dipilih pengguna dalam WIB.
  DateTime? _scheduledAt;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _body.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _body.dispose();
    super.dispose();
  }

  Future<void> _pickSchedule() async {
    final picked = await pickWibDateTime(context, initialUtc: _scheduledAt);
    if (picked != null) setState(() => _scheduledAt = picked);
  }

  Future<void> _submit() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await ref
          .read(streamActionsProvider)
          .announce(widget.courseId, body: _body.text.trim(), scheduledAt: _scheduledAt);
      if (!mounted) return;
      showMessage(context, _scheduledAt == null ? S.announcementPosted : S.announcementScheduled);
      context.pop();
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.fieldError('scheduled_at') ?? e.fieldError('body') ?? e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _close() async {
    if (_body.text.trim().isEmpty) {
      context.pop();
      return;
    }
    final discard = await showConfirmDialog(
      context,
      title: S.discardTitle,
      body: S.discardBody,
      confirmLabel: S.discard,
      destructive: true,
    );
    if (discard && mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final course = ref.watch(courseProvider(widget.courseId)).value;
    final canSubmit = _body.text.trim().isNotEmpty && !_loading;

    return PopScope(
      canPop: _body.text.trim().isEmpty,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _close();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(tooltip: S.close, icon: const Icon(Symbols.close), onPressed: _close),
          title: const Text(S.shareWithClass),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: Space.sm),
              child: FilledButton(
                onPressed: canSubmit ? _submit : null,
                child: Text(_scheduledAt == null ? S.post : S.schedule),
              ),
            ),
          ],
        ),
        body: FormBody(
          children: [
            TextField(
              controller: _body,
              autofocus: true,
              minLines: 5,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(labelText: S.announceHint, alignLabelWithHint: true, errorText: _error),
            ),
            if (course?.isTeacher ?? false) ...[
              const SizedBox(height: Space.lg),
              if (_scheduledAt == null)
                OutlinedButton.icon(
                  onPressed: _pickSchedule,
                  icon: const Icon(Symbols.schedule),
                  label: const Text(S.schedule),
                )
              else
                InputChip(
                  avatar: const Icon(Symbols.schedule),
                  label: Text('${S.scheduledFor} ${formatWib(_scheduledAt!, 'EEEE, d MMM, HH.mm')} WIB'),
                  onPressed: _pickSchedule,
                  onDeleted: () => setState(() => _scheduledAt = null),
                  deleteButtonTooltipMessage: S.removeSchedule,
                ),
            ],
          ],
        ),
      ),
    );
  }
}
