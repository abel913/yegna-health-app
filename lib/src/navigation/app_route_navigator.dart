import 'package:flutter/material.dart';

import '../assessment/self_assessment_page.dart';
import '../auth/auth_controller.dart';
import '../auth/auth_pages.dart';
import '../clubs/club_controller.dart';
import '../clubs/club_detail_sheet.dart';
import '../clubs/clubs_page.dart';
import '../clubs/models/student_club_model.dart';
import '../learning/assessment_repository.dart';
import '../learning/learn_pages.dart';
import '../learning/learning_progress_controller.dart';
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

  static void handleNotificationNavigate({
    required BuildContext context,
    required String route,
    required ValueChanged<int> onSelectTab,
    required ClubController clubController,
    required AuthController authController,
    required InAppNotificationController notificationController,
  }) {
    if (route == 'learn' || route.startsWith('learn:')) {
      onSelectTab(3);
    } else if (route == 'facility' || route.startsWith('facility:')) {
      onSelectTab(1);
    } else if (route == 'assessment' || route.startsWith('assessment:')) {
      onSelectTab(2);
    } else if (route.startsWith('club:')) {
      final clubId = route.replaceFirst('club:', '');
      final club = clubController.clubs.cast<StudentClub?>().firstWhere(
            (c) => c?.id == clubId,
            orElse: () => null,
          );
      if (club != null) {
        ClubDetailSheet.show(
          context,
          club: club,
          controller: clubController,
          userId: authController.user?.id ?? 'guest',
          userEmail: authController.user?.email,
          userName: authController.user?.displayName,
          notificationController: notificationController,
        );
      } else {
        openClubs(
          context: context,
          clubController: clubController,
          authController: authController,
          notificationController: notificationController,
        );
      }
    }
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
