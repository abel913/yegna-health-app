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

  Future<CachedValue<List<ArticlePreview>>> _loadArticles() =>
      widget.educationRepository.articles(widget.locale.languageCode);

  Future<void> _refresh() async {
    setState(() => _articles = _loadArticles());
    await _articles;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
        children: [
          _SafetyBanner(text: l10n.healthEducationBoundary),
          const SizedBox(height: 12),
          _WelcomeCard(
            title: l10n.welcomeTitle,
            body: l10n.welcomeBody,
            onOpenAccount: widget.onOpenAccount,
            accountLabel: l10n.accountTitle,
          ),
          const SizedBox(height: 22),
          _SectionHeading(
            title: l10n.quickLinksHeading,
            subtitle: l10n.quickLinksDescription,
          ),
          const SizedBox(height: 10),
          LayoutBuilder(builder: (context, constraints) {
            final columns = constraints.maxWidth > 560 ? 4 : 2;
            return GridView.count(
              crossAxisCount: columns,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: columns == 2 ? 1.32 : 1.08,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _ShortcutCard(
                  icon: Icons.menu_book_rounded,
                  label: l10n.learnTab,
                  color: const Color(0xFFDBF2F8),
                  onTap: widget.onOpenLearning,
                ),
                _ShortcutCard(
                  icon: Icons.local_hospital_outlined,
                  label: l10n.facilitiesTab,
                  color: const Color(0xFFE4E9FF),
                  onTap: widget.onOpenFacilities,
                ),
                _ShortcutCard(
                  icon: Icons.people_alt_outlined,
                  label: l10n.mentorsTab,
                  color: const Color(0xFFD9F7EA),
                  onTap: widget.onOpenMentors,
                ),
                _ShortcutCard(
                  icon: Icons.account_circle_outlined,
                  label: l10n.accountTitle,
                  color: const Color(0xFFEAEAFF),
                  onTap: widget.onOpenAccount,
                ),
              ],
            );
          }),
          const SizedBox(height: 22),
          _SectionHeading(
            title: l10n.featuredArticlesHeading,
            action: TextButton(
              onPressed: widget.onOpenLearning,
              child: Text(l10n.viewAllAction),
            ),
          ),
          const SizedBox(height: 8),
          _FeaturedArticles(
            future: _articles,
            onOpenLearning: widget.onOpenLearning,
            onOpenArticle: widget.onOpenArticle,
          ),
          const SizedBox(height: 24),
          _SectionHeading(title: l10n.homeFaqHeading),
          const SizedBox(height: 8),
          _EmptyInfoCard(
            icon: Icons.help_outline_rounded,
            title: l10n.noReviewedFaqsTitle,
            body: l10n.noReviewedFaqsBody,
          ),
          const SizedBox(height: 16),
          Material(
            color: const Color(0xFF005A71),
            borderRadius: BorderRadius.circular(24),
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: widget.onOpenFacilities,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(children: [
                  const Icon(Icons.health_and_safety_outlined,
                      color: Colors.white, size: 34),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.findVerifiedCare,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: Colors.white)),
                        const SizedBox(height: 4),
                        Text(l10n.facilitiesNotAvailableBody,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Colors.white70)),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_rounded, color: Colors.white),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SafetyBanner extends StatelessWidget {
  const _SafetyBanner({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFE5F1F2),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(children: [
          const Icon(Icons.verified_user_outlined, color: Color(0xFF00695C)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: const Color(0xFF00695C),
                    )),
          ),
        ]),
      );
}

class _WelcomeCard extends StatelessWidget {
  const _WelcomeCard({
    required this.title,
    required this.body,
    required this.onOpenAccount,
    required this.accountLabel,
  });
  final String title;
  final String body;
  final VoidCallback onOpenAccount;
  final String accountLabel;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFFFFF), Color(0xFFE3F5FA)],
            begin: AlignmentDirectional.topStart,
            end: AlignmentDirectional.bottomEnd,
          ),
          borderRadius: BorderRadius.circular(22),
          boxShadow: const [
            BoxShadow(
              color: Color(0x12005A71),
              blurRadius: 18,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.eco_outlined, color: Color(0xFF007A78), size: 28),
            const SizedBox(height: 12),
            Text(title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    )),
            const SizedBox(height: 8),
            Text(body, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: onOpenAccount,
              icon: const Icon(Icons.person_outline),
              label: Text(accountLabel),
            ),
          ],
        ),
      );
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title, this.subtitle, this.action});
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
                Text(title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        )),
                if (subtitle != null) ...[
                  const SizedBox(height: 3),
                  Text(subtitle!, style: Theme.of(context).textTheme.bodySmall),
                ],
              ],
            ),
          ),
          if (action != null) action!,
        ],
      );
}

class _ShortcutCard extends StatelessWidget {
  const _ShortcutCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(13),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: color,
                  child: Icon(icon, color: const Color(0xFF005A71)),
                ),
                Text(label,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        )),
                const Icon(Icons.arrow_forward_rounded,
                    size: 20, color: Color(0xFF005A71)),
              ],
            ),
          ),
        ),
      );
}

class _FeaturedArticles extends StatelessWidget {
  const _FeaturedArticles({
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
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return _EmptyInfoCard(
            icon: Icons.menu_book_outlined,
            title: l10n.noFeaturedArticlesTitle,
            body: l10n.noFeaturedArticlesBody,
            action: TextButton(
              onPressed: onOpenLearning,
              child: Text(l10n.learnTab),
            ),
          );
        }
        final articles = snapshot.data!.value.take(3).toList();
        if (articles.isEmpty) {
          return _EmptyInfoCard(
            icon: Icons.menu_book_outlined,
            title: l10n.noFeaturedArticlesTitle,
            body: l10n.noFeaturedArticlesBody,
            action: TextButton(
              onPressed: onOpenLearning,
              child: Text(l10n.learnTab),
            ),
          );
        }
        return SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: articles.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final article = articles[index];
              return SizedBox(
                width: 280,
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () => onOpenArticle(article.id),
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.auto_stories_outlined,
                              color: Color(0xFF007A78), size: 28),
                          const Spacer(),
                          Text(article.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w700)),
                          const SizedBox(height: 6),
                          Text(article.summary,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ),
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

class _EmptyInfoCard extends StatelessWidget {
  const _EmptyInfoCard({
    required this.icon,
    required this.title,
    required this.body,
    this.action,
  });
  final IconData icon;
  final String title;
  final String body;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: const Color(0xFF005A71)),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(body, style: Theme.of(context).textTheme.bodySmall),
                    if (action != null) action!,
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
