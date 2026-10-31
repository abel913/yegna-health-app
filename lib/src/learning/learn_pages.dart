import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../locale_controller.dart';
import 'assessment_repository.dart';
import 'education_repository.dart';
import 'learning_models.dart';
import 'learning_progress_controller.dart';

class LearnPage extends StatefulWidget {
  const LearnPage({
    required this.educationRepository,
    required this.assessmentRepository,
    required this.progressController,
    required this.localeController,
    super.key,
  });

  final EducationRepository educationRepository;
  final AssessmentRepository assessmentRepository;
  final LearningProgressController progressController;
  final LocaleController localeController;

  @override
  State<LearnPage> createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage> {
  late Future<_LibraryData> _libraryFuture;
  String _locale = '';
  String? _selectedCategory;
  String _search = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = Localizations.localeOf(context).languageCode;
    if (_locale != locale) {
      _locale = locale;
      _libraryFuture = _loadLibrary(locale);
    }
  }

  Future<_LibraryData> _loadLibrary(String locale) async {
    final values = await Future.wait([
      widget.educationRepository.categories(locale),
      widget.educationRepository.articles(locale),
    ]);
    return _LibraryData(
      categories: values[0] as CachedValue<List<LearningCategory>>,
      articles: values[1] as CachedValue<List<ArticlePreview>>,
    );
  }

