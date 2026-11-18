import 'dart:ui';
import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../notifications/notification_controller.dart';
import '../auth_controller.dart';
import '../auth_page_mode.dart';
import '../widgets/auth_ambient_backdrop.dart';
import '../widgets/auth_form_content.dart';
import '../widgets/auth_glass_container.dart';
import '../widgets/auth_guest_footer.dart';
import '../widgets/auth_notice.dart';
import '../widgets/auth_status_views.dart';
import '../widgets/auth_unconfigured_view.dart';
import '../widgets/auth_verification_pending_view.dart';
import 'auth_page_flow_mixin.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({
    required this.controller,
    this.notificationController,
    this.initialMode = AuthPageMode.signIn,
    super.key,
  });

  final AuthController controller;
  final InAppNotificationController? notificationController;
  final AuthPageMode initialMode;

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with AuthPageFlowMixin {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFEAF5FD),
      appBar: AppBar(
        title: Text(
          l10n.accountTitle,
          style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF08264A)),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.55),
                border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.85), width: 1.2)),
              ),
            ),
          ),
        ),
      ),
      body: AuthAmbientBackdrop(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight > 32 ? constraints.maxHeight - 32 : 0,
                  maxWidth: 440,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (!widget.controller.isConfigured)
                        AuthUnconfiguredView(onContinueAsGuest: () => Navigator.of(context).pop())
                      else ...[
                        AuthGlassContainer(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (mode == AuthPageMode.verificationPending)
                                AuthVerificationPendingView(
                                  targetEmail: widget.controller.verificationEmail ?? emailController.text.trim(),
                                  verificationCodeController: verificationCodeController,
                                  isVerifyingCode: isVerifyingCode,
                                  isResendingCode: isResendingCode,
                                  resendCooldownSeconds: resendCooldownSeconds,
                                  onVerify: verifyCode,
                                  onResend: resendCode,
                                  onChangeEmail: () => changeMode(AuthPageMode.signIn),
                                )
                              else if (mode == AuthPageMode.passwordUpdated)
                                AuthPasswordUpdatedView(onDismiss: () {
                                  widget.controller.clearIssue();
                                  Navigator.of(context).pop();
                                })
                              else if (mode == AuthPageMode.recover && recoverySent)
                                AuthRecoverySentView(onSignIn: () => changeMode(AuthPageMode.signIn))
                              else
                                AuthFormContent(
                                  mode: mode,
                                  formKey: formKey,
                                  displayNameController: displayNameController,
                                  emailController: emailController,
                                  passwordController: passwordController,
                                  confirmationController: confirmationController,
                                  obscurePassword: obscurePassword,
                                  obscureConfirmation: obscureConfirmation,
                                  isBusy: widget.controller.isBusy,
                                  onToggleObscurePassword: () => setState(() => obscurePassword = !obscurePassword),
                                  onToggleObscureConfirmation: () => setState(() => obscureConfirmation = !obscureConfirmation),
                                  onSubmit: submit,
                                  onChangeMode: changeMode,
                                ),
                              if (widget.controller.issue != null) ...[
                                const SizedBox(height: 12),
                                AuthNotice(
                                  icon: Icons.error_outline,
                                  text: authIssueMessage(l10n, widget.controller.issue!),
                                  isError: true,
                                ),
                              ],
                            ],
                          ),
                        ),
                        AuthGuestFooter(onContinueAsGuest: () => Navigator.of(context).pop()),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
