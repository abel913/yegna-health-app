import 'dart:ui';
import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../assessment/self_assessment_page.dart';
import '../auth/auth_controller.dart';
import '../learning/assessment_repository.dart';
import '../learning/education_repository.dart';
import '../learning/hiv_module_page.dart';
import '../learning/learning_modules_carousel.dart';
import '../learning/learning_progress_controller.dart';
import '../onboarding/onboarding_survey_dialog.dart';
import '../onboarding/onboarding_survey_repository.dart';
import '../theme/app_glass_theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    required this.educationRepository,
    required this.locale,
    required this.onOpenLearning,
    required this.onOpenMentors,
    required this.onOpenFacilities,
    required this.onOpenAccount,
    required this.onOpenArticle,
    this.onOpenSelfAssessment,
    this.onOpenClubs,
    this.onOpenAdmin,
    this.authController,
    this.progressController,
    this.assessmentRepository,
    super.key,
  });

  final EducationRepository educationRepository;
  final Locale locale;
  final VoidCallback onOpenLearning;
  final VoidCallback onOpenMentors;
  final VoidCallback onOpenFacilities;
  final VoidCallback onOpenAccount;
  final ValueChanged<String> onOpenArticle;
  final VoidCallback? onOpenSelfAssessment;
  final VoidCallback? onOpenClubs;
  final VoidCallback? onOpenAdmin;
  final AuthController? authController;
  final LearningProgressController? progressController;
  final AssessmentRepository? assessmentRepository;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndPromptOnboardingSurvey();
    });
  }

  Future<void> _checkAndPromptOnboardingSurvey() async {
    final repo = OnboardingSurveyRepository();
    final isDone = await repo.isCompleted();
    if (!isDone && mounted) {
      _showOnboardingSurveyModal(context);
    }
  }

  void _showOnboardingSurveyModal(BuildContext context) {
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
            onOpenFacilities: widget.onOpenFacilities,
            onCompleted: (_) {
              if (mounted) setState(() {});
            },
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

  Widget _buildSurveyBanner(BuildContext context, AppLocalizations l10n) {
    final glass = context.glassTheme;
    final isDark = glass.isDark;

    return FutureBuilder<bool>(
      future: OnboardingSurveyRepository().isCompleted(),
      builder: (context, snapshot) {
        final isCompleted = snapshot.data ?? false;

        return _DeepGlassContainer(
          borderRadius: 22,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          onTap: () => _showOnboardingSurveyModal(context),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: isCompleted
                      ? const LinearGradient(
                          colors: [Color(0xFF10B981), Color(0xFF059669)],
                        )
                      : const LinearGradient(
                          colors: [Color(0xFFFF7A59), Color(0xFFFF5252)],
                        ),
                  boxShadow: [
                    BoxShadow(
                      color: (isCompleted
                              ? const Color(0xFF10B981)
                              : const Color(0xFFFF5252))
                          .withValues(alpha: 0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  isCompleted
                      ? Icons.check_circle_outline_rounded
                      : Icons.assignment_outlined,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            l10n.onboardingSurveySubtitle,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: isCompleted
                                ? const Color(0xFF10B981).withValues(alpha: 0.15)
                                : const Color(0xFFFF7A59).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            isCompleted ? '✓' : '1 min',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: isCompleted
                                  ? const Color(0xFF10B981)
                                  : const Color(0xFFFF7A59),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      l10n.onboardingSurveyTitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white70 : const Color(0xFF64748B),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1E293B)
                      : const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isCompleted
                          ? (l10n.localeName == 'am' ? 'ተመልከት' : 'View')
                          : (l10n.localeName == 'am' ? 'ጀምር' : 'Start'),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      size: 14,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _refresh() async {
    setState(() {});
  }

  String _getGreeting(int hour, AppLocalizations l10n) {
    if (hour >= 5 && hour < 12) {
      return l10n.greetingMorning;
    } else if (hour >= 12 && hour < 17) {
      return l10n.greetingAfternoon;
    } else {
      return l10n.greetingEvening;
    }
  }

  void _showDoctorDailyArticleSheet(
      BuildContext context, AppLocalizations l10n) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final glass = ctx.glassTheme;
        final isDark = glass.isDark;

        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF0F172A).withValues(alpha: 0.96)
                  : Colors.white.withValues(alpha: 0.96),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(30)),
              border: isDark
                  ? Border.all(color: glass.cardBorder, width: 1.2)
                  : null,
              boxShadow: const [
                BoxShadow(
                  color: Color(0x30000000),
                  blurRadius: 28,
                  offset: Offset(0, -6),
                ),
              ],
            ),
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.88,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top drag handle & close button
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 12, 4),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 4,
                        decoration: BoxDecoration(
                          color: glass.modalHandle,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, size: 22),
                        color: glass.subtitleText,
                        onPressed: () => Navigator.of(ctx).pop(),
                      ),
                    ],
                  ),
                ),

                // Scrollable Article Content
                Flexible(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(22, 6, 22, 32),
                    children: [
                      // Doctor & Clinical Team Header
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              glass.accentColor.withValues(alpha: 0.08),
                              const Color(0xFF0EA5E9).withValues(alpha: 0.03),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isDark
                                ? glass.cardBorder
                                : const Color(0xFFBAE6FD)
                                    .withValues(alpha: 0.8),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF0284C7),
                                    Color(0xFF0EA5E9)
                                  ],
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0x250284C7),
                                    blurRadius: 8,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.medical_services_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          l10n.doctorArticleAuthor,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800,
                                            color: glass.titleText,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Icon(
                                        Icons.verified_rounded,
                                        size: 16,
                                        color: glass.accentColor,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    '${l10n.doctorArticleDate} • ${l10n.doctorArticleReadTime}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: isDark
                                          ? const Color(0xFF38BDF8)
                                          : const Color(0xFF0369A1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Article Title
                      Text(
                        l10n.dailyTipTitle,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: glass.titleText,
                          height: 1.3,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Full Article Body
                      Text(
                        l10n.doctorArticleFullText,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.65,
                          color: isDark
                              ? const Color(0xFFCBD5E1)
                              : const Color(0xFF1E3A54),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 22),

                      // Key Doctor Advice Heading
                      Row(
                        children: [
                          Container(
                            width: 4,
                            height: 18,
                            decoration: BoxDecoration(
                              color: glass.accentColor,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            l10n.doctorArticleSheetTitle,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: glass.titleText,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Doctor Advice Card 1: Skincare
                      _DoctorAdviceTile(
                        icon: Icons.clean_hands_rounded,
                        iconColor: const Color(0xFF0D9488),
                        title: l10n.doctorAdviceSkincareTitle,
                        description: l10n.doctorAdviceSkincareDesc,
                      ),
                      const SizedBox(height: 10),

                      // Doctor Advice Card 2: Emotional Balance
                      _DoctorAdviceTile(
                        icon: Icons.spa_rounded,
                        iconColor: const Color(0xFF6366F1),
                        title: l10n.doctorAdviceEmotionalTitle,
                        description: l10n.doctorAdviceEmotionalDesc,
                      ),
                      const SizedBox(height: 10),

                      // Doctor Advice Card 3: Clinical Support
                      _DoctorAdviceTile(
                        icon: Icons.local_hospital_rounded,
                        iconColor: const Color(0xFFE11D48),
                        title: l10n.doctorAdviceClinicalTitle,
                        description: l10n.doctorAdviceClinicalDesc,
                      ),
                      const SizedBox(height: 24),

                      // Action Buttons Row: Ask Mentor & Close
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Navigator.of(ctx).pop();
                                widget.onOpenMentors();
                              },
                              icon: const Icon(Icons.people_alt_rounded,
                                  size: 18),
                              label: Text(
                                l10n.askMentorAction,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: glass.accentColor,
                                side: BorderSide(
                                    color: isDark
                                        ? glass.cardBorder
                                        : const Color(0xFFBAE6FD)),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 13),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => Navigator.of(ctx).pop(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: glass.accentColor,
                                foregroundColor:
                                    isDark ? Colors.black : Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 13),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                l10n.closeArticleAction,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hour = DateTime.now().hour;
    final greeting = _getGreeting(hour, l10n);

    Widget buildGreetingHeader() {
      final auth = widget.authController;
      if (auth != null) {
        return ListenableBuilder(
          listenable: auth,
          builder: (context, _) {
            final user = auth.user;
            final isAuthed = auth.isAuthenticated;
            final displayName =
                (isAuthed && user != null && user.displayName.trim().isNotEmpty)
                    ? user.displayName.trim()
                    : null;
            return _DeepGlassGreetingHeader(
              greeting: greeting,
              displayName: displayName,
              subtitle: l10n.guestGreetingSubtitle,
              confidentialText: l10n.confidentialPill,
              reviewedText: l10n.reviewedPill,
              guestReadyText: l10n.guestReadyPill,
              accountTitle: l10n.accountTitle,
              onOpenAccount: widget.onOpenAccount,
            );
          },
        );
      }
      return _DeepGlassGreetingHeader(
        greeting: greeting,
        displayName: null,
        subtitle: l10n.guestGreetingSubtitle,
        confidentialText: l10n.confidentialPill,
        reviewedText: l10n.reviewedPill,
        guestReadyText: l10n.guestReadyPill,
        accountTitle: l10n.accountTitle,
        onOpenAccount: widget.onOpenAccount,
      );
    }

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
          // Luminous Ambient Mesh (Vibrant Orbs for Optical Glass Refraction)
          Positioned(
            top: -40,
            left: -30,
            child: Container(
              width: 360,
              height: 360,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: isDark
                      ? const [
                          Color(0x350284C7),
                          Color(0x1838BDF8),
                          Colors.transparent,
                        ]
                      : const [
                          Color(0x950284C7),
                          Color(0x5038BDF8),
                          Colors.transparent,
                        ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 90,
            right: -60,
            child: Container(
              width: 380,
              height: 380,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: isDark
                      ? const [
                          Color(0x3006B6D4),
                          Color(0x150EA5E9),
                          Colors.transparent,
                        ]
                      : const [
                          Color(0x8806B6D4),
                          Color(0x450EA5E9),
                          Colors.transparent,
                        ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 360,
            left: -60,
            child: Container(
              width: 340,
              height: 340,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: isDark
                      ? const [
                          Color(0x286366F1),
                          Color(0x1238BDF8),
                          Colors.transparent,
                        ]
                      : const [
                          Color(0x806366F1),
                          Color(0x3538BDF8),
                          Colors.transparent,
                        ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 540,
            right: -50,
            child: Container(
              width: 340,
              height: 340,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: isDark
                      ? const [
                          Color(0x250D9488),
                          Color(0x1014B8A6),
                          Colors.transparent,
                        ]
                      : const [
                          Color(0x750D9488),
                          Color(0x3514B8A6),
                          Colors.transparent,
                        ],
                ),
              ),
            ),
          ),

          // Decorative Floating Glass Spheres
          Positioned(
            top: 70,
            left: 20,
            child: Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF38BDF8).withValues(alpha: 0.25)
                      : Colors.white.withValues(alpha: 0.50),
                  width: 2,
                ),
                gradient: RadialGradient(
                  colors: isDark
                      ? [
                          const Color(0xFF38BDF8).withValues(alpha: 0.12),
                          Colors.transparent,
                        ]
                      : [
                          Colors.white.withValues(alpha: 0.35),
                          Colors.white.withValues(alpha: 0.05),
                        ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 480,
            right: 26,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF38BDF8).withValues(alpha: 0.25)
                      : Colors.white.withValues(alpha: 0.45),
                  width: 2,
                ),
                gradient: RadialGradient(
                  colors: isDark
                      ? [
                          const Color(0xFF38BDF8).withValues(alpha: 0.12),
                          Colors.transparent,
                        ]
                      : [
                          Colors.white.withValues(alpha: 0.30),
                          Colors.white.withValues(alpha: 0.05),
                        ],
                ),
              ),
            ),
          ),

          // Main Scrollable Dashboard Content
          RefreshIndicator(
            onRefresh: _refresh,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 580),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 36),
                  children: [
                    // 1. Dynamic Greeting & Profile Card (Single clean Account CTA)
                    buildGreetingHeader(),
                    const SizedBox(height: 14),

                    // Student Baseline Survey Banner (1-tap to open popup anytime)
                    _buildSurveyBanner(context, l10n),
                    const SizedBox(height: 18),

                    // 2. Section Heading: Explore Services
                    _GlassSectionHeader(
                      title: l10n.exploreServicesHeading,
                      subtitle: l10n.exploreServicesSubtitle,
                    ),
                    const SizedBox(height: 14),

                    // 5. Refined 2x2 Feature Action Cards Grid (Aspect Ratio 0.96 for overflow-free layout)
                    GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.96,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _DeepGlassActionCard(
                          icon: Icons.assignment_turned_in_rounded,
                          iconGradient: const [
                            Color(0xFF0284C7),
                            Color(0xFF38BDF8),
                          ],
                          title: l10n.selfAssessmentTitle,
                          description: l10n.selfAssessmentDesc,
                          onTap: widget.onOpenSelfAssessment ??
                              () {
                                Navigator.of(context).push<void>(
                                  MaterialPageRoute<void>(
                                    builder: (_) => SelfAssessmentPage(
                                      onOpenMentors: widget.onOpenMentors,
                                      onOpenFacilities: widget.onOpenFacilities,
                                      onOpenLearning: widget.onOpenLearning,
                                    ),
                                  ),
                                );
                              },
                        ),
                        _DeepGlassActionCard(
                          icon: Icons.menu_book_rounded,
                          iconGradient: const [
                            Color(0xFF4F46E5),
                            Color(0xFF06B6D4),
                          ],
                          title: l10n.learnTab,
                          description: l10n.learnDesc,
                          onTap: widget.onOpenLearning,
                        ),
                        _DeepGlassActionCard(
                          icon: Icons.location_on_rounded,
                          iconGradient: const [
                            Color(0xFF0D9488),
                            Color(0xFF2DD4BF),
                          ],
                          title: l10n.findFacilitiesTitle,
                          description: l10n.findFacilitiesDesc,
                          onTap: widget.onOpenFacilities,
                        ),
                        _DeepGlassActionCard(
                          icon: Icons.people_alt_rounded,
                          iconGradient: const [
                            Color(0xFF0284C7),
                            Color(0xFF818CF8),
                          ],
                          title: l10n.peerMentorTitle,
                          description: l10n.peerMentorDesc,
                          onTap: widget.onOpenMentors,
                        ),
                      ],
                    ),
                    if (widget.onOpenClubs != null) ...[
                      const SizedBox(height: 18),
                      InkWell(
                        onTap: widget.onOpenClubs,
                        borderRadius: BorderRadius.circular(22),
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF065F46), Color(0xFF047857)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(
                              color: const Color(0xFF34D399)
                                  .withValues(alpha: 0.4),
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF047857)
                                    .withValues(alpha: 0.25),
                                blurRadius: 14,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.groups_rounded,
                                    color: Colors.white, size: 26),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l10n.studentClubsPromoTitle,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.5,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      l10n.studentClubsPromoSubtitle,
                                      style: TextStyle(
                                        color: Colors.white
                                            .withValues(alpha: 0.85),
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.25),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.arrow_forward_rounded,
                                    color: Colors.white, size: 18),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    if (widget.onOpenAdmin != null &&
                        (widget.authController?.user?.email.trim().toLowerCase() ==
                                'natnaelzemene21@gmail.com' ||
                            widget
                                    .authController?.user?.email
                                    .trim()
                                    .toLowerCase() ==
                                'naelzemene21@gmail.com' ||
                            widget
                                    .authController?.user?.email
                                    .trim()
                                    .toLowerCase() ==
                                'natnaelzemne21@gmail.com' ||
                            widget.authController?.user?.email
                                    .trim()
                                    .toLowerCase() ==
                                'admin@yegnahealth.org' ||
                            (widget.authController?.user?.email
                                    .trim()
                                    .toLowerCase()
                                    .contains('admin') ??
                                false) ||
                            (widget.authController?.user?.displayName
                                    .trim()
                                    .toLowerCase()
                                    .contains('admin') ??
                                false))) ...[
                      const SizedBox(height: 18),
                      InkWell(
                        onTap: widget.onOpenAdmin,
                        borderRadius: BorderRadius.circular(22),
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF0F172A), Color(0xFF0369A1)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(
                              color: const Color(0xFF38BDF8),
                              width: 1.4,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x330284C7),
                                blurRadius: 16,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF0284C7),
                                      Color(0xFF38BDF8)
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                    Icons.admin_panel_settings_rounded,
                                    color: Colors.white,
                                    size: 26),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          Localizations.localeOf(context)
                                                      .languageCode ==
                                                  'am'
                                              ? 'የአስተዳዳሪ ማዕከል'
                                              : 'Executive Admin Console',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 15.5,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF38BDF8),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: const Text(
                                            'ADMIN',
                                            style: TextStyle(
                                              color: Color(0xFF0F172A),
                                              fontSize: 9.5,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      Localizations.localeOf(context)
                                                  .languageCode ==
                                              'am'
                                          ? 'ሞጁሎችን፣ ጥያቄዎችን፣ ጽሑፎችን እና ክለቦችን ለማስተዳደር ይንኩ'
                                          : 'Tap to manage learning modules, quizzes, articles & clubs',
                                      style: TextStyle(
                                        color:
                                            Colors.white.withValues(alpha: 0.9),
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios_rounded,
                                  color: Color(0xFF38BDF8), size: 16),
                            ],
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 26),

                    // 6. Featured Health Topics Carousel with Real Modules & Photos
                    _GlassSectionHeader(
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
                    _DeepGlassLearningModulesCarousel(
                      locale: widget.locale,
                      progressController: widget.progressController,
                      assessmentRepository: widget.assessmentRepository,
                      onOpenLearning: widget.onOpenLearning,
                      onOpenArticle: widget.onOpenArticle,
                    ),
                    const SizedBox(height: 20),

                    // Doctor's Daily Health Article Card (Positioned at bottom of feed)
                    _DeepGlassDoctorArticleCard(
                      badgeText: l10n.doctorDailyArticleBadge,
                      authorText: l10n.doctorArticleAuthor,
                      titleText: l10n.dailyTipTitle,
                      bodyText: l10n.dailyTipBody,
                      actionText: l10n.readFullArticleAction,
                      onTap: () => _showDoctorDailyArticleSheet(context, l10n),
                    ),
                    const SizedBox(height: 22),

                    // Safeguarding Boundary Banner
                    _DeepGlassSafetyBanner(
                      text: l10n.healthEducationBoundary,
                    ),
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

/// Advanced Deep Glass Container (Optical Frosted Glassmorphism)
class _DeepGlassContainer extends StatelessWidget {
  const _DeepGlassContainer({
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.borderRadius = 26.0,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final glass = context.glassTheme;
    final isDark = glass.isDark;

    final glassBody = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
        child: Container(
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF131D36).withValues(alpha: 0.76)
                : Colors.white.withValues(alpha: 0.38),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      const Color(0xFF1E293B).withValues(alpha: 0.85),
                      const Color(0xFF0F172A).withValues(alpha: 0.70),
                      const Color(0xFF0284C7).withValues(alpha: 0.16),
                    ]
                  : [
                      Colors.white.withValues(alpha: 0.65),
                      Colors.white.withValues(alpha: 0.22),
                      const Color(0xFFBAE6FD).withValues(alpha: 0.16),
                    ],
              stops: const [0.0, 0.65, 1.0],
            ),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: isDark
                  ? const Color(0xFF38BDF8).withValues(alpha: 0.24)
                  : Colors.white.withValues(alpha: 0.90),
              width: 1.5,
            ),
            boxShadow: isDark
                ? const [
                    BoxShadow(
                      color: Color(0x60000000),
                      blurRadius: 26,
                      offset: Offset(0, 10),
                      spreadRadius: -2,
                    ),
                    BoxShadow(
                      color: Color(0x1F38BDF8),
                      blurRadius: 8,
                      offset: Offset(-1, -1),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: const Color(0xFF0284C7).withValues(alpha: 0.16),
                      blurRadius: 26,
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
                      colors: isDark
                          ? [
                              const Color(0xFF38BDF8).withValues(alpha: 0.50),
                              const Color(0xFF38BDF8).withValues(alpha: 0.15),
                              Colors.transparent,
                            ]
                          : [
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

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: onTap,
          child: glassBody,
        ),
      );
    }
    return glassBody;
  }
}

