import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/copy/strings.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/form_widgets.dart';
import '../application/session.dart';

/// Layar 2: Masuk.
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;
  ApiException? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await ref.read(sessionProvider.notifier).login(email: _email.text.trim(), password: _password.text);
      TextInput.finishAutofillContext();
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(S.signIn),
        leading: BackButton(onPressed: () => context.go('/welcome')),
      ),
      body: Form(
        key: _formKey,
        child: AutofillGroup(
          child: FormBody(
            children: [
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email, AutofillHints.username],
                textInputAction: TextInputAction.next,
                validator: _validateEmail,
                decoration: InputDecoration(labelText: S.email, errorText: _error?.fieldError('email')),
              ),
              const SizedBox(height: Space.lg),
              PasswordField(
                controller: _password,
                label: S.password,
                autofillHints: const [AutofillHints.password],
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _submit(),
                validator: (v) => (v == null || v.isEmpty) ? S.required : null,
                errorText: _error?.fieldError('password'),
              ),
              const SizedBox(height: Space.xl),
              SubmitButton(label: S.signIn, loading: _loading, onPressed: _submit),
              const SizedBox(height: Space.md),
              _SwitchLink(prompt: S.noAccount, action: S.signUp, onPressed: () => context.go('/register')),
            ],
          ),
        ),
      ),
    );
  }
}

/// Layar 3: Buat akun.
class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _loading = false;
  ApiException? _error;

  @override
  void dispose() {
    for (final c in [_name, _email, _password, _confirm]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await ref
          .read(sessionProvider.notifier)
          .register(
            name: _name.text.trim(),
            email: _email.text.trim(),
            password: _password.text,
            passwordConfirmation: _confirm.text,
          );
      TextInput.finishAutofillContext();
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(S.signUp),
        leading: BackButton(onPressed: () => context.go('/welcome')),
      ),
      body: Form(
        key: _formKey,
        child: AutofillGroup(
          child: FormBody(
            children: [
              TextFormField(
                controller: _name,
                textCapitalization: TextCapitalization.words,
                autofillHints: const [AutofillHints.name],
                textInputAction: TextInputAction.next,
                validator: (v) => (v == null || v.trim().isEmpty) ? S.required : null,
                decoration: InputDecoration(labelText: S.name, errorText: _error?.fieldError('name')),
              ),
              const SizedBox(height: Space.lg),
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                textInputAction: TextInputAction.next,
                validator: _validateEmail,
                decoration: InputDecoration(labelText: S.email, errorText: _error?.fieldError('email')),
              ),
              const SizedBox(height: Space.lg),
              PasswordField(
                controller: _password,
                label: S.password,
                helperText: S.passwordHint,
                autofillHints: const [AutofillHints.newPassword],
                textInputAction: TextInputAction.next,
                validator: (v) => (v == null || v.length < 8) ? S.passwordHint : null,
                errorText: _error?.fieldError('password'),
              ),
              const SizedBox(height: Space.lg),
              PasswordField(
                controller: _confirm,
                label: S.passwordConfirm,
                autofillHints: const [AutofillHints.newPassword],
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _submit(),
                validator: (v) => v != _password.text ? S.passwordMismatch : null,
              ),
              const SizedBox(height: Space.xl),
              SubmitButton(label: S.signUp, loading: _loading, onPressed: _submit),
              const SizedBox(height: Space.md),
              _SwitchLink(prompt: S.haveAccount, action: S.signIn, onPressed: () => context.go('/login')),
            ],
          ),
        ),
      ),
    );
  }
}

String? _validateEmail(String? value) {
  final v = value?.trim() ?? '';
  if (v.isEmpty) return S.required;
  if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v)) return S.invalidEmail;
  return null;
}

class _SwitchLink extends StatelessWidget {
  const _SwitchLink({required this.prompt, required this.action, required this.onPressed});

  final String prompt;
  final String action;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(prompt),
        TextButton(onPressed: onPressed, child: Text(action)),
      ],
    );
  }
}
