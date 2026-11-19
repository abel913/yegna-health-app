import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../notifications/notification_controller.dart';
import '../auth_controller.dart';
import '../screens/auth_page.dart';
import 'auth_glass_container.dart';
import 'auth_notice.dart';

class ProfileSessionEndedCard extends StatelessWidget {
  const ProfileSessionEndedCard({
    required this.controller,
    this.notificationController,
    super.key,
  });

  final AuthController controller;
  final InAppNotificationController? notificationController;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AuthGlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AuthNotice(icon: Icons.lock_outline, text: l10n.sessionEnded),
          const SizedBox(height: 16),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF0284C7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(vertical: 13),
            ),
            onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute<void>(
                builder: (_) => AuthPage(
                  controller: controller,
                  notificationController: notificationController,
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
    );
  }
}