  void _reload() => setState(() => _libraryFuture = _loadLibrary(_locale));

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 12, 20, 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l10n.learningHeading,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text(l10n.learningIntroduction,
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 8),
                ListenableBuilder(
                  listenable: widget.progressController,
                  builder: (context, _) {
                    final progress = widget.progressController.progress;
                    return Card(
                      color: const Color(0xFFF0F2FF),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(l10n.learningProgressTitle,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w700)),
                            const SizedBox(height: 8),
                            if (widget.progressController.isLoading)
                              const LinearProgressIndicator()
                            else
                              Wrap(
                                spacing: 10,
                                runSpacing: 8,
                                children: [
                                  _ProgressPill(
                                    icon: Icons.menu_book_outlined,
                                    label: l10n.completedArticlesCount(
                                        progress?.articles.length ?? 0),
                                  ),
                                  _ProgressPill(
                                    icon: Icons.quiz_outlined,
                                    label: l10n.assessmentAttemptsCount(
                                        progress?.attempts.length ?? 0),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Material(
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(16),
              child: TabBar(
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(13),
                ),
                labelColor: Colors.white,
                unselectedLabelColor:
                    Theme.of(context).colorScheme.onSurfaceVariant,
                labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                tabs: [
                  Tab(text: l10n.articlesHeading),
                  Tab(text: l10n.assessmentsHeading),
                  Tab(text: l10n.progressHeading),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildArticles(context),
                _AssessmentList(
                  repository: widget.assessmentRepository,
                  progressController: widget.progressController,
                  locale: _locale,
                ),
                LearningProgressPage(
                  controller: widget.progressController,
                  assessmentRepository: widget.assessmentRepository,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticles(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return FutureBuilder<_LibraryData>(
      future: _libraryFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return _ErrorState(
            message: snapshot.error is EducationUnavailable
                ? l10n.educationUnavailable
                : l10n.learningLoadError,
            onRetry: _reload,
          );
        }
        final data = snapshot.requireData;
        final categories = data.categories.value;
        final visible = data.articles.value.where((article) {
          final matchesCategory = _selectedCategory == null ||
              article.categoryId == _selectedCategory;
          final query = _search.trim().toLowerCase();
          final matchesSearch = query.isEmpty ||
              article.title.toLowerCase().contains(query) ||
              article.summary.toLowerCase().contains(query);
          return matchesCategory && matchesSearch;
        }).toList(growable: false);
        return RefreshIndicator(
          onRefresh: () async => _reload(),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (data.categories.isStale || data.articles.isStale)
                _StaleBanner(date: data.articles.fetchedAt ?? DateTime.now()),
              TextField(
                decoration: InputDecoration(
                  labelText: l10n.searchArticles,
                  prefixIcon: const Icon(Icons.search),
                  border: const OutlineInputBorder(),
                ),
                onChanged: (value) => setState(() => _search = value),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.only(end: 8),
                      child: ChoiceChip(
                        label: Text(l10n.allCategories),
                        selected: _selectedCategory == null,
                        onSelected: (_) =>
                            setState(() => _selectedCategory = null),
                      ),
                    ),
                    for (final category in categories)
                      Padding(
                        padding: const EdgeInsetsDirectional.only(end: 8),
                        child: ChoiceChip(
                          label: Text(category.name),
                          selected: _selectedCategory == category.id,
                          onSelected: (_) =>
                              setState(() => _selectedCategory = category.id),
                        ),
                      ),
                  ],
                ),
              ),
              if (visible.isEmpty)
                Card(
                  color: Theme.of(context).colorScheme.surfaceContainerLow,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 26),
                    child: Column(
                      children: [
                        Icon(Icons.menu_book_outlined,
                            size: 30,
                            color: Theme.of(context).colorScheme.primary),
                        const SizedBox(height: 10),
                        Text(
                          _search.isEmpty && _selectedCategory == null
                              ? l10n.noReviewedArticles
                              : l10n.noSearchResults,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                )
              else
                ...visible.map((article) => Card(
                      child: ListTile(
                        leading: const Icon(Icons.menu_book_outlined),
                        title: Text(article.title),
                        subtitle: Text(article.summary),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => _openArticle(article.id),
                      ),
                    )),
            ],
          ),
        );
      },
    );
  }

  void _openArticle(String id) {
    Navigator.of(context).push<void>(MaterialPageRoute<void>(
      builder: (_) => ArticlePage(
        articleId: id,
        repository: widget.educationRepository,
        progressController: widget.progressController,
        localeController: widget.localeController,
      ),
    ));
  }
}

class _LibraryData {
  const _LibraryData({required this.categories, required this.articles});
  final CachedValue<List<LearningCategory>> categories;
  final CachedValue<List<ArticlePreview>> articles;
}

class _ProgressPill extends StatelessWidget {
  const _ProgressPill({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsetsDirectional.fromSTEB(10, 7, 10, 7),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: const Color(0xFF005A71)),
            const SizedBox(width: 8),
            Text(label, style: Theme.of(context).textTheme.labelMedium),
          ],
        ),
      );
}

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
            return _ErrorState(
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
                _StaleBanner(date: cached.fetchedAt ?? article.reviewedAt),
              Text(article.title,
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text(article.summary,
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(l10n.articleReviewInfo(MaterialLocalizations.of(context)
                  .formatMediumDate(article.reviewedAt.toLocal()))),
              const SizedBox(height: 20),
              _StructuredMarkdown(markdown: article.bodyMarkdown),
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

class _StructuredMarkdown extends StatelessWidget {
  const _StructuredMarkdown({required this.markdown});
  final String markdown;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final blocks = markdown.split(RegExp(r'\r?\n\s*\r?\n'));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: blocks.map((block) {
        final text = block.trim();
        if (text.isEmpty) return const SizedBox.shrink();
        final heading = RegExp(r'^(#{1,3})\s+(.+)$').firstMatch(text);
        if (heading != null) {
          final style = heading.group(1)!.length == 1
              ? theme.textTheme.headlineSmall
              : theme.textTheme.titleLarge;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(heading.group(2)!, style: style),
          );
        }
        if (text.split('\n').every(
            (line) => RegExp(r'^\s*(?:[-*]|\d+[.)])\s+').hasMatch(line))) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: text.split('\n').map((line) {
              final content = line.replaceFirst(
                RegExp(r'^\s*(?:[-*]|\d+[.)])\s+'),
                '',
              );
              return Padding(
                padding: const EdgeInsetsDirectional.only(start: 12, bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('•  '),
                    Expanded(child: Text(content)),
                  ],
                ),
              );
            }).toList(),
          );
        }
        // Render text as plain Flutter text: raw HTML is never interpreted.
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(text, style: theme.textTheme.bodyLarge),
        );
      }).toList(),
    );
  }
}

class _AssessmentList extends StatefulWidget {
  const _AssessmentList({
    required this.repository,
    required this.progressController,
    required this.locale,
  });
  final AssessmentRepository repository;
  final LearningProgressController progressController;
  final String locale;

  @override
  State<_AssessmentList> createState() => _AssessmentListState();
}

