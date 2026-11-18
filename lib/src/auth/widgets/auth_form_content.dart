import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../auth_models.dart';
import '../auth_page_mode.dart';
import '../auth_validation.dart';
import 'auth_form_header.dart';
import 'auth_mode_toggle_buttons.dart';
import 'auth_notice.dart';
import 'auth_submit_button.dart';
import 'auth_text_field.dart';

class AuthFormContent extends StatelessWidget {
  const AuthFormContent({
    required this.mode,
    required this.formKey,
    required this.displayNameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmationController,
    required this.obscurePassword,
    required this.obscureConfirmation,
    required this.isBusy,
    required this.onToggleObscurePassword,
    required this.onToggleObscureConfirmation,
    required this.onSubmit,
    required this.onChangeMode,
    super.key,
  });

  final AuthPageMode mode;
  final GlobalKey<FormState> formKey;
  final TextEditingController displayNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmationController;
  final bool obscurePassword;
  final bool obscureConfirmation;
  final bool isBusy;
  final VoidCallback onToggleObscurePassword;
  final VoidCallback onToggleObscureConfirmation;
  final VoidCallback onSubmit;
  final ValueChanged<AuthPageMode> onChangeMode;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isRegister = mode == AuthPageMode.register;
    final isRecovery = mode == AuthPageMode.recover;
    final isNewPassword = mode == AuthPageMode.newPassword;

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AuthFormHeader(mode: mode),
          const SizedBox(height: 18),
          if (isRegister) ...[
            AuthTextField(
              controller: displayNameController,
              label: l10n.displayNameLabel,
              prefixIcon: Icons.person_outline_rounded,
              validator: (v) => _validation(l10n, AuthValidation.displayName(v ?? '')),
              textCapitalization: TextCapitalization.words,
              enabled: !isBusy,
            ),
            const SizedBox(height: 11),
          ],
          if (!isNewPassword) ...[
            AuthTextField(
              controller: emailController,
              label: l10n.emailLabel,
              prefixIcon: Icons.mail_outline_rounded,
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
              validator: (v) => _validation(l10n, AuthValidation.email(v ?? '')),
              enabled: !isBusy,
            ),
            const SizedBox(height: 11),
          ],
          if (!isRecovery) ...[
            AuthTextField(
              controller: passwordController,
              label: isNewPassword ? l10n.newPasswordLabel : l10n.passwordLabel,
              prefixIcon: Icons.lock_outline_rounded,
              obscureText: obscurePassword,
              suffixIcon: IconButton(
                icon: Icon(
                  obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  size: 20,
                  color: const Color(0xFF0284C7),
                ),
                onPressed: onToggleObscurePassword,
              ),
              autofillHints: isRegister ? const [AutofillHints.newPassword] : const [AutofillHints.password],
              validator: (v) => _validation(
                l10n,
                isNewPassword || isRegister
                    ? AuthValidation.password(v ?? '')
                    : (v?.isEmpty ?? true) ? AuthIssue.passwordRequired : null,
              ),
              enabled: !isBusy,
            ),
          ],
          if (isRegister || isNewPassword) ...[
            const SizedBox(height: 11),
            AuthTextField(
              controller: confirmationController,
              label: l10n.confirmPasswordLabel,
              prefixIcon: Icons.lock_reset_rounded,
              obscureText: obscureConfirmation,
              suffixIcon: IconButton(
                icon: Icon(
                  obscureConfirmation ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  size: 20,
                  color: const Color(0xFF0284C7),
                ),
                onPressed: onToggleObscureConfirmation,
              ),
              autofillHints: const [AutofillHints.newPassword],
              validator: (v) => _validation(
                l10n,
                AuthValidation.passwordConfirmation(passwordController.text, v ?? ''),
              ),
              enabled: !isBusy,
            ),
          ],
          if (mode == AuthPageMode.signIn)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Align(
                alignment: AlignmentDirectional.centerEnd,
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () => onChangeMode(AuthPageMode.recover),
                  child: Text(
                    l10n.forgotPassword,
                    style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: Color(0xFF0284C7)),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 14),
          AuthSubmitButton(
            isBusy: isBusy,
            label: isRegister
                ? l10n.registerAction
                : isRecovery
                    ? l10n.sendRecoveryEmail
                    : isNewPassword
                        ? l10n.updatePassword
                        : l10n.loginAction,
            onSubmit: onSubmit,
          ),
          const SizedBox(height: 14),
          AuthModeToggleButtons(mode: mode, onChangeMode: onChangeMode),
        ],
      ),
    );
  }

  String? _validation(AppLocalizations l10n, AuthIssue? issue) =>
      issue == null ? null : authIssueMessage(l10n, issue);
}
