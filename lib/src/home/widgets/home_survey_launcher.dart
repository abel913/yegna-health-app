import 'dart:ui';
import 'package:flutter/material.dart';

import '../../auth/auth_controller.dart';
import '../../onboarding/onboarding_survey_dialog.dart';
import '../../onboarding/onboarding_survey_repository.dart';

class HomeSurveyLauncher {
  const HomeSurveyLauncher._();

  static Future<void> checkAndPrompt({
    required BuildContext context,
    required AuthController? authController,
    required VoidCallback onOpenFacilities,
    required VoidCallback onUpdate,
  }) async {
    final user = authController?.user;
    if (user != null && user.role != null && user.role!.toUpperCase() != 'STUDENT') {
      return;
    }
    if (user != null && user.displayName.toLowerCase().contains('admin')) {
      return;
    }
    final repo = OnboardingSurveyRepository();
    final isDone = await repo.hasCompletedOrDismissed(user: user);
    if (!isDone && context.mounted) {
      showModal(
        context: context,
        authController: authController,
        onOpenFacilities: onOpenFacilities,
        onUpdate: onUpdate,
      );
    }
  }

  static void showModal({
    required BuildContext context,
    required AuthController? authController,
    required VoidCallback onOpenFacilities,
    required VoidCallback onUpdate,
  }) {
    final user = authController?.user;
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss Onboarding Survey',
      barrierColor: Colors.black.withValues(alpha: 0.38),
      transitionDuration: const Duration(milliseconds: 320),
      pageBuilder: (dialogCtx, anim1, anim2) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: OnboardingSurveyDialog(
            userId: user?.id,
            onOpenFacilities: onOpenFacilities,
            onCompleted: (_) => onUpdate(),
            onDismissed: onUpdate,
          ),
        );
      },
      transitionBuilder: (dialogCtx, anim, _, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: anim, curve: Curves.easeOutBack),
          child: FadeTransition(opacity: anim, child: child),
        );
      },
    );
  }
}