class _AssessmentListState extends State<_AssessmentList> {
  late Future<List<AssessmentSummary>> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.repository.assessments(widget.locale);
  }

  @override
  void didUpdateWidget(covariant _AssessmentList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.locale != widget.locale) {
      _future = widget.repository.assessments(widget.locale);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return FutureBuilder<List<AssessmentSummary>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return _ErrorState(
            message: snapshot.error is AssessmentUnavailable
                ? l10n.educationUnavailable
                : l10n.learningLoadError,
            onRetry: () => setState(
                () => _future = widget.repository.assessments(widget.locale)),
          );
        }
        final assessments = snapshot.data ?? const <AssessmentSummary>[];
        if (assessments.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child:
                  Text(l10n.noReviewedAssessments, textAlign: TextAlign.center),
            ),
          );
        }
        return ListView(
          padding: const EdgeInsets.all(16),
          children: assessments
              .map((summary) => Card(
                    child: ListTile(
                      title: Text(summary.title),
                      subtitle: Text(summary.description),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.of(context).push<void>(
                        MaterialPageRoute<void>(
                          builder: (_) => AssessmentSessionPage(
                            summary: summary,
                            repository: widget.repository,
                            progressController: widget.progressController,
                          ),
                        ),
                      ),
                    ),
                  ))
              .toList(),
        );
      },
    );
  }
}

class AssessmentSessionPage extends StatefulWidget {
  const AssessmentSessionPage({
    required this.summary,
    required this.repository,
    required this.progressController,
    super.key,
  });
  final AssessmentSummary summary;
  final AssessmentRepository repository;
  final LearningProgressController progressController;

  @override
  State<AssessmentSessionPage> createState() => _AssessmentSessionPageState();
}

