import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../l10n/app_localizations.dart';
import '../auth/auth_controller.dart';
import '../learning/assessment_repository.dart';
import '../learning/education_repository.dart';
import '../learning/hiv_module_page.dart';
import '../learning/learning_models.dart';
import '../learning/learning_modules_carousel.dart';
import '../learning/learning_progress_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    required this.educationRepository,
    required this.locale,
    required this.onOpenLearning,
    required this.onOpenMentors,
    required this.onOpenFacilities,
    required this.onOpenAccount,
    required this.onOpenArticle,
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
  final AuthController? authController;
  final LearningProgressController? progressController;
  final AssessmentRepository? assessmentRepository;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<CachedValue<List<ArticlePreview>>> _articles;

  @override
  void initState() {
    super.initState();
    _articles = _loadArticles();
  }

  @override
  void didUpdateWidget(covariant HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.locale != widget.locale ||
        oldWidget.educationRepository != widget.educationRepository) {
      _articles = _loadArticles();
    }
  }

  Future<CachedValue<List<ArticlePreview>>> _loadArticles() async {
    try {
      return await widget.educationRepository
          .articles(widget.locale.languageCode);
    } catch (_) {
      return const CachedValue(value: [], isStale: true);
    }
  }

  Future<void> _refresh() async {
    setState(() => _articles = _loadArticles());
    await _articles;
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

  void _showEmergencyHelplineSheet(
      BuildContext context, AppLocalizations l10n) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x30000000),
                blurRadius: 28,
                offset: Offset(0, -6),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 36),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE4E6),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.phone_in_talk_rounded,
                      color: Color(0xFFE11D48),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.emergencySheetTitle,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF08264A),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          l10n.emergencySheetDisclaimer,
                          style: const TextStyle(
                            fontSize: 12,
                            height: 1.4,
                            color: Color(0xFF4A6277),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              _EmergencyHelplineTile(
                number: '952',
                name: l10n.emergencyHotline952Name,
                description: l10n.emergencyHotline952Desc,
                callActionLabel: l10n.callNowAction,
                copiedToast: l10n.copiedToClipboard,
              ),
              const SizedBox(height: 12),
              _EmergencyHelplineTile(
                number: '8335',
                name: l10n.emergencyHotline8335Name,
                description: l10n.emergencyHotline8335Desc,
                callActionLabel: l10n.callNowAction,
                copiedToast: l10n.copiedToClipboard,
              ),
            ],
          ),
        ),
      ),
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

    return Container(
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
          // Luminous Ambient Mesh (Vibrant Orbs for Optical Glass Refraction)
          Positioned(
            top: -40,
            left: -30,
            child: Container(
              width: 360,
              height: 360,
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
            top: 90,
            right: -60,
            child: Container(
              width: 380,
              height: 380,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
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
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
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
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
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
                  color: Colors.white.withValues(alpha: 0.50),
                  width: 2,
                ),
                gradient: RadialGradient(
                  colors: [
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
                  color: Colors.white.withValues(alpha: 0.45),
                  width: 2,
                ),
                gradient: RadialGradient(
                  colors: [
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
                    const SizedBox(height: 16),

                    // 2. Interactive Daily Insight Card (Myth vs Fact)
                    _DeepGlassDailyTipCard(
                      badgeText: l10n.dailyTipBadge,
                      mythFactText: l10n.dailyTipMythFact,
                      titleText: l10n.dailyTipTitle,
                      bodyText: l10n.dailyTipBody,
                      actionText: l10n.readArticleAction,
                      onOpenLearning: widget.onOpenLearning,
                    ),
                    const SizedBox(height: 14),

                    // 3. 24/7 Confidential Helpline Quick Bar
                    _DeepGlassCrisisBar(
                      title: l10n.emergencyHelplineTitle,
                      subtitle: l10n.emergencyHelplineSubtitle,
                      actionLabel: l10n.emergencyHelplineAction,
                      onTap: () => _showEmergencyHelplineSheet(context, l10n),
                    ),
                    const SizedBox(height: 24),

                    // 4. Section Heading: Explore Services
                    _GlassSectionHeader(
                      title: l10n.exploreServicesHeading,
                      subtitle: l10n.exploreServicesSubtitle,
                    ),
                    const SizedBox(height: 14),

                    // 5. Refined 2x2 Feature Action Cards Grid (Aspect Ratio 1.15)
                    GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 1.15,
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
                          onTap: widget.onOpenLearning,
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
                    const SizedBox(height: 22),

                    // 7. Safeguarding Boundary Banner
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
    final glassBody = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.38),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.65),
                Colors.white.withValues(alpha: 0.22),
                const Color(0xFFBAE6FD).withValues(alpha: 0.16),
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
    final titleText = displayName != null && displayName!.isNotEmpty
        ? '$greeting, $displayName! 👋'
        : '$greeting! 👋';

    return _DeepGlassContainer(
      borderRadius: 28,
      padding: const EdgeInsets.all(22),
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
                    const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFBAE6FD),
                    width: 1,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x120284C7),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.shield_rounded,
                      size: 15,
                      color: Color(0xFF0284C7),
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Yegna Health',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0369A1),
                      ),
                    ),
                  ],
                ),
              ),

              // Single Account Pill Button (Keeps test finding accountTitle intact)
              InkWell(
                onTap: onOpenAccount,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 13,
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
                      Text(
                        accountTitle,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        size: 14,
                        color: Colors.white,
                      ),
                    ],
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
                  color: const Color(0xFF08264A),
                  letterSpacing: -0.5,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 13.5,
              height: 1.5,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1E3A54),
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

