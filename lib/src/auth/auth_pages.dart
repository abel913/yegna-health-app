import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import 'auth_controller.dart';
import 'auth_models.dart';
import 'auth_validation.dart';

enum AuthPageMode {
  signIn,
  register,
  recover,
  verificationPending,
  newPassword,
  passwordUpdated,
}

class AuthPage extends StatefulWidget {
  const AuthPage({
    required this.controller,
    this.initialMode = AuthPageMode.signIn,
    super.key,
  });

  final AuthController controller;
  final AuthPageMode initialMode;

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmation = TextEditingController();
  final _displayName = TextEditingController();
  late AuthPageMode _mode = widget.initialMode;
  bool _recoverySent = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onAuthChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onAuthChanged);
    _email.dispose();
    _password.dispose();
    _confirmation.dispose();
    _displayName.dispose();
    super.dispose();
  }

  void _onAuthChanged() {
    if (!mounted) return;
    if (widget.controller.recoveryRequested &&
        _mode != AuthPageMode.newPassword &&
        _mode != AuthPageMode.passwordUpdated) {
      setState(() => _mode = AuthPageMode.newPassword);
    } else {
      setState(() {});
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    switch (_mode) {
      case AuthPageMode.signIn:
        final success = await widget.controller.signIn(
          email: _email.text,
          password: _password.text,
        );
        if (success && mounted) {
          Navigator.of(context).pop();
        }
        return;
      case AuthPageMode.register:
        final outcome = await widget.controller.register(
          email: _email.text,
          password: _password.text,
          confirmation: _confirmation.text,
          displayName: _displayName.text,
        );
        if (!mounted) return;
        if (outcome == RegistrationOutcome.verificationPending) {
          setState(() => _mode = AuthPageMode.verificationPending);
        } else if (outcome == RegistrationOutcome.signedIn) {
          Navigator.of(context).pop();
        }
        return;
      case AuthPageMode.recover:
        final success =
            await widget.controller.requestPasswordRecovery(_email.text);
        if (success && mounted) setState(() => _recoverySent = true);
        return;
      case AuthPageMode.newPassword:
        final success = await widget.controller.completePasswordRecovery(
          password: _password.text,
          confirmation: _confirmation.text,
        );
        if (success && mounted) {
          setState(() => _mode = AuthPageMode.passwordUpdated);
        }
        return;
      case AuthPageMode.verificationPending:
      case AuthPageMode.passwordUpdated:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.accountTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            if (!widget.controller.isConfigured) ...[
              _Notice(icon: Icons.info_outline, text: l10n.authConfigMissing),
              const SizedBox(height: 16),
              Text(l10n.guestAccessDescription),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.continueAsGuest),
              ),
            ] else ...[
              if (_mode == AuthPageMode.verificationPending)
                _verificationPending(l10n)
              else if (_mode == AuthPageMode.passwordUpdated)
                _passwordUpdated(l10n)
              else if (_mode == AuthPageMode.recover && _recoverySent)
                _recoverySentView(l10n)
              else
                _form(l10n),
              if (widget.controller.issue != null) ...[
                const SizedBox(height: 16),
                _Notice(
                  icon: Icons.error_outline,
                  text: _issueText(l10n, widget.controller.issue!),
                  isError: true,
                ),
              ],
              const SizedBox(height: 20),
              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.continueAsGuest),
              ),
              const SizedBox(height: 8),
              Text(l10n.guestAccessDescription,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall),
            ],
          ],
        ),
      ),
    );
  }

  Widget _form(AppLocalizations l10n) {
    final isRegister = _mode == AuthPageMode.register;
    final isRecovery = _mode == AuthPageMode.recover;
    final isNewPassword = _mode == AuthPageMode.newPassword;
    final title = isRegister
        ? l10n.createAccount
        : isRecovery
            ? l10n.passwordRecoveryTitle
            : isNewPassword
                ? l10n.passwordRecoveryTitle
                : l10n.signIn;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          if (isRecovery) Text(l10n.recoveryInstructions),
          const SizedBox(height: 20),
          if (isRegister)
            _textField(
              controller: _displayName,
              label: l10n.displayNameLabel,
              validator: (value) => _validationText(
                l10n,
                AuthValidation.displayName(value ?? ''),
              ),
              textCapitalization: TextCapitalization.words,
            ),
          if (isRegister) const SizedBox(height: 12),
          if (!isNewPassword)
            _textField(
              controller: _email,
              label: l10n.emailLabel,
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
              validator: (value) =>
                  _validationText(l10n, AuthValidation.email(value ?? '')),
            ),
          if (!isRecovery) ...[
            const SizedBox(height: 12),
            _textField(
              controller: _password,
              label: isNewPassword ? l10n.newPasswordLabel : l10n.passwordLabel,
              obscureText: true,
              autofillHints: isRegister
                  ? const [AutofillHints.newPassword]
                  : const [AutofillHints.password],
              validator: (value) => _validationText(
                l10n,
                isNewPassword || isRegister
                    ? AuthValidation.password(value ?? '')
                    : (value?.isEmpty ?? true)
                        ? AuthIssue.passwordRequired
                        : null,
              ),
            ),
          ],
          if (isRegister || isNewPassword) ...[
            const SizedBox(height: 12),
            _textField(
              controller: _confirmation,
              label: l10n.confirmPasswordLabel,
              obscureText: true,
              autofillHints: const [AutofillHints.newPassword],
              validator: (value) => _validationText(
                l10n,
                AuthValidation.passwordConfirmation(
                    _password.text, value ?? ''),
              ),
            ),
          ],
          if (_mode == AuthPageMode.signIn)
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton(
                onPressed: () => _changeMode(AuthPageMode.recover),
                child: Text(l10n.forgotPassword),
              ),
            ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: widget.controller.isBusy ? null : _submit,
            child: widget.controller.isBusy
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(isRegister
                    ? l10n.registerAction
                    : isRecovery
                        ? l10n.sendRecoveryEmail
                        : isNewPassword
                            ? l10n.updatePassword
                            : l10n.loginAction),
          ),
          if (_mode == AuthPageMode.signIn || isRegister) ...[
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => _changeMode(
                isRegister ? AuthPageMode.signIn : AuthPageMode.register,
              ),
              child: Text(isRegister ? l10n.hasAccount : l10n.noAccount),
            ),
          ],
          if (isRecovery || isNewPassword)
            TextButton(
              onPressed: () => _changeMode(AuthPageMode.signIn),
              child: Text(l10n.signIn),
            ),
        ],
      ),
    );
  }

  Widget _verificationPending(AppLocalizations l10n) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(Icons.mark_email_unread_outlined, size: 56),
          const SizedBox(height: 16),
          Text(l10n.verificationPendingTitle,
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(l10n.verificationPendingBody(
              widget.controller.verificationEmail ?? _email.text.trim())),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => _changeMode(AuthPageMode.signIn),
            child: Text(l10n.signIn),
          ),
        ],
      );

  Widget _recoverySentView(AppLocalizations l10n) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(Icons.mark_email_read_outlined, size: 56),
          const SizedBox(height: 16),
          Text(l10n.recoveryEmailSent),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => _changeMode(AuthPageMode.signIn),
            child: Text(l10n.signIn),
          ),
        ],
      );

  Widget _passwordUpdated(AppLocalizations l10n) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(Icons.check_circle_outline, size: 56),
          const SizedBox(height: 16),
          Text(l10n.passwordUpdatedTitle,
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(l10n.passwordUpdatedBody),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () {
              widget.controller.clearIssue();
              Navigator.of(context).pop();
            },
            child: Text(l10n.signIn),
          ),
        ],
      );

  Widget _textField({
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
    Iterable<String>? autofillHints,
    TextCapitalization textCapitalization = TextCapitalization.none,
    bool obscureText = false,
  }) =>
      TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        keyboardType: keyboardType,
        autofillHints: autofillHints,
        textCapitalization: textCapitalization,
        obscureText: obscureText,
        validator: validator,
        enabled: !widget.controller.isBusy,
      );

  void _changeMode(AuthPageMode mode) {
    widget.controller.clearIssue();
    setState(() {
      _mode = mode;
      _recoverySent = false;
    });
  }

  String? _validationText(AppLocalizations l10n, AuthIssue? issue) =>
      issue == null ? null : _issueText(l10n, issue);

  String _issueText(AppLocalizations l10n, AuthIssue issue) => switch (issue) {
        AuthIssue.configurationMissing => l10n.authConfigMissing,
        AuthIssue.emailRequired => l10n.errorEmailRequired,
        AuthIssue.invalidEmail => l10n.errorInvalidEmail,
        AuthIssue.passwordRequired => l10n.errorPasswordRequired,
        AuthIssue.passwordTooShort => l10n.errorPasswordTooShort,
        AuthIssue.passwordMismatch => l10n.errorPasswordMismatch,
        AuthIssue.displayNameRequired => l10n.errorDisplayNameRequired,
        AuthIssue.displayNameTooLong => l10n.errorDisplayNameTooLong,
        AuthIssue.invalidCredentials => l10n.errorInvalidCredentials,
        AuthIssue.emailNotConfirmed => l10n.errorEmailNotConfirmed,
        AuthIssue.registrationFailed => l10n.errorRegistration,
        AuthIssue.networkUnavailable => l10n.errorNetwork,
        AuthIssue.recoveryExpired => l10n.errorRecoveryExpired,
        AuthIssue.sessionUnavailable => l10n.errorSessionUnavailable,
        AuthIssue.unexpected => l10n.errorUnexpected,
      };
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({required this.controller, super.key});

  final AuthController controller;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _displayName = TextEditingController(
    text: widget.controller.user?.displayName ?? '',
  );
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_refresh);
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    widget.controller.removeListener(_refresh);
    _displayName.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final success =
        await widget.controller.updateDisplayName(_displayName.text);
    if (mounted && success) setState(() => _saved = true);
  }

  Future<void> _signOut() async {
    final success = await widget.controller.signOut();
    if (mounted && success) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final user = widget.controller.user;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.profile)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            if (!widget.controller.isAuthenticated || user == null) ...[
              _Notice(icon: Icons.lock_outline, text: l10n.sessionEnded),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute<void>(
                    builder: (_) => AuthPage(controller: widget.controller),
                  ),
                ),
                child: Text(l10n.signIn),
              ),
            ] else ...[
              Text(user.email, style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 8),
              Text(l10n.profileDescription),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _displayName,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: l10n.displayNameLabel,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    final issue = AuthValidation.displayName(value ?? '');
                    if (issue == AuthIssue.displayNameRequired) {
                      return l10n.errorDisplayNameRequired;
                    }
                    if (issue == AuthIssue.displayNameTooLong) {
                      return l10n.errorDisplayNameTooLong;
                    }
                    return null;
                  },
                ),
              ),
              if (widget.controller.issue != null) ...[
                const SizedBox(height: 12),
                _Notice(
                  icon: Icons.error_outline,
                  text: _issueMessage(l10n, widget.controller.issue!),
                  isError: true,
                ),
              ],
              if (_saved) ...[
                const SizedBox(height: 12),
                _Notice(
                    icon: Icons.check_circle_outline, text: l10n.profileSaved),
              ],
              const SizedBox(height: 16),
              FilledButton(
                onPressed: widget.controller.isBusy ? null : _save,
                child: widget.controller.isBusy
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(l10n.saveProfile),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: widget.controller.isBusy ? null : _signOut,
                icon: const Icon(Icons.logout),
                label: Text(l10n.signOut),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

String _issueMessage(AppLocalizations l10n, AuthIssue issue) => switch (issue) {
      AuthIssue.configurationMissing => l10n.authConfigMissing,
      AuthIssue.emailRequired => l10n.errorEmailRequired,
      AuthIssue.invalidEmail => l10n.errorInvalidEmail,
      AuthIssue.passwordRequired => l10n.errorPasswordRequired,
      AuthIssue.passwordTooShort => l10n.errorPasswordTooShort,
      AuthIssue.passwordMismatch => l10n.errorPasswordMismatch,
      AuthIssue.displayNameRequired => l10n.errorDisplayNameRequired,
      AuthIssue.displayNameTooLong => l10n.errorDisplayNameTooLong,
      AuthIssue.invalidCredentials => l10n.errorInvalidCredentials,
      AuthIssue.emailNotConfirmed => l10n.errorEmailNotConfirmed,
      AuthIssue.registrationFailed => l10n.errorRegistration,
      AuthIssue.networkUnavailable => l10n.errorNetwork,
      AuthIssue.recoveryExpired => l10n.errorRecoveryExpired,
      AuthIssue.sessionUnavailable => l10n.errorSessionUnavailable,
      AuthIssue.unexpected => l10n.errorUnexpected,
    };

class _Notice extends StatelessWidget {
  const _Notice({required this.icon, required this.text, this.isError = false});

  final IconData icon;
  final String text;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isError ? colors.errorContainer : colors.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon,
              color: isError
                  ? colors.onErrorContainer
                  : colors.onSecondaryContainer),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
