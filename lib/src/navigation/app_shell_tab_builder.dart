import 'package:flutter/material.dart';

import '../account/account_page.dart';
import '../account/app_settings_controller.dart';
import '../app.dart';
import '../discovery/directory_pages.dart';
import '../discovery/facility_repository.dart';
import '../discovery/mentor_repository.dart';
import '../home/home_page.dart';
import '../learning/learn_pages.dart';
import 'app_route_navigator.dart';

/// Builder utility creating the 5 core bottom navigation tab views for AppShell.
class AppShellTabBuilder {
  static List<Widget> buildPages({
    required BuildContext context,
    required AppShell widget,
    required ValueChanged<int> onSelectTab,
    required VoidCallback onOpenAccount,
    required VoidCallback onOpenClubs,
  }) {
    return [
      HomePage(
        educationRepository: widget.educationRepository,
        authController: widget.authController,
        progressController: widget.progressController,
        assessmentRepository: widget.assessmentRepository,
        locale: Localizations.localeOf(context),
        onOpenLearning: () => onSelectTab(3),
        onOpenMentors: () => onSelectTab(2),
        onOpenFacilities: () => onSelectTab(1),
        onOpenAccount: onOpenAccount,
        onOpenArticle: (id) => AppRouteNavigator.openArticle(
          context: context,
          articleId: id,
          repository: widget.educationRepository,
          progressController: widget.progressController,
          localeController: widget.localeController,
        ),
        onOpenSelfAssessment: () => AppRouteNavigator.openSelfAssessment(
          context: context,
          onSelectTab: onSelectTab,
        ),
        onOpenClubs: onOpenClubs,
      ),
      FacilitiesPage(
        facilityRepository: widget.facilityRepository ?? const LocalVerifiedFacilityRepository(),
      ),
      MentorsPage(
        mentorRepository: widget.mentorRepository ?? const LocalVerifiedMentorRepository(),
      ),
      LearnPage(
        educationRepository: widget.educationRepository,
        assessmentRepository: widget.assessmentRepository,
        progressController: widget.progressController,
        localeController: widget.localeController,
      ),
      AccountPage(
        localeController: widget.localeController,
        authController: widget.authController,
        progressController: widget.progressController,
        assessmentRepository: widget.assessmentRepository,
        settingsController: widget.settingsController ?? AppSettingsController(),
        onOpenAccount: onOpenAccount,
        onOpenLearningProgress: () => AppRouteNavigator.openLearningProgress(
          context: context,
          progressController: widget.progressController,
          assessmentRepository: widget.assessmentRepository,
        ),
        onOpenClubs: onOpenClubs,
      ),
    ];
  }
}