class _AssessmentSessionPageState extends State<AssessmentSessionPage> {
  late Future<CachedValue<Assessment>?> _future;
  final Map<String, String> _answers = {};
  int _questionIndex = 0;
  Assessment? _assessment;
  bool _contentIsStale = false;
  DateTime? _fetchedAt;
  AssessmentSubmission? _submission;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _future = widget.repository
        .assessment(widget.summary.versionId, widget.summary.locale);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(widget.summary.title)),
      body: FutureBuilder<CachedValue<Assessment>?>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || snapshot.data == null) {
            return _ErrorState(
              message: snapshot.hasError
                  ? l10n.learningLoadError
                  : l10n.educationUnavailable,
              onRetry: () => setState(() {
                _future = widget.repository.assessment(
                    widget.summary.versionId, widget.summary.locale);
              }),
            );
          }
          final cachedAssessment = snapshot.data;
          if (cachedAssessment == null ||
              cachedAssessment.value.questions.isEmpty) {
            return _ErrorState(
              message: l10n.educationUnavailable,
              onRetry: () => setState(() {
                _future = widget.repository.assessment(
                  widget.summary.versionId,
                  widget.summary.locale,
                );
              }),
            );
          }
          _contentIsStale = cachedAssessment.isStale;
          _fetchedAt = cachedAssessment.fetchedAt;
          _assessment = cachedAssessment.value;
          final submission = _submission;
          if (submission != null) {
            return _resultView(submission, _assessment!, l10n);
          }
          final assessment = _assessment!;
          final question = assessment.questions[_questionIndex];
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              if (_contentIsStale)
                _StaleBanner(
                  date: cachedAssessment.fetchedAt ?? DateTime.now(),
                ),
              Text(l10n.questionProgress(
                _questionIndex + 1,
                assessment.questions.length,
              )),
              const SizedBox(height: 20),
              Text(question.prompt,
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              IgnorePointer(
                ignoring: _submitting,
                child: RadioGroup<String>(
                  groupValue: _answers[question.id],
                  onChanged: (value) => setState(() {
                    if (!_submitting && value != null) {
                      _answers[question.id] = value;
                    }
                  }),
                  child: Column(
                    children: question.options
                        .map((option) => RadioListTile<String>(
                              value: option.id,
                              title: Text(option.label),
                            ))
                        .toList(growable: false),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed:
                    _submitting ? null : () => _continue(assessment, l10n),
                child: _submitting
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(_questionIndex == assessment.questions.length - 1
                        ? l10n.submitAnswers
                        : l10n.nextQuestion),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _continue(Assessment assessment, AppLocalizations l10n) async {
    final question = assessment.questions[_questionIndex];
    if (!_answers.containsKey(question.id)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.selectAnAnswer)),
      );
      return;
    }
    if (_questionIndex < assessment.questions.length - 1) {
      setState(() => _questionIndex++);
      return;
    }
    setState(() => _submitting = true);
    try {
      final submission = await widget.repository.submit(
        assessment: assessment,
        selectedOptions: _answers,
        syncProgress: widget.progressController.syncEnabled &&
            widget.progressController.isAuthenticated,
      );
      if (!mounted) return;
      setState(() => _submission = submission);
      final result = submission.result;
      if (result != null) {
        await widget.progressController.recordAttempt(
          requestId: submission.requestId,
          versionId: assessment.summary.versionId,
          locale: assessment.summary.locale,
          score: result.score,
          totalQuestions: result.totalQuestions,
        );
      }
    } on Object {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.assessmentSubmitError)),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Widget _resultView(
    AssessmentSubmission submission,
    Assessment assessment,
    AppLocalizations l10n,
  ) {
    final result = submission.result;
    if (result == null) {
      return ListView(
        padding: const EdgeInsets.all(24),
        children: [
          if (_contentIsStale) _StaleBanner(date: _fetchedAt ?? DateTime.now()),
          const Icon(Icons.cloud_off_outlined, size: 48),
          const SizedBox(height: 16),
          Text(l10n.pendingScore, textAlign: TextAlign.center),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: _submitting ? null : () => _retry(submission.requestId),
            icon: const Icon(Icons.refresh),
            label: Text(l10n.retryAction),
          ),
          TextButton(
            onPressed: _retake,
            child: Text(l10n.retakeAssessment),
          ),
        ],
      );
    }
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        if (_contentIsStale) _StaleBanner(date: _fetchedAt ?? DateTime.now()),
        Text(
            l10n.assessmentResult(
              result.score,
              result.totalQuestions,
              result.percentage,
            ),
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        ...result.details.map((detail) {
          final question = assessment.questions.firstWhere(
            (item) => item.id == detail.questionId,
          );
          final correctOption = question.options.firstWhere(
            (item) => item.id == detail.correctOptionId,
          );
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(question.prompt,
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text('${l10n.correctAnswer}: ${correctOption.label}'),
                  if (detail.explanation.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(l10n.answerExplanation,
                        style: Theme.of(context).textTheme.labelLarge),
                    Text(detail.explanation),
                  ],
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: _retake,
          child: Text(l10n.retakeAssessment),
        ),
      ],
    );
  }

  Future<void> _retry(String requestId) async {
    setState(() => _submitting = true);
    final result = await widget.repository.retryPending(requestId);
    if (!mounted) return;
    if (result != null) {
      setState(() => _submission = result);
      final score = result.result;
      if (score != null) {
        await widget.progressController.recordAttempt(
          requestId: result.requestId,
          versionId: widget.summary.versionId,
          locale: widget.summary.locale,
          score: score.score,
          totalQuestions: score.totalQuestions,
        );
      }
    }
    setState(() => _submitting = false);
  }

  void _retake() {
    setState(() {
      _answers.clear();
      _questionIndex = 0;
      _submission = null;
    });
  }
}

