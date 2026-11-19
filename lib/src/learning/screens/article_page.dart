import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../locale_controller.dart';
import '../education_repository.dart';
import '../learning_models.dart';
import '../learning_progress_controller.dart';
import 'learn_components.dart';
import 'structured_markdown.dart';

/// Screen displaying clinical educational article content, sources, and completion action.
class ArticlePage extends StatefulWidget {
  const ArticlePage({
    required this.articleId,
    required this.repository,
    required this.progressController,
    required this.localeController,
    super.key,
  });

  final String articleId;
  final EducationRepository repository;
  final LearningProgressController progressController;
  final LocaleController localeController;

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  final ScrollController _scrollController = ScrollController();
  late Future<CachedValue<EducationArticle>?> _articleFuture;
  String _locale = '';
  double _readingOffset = 0;
  bool _restoreReadingPosition = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = Localizations.localeOf(context).languageCode;
    if (_locale != locale) {
      if (_scrollController.hasClients) {
        _readingOffset = _scrollController.offset;
      }
      _locale = locale;
      _restoreReadingPosition = _readingOffset > 0;
      _articleFuture = widget.repository.article(widget.articleId, locale);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.articlesHeading),
        actions: [
          PopupMenuButton<String>(
            tooltip: l10n.selectLanguage,
            initialValue: _locale,
            onSelected: widget.localeController.setLanguage,
            itemBuilder: (context) => [
              PopupMenuItem(value: 'en', child: Text(l10n.englishLanguage)),
              PopupMenuItem(value: 'am', child: Text(l10n.amharicLanguage)),
            ],
          ),
        ],
      ),
      body: FutureBuilder<CachedValue<EducationArticle>?>(
        future: _articleFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return LearningErrorState(
              message: snapshot.error is EducationUnavailable
                  ? l10n.educationUnavailable
                  : l10n.learningLoadError,
              onRetry: () => setState(() {
                _articleFuture =
                    widget.repository.article(widget.articleId, _locale);
              }),
            );
          }
          final cached = snapshot.data;
          if (cached == null) {
            return Center(child: Text(l10n.noReviewedArticles));
          }
          final article = cached.value;
          if (_restoreReadingPosition) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted || !_scrollController.hasClients) return;
              _scrollController.jumpTo(_readingOffset.clamp(
                0,
                _scrollController.position.maxScrollExtent,
              ));
              _restoreReadingPosition = false;
            });
          }
          return ListView(
            controller: _scrollController,
            padding: const EdgeInsets.all(20),
            children: [
              if (cached.isStale)
                LearningStaleBanner(
                  date: cached.fetchedAt ?? article.reviewedAt,
                ),
              Text(article.title,
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text(article.summary,
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(l10n.articleReviewInfo(MaterialLocalizations.of(context)
                  .formatMediumDate(article.reviewedAt.toLocal()))),
              const SizedBox(height: 20),
              StructuredMarkdown(markdown: article.bodyMarkdown),
              if (article.sources.isNotEmpty) ...[
                const SizedBox(height: 24),
                Text(l10n.sourceReferences,
                    style: Theme.of(context).textTheme.titleLarge),
                ...article.sources.map((source) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.source_outlined),
                      title: Text(source.citationTitle),
                      subtitle: Text(source.publisher),
                    )),
              ],
              if (article.relatedArticles.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(l10n.relatedLearning,
                    style: Theme.of(context).textTheme.titleLarge),
                ...article.relatedArticles.map((relatedArticle) => ListTile(
                      leading: const Icon(Icons.article_outlined),
                      title: Text(relatedArticle.title),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.of(context).push<void>(
                        MaterialPageRoute<void>(
                          builder: (_) => ArticlePage(
                            articleId: relatedArticle.id,
                            repository: widget.repository,
                            progressController: widget.progressController,
                            localeController: widget.localeController,
                          ),
                        ),
                      ),
                    )),
              ],
              const SizedBox(height: 20),
              ListenableBuilder(
                listenable: widget.progressController,
                builder: (context, _) => FilledButton.icon(
                  onPressed: () async {
                    final saved = await widget.progressController
                        .markArticleComplete(article.id, article.locale);
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(saved
                          ? l10n.articleMarkedComplete
                          : l10n.learningLoadError),
                    ));
                  },
                  icon: const Icon(Icons.check_circle_outline),
                  label: Text(l10n.markArticleComplete),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
