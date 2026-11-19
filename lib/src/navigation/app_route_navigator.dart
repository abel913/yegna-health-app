import 'package:flutter/material.dart';

import '../assessment/self_assessment_page.dart';
import '../auth/auth_controller.dart';
import '../auth/auth_pages.dart';
import '../clubs/club_controller.dart';
import '../clubs/clubs_page.dart';
import '../learning/assessment_repository.dart';
import '../learning/education_repository.dart';
import '../learning/learn_pages.dart';
import '../learning/learning_progress_controller.dart';
import '../locale_controller.dart';
import '../notifications/notification_controller.dart';

/// Centralizes route transitions pushed on top of the AppShell root coordinator.
class AppRouteNavigator {
  static void openClubs({
    required BuildContext context,
    required ClubController clubController,
    required AuthController authController,
    required InAppNotificationController notificationController,
  }) {
    final userId = authController.user?.id ?? 'guest_explorer';
    final userEmail = authController.user?.email;
    final userName = authController.user?.displayName;
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => ClubsPage(
          controller: clubController,
          userId: userId,
          userEmail: userEmail,
          userName: userName,
          notificationController: notificationController,
          onRequireAuth: () {
            Navigator.of(context).push<void>(
              MaterialPageRoute<void>(
                builder: (_) => AuthPage(
                  controller: authController,
                  notificationController: notificationController,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  static Future<void> openAccount({
    required BuildContext context,
    required AuthController authController,
    required InAppNotificationController notificationController,
  }) {
    final page = authController.isAuthenticated
        ? ProfilePage(controller: authController, notificationController: notificationController)
        : AuthPage(controller: authController, notificationController: notificationController);
    return Navigator.of(context).push<void>(MaterialPageRoute<void>(builder: (_) => page));
  }

  static void handleAuthRecovery({
    required BuildContext context,
    required AuthController authController,
    required InAppNotificationController notificationController,
    required VoidCallback onComplete,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context)
          .push<void>(MaterialPageRoute<void>(
            builder: (_) => AuthPage(
              controller: authController,
              notificationController: notificationController,
              initialMode: AuthPageMode.newPassword,
            ),
          ))
          .whenComplete(onComplete);
    });
  }

  static void openArticle({
    required BuildContext context,
    required String articleId,
    required EducationRepository repository,
    required LearningProgressController progressController,
    required LocaleController localeController,
  }) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => ArticlePage(
          articleId: articleId,
          repository: repository,
          progressController: progressController,
          localeController: localeController,
        ),
      ),
    );
  }

  static void openLearningProgress({
    required BuildContext context,
    required LearningProgressController progressController,
    required AssessmentRepository assessmentRepository,
  }) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => LearningProgressScreen(
          controller: progressController,
          assessmentRepository: assessmentRepository,
        ),
      ),
    );
  }

  static void openSelfAssessment({
    required BuildContext context,
    required ValueChanged<int> onSelectTab,
  }) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => SelfAssessmentPage(
          onOpenMentors: () => onSelectTab(2),
          onOpenFacilities: () => onSelectTab(1),
          onOpenLearning: () => onSelectTab(3),
        ),
      ),
    );
  }
}