/// Dynamic Greeting Header in Deep Glass (Single clean Account CTA & no duplicates)
class _DeepGlassGreetingHeader extends StatelessWidget {
  const _DeepGlassGreetingHeader({
    required this.greeting,
    required this.displayName,
    required this.subtitle,
    required this.confidentialText,
    required this.reviewedText,
    required this.guestReadyText,
    required this.accountTitle,
    required this.onOpenAccount,
  });

  final String greeting;
  final String? displayName;
  final String subtitle;
  final String confidentialText;
  final String reviewedText;
  final String guestReadyText;
  final String accountTitle;
  final VoidCallback onOpenAccount;

  @override
  Widget build(BuildContext context) {
    final glass = context.glassTheme;
    final isDark = glass.isDark;

    final titleText = displayName != null && displayName!.isNotEmpty
        ? '$greeting, $displayName! 👋'
        : '$greeting! 👋';

    return _DeepGlassContainer(
      borderRadius: 28,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Youth Health Shield Avatar Badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1E293B)
                      : Colors.white.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF38BDF8).withValues(alpha: 0.3)
                        : const Color(0xFFBAE6FD),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? const Color(0x33000000)
                          : const Color(0x120284C7),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.shield_rounded,
                      size: 15,
                      color: glass.accentColor,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Yegna Health',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: isDark
                            ? const Color(0xFF38BDF8)
                            : const Color(0xFF0369A1),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Single Account Pill Button (Keeps test finding accountTitle intact)
              Flexible(
                child: InkWell(
                  onTap: onOpenAccount,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0284C7), Color(0xFF0369A1)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x300284C7),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            accountTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          size: 13,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            titleText,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: glass.titleText,
                  letterSpacing: -0.5,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 13.5,
              height: 1.5,
              fontWeight: FontWeight.w500,
              color: glass.subtitleText,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _GlassFeatureBadge(
                icon: Icons.shield_outlined,
                text: confidentialText,
              ),
              _GlassFeatureBadge(
                icon: Icons.auto_stories_outlined,
                text: reviewedText,
              ),
              _GlassFeatureBadge(
                icon: Icons.check_circle_outline_rounded,
                text: guestReadyText,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GlassFeatureBadge extends StatelessWidget {
  const _GlassFeatureBadge({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final glass = context.glassTheme;
    final isDark = glass.isDark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5.5),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1E293B)
            : Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? const Color(0xFF38BDF8).withValues(alpha: 0.25)
              : Colors.white.withValues(alpha: 0.95),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? const Color(0x33000000) : const Color(0x100284C7),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: glass.accentColor),
          const SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: glass.titleText,
            ),
          ),
        ],
      ),
    );
  }
}

