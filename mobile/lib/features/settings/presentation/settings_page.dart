import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/global_scaffold.dart';
import '../../../core/copy/strings.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/uploads.dart';
import '../../../core/widgets/form_widgets.dart';
import '../../../core/widgets/user_avatar.dart';
import '../../auth/application/session.dart';
import '../../auth/data/user.dart';
import '../application/theme_mode.dart';

/// Layar 11: Profil (nama, foto) dan setelan perangkat (mode terang/gelap).
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(sessionProvider).value;
    return GlobalScaffold(
      location: '/settings',
      title: const Text(S.navSettings),
      body: user == null ? const SizedBox.shrink() : _SettingsBody(user: user),
    );
  }
}

class _SettingsBody extends ConsumerStatefulWidget {
  const _SettingsBody({required this.user});

  final User user;

  @override
  ConsumerState<_SettingsBody> createState() => _SettingsBodyState();
}

class _SettingsBodyState extends ConsumerState<_SettingsBody> {
  late final _name = TextEditingController(text: widget.user.name);
  bool _savingName = false;
  bool _uploading = false;
  ApiException? _error;

  @override
  void initState() {
    super.initState();
    _name.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _saveName() async {
    setState(() {
      _savingName = true;
      _error = null;
    });
    try {
      await ref.read(sessionProvider.notifier).updateName(_name.text.trim());
      if (mounted) showMessage(context, S.profileSaved);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _error = e);
      if (!e.isValidation) showMessage(context, e.message);
    } finally {
      if (mounted) setState(() => _savingName = false);
    }
  }

  Future<void> _changePhoto() async {
    final photo = await pickAvatar();
    if (photo == null || !mounted) return;
    if (photo.size > maxAvatarBytes) {
      showMessage(context, S.photoTooLarge);
      return;
    }
    setState(() => _uploading = true);
    try {
      await ref.read(sessionProvider.notifier).updateAvatar(photo);
      if (mounted) showMessage(context, S.photoUpdated);
    } on ApiException catch (e) {
      if (mounted) showMessage(context, e.fieldError('avatar') ?? e.message);
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = widget.user;
    final themeMode = ref.watch(themeModeSettingProvider).value ?? ThemeMode.system;
    final nameChanged = _name.text.trim().isNotEmpty && _name.text.trim() != user.name;

    Widget heading(String text) => Padding(
      padding: const EdgeInsets.only(bottom: Space.md),
      child: Semantics(header: true, child: Text(text, style: theme.textTheme.titleLarge)),
    );

    return FormBody(
      children: [
        heading(S.profile),
        Wrap(
          spacing: Space.lg,
          runSpacing: Space.md,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            UserAvatar(name: user.name, url: user.avatarUrl, size: Sizes.avatarLg),
            OutlinedButton.icon(
              onPressed: _uploading ? null : _changePhoto,
              icon: _uploading
                  ? const SizedBox.square(dimension: Sizes.iconInChip, child: CircularProgressIndicator())
                  : const Icon(Symbols.photo_camera),
              label: const Text(S.changePhoto),
            ),
          ],
        ),
        const SizedBox(height: Space.xl),
        TextField(
          controller: _name,
          textCapitalization: TextCapitalization.words,
          autofillHints: const [AutofillHints.name],
          decoration: InputDecoration(labelText: S.name, errorText: _error?.fieldError('name')),
          onSubmitted: (_) {
            if (nameChanged && !_savingName) _saveName();
          },
        ),
        const SizedBox(height: Space.sm),
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton(onPressed: nameChanged && !_savingName ? _saveName : null, child: const Text(S.save)),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Symbols.mail),
          title: const Text(S.email),
          subtitle: Text(user.email),
        ),
        const Divider(height: Space.xxl),
        heading(S.appearance),
        SegmentedButton<ThemeMode>(
          segments: const [
            ButtonSegment(value: ThemeMode.system, label: Text(S.themeSystem), icon: Icon(Symbols.brightness_auto)),
            ButtonSegment(value: ThemeMode.light, label: Text(S.themeLight), icon: Icon(Symbols.light_mode)),
            ButtonSegment(value: ThemeMode.dark, label: Text(S.themeDark), icon: Icon(Symbols.dark_mode)),
          ],
          selected: {themeMode},
          onSelectionChanged: (s) => ref.read(themeModeSettingProvider.notifier).set(s.single),
        ),
        const Divider(height: Space.xxl),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () => ref.read(sessionProvider.notifier).logout(),
            icon: const Icon(Symbols.logout),
            label: const Text(S.signOut),
          ),
        ),
      ],
    );
  }
}
