import 'dart:async';
import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../auth_models.dart';
import '../auth_page_mode.dart';
import '../widgets/auth_snack_bars.dart';
import 'auth_page.dart';

mixin AuthPageFlowMixin on State<AuthPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmationController = TextEditingController();
  final displayNameController = TextEditingController();
  final verificationCodeController = TextEditingController();

  late AuthPageMode mode = widget.initialMode;
  bool recoverySent = false;
  bool obscurePassword = true;
  bool obscureConfirmation = true;
  bool isVerifyingCode = false;
  bool isResendingCode = false;
  int resendCooldownSeconds = 0;
  Timer? resendCooldownTimer;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(onAuthChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(onAuthChanged);
    resendCooldownTimer?.cancel();
    emailController.dispose();
    passwordController.dispose();
    confirmationController.dispose();
    displayNameController.dispose();
    verificationCodeController.dispose();
    super.dispose();
  }

  void startCooldown() {
    resendCooldownTimer?.cancel();
    setState(() => resendCooldownSeconds = 60);
    resendCooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (resendCooldownSeconds <= 1) {
        timer.cancel();
        setState(() => resendCooldownSeconds = 0);
      } else {
        setState(() => resendCooldownSeconds--);
      }
    });
  }

  void onAuthChanged() {
    if (!mounted) return;
    if (widget.controller.recoveryRequested &&
        mode != AuthPageMode.newPassword &&
        mode != AuthPageMode.passwordUpdated) {
      setState(() => mode = AuthPageMode.newPassword);
    } else {
      setState(() {});
    }
  }

  void changeMode(AuthPageMode newMode) {
    widget.controller.clearIssue();
    setState(() {
      mode = newMode;
      recoverySent = false;
    });
  }

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context);

    if (mode == AuthPageMode.signIn) {
      final email = emailController.text.trim();
      if (!widget.controller.isConfigured) return;

      final success = await widget.controller.signIn(email: email, password: passwordController.text);
      if (!mounted) return;

      if (widget.controller.issue == AuthIssue.accountSuspended) {
        AuthSnackBars.showAccountSuspended(context, l10n);
        return;
      }
      if (widget.controller.issue == AuthIssue.emailNotConfirmed) {
        widget.controller.setVerificationEmail(email);
        AuthSnackBars.showEmailNotConfirmed(context, l10n);
        setState(() => mode = AuthPageMode.verificationPending);
        return;
      }
      if (success) {
        final name = widget.controller.user?.displayName.trim();
        final finalName = (name != null && name.isNotEmpty)
            ? name
            : (email.contains('@') ? email.split('@').first : 'User');
        final isAm = Localizations.localeOf(context).languageCode == 'am';
        widget.notificationController?.addWelcomeBackNotification(finalName, isAmharic: isAm);
        AuthSnackBars.showWelcomeBack(context, l10n, finalName);
        Navigator.of(context).pop();
      }
      return;
    }

    if (mode == AuthPageMode.register) {
      final outcome = await widget.controller.register(
        email: emailController.text,
        password: passwordController.text,
        confirmation: confirmationController.text,
        displayName: displayNameController.text,
      );
      if (!mounted) return;
      final rawName = displayNameController.text.trim().isNotEmpty
          ? displayNameController.text.trim()
          : (emailController.text.trim().contains('@')
              ? emailController.text.trim().split('@').first
              : 'User');
      final isAm = Localizations.localeOf(context).languageCode == 'am';

      if (outcome == RegistrationOutcome.verificationPending) {
        widget.notificationController?.addAccountCreatedNotification(
          rawName,
          isAmharic: isAm,
          verificationPending: true,
        );
        AuthSnackBars.showRegistrationPending(context, l10n);
        setState(() => mode = AuthPageMode.verificationPending);
      } else if (outcome == RegistrationOutcome.signedIn) {
        widget.notificationController?.addAccountCreatedNotification(
          rawName,
          isAmharic: isAm,
          verificationPending: false,
        );
        AuthSnackBars.showRegistrationSuccess(context, l10n, rawName);
        Navigator.of(context).pop();
      }
      return;
    }

    if (mode == AuthPageMode.recover) {
      final success = await widget.controller.requestPasswordRecovery(emailController.text);
      if (mounted && success) setState(() => recoverySent = true);
      return;
    }

    if (mode == AuthPageMode.newPassword) {
      final success = await widget.controller.completePasswordRecovery(
        password: passwordController.text,
        confirmation: confirmationController.text,
      );
      if (mounted && success) setState(() => mode = AuthPageMode.passwordUpdated);
    }
  }

  Future<void> verifyCode() async {
    final code = verificationCodeController.text.trim();
    final l10n = AppLocalizations.of(context);
    final target = widget.controller.verificationEmail ?? emailController.text.trim();

    if (code.length != 6) {
      AuthSnackBars.showError(context, l10n.invalidCodeError);
      return;
    }
    setState(() => isVerifyingCode = true);
    try {
      final ok = await widget.controller.verifyEmailCode(email: target, code: code);
      if (!mounted) return;
      if (ok) {
        final name = widget.controller.user?.displayName.trim();
        final finalName = (name != null && name.isNotEmpty)
            ? name
            : (target.contains('@') ? target.split('@').first : 'User');
        final isAm = Localizations.localeOf(context).languageCode == 'am';
        widget.notificationController?.addAccountCreatedNotification(
          finalName,
          isAmharic: isAm,
          verificationPending: false,
        );
        AuthSnackBars.showVerifiedSuccess(context, l10n, finalName);
        Navigator.of(context).pop();
      } else {
        AuthSnackBars.showError(context, l10n.invalidCodeError);
      }
    } finally {
      if (mounted) setState(() => isVerifyingCode = false);
    }
  }

  Future<void> resendCode() async {
    if (resendCooldownSeconds > 0 || isResendingCode) return;
    final target = widget.controller.verificationEmail ?? emailController.text.trim();
    if (target.isEmpty) return;

    final l10n = AppLocalizations.of(context);
    setState(() => isResendingCode = true);
    try {
      final ok = await widget.controller.resendVerification(target);
      if (!mounted) return;
      if (ok) {
        startCooldown();
        AuthSnackBars.showCodeResent(context, l10n);
      } else {
        AuthSnackBars.showError(context, l10n.errorNetwork);
      }
    } finally {
      if (mounted) setState(() => isResendingCode = false);
    }
  }
}