/// 2x2 Action Cards in Deep Frosted Glass with comfortable aspect ratio (1.15)
class _DeepGlassActionCard extends StatelessWidget {
  const _DeepGlassActionCard({
    required this.icon,
    required this.iconGradient,
    required this.title,
    required this.description,
    required this.onTap,
  });

  final IconData icon;
  final List<Color> iconGradient;
  final String title;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final glass = context.glassTheme;
    final isDark = glass.isDark;

    return _DeepGlassContainer(
      borderRadius: 24,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: iconGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.5),
                    width: 1.4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: iconGradient.first.withValues(alpha: 0.40),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 22),
              ),
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1E293B)
                      : Colors.white.withValues(alpha: 0.7),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF38BDF8).withValues(alpha: 0.3)
                        : Colors.white.withValues(alpha: 0.9),
                  ),
                ),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  size: 14,
                  color: isDark
                      ? const Color(0xFF38BDF8)
                      : const Color(0xFF0284C7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    color: glass.titleText,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.5,
                    height: 1.3,
                    fontWeight: FontWeight.w400,
                    color: glass.subtitleText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Section Heading in Crisp Typography
class _GlassSectionHeader extends StatelessWidget {
  const _GlassSectionHeader({
    required this.title,
    this.subtitle,
    this.action,
  });

  final String title;
  final String? subtitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final glass = context.glassTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  color: glass.titleText,
                  letterSpacing: -0.3,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: glass.subtitleText,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (action != null) action!,
      ],
    );
  }
}

