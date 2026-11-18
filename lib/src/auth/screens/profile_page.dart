import 'dart:ui';
import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../notifications/notification_controller.dart';
import '../auth_controller.dart';
import '../widgets/auth_ambient_backdrop.dart';
import '../widgets/auth_glass_container.dart';
import '../widgets/auth_notice.dart';
import '../widgets/auth_snack_bars.dart';
import '../widgets/profile_account_actions.dart';
import '../widgets/profile_delete_dialog.dart';
import '../widgets/profile_form.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_survey_card.dart';
import 'auth_page.dart';

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
    final success = await widget.controller.updateDisplayName(_displayName.text);
    if (mounted && success) setState(() => _saved = true);
  }

  Future<void> _signOut() async {
    final success = await widget.controller.signOut();
    if (mounted && success) Navigator.of(context).pop();
  }

  Future<void> _deleteAccount() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showProfileDeleteDialog(context);

    if (confirmed == true && mounted) {
      final success = await widget.controller.deleteAccount();
      if (!mounted) return;
      if (success) {
        AuthSnackBars.showAccountDeletedSuccess(context, l10n);
        Navigator.of(context).pop();
      } else {
        AuthSnackBars.showError(context, l10n.errorNetwork);
      }
    }
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
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 36),
                children: [
                  if (!widget.controller.isAuthenticated || user == null) ...[
                    AuthGlassContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AuthNotice(icon: Icons.lock_outline, text: l10n.sessionEnded),
                          const SizedBox(height: 16),
                          FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFF0284C7),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              padding: const EdgeInsets.symmetric(vertical: 13),
                            ),
                            onPressed: () => Navigator.of(context).pushReplacement(
                              MaterialPageRoute<void>(
                                builder: (_) => AuthPage(
                                  controller: widget.controller,
                                  notificationController: widget.notificationController,
                                ),
                              ),
                            ),
                            child: Text(
                              l10n.signIn,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    AuthGlassContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ProfileHeader(user: user),
                          const SizedBox(height: 22),
                          ProfileForm(
                            formKey: _formKey,
                            displayNameController: _displayName,
                            isBusy: widget.controller.isBusy,
                            saved: _saved,
                            onSave: _save,
                          ),
                          if (widget.controller.issue != null) ...[
                            const SizedBox(height: 12),
                            AuthNotice(
                              icon: Icons.error_outline,
                              text: authIssueMessage(l10n, widget.controller.issue!),
                              isError: true,
                            ),
                          ],
                          ProfileSurveyCard(user: user, onSurveyCompleted: _refresh),
                          ProfileAccountActions(
                            isBusy: widget.controller.isBusy,
                            onSignOut: _signOut,
                            onDeleteAccount: _deleteAccount,
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
      ),
    );
  }
}
