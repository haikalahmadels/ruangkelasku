import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/copy/strings.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/theme/course_themes.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/course_banner.dart';
import '../../../core/widgets/form_widgets.dart';
import '../../../core/widgets/user_avatar.dart';
import '../../auth/application/session.dart';
import '../application/courses.dart';
import 'home_page.dart';

/// Layar 5: Gabung ke kelas.
class JoinCoursePage extends ConsumerStatefulWidget {
  const JoinCoursePage({super.key});

  @override
  ConsumerState<JoinCoursePage> createState() => _JoinCoursePageState();
}

class _JoinCoursePageState extends ConsumerState<JoinCoursePage> {
  final _code = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _code.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  Future<void> _join() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final course = await ref.read(courseActionsProvider).join(_code.text.trim());
      if (mounted) await showJoinedDialog(context, course);
    } on ApiException catch (e) {
      // 404 dan kode 409 (dinonaktifkan, diarsipkan, sudah anggota) tampil di bawah kolom kode.
      if (mounted) setState(() => _error = e.fieldError('code') ?? e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(sessionProvider).value;
    final textTheme = Theme.of(context).textTheme;
    final canJoin = _code.text.trim().length >= 5 && !_loading;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(tooltip: S.close, icon: const Icon(Symbols.close), onPressed: () => context.pop()),
        title: const Text(S.joinClass),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: Space.sm),
            child: FilledButton(onPressed: canJoin ? _join : null, child: const Text(S.join)),
          ),
        ],
      ),
      body: FormBody(
        children: [
          if (user != null)
            Card.outlined(
              child: Padding(
                padding: const EdgeInsets.all(Space.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(S.signedInAs, style: textTheme.bodyMedium),
                    const SizedBox(height: Space.md),
                    Row(
                      children: [
                        UserAvatar(name: user.name, url: user.avatarUrl),
                        const SizedBox(width: Space.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(user.name, style: textTheme.titleMedium),
                              Text(user.email, style: textTheme.bodyMedium),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: Space.lg),
          Card.outlined(
            child: Padding(
              padding: const EdgeInsets.all(Space.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(S.classCode, style: textTheme.titleMedium),
                  const SizedBox(height: Space.xs),
                  Text(S.classCodeHelp, style: textTheme.bodyMedium),
                  const SizedBox(height: Space.lg),
                  TextField(
                    controller: _code,
                    autofocus: true,
                    textInputAction: TextInputAction.go,
                    onSubmitted: (_) => canJoin ? _join() : null,
                    decoration: InputDecoration(labelText: S.classCode, errorText: _error),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: Space.lg),
          Text(S.classCodeRules, style: textTheme.bodyMedium),
        ],
      ),
    );
  }
}

/// Layar 6: Buat kelas, dengan pratinjau dan pilihan tema.
class CreateCoursePage extends ConsumerStatefulWidget {
  const CreateCoursePage({super.key});

  @override
  ConsumerState<CreateCoursePage> createState() => _CreateCoursePageState();
}

class _CreateCoursePageState extends ConsumerState<CreateCoursePage> {
  final _name = TextEditingController();
  final _section = TextEditingController();
  final _subject = TextEditingController();
  final _room = TextEditingController();
  String _theme = CourseTheme.all.first.key;
  bool _loading = false;
  ApiException? _error;

  @override
  void initState() {
    super.initState();
    _name.addListener(() => setState(() {}));
    _section.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    for (final c in [_name, _section, _subject, _room]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _create() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    String? nullIfEmpty(TextEditingController c) => c.text.trim().isEmpty ? null : c.text.trim();
    try {
      final course = await ref.read(courseActionsProvider).create({
        'name': _name.text.trim(),
        'section': nullIfEmpty(_section),
        'subject': nullIfEmpty(_subject),
        'room': nullIfEmpty(_room),
        'theme': _theme,
      });
      if (mounted) context.go('/c/${course.id}/stream');
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _error = e);
      if (!e.isValidation) showMessage(context, e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onHeader = CourseTheme.of(_theme).onHeader;
    final canCreate = _name.text.trim().isNotEmpty && !_loading;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(tooltip: S.close, icon: const Icon(Symbols.close), onPressed: () => context.pop()),
        title: const Text(S.createClass),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: Space.sm),
            child: FilledButton(onPressed: canCreate ? _create : null, child: const Text(S.create)),
          ),
        ],
      ),
      body: FormBody(
        children: [
          CourseBanner(
            themeKey: _theme,
            borderRadius: Radii.lgAll,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: Sizes.courseCardHeader),
              child: Padding(
                padding: const EdgeInsets.all(Space.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _name.text.trim().isEmpty ? S.className : _name.text,
                      style: theme.textTheme.titleLarge?.copyWith(color: onHeader),
                    ),
                    if (_section.text.trim().isNotEmpty)
                      Text(_section.text, style: theme.textTheme.bodyMedium?.copyWith(color: onHeader)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: Space.xl),
          TextField(
            controller: _name,
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(labelText: S.className, errorText: _error?.fieldError('name')),
          ),
          const SizedBox(height: Space.lg),
          TextField(
            controller: _section,
            decoration: const InputDecoration(labelText: S.section),
          ),
          const SizedBox(height: Space.lg),
          TextField(
            controller: _subject,
            decoration: const InputDecoration(labelText: S.subject),
          ),
          const SizedBox(height: Space.lg),
          TextField(
            controller: _room,
            decoration: const InputDecoration(labelText: S.room),
          ),
          const SizedBox(height: Space.xl),
          Text(S.theme, style: theme.textTheme.titleMedium),
          const SizedBox(height: Space.sm),
          ThemePicker(selected: _theme, onChanged: (key) => setState(() => _theme = key)),
        ],
      ),
    );
  }
}

/// Delapan swatch tema, masing-masing target sentuh 48 dp dengan label untuk pembaca layar.
class ThemePicker extends StatelessWidget {
  const ThemePicker({super.key, required this.selected, required this.onChanged});

  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final ring = Theme.of(context).colorScheme.primary;

    return Wrap(
      spacing: Space.sm,
      runSpacing: Space.sm,
      children: [
        for (final t in CourseTheme.all)
          Semantics(
            label: S.themeNames[t.key],
            selected: t.key == selected,
            button: true,
            child: Tooltip(
              message: S.themeNames[t.key]!,
              child: InkResponse(
                onTap: () => onChanged(t.key),
                radius: Sizes.touchTarget / 2,
                child: AnimatedContainer(
                  duration: Motion.short,
                  width: Sizes.touchTarget,
                  height: Sizes.touchTarget,
                  decoration: BoxDecoration(
                    color: t.headerFor(brightness),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: t.key == selected ? ring : ring.withValues(alpha: 0),
                      width: Sizes.focusRingWidth * 2,
                    ),
                  ),
                  child: t.key == selected ? Icon(Symbols.check, color: t.onHeader) : null,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