/// Featured Health Education Modules Carousel with Real Photos and Progress from Learn Page
class _DeepGlassLearningModulesCarousel extends StatelessWidget {
  const _DeepGlassLearningModulesCarousel({
    required this.locale,
    required this.onOpenLearning,
    required this.onOpenArticle,
    this.progressController,
    this.assessmentRepository,
  });

  final Locale locale;
  final VoidCallback onOpenLearning;
  final ValueChanged<String> onOpenArticle;
  final LearningProgressController? progressController;
  final AssessmentRepository? assessmentRepository;

  void _handleModuleTap(BuildContext context, LearningModuleItem module) {
    if (module.id == 'module-07' && progressController != null) {
      Navigator.of(context).push<void>(
        MaterialPageRoute<void>(
          builder: (_) => HivModuleDetailPage(
            progressController: progressController!,
            assessmentRepository: assessmentRepository,
            onOpenQuiz: onOpenLearning,
          ),
        ),
      );
    } else {
      _showModuleBottomSheet(context, module);
    }
  }

  void _showModuleBottomSheet(BuildContext context, LearningModuleItem module) {
    final l10n = AppLocalizations.of(context);
    final isAmharic = locale.languageCode == 'am';

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        final glass = ctx.glassTheme;
        final isDark = glass.isDark;

        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF0F172A).withValues(alpha: 0.96)
                  : Colors.white.withValues(alpha: 0.96),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(28)),
              border: isDark
                  ? Border.all(color: glass.cardBorder, width: 1.2)
                  : null,
              boxShadow: const [
                BoxShadow(
                  color: Color(0x30000000),
                  blurRadius: 28,
                  offset: Offset(0, -6),
                ),
              ],
            ),
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: glass.modalHandle,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.asset(
                    module.imageAsset,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 180,
                      color: isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFBAE6FD),
                      child: Icon(
                        Icons.image_not_supported_rounded,
                        color: glass.accentColor,
                        size: 40,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF0284C7), Color(0xFF0EA5E9)],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        l10n.moduleLabel(module.number).toUpperCase(),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (progressController?.progress?.articles
                            .any((a) => a.articleId == module.id) ==
                        true)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 9, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF16A34A),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.check_circle_rounded,
                              color: Colors.white,
                              size: 13,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              l10n.completedStatus,
                              style: const TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  module.title(l10n),
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: glass.titleText,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  module.description(l10n),
                  style: TextStyle(
                    fontSize: 13.5,
                    height: 1.5,
                    color: glass.subtitleText,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      onOpenLearning();
                    },
                    icon: const Icon(Icons.menu_book_rounded, size: 18),
                    label: Text(
                      isAmharic ? 'በትምህርት ገጽ ይመልከቱ' : 'Explore in Learn Tab',
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 14),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: glass.accentColor,
                      foregroundColor: isDark ? Colors.black : Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isAmharic = locale.languageCode == 'am';

    Widget buildCarousel(Set<String> completedIds) {
      return SizedBox(
        height: 255,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: kLearningModules.length,
          separatorBuilder: (_, __) => const SizedBox(width: 14),
          itemBuilder: (context, index) {
            final module = kLearningModules[index];
            final isCompleted = completedIds.contains(module.id);

            return SizedBox(
              width: 275,
              child: _DeepGlassContainer(
                borderRadius: 22,
                padding: EdgeInsets.zero,
                onTap: () => _handleModuleTap(context, module),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Hero Image Banner with Optical Glass Border & Floating Badges
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(22),
                          ),
                          child: Image.asset(
                            module.imageAsset,
                            height: 125,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              height: 125,
                              color: const Color(0xFFBAE6FD),
                              child: const Icon(
                                Icons.image_not_supported_rounded,
                                color: Color(0xFF0284C7),
                              ),
                            ),
                          ),
                        ),
                        // Soft subtle gradient overlay at bottom of photo
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 35,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.35),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Module Number Tag
                        Positioned(
                          top: 10,
                          left: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3.5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.65),
                              borderRadius: BorderRadius.circular(9),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.4),
                                width: 0.8,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x35000000),
                                  blurRadius: 6,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              'MODULE ${module.number}',
                              style: const TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                        // Completed Status Badge
                        if (isCompleted)
                          Positioned(
                            top: 10,
                            right: 10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3.5,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF16A34A)
                                    .withValues(alpha: 0.92),
                                borderRadius: BorderRadius.circular(9),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x4016A34A),
                                    blurRadius: 6,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.check_circle_rounded,
                                    size: 11,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    l10n.completedStatus,
                                    style: const TextStyle(
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),

                    // Bottom Content (Title, Description, and Action)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              module.title(l10n),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF08264A),
                                height: 1.25,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Expanded(
                              child: Text(
                                module.description(l10n),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 11,
                                  height: 1.35,
                                  color: Color(0xFF4A6277),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE0F2FE),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    isAmharic ? 'ጤና ትምህርት' : 'Youth Health',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF0369A1),
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                const Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 16,
                                  color: Color(0xFF0284C7),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }

    Set<String> getCompletedIds() {
      return progressController?.progress?.articles
              .map((a) => a.articleId)
              .toSet() ??
          const <String>{};
    }

    if (progressController != null) {
      return ListenableBuilder(
        listenable: progressController!,
        builder: (context, _) => buildCarousel(getCompletedIds()),
      );
    }

    return buildCarousel(const {});
  }
}

