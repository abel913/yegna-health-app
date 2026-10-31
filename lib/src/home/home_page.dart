import 'dart:ui';
import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../learning/education_repository.dart';
import '../learning/learning_models.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    required this.educationRepository,
    required this.locale,
    required this.onOpenLearning,
    required this.onOpenMentors,
    required this.onOpenFacilities,
    required this.onOpenAccount,
    required this.onOpenArticle,
    super.key,
  });

  final EducationRepository educationRepository;
  final Locale locale;
  final VoidCallback onOpenLearning;
  final VoidCallback onOpenMentors;
  final VoidCallback onOpenFacilities;
  final VoidCallback onOpenAccount;
  final ValueChanged<String> onOpenArticle;

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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

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
            top: 80,
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
            top: 320,
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
            top: 480,
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
          Positioned(
            top: 750,
            left: 10,
            child: Container(
              width: 320,
              height: 320,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Color(0x700284C7),
                    Color(0x2538BDF8),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Decorative Floating Glass Spheres
          Positioned(
            top: 60,
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
            top: 440,
            right: 30,
            child: Container(
              width: 120,
              height: 120,
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

          // Main Scrollable Area (Centered in Max-Width for Clean 2x2 Proportions)
          RefreshIndicator(
            onRefresh: _refresh,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 580),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 36),
                  children: [
                    // Brand Header Bar
                    _DeepGlassBrandHeader(
                      onOpenAccount: widget.onOpenAccount,
                      accountTitle: l10n.accountTitle,
                    ),
                    const SizedBox(height: 16),

                    // Hero Glass Welcome Card
                    _DeepGlassWelcomeCard(
                      welcomeTitle: l10n.welcomeHeroTitle,
                      welcomeBody: l10n.welcomeHeroSubtitle,
                      confidentialText: l10n.confidentialPill,
                      reviewedText: l10n.reviewedPill,
                      guestReadyText: l10n.guestReadyPill,
                      accountTitle: l10n.accountTitle,
                      onOpenAccount: widget.onOpenAccount,
                    ),
                    const SizedBox(height: 24),

                    // Section Heading: Explore
                    _GlassSectionHeader(
                      title: l10n.quickLinksHeading,
                      subtitle: l10n.quickLinksDescription,
                    ),
                    const SizedBox(height: 14),

                    // 2x2 Feature Action Cards Grid
                    GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 1.05,
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

                    // Featured Health Topics
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
                    _DeepGlassArticlesCarousel(
                      future: _articles,
                      onOpenLearning: widget.onOpenLearning,
                      onOpenArticle: widget.onOpenArticle,
                    ),
                    const SizedBox(height: 22),

                    // Discreet Health Education Disclaimer Banner
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

/// Top Brand Header Bar in Deep Glass
class _DeepGlassBrandHeader extends StatelessWidget {
  const _DeepGlassBrandHeader({
    required this.onOpenAccount,
    required this.accountTitle,
  });

  final VoidCallback onOpenAccount;
  final String accountTitle;

  @override
  Widget build(BuildContext context) {
    return _DeepGlassContainer(
      borderRadius: 24,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
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
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.65),
                width: 1.4,
              ),
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
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Yegna Health',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF08264A),
                    letterSpacing: -0.2,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Youth & Community Health',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0284C7),
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: onOpenAccount,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0284C7), Color(0xFF0369A1)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x300284C7),
                    blurRadius: 8,
                    offset: Offset(0, 3),
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
                  const SizedBox(width: 4),
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

/// Hero Welcome Card in Deep Glass
class _DeepGlassWelcomeCard extends StatelessWidget {
  const _DeepGlassWelcomeCard({
    required this.welcomeTitle,
    required this.welcomeBody,
    required this.confidentialText,
    required this.reviewedText,
    required this.guestReadyText,
    required this.accountTitle,
    required this.onOpenAccount,
  });

  final String welcomeTitle;
  final String welcomeBody;
  final String confidentialText;
  final String reviewedText;
  final String guestReadyText;
  final String accountTitle;
  final VoidCallback onOpenAccount;

  @override
  Widget build(BuildContext context) => _DeepGlassContainer(
        borderRadius: 28,
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Badge & Account Quick Link Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4.5),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFBAE6FD),
                      width: 1,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x100284C7),
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.verified_rounded,
                        size: 14,
                        color: Color(0xFF0284C7),
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Youth Health Platform',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0369A1),
                        ),
                      ),
                    ],
                  ),
                ),
                // Account Pill Button (Keeps test finding accountTitle intact)
                InkWell(
                  onTap: onOpenAccount,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 11, vertical: 4.5),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0284C7), Color(0xFF0369A1)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x2E0284C7),
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
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
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
              ],
            ),
            const SizedBox(height: 16),

            // Main Title
            Text(
              welcomeTitle,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF08264A),
                    letterSpacing: -0.5,
                  ),
            ),
            const SizedBox(height: 10),

            // Empowering Body Text
            Text(
              welcomeBody,
              style: const TextStyle(
                fontSize: 14,
                height: 1.55,
                fontWeight: FontWeight.w400,
                color: Color(0xFF1E3A54),
              ),
            ),
            const SizedBox(height: 18),

            // Three Frosted Micro Badges
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

class _GlassFeatureBadge extends StatelessWidget {
  const _GlassFeatureBadge({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5.5),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.82),
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

/// 2x2 Action Cards in Deep Frosted Glass
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
            // 3D Glass Halo Icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: iconGradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.5),
                      width: 1.4,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: iconGradient.first.withValues(alpha: 0.40),
                        blurRadius: 14,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: Colors.white, size: 26),
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
                    size: 16,
                    color: Color(0xFF0284C7),
                  ),
                ),
              ],
            ),
            const Spacer(),

            // Card Title (High Contrast, Bold)
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Color(0xFF08264A),
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 5),

            // Card Description (Comfortable reading, no truncation)
            Text(
              description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
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

/// Featured Health Articles Carousel in Deep Glass
class _DeepGlassArticlesCarousel extends StatelessWidget {
  const _DeepGlassArticlesCarousel({
    required this.future,
    required this.onOpenLearning,
    required this.onOpenArticle,
  });

  final Future<CachedValue<List<ArticlePreview>>> future;
  final VoidCallback onOpenLearning;
  final ValueChanged<String> onOpenArticle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return FutureBuilder<CachedValue<List<ArticlePreview>>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: Center(
              child: CircularProgressIndicator(color: Color(0xFF0284C7)),
            ),
          );
        }

        final articles = snapshot.data?.value.take(4).toList() ?? [];
        if (snapshot.hasError || articles.isEmpty) {
          return _DeepGlassContainer(
            borderRadius: 22,
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFE0F2FE), Color(0xFFBAE6FD)],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.menu_book_rounded,
                    color: Color(0xFF0284C7),
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.noFeaturedArticlesTitle,
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF08264A),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        l10n.noFeaturedArticlesBody,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF4A6277),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return SizedBox(
          height: 185,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: articles.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final article = articles[index];
              return SizedBox(
                width: 270,
                child: _DeepGlassContainer(
                  borderRadius: 22,
                  padding: const EdgeInsets.all(16),
                  onTap: () => onOpenArticle(article.id),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 9, vertical: 3.5),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE0F2FE),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'Education',
                              style: TextStyle(
                                fontSize: 10.5,
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
                      const Spacer(),
                      Text(
                        article.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF08264A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        article.summary,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: Color(0xFF4A6277),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
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