/// Interactive Daily Youth Health Insight Card (Myth vs Fact)
class _DeepGlassDailyTipCard extends StatelessWidget {
  const _DeepGlassDailyTipCard({
    required this.onOpenLearning,
    required this.badgeText,
    required this.mythFactText,
    required this.titleText,
    required this.bodyText,
    required this.actionText,
  });

  final VoidCallback onOpenLearning;
  final String badgeText;
  final String mythFactText;
  final String titleText;
  final String bodyText;
  final String actionText;

  @override
  Widget build(BuildContext context) {
    return _DeepGlassContainer(
      borderRadius: 24,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                      Icons.lightbulb_rounded,
                      size: 14,
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
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFBAE6FD)),
                ),
                child: Text(
                  mythFactText,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0369A1),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            titleText,
            style: const TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.w800,
              color: Color(0xFF08264A),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            bodyText,
            style: const TextStyle(
              fontSize: 13,
              height: 1.45,
              color: Color(0xFF1E3A54),
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: onOpenLearning,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      actionText,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0284C7),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      size: 14,
                      color: Color(0xFF0284C7),
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

/// 24/7 Toll-Free Emergency Helpline Quick Bar
class _DeepGlassCrisisBar extends StatelessWidget {
  const _DeepGlassCrisisBar({
    required this.title,
    required this.subtitle,
    required this.actionLabel,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String actionLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _DeepGlassContainer(
      borderRadius: 20,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFFE11D48), Color(0xFFFB7185)],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFE11D48).withValues(alpha: 0.35),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Icon(
              Icons.phone_in_talk_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF881337),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF9F1239),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFBE123C),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              actionLabel,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Bottom Sheet Emergency Helpline Tile with Telephone Action & Clipboard Feedback
class _EmergencyHelplineTile extends StatelessWidget {
  const _EmergencyHelplineTile({
    required this.number,
    required this.name,
    required this.description,
    required this.callActionLabel,
    required this.copiedToast,
  });

  final String number;
  final String name;
  final String description;
  final String callActionLabel;
  final String copiedToast;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F2),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFFECDD3),
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFE11D48),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              number,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF881337),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: Color(0xFF9F1239),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: number));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$copiedToast: $number'),
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            icon: const Icon(
              Icons.phone_rounded,
              color: Color(0xFFE11D48),
            ),
            tooltip: callActionLabel,
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
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5.5),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.95),
            width: 1.2,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x100284C7),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: const Color(0xFF0284C7)),
            const SizedBox(width: 5),
            Text(
              text,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: Color(0xFF092542),
              ),
            ),
          ],
        ),
      );
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
  Widget build(BuildContext context) => _DeepGlassContainer(
        borderRadius: 24,
        padding: const EdgeInsets.all(16),
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: iconGradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
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
                  child: Icon(icon, color: Colors.white, size: 24),
                ),
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.7),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_rounded,
                    size: 15,
                    color: Color(0xFF0284C7),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w800,
                color: Color(0xFF08264A),
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11.5,
                height: 1.35,
                fontWeight: FontWeight.w400,
                color: Color(0xFF2B445B),
              ),
            ),
          ],
        ),
      );
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
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF08264A),
                    letterSpacing: -0.3,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: Color(0xFF4A6277),
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
      builder: (ctx) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.96),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
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
                    color: Colors.grey.withValues(alpha: 0.35),
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
                    color: const Color(0xFFBAE6FD),
                    child: const Icon(
                      Icons.image_not_supported_rounded,
                      color: Color(0xFF0284C7),
                      size: 40,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF08264A),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                module.description(l10n),
                style: const TextStyle(
                  fontSize: 13.5,
                  height: 1.5,
                  color: Color(0xFF475569),
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
                    backgroundColor: const Color(0xFF0284C7),
                    foregroundColor: Colors.white,
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
      ),
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
