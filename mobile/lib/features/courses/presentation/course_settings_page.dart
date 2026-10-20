import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/copy/strings.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/async_view.dart';
import '../../../core/widgets/class_code_display.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/widgets/form_widgets.dart';
import '../application/courses.dart';
import '../data/course.dart';
import 'join_create_pages.dart';

/// Layar 17: Setelan kelas (guru). Detail kelas dan tema, kode undangan, izin Forum,
/// dan tampilan Tugas Kelas di Forum. Perubahan dikirim sekaligus lewat "Simpan".
class CourseSettingsPage extends ConsumerWidget {
  const CourseSettingsPage({super.key, required this.courseId});

  final int courseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final course = ref.watch(courseProvider(courseId));
    if (course.hasValue) return _SettingsForm(course: course.requireValue);

    return Scaffold(
      appBar: AppBar(title: const Text(S.classSettings)),
      body: course.hasError
          ? ErrorView(error: course.error!, onRetry: () => ref.invalidate(courseProvider(courseId)))
          : const SkeletonList(),
    );
  }
}

class _SettingsForm extends ConsumerStatefulWidget {
  const _SettingsForm({required this.course});

  final Course course;

  @override
  ConsumerState<_SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends ConsumerState<_SettingsForm> {
  late final _name = TextEditingController(text: widget.course.name);
  late final _description = TextEditingController(text: widget.course.description ?? '');
  late final _section = TextEditingController(text: widget.course.section ?? '');
  late final _room = TextEditingController(text: widget.course.room ?? '');
  late final _subject = TextEditingController(text: widget.course.subject ?? '');
  late String _theme = widget.course.theme;
  late bool _codeEnabled = widget.course.codeEnabled;
  late String _streamPermission = widget.course.streamPermission;
  late String _classworkOnStream = widget.course.classworkOnStream;
  bool _saving = false;
  ApiException? _error;

  @override
  void initState() {
    super.initState();
    for (final c in _controllers) {
      c.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  List<TextEditingController> get _controllers => [_name, _description, _section, _room, _subject];

  /// Hanya field yang berubah yang dikirim ke PATCH /courses/{course}.
  Map<String, dynamic> get _changes {
    final c = widget.course;
    String? text(TextEditingController t) => t.text.trim().isEmpty ? null : t.text.trim();
    return {
      if (_name.text.trim() != c.name) 'name': _name.text.trim(),
      if (text(_description) != c.description) 'description': text(_description),
      if (text(_section) != c.section) 'section': text(_section),
      if (text(_room) != c.room) 'room': text(_room),
      if (text(_subject) != c.subject) 'subject': text(_subject),
      if (_theme != c.theme) 'theme': _theme,
      if (_codeEnabled != c.codeEnabled) 'code_enabled': _codeEnabled,
      if (_streamPermission != c.streamPermission) 'stream_permission': _streamPermission,
      if (_classworkOnStream != c.classworkOnStream) 'classwork_on_stream': _classworkOnStream,
    };
  }

  void _leave() => context.canPop() ? context.pop() : context.go('/c/${widget.course.id}/stream');

  Future<void> _close() async {
    if (_changes.isEmpty) {
      _leave();
      return;
    }
    final discard = await showConfirmDialog(
      context,
      title: S.discardTitle,
      body: S.discardBody,
      confirmLabel: S.discard,
      destructive: true,
    );
    if (discard && mounted) _leave();
  }

  Future<void> _save() async {
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref.read(courseActionsProvider).update(widget.course.id, _changes);
      if (!mounted) return;
      showMessage(context, S.settingsSaved);
      _leave();
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _error = e);
      if (!e.isValidation) showMessage(context, e.message);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _resetCode() async {
    final ok = await showConfirmDialog(
      context,
      title: S.resetCodeTitle,
      body: S.resetCodeBody,
      confirmLabel: S.resetCode,
    );
    if (!ok) return;
    try {
      await ref.read(courseActionsProvider).resetCode(widget.course.id);
      if (mounted) showMessage(context, S.codeReset);
    } on ApiException catch (e) {
      if (mounted) showMessage(context, e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Kode baru setelah reset datang lewat provider, bukan dari salinan awal form.
    final code = ref.watch(courseProvider(widget.course.id)).value?.code ?? widget.course.code;
    final editable = !widget.course.isArchived;
    final canSave = editable && !_saving && _changes.isNotEmpty && _name.text.trim().isNotEmpty;

    Widget heading(String text) => Padding(
      padding: const EdgeInsets.only(top: Space.xl, bottom: Space.md),
      child: Semantics(header: true, child: Text(text, style: theme.textTheme.titleLarge)),
    );

    Widget field(TextEditingController controller, String label, String key, {int maxLines = 1}) => Padding(
      padding: const EdgeInsets.only(bottom: Space.lg),
      child: TextField(
        controller: controller,
        enabled: editable,
        minLines: 1,
        maxLines: maxLines,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(labelText: label, errorText: _error?.fieldError(key)),
      ),
    );

    return PopScope(
      canPop: _changes.isEmpty,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _close();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(tooltip: S.close, icon: const Icon(Symbols.close), onPressed: _close),
          title: const Text(S.classSettings),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: Space.sm),
              child: FilledButton(onPressed: canSave ? _save : null, child: const Text(S.save)),
            ),
          ],
        ),
        body: FormBody(
          children: [
            if (!editable)
              const Card.filled(
                child: ListTile(leading: Icon(Symbols.archive), title: Text(S.archivedBanner)),
              ),
            heading(S.classDetails),
            field(_name, S.className, 'name'),
            field(_description, S.classDescription, 'description', maxLines: 4),
            field(_section, S.section, 'section'),
            field(_room, S.room, 'room'),
            field(_subject, S.subject, 'subject'),
            Text(S.theme, style: theme.textTheme.titleMedium),
            const SizedBox(height: Space.sm),
            IgnorePointer(
              ignoring: !editable,
              child: ThemePicker(selected: _theme, onChanged: (key) => setState(() => _theme = key)),
            ),

            heading(S.general),
            Text(S.inviteCode, style: theme.textTheme.titleMedium),
            const SizedBox(height: Space.sm),
            if (code != null)
              Wrap(
                spacing: Space.sm,
                runSpacing: Space.sm,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(code, style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.primary)),
                  TextButton.icon(
                    onPressed: () => showClassCodeDialog(context, code: code, className: widget.course.name),
                    icon: const Icon(Symbols.fullscreen),
                    label: const Text(S.showClassCode),
                  ),
                  TextButton.icon(
                    onPressed: editable ? _resetCode : null,
                    icon: const Icon(Symbols.refresh),
                    label: const Text(S.resetCode),
                  ),
                ],
              ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(S.codeEnabled),
              subtitle: const Text(S.codeEnabledHelp),
              value: _codeEnabled,
              onChanged: editable ? (value) => setState(() => _codeEnabled = value) : null,
            ),
            const SizedBox(height: Space.lg),
            _OptionMenu(
              label: S.streamPermission,
              options: S.streamPermissions,
              value: _streamPermission,
              enabled: editable,
              onChanged: (value) => setState(() => _streamPermission = value),
            ),
            const SizedBox(height: Space.lg),
            _OptionMenu(
              label: S.classworkOnStream,
              options: S.classworkOnStreamOptions,
              value: _classworkOnStream,
              enabled: editable,
              onChanged: (value) => setState(() => _classworkOnStream = value),
            ),
          ],
        ),
      ),
    );
  }
}

/// Pilihan berlabel seperti menu tarik-turun di setelan Google Classroom.
class _OptionMenu extends StatelessWidget {
  const _OptionMenu({
    required this.label,
    required this.options,
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  final String label;
  final Map<String, String> options;
  final String value;
  final bool enabled;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      initialSelection: value,
      enabled: enabled,
      label: Text(label),
      expandedInsets: EdgeInsets.zero,
      requestFocusOnTap: false,
      onSelected: (selected) {
        if (selected != null) onChanged(selected);
      },
      dropdownMenuEntries: [
        for (final MapEntry(:key, value: text) in options.entries) DropdownMenuEntry(value: key, label: text),
      ],
    );
  }
}