/// Glass Safety & Ethics Banner
class _DeepGlassSafetyBanner extends StatelessWidget {
  const _DeepGlassSafetyBanner({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.65),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.85),
            width: 1.2,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x10007A78),
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(
              Icons.verified_user_outlined,
              color: Color(0xFF007A78),
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 11.5,
                  height: 1.4,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF005A56),
                ),
              ),
            ),
          ],
        ),
      );
}

/// Daily Doctor-Authored Youth Health Article Card
class _DeepGlassDoctorArticleCard extends StatelessWidget {
  const _DeepGlassDoctorArticleCard({
    required this.badgeText,
    required this.authorText,
    required this.titleText,
    required this.bodyText,
    required this.actionText,
    required this.onTap,
  });

  final String badgeText;
  final String authorText;
  final String titleText;
  final String bodyText;
  final String actionText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final glass = context.glassTheme;
    final isDark = glass.isDark;

    return _DeepGlassContainer(
      borderRadius: 24,
      padding: const EdgeInsets.all(18),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0284C7), Color(0xFF0EA5E9)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x250284C7),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.medical_services_rounded,
                      size: 13,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      badgeText,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF0C4A6E)
                      : const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF0284C7)
                        : const Color(0xFFBAE6FD),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.verified_rounded,
                      size: 12,
                      color: glass.accentColor,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        authorText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? const Color(0xFF38BDF8)
                              : const Color(0xFF0284C7),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            titleText,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: glass.titleText,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            bodyText,
            style: TextStyle(
              fontSize: 13,
              height: 1.45,
              color: glass.subtitleText,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Text(
                actionText,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: glass.accentColor,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.arrow_forward_rounded,
                size: 15,
                color: glass.accentColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DoctorAdviceTile extends StatelessWidget {
  const _DoctorAdviceTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final glass = context.glassTheme;
    final isDark = glass.isDark;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? glass.cardBorder : const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: glass.titleText,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12.5,
                    height: 1.45,
                    color: glass.subtitleText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
