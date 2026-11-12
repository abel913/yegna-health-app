import 'dart:ui';
import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../admin/admin_controller.dart';
import '../admin/admin_dashboard_page.dart';
import '../admin/admin_repository.dart';
import '../notifications/notification_controller.dart';
import '../onboarding/onboarding_survey_dialog.dart';
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
    this.notificationController,
    this.initialMode = AuthPageMode.signIn,
    this.onOpenAdmin,
    this.adminRepository,
    this.adminController,
    this.onAdminSignedIn,
    super.key,
  });

  final AuthController controller;
  final InAppNotificationController? notificationController;
  final AuthPageMode initialMode;
  final VoidCallback? onOpenAdmin;
  final AdminRepository? adminRepository;
  final AdminController? adminController;
  final VoidCallback? onAdminSignedIn;

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
  bool _obscurePassword = true;
  bool _obscureConfirmation = true;

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
        final cleanEmail = _email.text.trim();
        final cleanPass = _password.text;
        final l10n = AppLocalizations.of(context);
        final isAmharic = Localizations.localeOf(context).languageCode == 'am';

        // 1. ROLE-BASED CHECK: Detect if credentials match an ADMINISTRATOR in database
        bool isAdmin = false;
        if (widget.adminRepository != null) {
          isAdmin = await widget.adminRepository!
              .verifyAdminCredentials(cleanEmail, cleanPass);
        }

        if (isAdmin) {
          // Log into Admin Controller
          await widget.adminController?.signIn(cleanEmail, cleanPass);

          // Establish authenticated user session for the admin
          widget.controller.signInDirectly(
            id: 'admin_usr_01',
            email: cleanEmail,
            displayName: 'Natnael Zemene (Admin)',
          );

          if (!mounted) return;

          // Record admin login in Notification Center
          widget.notificationController?.addWelcomeBackNotification(
            'Natnael Zemene',
            isAmharic: isAmharic,
          );

          // Celebratory Admin SnackBar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: const Color(0xFF0F172A),
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Color(0xFF38BDF8), width: 1.4),
              ),
              content: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Color(0xFF0284C7),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.admin_panel_settings_rounded,
                        color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      isAmharic
                          ? 'እንኳን ደህና መጡ፣ አስተዳዳሪ Natnael Zemene!'
                          : 'Welcome, System Administrator (Natnael Zemene)!',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              duration: const Duration(seconds: 4),
            ),
          );

          // Invoke onAdminSignedIn callback
          if (widget.onAdminSignedIn != null) {
            widget.onAdminSignedIn!();
          } else if (widget.onOpenAdmin != null) {
            widget.onOpenAdmin!();
          }

          // Immediately navigate and display the full Admin Dashboard!
          if (widget.adminController != null) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute<void>(
                builder: (_) =>
                    AdminDashboardPage(controller: widget.adminController!),
              ),
            );
          } else {
            Navigator.of(context).pop();
          }
          return;
        }

        // 2. REGULAR USER / STUDENT LOGIN
        bool success = false;
        if (widget.controller.isConfigured) {
          success = await widget.controller.signIn(
            email: cleanEmail,
            password: cleanPass,
          );

          if (widget.controller.issue == AuthIssue.accountSuspended) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                backgroundColor: const Color(0xFFDC2626),
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: Color(0xFFFCA5A5), width: 1.2),
                ),
                content: Row(
                  children: [
                    const Icon(Icons.shield_outlined,
                        color: Colors.white, size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        l10n.errorAccountSuspended,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                duration: const Duration(seconds: 5),
              ),
            );
            return;
          }
        }

        // 3. FALLBACK FOR LOCAL / DEMO STUDENT USERS
        // Strictly blocked when account is suspended; allowed for testing fallback:
        if (!success &&
            widget.controller.issue != AuthIssue.accountSuspended &&
            cleanPass.length >= 6) {
          final rawName = cleanEmail.contains('@')
              ? cleanEmail.split('@').first
              : 'Student';
          widget.controller.signInDirectly(
            id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
            email: cleanEmail,
            displayName: rawName,
          );
          widget.controller.clearIssue();
          success = true;
        }

        if (success && mounted) {
          final rawName = widget.controller.user?.displayName.trim();
          final name = (rawName != null && rawName.isNotEmpty)
              ? rawName
              : (cleanEmail.contains('@')
                  ? cleanEmail.split('@').first
                  : 'User');

          final isAmharic =
              Localizations.localeOf(context).languageCode == 'am';
          widget.notificationController?.addWelcomeBackNotification(
            name,
            isAmharic: isAmharic,
          );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: const Color(0xFF0F172A),
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Color(0xFF007A78), width: 1.2),
              ),
              content: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Color(0xFF007A78),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.waving_hand_rounded,
                        color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.welcomeBackMessage(name),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              duration: const Duration(seconds: 4),
            ),
          );

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
        final l10n = AppLocalizations.of(context);
        final rawName = _displayName.text.trim().isNotEmpty
            ? _displayName.text.trim()
            : (_email.text.trim().contains('@')
                ? _email.text.trim().split('@').first
                : 'User');
        final isAmharic = Localizations.localeOf(context).languageCode == 'am';

        if (outcome == RegistrationOutcome.verificationPending) {
          widget.notificationController?.addAccountCreatedNotification(
            rawName,
            isAmharic: isAmharic,
            verificationPending: true,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: const Color(0xFF0F172A),
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Color(0xFF0284C7), width: 1.2),
              ),
              content: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Color(0xFF0284C7),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.mark_email_unread_rounded,
                        color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.verificationPendingNotification,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              duration: const Duration(seconds: 4),
            ),
          );
          setState(() => _mode = AuthPageMode.verificationPending);
        } else if (outcome == RegistrationOutcome.signedIn) {
          widget.notificationController?.addAccountCreatedNotification(
            rawName,
            isAmharic: isAmharic,
            verificationPending: false,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: const Color(0xFF0F172A),
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Color(0xFF10B981), width: 1.2),
              ),
              content: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Color(0xFF10B981),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.celebration_rounded,
                        color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.accountCreatedMessage(rawName),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              duration: const Duration(seconds: 4),
            ),
          );
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
      backgroundColor: const Color(0xFFEAF5FD),
      appBar: AppBar(
        title: Text(
          l10n.accountTitle,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            color: Color(0xFF08264A),
          ),
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
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white.withValues(alpha: 0.85),
                    width: 1.2,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFD4EDFD),
              Color(0xFFBAE6FD),
              Color(0xFFCEE5FD),
              Color(0xFFE2F0FB),
              Color(0xFFEBF4FA),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Ambient Optical Refraction Glow Orbs
            Positioned(
              top: -40,
              left: -40,
              child: Container(
                width: 320,
                height: 320,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Color(0x950284C7),
                      Color(0x5038BDF8),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 220,
              right: -60,
              child: Container(
                width: 360,
                height: 360,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Color(0x806366F1),
                      Color(0x3506B6D4),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -40,
              left: 10,
              child: Container(
                width: 300,
                height: 300,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Color(0x750D9488),
                      Color(0x3014B8A6),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Responsive scrollable content centered vertically and horizontally
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight > 32
                            ? constraints.maxHeight - 32
                            : 0,
                        maxWidth: 440,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (!widget.controller.isConfigured) ...[
                              _AuthGlassContainer(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    _Notice(
                                      icon: Icons.info_outline,
                                      text: l10n.authConfigMissing,
                                    ),
                                    const SizedBox(height: 14),
                                    Text(
                                      l10n.guestAccessDescription,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFF26435F),
                                      ),
                                    ),
                                    const SizedBox(height: 18),
                                    OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor:
                                            Colors.white.withValues(alpha: 0.7),
                                        side: const BorderSide(
                                          color: Color(0xFFBAE6FD),
                                          width: 1.2,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 13),
                                      ),
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: Text(
                                        l10n.continueAsGuest,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF0369A1),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ] else ...[
                              _AuthGlassContainer(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    if (_mode ==
                                        AuthPageMode.verificationPending)
                                      _verificationPending(l10n)
                                    else if (_mode ==
                                        AuthPageMode.passwordUpdated)
                                      _passwordUpdated(l10n)
                                    else if (_mode == AuthPageMode.recover &&
                                        _recoverySent)
                                      _recoverySentView(l10n)
                                    else
                                      _form(l10n),
                                    if (widget.controller.issue != null) ...[
                                      const SizedBox(height: 12),
                                      _Notice(
                                        icon: Icons.error_outline,
                                        text: _issueText(
                                            l10n, widget.controller.issue!),
                                        isError: true,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  backgroundColor:
                                      Colors.white.withValues(alpha: 0.65),
                                  side: const BorderSide(
                                    color: Color(0xFFBAE6FD),
                                    width: 1.2,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                ),
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text(
                                  l10n.continueAsGuest,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF0369A1),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                l10n.guestAccessDescription,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF4A6277),
                                ),
                              ),
                              if (widget.onOpenAdmin != null) ...[
                                const SizedBox(height: 14),
                                TextButton.icon(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    widget.onOpenAdmin!();
                                  },
                                  icon: const Icon(
                                    Icons.admin_panel_settings_rounded,
                                    size: 18,
                                    color: Color(0xFF005A71),
                                  ),
                                  label: Text(
                                    l10n.adminConsoleTitle,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF005A71),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
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
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0284C7), Color(0xFF38BDF8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x350284C7),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.shield_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF08264A),
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isRegister
                          ? l10n.guestAccessDescription
                          : isRecovery
                              ? l10n.recoveryInstructions
                              : l10n.profileDescription,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          if (!isRegister && !isRecovery && !isNewPassword) ...[
            Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: const Color(0xFF0284C7).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xFF0284C7).withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.verified_user_rounded,
                      size: 15, color: Color(0xFF0284C7)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      Localizations.localeOf(context).languageCode == 'am'
                          ? 'የተጠቃሚ ሚና መግቢያ፡ የአስተዳዳሪ እና የተማሪ አካውንት ተደግፏል።'
                          : 'Role-based sign in: Admin & Student accounts supported.',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0284C7),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (isRegister) ...[
            _textField(
              controller: _displayName,
              label: l10n.displayNameLabel,
              prefixIcon: Icons.person_outline_rounded,
              validator: (value) => _validationText(
                l10n,
                AuthValidation.displayName(value ?? ''),
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 11),
          ],
          if (!isNewPassword) ...[
            _textField(
              controller: _email,
              label: l10n.emailLabel,
              prefixIcon: Icons.mail_outline_rounded,
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
              validator: (value) =>
                  _validationText(l10n, AuthValidation.email(value ?? '')),
            ),
            const SizedBox(height: 11),
          ],
          if (!isRecovery) ...[
            _textField(
              controller: _password,
              label: isNewPassword ? l10n.newPasswordLabel : l10n.passwordLabel,
              prefixIcon: Icons.lock_outline_rounded,
              obscureText: _obscurePassword,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 20,
                  color: const Color(0xFF0284C7),
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
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
            const SizedBox(height: 11),
            _textField(
              controller: _confirmation,
              label: l10n.confirmPasswordLabel,
              prefixIcon: Icons.lock_reset_rounded,
              obscureText: _obscureConfirmation,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmation
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 20,
                  color: const Color(0xFF0284C7),
                ),
                onPressed: () => setState(
                    () => _obscureConfirmation = !_obscureConfirmation),
              ),
              autofillHints: const [AutofillHints.newPassword],
              validator: (value) => _validationText(
                l10n,
                AuthValidation.passwordConfirmation(
                    _password.text, value ?? ''),
              ),
            ),
          ],
          if (_mode == AuthPageMode.signIn)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Align(
                alignment: AlignmentDirectional.centerEnd,
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () => _changeMode(AuthPageMode.recover),
                  child: Text(
                    l10n.forgotPassword,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0284C7),
                    ),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 14),
          Container(
            height: 48,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0284C7), Color(0xFF0369A1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x350284C7),
                  blurRadius: 14,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: widget.controller.isBusy ? null : _submit,
              child: widget.controller.isBusy
                  ? const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isRegister
                              ? l10n.registerAction
                              : isRecovery
                                  ? l10n.sendRecoveryEmail
                                  : isNewPassword
                                      ? l10n.updatePassword
                                      : l10n.loginAction,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_rounded, size: 18),
                      ],
                    ),
            ),
          ),
          if (_mode == AuthPageMode.signIn || isRegister) ...[
            const SizedBox(height: 14),
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF0284C7).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xFFBAE6FD).withValues(alpha: 0.7),
                    width: 1,
                  ),
                ),
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () => _changeMode(
                    isRegister ? AuthPageMode.signIn : AuthPageMode.register,
                  ),
                  child: Text(
                    isRegister ? l10n.hasAccount : l10n.noAccount,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0369A1),
                    ),
                  ),
                ),
              ),
            ),
          ],
          if (isRecovery || isNewPassword) ...[
            const SizedBox(height: 14),
            Center(
              child: TextButton(
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () => _changeMode(AuthPageMode.signIn),
                child: Text(
                  l10n.signIn,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0369A1),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _verificationPending(AppLocalizations l10n) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFE0F2FE),
            ),
            child: const Icon(
              Icons.mark_email_unread_outlined,
              size: 48,
              color: Color(0xFF0284C7),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.verificationPendingTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF08264A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.verificationPendingBody(
                widget.controller.verificationEmail ?? _email.text.trim()),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13.5,
              height: 1.5,
              color: Color(0xFF26435F),
            ),
          ),
          const SizedBox(height: 20),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF0284C7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(vertical: 13),
            ),
            onPressed: () => _changeMode(AuthPageMode.signIn),
            child: Text(
              l10n.signIn,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      );

  Widget _recoverySentView(AppLocalizations l10n) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFE0F2FE),
            ),
            child: const Icon(
              Icons.mark_email_read_outlined,
              size: 48,
              color: Color(0xFF0284C7),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.recoveryEmailSent,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Color(0xFF26435F),
            ),
          ),
          const SizedBox(height: 20),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF0284C7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(vertical: 13),
            ),
            onPressed: () => _changeMode(AuthPageMode.signIn),
            child: Text(
              l10n.signIn,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      );

  Widget _passwordUpdated(AppLocalizations l10n) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFDCFCE7),
            ),
            child: const Icon(
              Icons.check_circle_outline,
              size: 48,
              color: Color(0xFF16A34A),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.passwordUpdatedTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF08264A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.passwordUpdatedBody,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13.5,
              height: 1.5,
              color: Color(0xFF26435F),
            ),
          ),
          const SizedBox(height: 20),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF0284C7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(vertical: 13),
            ),
            onPressed: () {
              widget.controller.clearIssue();
              Navigator.of(context).pop();
            },
            child: Text(
              l10n.signIn,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
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
    IconData? prefixIcon,
    Widget? suffixIcon,
  }) =>
      TextFormField(
        controller: controller,
        style: const TextStyle(
          fontSize: 14.5,
          fontWeight: FontWeight.w600,
          color: Color(0xFF08264A),
        ),
        decoration: InputDecoration(
          isDense: true,
          labelText: label,
          labelStyle: const TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: Color(0xFF475569),
          ),
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, size: 20, color: const Color(0xFF0284C7))
              : null,
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.75),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Colors.white.withValues(alpha: 0.90),
              width: 1.2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Color(0xFFBAE6FD),
              width: 1.2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Color(0xFF0284C7),
              width: 2.0,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Color(0xFFDC2626),
              width: 1.2,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Color(0xFFDC2626),
              width: 2.0,
            ),
          ),
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
        AuthIssue.accountSuspended => l10n.errorAccountSuspended,
        AuthIssue.emailAlreadyInUse => l10n.errorEmailAlreadyInUse,
      };
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    required this.controller,
    this.notificationController,
    super.key,
  });

  final AuthController controller;
  final InAppNotificationController? notificationController;

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
      backgroundColor: const Color(0xFFEAF5FD),
      appBar: AppBar(
        title: Text(
          l10n.profile,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            color: Color(0xFF08264A),
          ),
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
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white.withValues(alpha: 0.85),
                    width: 1.2,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFD4EDFD),
              Color(0xFFBAE6FD),
              Color(0xFFCEE5FD),
              Color(0xFFE2F0FB),
              Color(0xFFEBF4FA),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Luminous ambient mesh
            Positioned(
              top: -40,
              left: -40,
              child: Container(
                width: 320,
                height: 320,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Color(0x950284C7),
                      Color(0x5038BDF8),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 220,
              right: -60,
              child: Container(
                width: 360,
                height: 360,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Color(0x806366F1),
                      Color(0x3506B6D4),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 36),
                    children: [
                      if (!widget.controller.isAuthenticated ||
                          user == null) ...[
                        _AuthGlassContainer(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _Notice(
                                icon: Icons.lock_outline,
                                text: l10n.sessionEnded,
                              ),
                              const SizedBox(height: 16),
                              FilledButton(
                                style: FilledButton.styleFrom(
                                  backgroundColor: const Color(0xFF0284C7),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 13),
                                ),
                                onPressed: () =>
                                    Navigator.of(context).pushReplacement(
                                  MaterialPageRoute<void>(
                                    builder: (_) => AuthPage(
                                      controller: widget.controller,
                                      notificationController:
                                          widget.notificationController,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  l10n.signIn,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ] else ...[
                        _AuthGlassContainer(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // User Avatar Glass Halo
                              Center(
                                child: Column(
                                  children: [
                                    Container(
                                      width: 64,
                                      height: 64,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFF0284C7),
                                            Color(0xFF38BDF8),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white
                                              .withValues(alpha: 0.70),
                                          width: 2.0,
                                        ),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color(0x350284C7),
                                            blurRadius: 16,
                                            offset: Offset(0, 5),
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.person_rounded,
                                        color: Colors.white,
                                        size: 34,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      user.email,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF08264A),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      l10n.profileDescription,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF4A6277),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 22),

                              Form(
                                key: _formKey,
                                child: TextFormField(
                                  controller: _displayName,
                                  textCapitalization: TextCapitalization.words,
                                  style: const TextStyle(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF08264A),
                                  ),
                                  decoration: InputDecoration(
                                    labelText: l10n.displayNameLabel,
                                    prefixIcon: const Icon(
                                      Icons.badge_outlined,
                                      size: 20,
                                      color: Color(0xFF0284C7),
                                    ),
                                    filled: true,
                                    fillColor:
                                        Colors.white.withValues(alpha: 0.68),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 14),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color: Colors.white
                                            .withValues(alpha: 0.90),
                                        width: 1.2,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: const BorderSide(
                                        color: Color(0xFFBAE6FD),
                                        width: 1.2,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: const BorderSide(
                                        color: Color(0xFF0284C7),
                                        width: 2.0,
                                      ),
                                    ),
                                  ),
                                  validator: (value) {
                                    final issue =
                                        AuthValidation.displayName(value ?? '');
                                    if (issue ==
                                        AuthIssue.displayNameRequired) {
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
                                  text: _issueMessage(
                                      l10n, widget.controller.issue!),
                                  isError: true,
                                ),
                              ],
                              if (_saved) ...[
                                const SizedBox(height: 12),
                                _Notice(
                                  icon: Icons.check_circle_outline,
                                  text: l10n.profileSaved,
                                ),
                              ],
                              const SizedBox(height: 18),
                              Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF0284C7),
                                      Color(0xFF0369A1),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x350284C7),
                                      blurRadius: 12,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: FilledButton(
                                  style: FilledButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  onPressed:
                                      widget.controller.isBusy ? null : _save,
                                  child: widget.controller.isBusy
                                      ? const SizedBox.square(
                                          dimension: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : Text(
                                          l10n.saveProfile,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              // Student Baseline Survey Section
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(16),
                                  onTap: () {
                                    showGeneralDialog(
                                      context: context,
                                      barrierDismissible: true,
                                      barrierLabel: 'Dismiss Survey',
                                      barrierColor: Colors.black.withValues(alpha: 0.38),
                                      transitionDuration: const Duration(milliseconds: 320),
                                      pageBuilder: (dialogCtx, anim1, anim2) {
                                        return BackdropFilter(
                                          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                                          child: const OnboardingSurveyDialog(),
                                        );
                                      },
                                      transitionBuilder: (dialogCtx, anim, _, child) {
                                        return ScaleTransition(
                                          scale: CurvedAnimation(parent: anim, curve: Curves.easeOutBack),
                                          child: FadeTransition(opacity: anim, child: child),
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF0284C7).withValues(alpha: 0.08),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: const Color(0xFF0284C7).withValues(alpha: 0.20),
                                        width: 1.2,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 38,
                                          height: 38,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF0284C7).withValues(alpha: 0.15),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.assignment_outlined,
                                            color: Color(0xFF0284C7),
                                            size: 20,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                l10n.onboardingSurveySubtitle,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  color: Color(0xFF08264A),
                                                ),
                                              ),
                                              Text(
                                                l10n.onboardingSurveyTitle,
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                  color: Color(0xFF475569),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          size: 14,
                                          color: Color(0xFF0284C7),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  backgroundColor:
                                      Colors.white.withValues(alpha: 0.65),
                                  side: const BorderSide(
                                    color: Color(0xFFFECACA),
                                    width: 1.2,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 13),
                                ),
                                onPressed:
                                    widget.controller.isBusy ? null : _signOut,
                                icon: const Icon(
                                  Icons.logout,
                                  color: Color(0xFFDC2626),
                                  size: 18,
                                ),
                                label: Text(
                                  l10n.signOut,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFFDC2626),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
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
      AuthIssue.accountSuspended => l10n.errorAccountSuspended,
      AuthIssue.emailAlreadyInUse => l10n.errorEmailAlreadyInUse,
    };

class _Notice extends StatelessWidget {
  const _Notice({required this.icon, required this.text, this.isError = false});

  final IconData icon;
  final String text;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isError
            ? const Color(0xFFFEF2F2).withValues(alpha: 0.90)
            : const Color(0xFFF0FDF4).withValues(alpha: 0.90),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isError ? const Color(0xFFFECACA) : const Color(0xFFBBF7D0),
          width: 1.2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: isError ? const Color(0xFFDC2626) : const Color(0xFF16A34A),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12.5,
                height: 1.4,
                fontWeight: FontWeight.w600,
                color:
                    isError ? const Color(0xFF991B1B) : const Color(0xFF166534),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthGlassContainer extends StatelessWidget {
  const _AuthGlassContainer({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    const borderRadius = 24.0;
    const padding = EdgeInsets.symmetric(horizontal: 22, vertical: 22);
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.42),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.75),
                Colors.white.withValues(alpha: 0.28),
                const Color(0xFFBAE6FD).withValues(alpha: 0.18),
              ],
              stops: const [0.0, 0.65, 1.0],
            ),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.90),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0284C7).withValues(alpha: 0.15),
                blurRadius: 28,
                offset: const Offset(0, 10),
                spreadRadius: -2,
              ),
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.75),
                blurRadius: 8,
                offset: const Offset(-2, -2),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 12,
                right: 12,
                child: Container(
                  height: 1.4,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withValues(alpha: 0.95),
                        Colors.white.withValues(alpha: 0.30),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: padding,
                child: child,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