class LearningProgressPage extends StatelessWidget {
  const LearningProgressPage({
    required this.controller,
    required this.assessmentRepository,
    super.key,
  });
  final LearningProgressController controller;
  final AssessmentRepository assessmentRepository;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final progress = controller.progress;
        if (controller.isLoading && progress == null) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.loadError != null && progress == null) {
          return _ErrorState(
            message: l10n.learningLoadError,
            onRetry: controller.refresh,
          );
        }
        final articles = progress?.articles ?? const [];
        final attempts = progress?.attempts ?? const [];
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.progressSyncTitle,
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(l10n.progressSyncDescription),
                    const SizedBox(height: 8),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      title: Text(controller.syncEnabled
                          ? l10n.progressSyncEnabled
                          : l10n.progressSyncDisabled),
                      value: controller.syncEnabled,
                      onChanged:
                          controller.isAuthenticated && !controller.isBusy
                              ? (value) => _setSync(context, value)
                              : null,
                    ),
                    if (!controller.isAuthenticated)
                      Text(l10n.progressSyncSignInRequired),
                    if (controller.isAuthenticated)
                      OutlinedButton.icon(
                        onPressed: controller.isBusy
                            ? null
                            : () => _clearHistory(context),
                        icon: const Icon(Icons.delete_outline),
                        label: Text(l10n.clearSyncedHistory),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.phone_android),
              title: Text(l10n.localProgressLabel),
              subtitle: Text(l10n.completedArticlesCount(articles.length)),
            ),
            ListTile(
              leading: const Icon(Icons.quiz_outlined),
              title: Text(l10n.scoreHistoryLabel),
              subtitle: Text(l10n.assessmentAttemptsCount(attempts.length)),
            ),
            _PendingSubmissionList(
              repository: assessmentRepository,
              progressController: controller,
            ),
            if (articles.isEmpty && attempts.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Center(child: Text(l10n.noLearningProgress)),
              ),
            ...attempts.map((attempt) => ListTile(
                  leading: const Icon(Icons.task_alt),
                  title: Text(l10n.assessmentScorePercent(
                    attempt.totalQuestions == 0
                        ? 0
                        : attempt.score * 100 ~/ attempt.totalQuestions,
                  )),
                  subtitle: Text(MaterialLocalizations.of(context)
                      .formatMediumDate(attempt.completedAt.toLocal())),
                )),
          ],
        );
      },
    );
  }

  Future<void> _setSync(BuildContext context, bool enabled) async {
    final l10n = AppLocalizations.of(context);
    final changed = await controller.setSyncEnabled(enabled);
    if (!context.mounted) return;
    if (!changed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.progressSyncError)),
      );
    }
  }

  Future<void> _clearHistory(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.clearSyncedHistoryTitle),
        content: Text(l10n.clearSyncedHistoryBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancelAction),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.clearHistoryAction),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    final cleared = await controller.clearSyncedHistory();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content:
          Text(cleared ? l10n.syncedHistoryCleared : l10n.clearHistoryError),
    ));
  }
}

class _PendingSubmissionList extends StatefulWidget {
  const _PendingSubmissionList({
    required this.repository,
    required this.progressController,
  });

  final AssessmentRepository repository;
  final LearningProgressController progressController;

  @override
  State<_PendingSubmissionList> createState() => _PendingSubmissionListState();
}

class _PendingSubmissionListState extends State<_PendingSubmissionList> {
  late Future<List<PendingAssessmentSubmission>> _pending;
  final Set<String> _retrying = {};

  @override
  void initState() {
    super.initState();
    _pending = widget.repository.pendingSubmissions();
  }

  Future<void> _retry(PendingAssessmentSubmission pending) async {
    setState(() => _retrying.add(pending.requestId));
    try {
      final submission =
          await widget.repository.retryPending(pending.requestId);
      final result = submission?.result;
      if (result != null) {
        await widget.progressController.recordAttempt(
          requestId: submission!.requestId,
          versionId: pending.versionId,
          locale: pending.locale,
          score: result.score,
          totalQuestions: result.totalQuestions,
        );
      }
    } on Object {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context).assessmentSubmitError),
        ));
      }
    } finally {
      if (mounted) {
        setState(() {
          _retrying.remove(pending.requestId);
          _pending = widget.repository.pendingSubmissions();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) =>
      FutureBuilder<List<PendingAssessmentSubmission>>(
        future: _pending,
        builder: (context, snapshot) {
          final pending = snapshot.data ?? const [];
          if (pending.isEmpty) return const SizedBox.shrink();
          final l10n = AppLocalizations.of(context);
          return Column(
            children: pending
                .map((item) => ListTile(
                      leading: const Icon(Icons.cloud_upload_outlined),
                      title: Text(l10n.pendingScore),
                      trailing: TextButton(
                        onPressed: _retrying.contains(item.requestId)
                            ? null
                            : () => _retry(item),
                        child: _retrying.contains(item.requestId)
                            ? const SizedBox.square(
                                dimension: 18,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Text(l10n.retryAction),
                      ),
                    ))
                .toList(),
          );
        },
      );
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Card(
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    child: Icon(Icons.cloud_off_outlined,
                        size: 28, color: Theme.of(context).colorScheme.primary),
                  ),
                  const SizedBox(height: 12),
                  Text(message,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh),
                    label: Text(AppLocalizations.of(context).retryAction),
                  ),
                ]),
              ),
            ),
          ),
        ),
      );
}

class _StaleBanner extends StatelessWidget {
  const _StaleBanner({required this.date});
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final dateString = MaterialLocalizations.of(context).formatMediumDate(date);
    return Card(
      color: Theme.of(context).colorScheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
            AppLocalizations.of(context).staleSavedContentWarning(dateString)),
      ),
    );
  }
}
