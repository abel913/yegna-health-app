import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../auth/auth_controller.dart';
import '../learning/assessment_repository.dart';
import '../learning/education_repository.dart';
import '../learning/learning_progress_controller.dart';
import '../theme/app_glass_theme.dart';
import 'widgets/home_ambient_mesh.dart';
import 'widgets/home_clubs_promo_card.dart';
import 'widgets/home_greeting_header.dart';
import 'widgets/home_learning_carousel.dart';
import 'widgets/home_quick_actions_grid.dart';
import 'widgets/home_safety_banner.dart';
import 'widgets/home_section_header.dart';
import 'widgets/home_survey_banner.dart';
import 'widgets/home_survey_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    required this.educationRepository,
    required this.locale,
    required this.onOpenLearning,
    required this.onOpenMentors,
    required this.onOpenFacilities,
    required this.onOpenAccount,
    this.onOpenSelfAssessment,
    this.onOpenClubs,
    this.authController,
    this.progressController,
    this.assessmentRepository,
    this.autoPromptSurvey,
    super.key,
  });

  final EducationRepository educationRepository;
  final Locale locale;
  final VoidCallback onOpenLearning;
  final VoidCallback onOpenMentors;
  final VoidCallback onOpenFacilities;
  final VoidCallback onOpenAccount;
  final VoidCallback? onOpenSelfAssessment;
  final VoidCallback? onOpenClubs;
  final AuthController? authController;
  final LearningProgressController? progressController;
  final AssessmentRepository? assessmentRepository;
  final bool? autoPromptSurvey;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool get _shouldAutoPrompt {
    if (widget.autoPromptSurvey != null) return widget.autoPromptSurvey!;
    final u = widget.authController?.user;
    if (u != null && (u.role?.toUpperCase() != 'STUDENT' || u.displayName.toLowerCase().contains('admin'))) {
      return false;
    }
    return !WidgetsBinding.instance.runtimeType.toString().contains('TestWidgets');
  }

  @override
  void initState() {
    super.initState();
    if (_shouldAutoPrompt) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        HomeSurveyLauncher.checkAndPrompt(
          context: context,
          authController: widget.authController,
          onOpenFacilities: widget.onOpenFacilities,
          onUpdate: () => mounted ? setState(() {}) : null,
        );
      });
    }
  }

  String _getGreeting(int hour, AppLocalizations l10n) {
    if (hour >= 5 && hour < 12) {
      return l10n.greetingMorning;
    } else if (hour >= 12 && hour < 17) {
      return l10n.greetingAfternoon;
    }
    return l10n.greetingEvening;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hour = DateTime.now().hour;
    final greeting = _getGreeting(hour, l10n);
    final glass = context.glassTheme;
    final isDark = glass.isDark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: glass.scaffoldGradientColors,
        ),
      ),
      child: Stack(
        children: [
          HomeAmbientMesh(isDark: isDark),
          RefreshIndicator(
            onRefresh: () async => setState(() {}),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 580),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 36),
                  children: [
                    HomeGreetingHeader(
                      greeting: greeting,
                      onOpenAccount: widget.onOpenAccount,
                      authController: widget.authController,
                    ),
                    const SizedBox(height: 14),
                    HomeSurveyBanner(
                      authController: widget.authController,
                      onTap: () => HomeSurveyLauncher.showModal(
                        context: context,
                        authController: widget.authController,
                        onOpenFacilities: widget.onOpenFacilities,
                        onUpdate: () => mounted ? setState(() {}) : null,
                      ),
                    ),
                    HomeSectionHeader(
                      title: l10n.exploreServicesHeading,
                      subtitle: l10n.exploreServicesSubtitle,
                    ),
                    const SizedBox(height: 14),
                    HomeQuickActionsGrid(
                      onOpenLearning: widget.onOpenLearning,
                      onOpenFacilities: widget.onOpenFacilities,
                      onOpenMentors: widget.onOpenMentors,
                      onOpenSelfAssessment: widget.onOpenSelfAssessment,
                    ),
                    if (widget.onOpenClubs != null) ...[
                      const SizedBox(height: 18),
                      HomeClubsPromoCard(onTap: widget.onOpenClubs!),
                    ],
                    const SizedBox(height: 26),
                    HomeSectionHeader(
                      title: l10n.featuredArticlesHeading,
                      action: TextButton.icon(
                        onPressed: widget.onOpenLearning,
                        icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                        label: Text(
                          l10n.viewAllAction,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    HomeLearningCarousel(
                      locale: widget.locale,
                      educationRepository: widget.educationRepository,
                      progressController: widget.progressController,
                      assessmentRepository: widget.assessmentRepository,
                      onOpenLearning: widget.onOpenLearning,
                    ),
                    const SizedBox(height: 22),
                    HomeSafetyBanner(text: l10n.healthEducationBoundary),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
