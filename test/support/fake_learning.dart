import 'package:yegna_health_app/src/learning/assessment_repository.dart';
import 'package:yegna_health_app/src/learning/education_repository.dart';
import 'package:yegna_health_app/src/learning/learning_models.dart';
import 'package:yegna_health_app/src/learning/progress_repository.dart';

class FakeEducationRepository implements EducationRepository {
  final category = const LearningCategory(
    id: 'category-1',
    slug: 'general',
    name: 'General',
    description: '',
    sortOrder: 0,
  );

  EducationArticle articleFor(String locale) => EducationArticle(
        id: 'article-1',
        slug: 'test-article',
        categoryId: category.id,
        locale: locale,
        title: locale == 'am' ? 'የሙከራ ጽሑፍ' : 'Test article',
        summary: locale == 'am' ? 'የሙከራ ማጠቃለያ' : 'Test summary',
        bodyMarkdown: locale == 'am' ? 'የሙከራ ጽሑፍ አካል።' : 'Test article body.',
        reviewedAt: DateTime.utc(2026, 1, 1),
        reviewDueAt: DateTime.utc(2027, 1, 1),
        sources: const [
          ArticleSource(
              citationTitle: 'Test reference', publisher: 'Test publisher'),
        ],
        relatedArticles: const [],
      );

  @override
  Future<CachedValue<List<LearningCategory>>> categories(String locale) async =>
      CachedValue(value: [category], isStale: false, fetchedAt: DateTime.now());

  @override
  Future<CachedValue<List<ArticlePreview>>> articles(
    String locale, {
    String? categoryId,
  }) async =>
      CachedValue(
        value: [
          ArticlePreview(
            id: 'article-1',
            slug: 'test-article',
            categoryId: category.id,
            locale: locale,
            title: locale == 'am' ? 'የሙከራ ጽሑፍ' : 'Test article',
            summary: locale == 'am' ? 'የሙከራ ማጠቃለያ' : 'Test summary',
          ),
        ],
        isStale: false,
        fetchedAt: DateTime.now(),
      );

  @override
  Future<CachedValue<EducationArticle>?> article(
          String id, String locale) async =>
      CachedValue(
        value: articleFor(locale),
        isStale: false,
        fetchedAt: DateTime.now(),
      );
}

class FakeAssessmentRepository implements AssessmentRepository {
  final summary = const AssessmentSummary(
    id: 'assessment-1',
    versionId: 'version-1',
    slug: 'test-assessment',
    locale: 'en',
    title: 'Test assessment',
    description: 'Test only; contains no health advice.',
    version: 1,
  );

  Assessment get assessmentData => Assessment(
        summary: summary,
        questions: const [
          AssessmentQuestion(
            id: 'question-1',
            prompt: 'Test question one?',
            options: [
              AssessmentOption(id: 'option-1a', label: 'Choice one'),
              AssessmentOption(id: 'option-1b', label: 'Choice two'),
            ],
          ),
          AssessmentQuestion(
            id: 'question-2',
            prompt: 'Test question two?',
            options: [
              AssessmentOption(id: 'option-2a', label: 'Choice three'),
              AssessmentOption(id: 'option-2b', label: 'Choice four'),
            ],
          ),
        ],
      );

  int submissionCount = 0;
  final List<PendingAssessmentSubmission> pending = [];
  AssessmentSubmission? retryResult;

  @override
  Future<List<AssessmentSummary>> assessments(String locale) async => [summary];

  @override
  Future<CachedValue<Assessment>?> assessment(
          String versionId, String locale) async =>
      CachedValue(
          value: assessmentData, isStale: false, fetchedAt: DateTime.now());

  @override
  Future<List<PendingAssessmentSubmission>> pendingSubmissions() async =>
      List.of(pending);

  @override
  Future<AssessmentSubmission> submit({
    required Assessment assessment,
    required Map<String, String> selectedOptions,
    required bool syncProgress,
  }) async {
    submissionCount++;
    final details = assessment.questions.map((question) {
      final correctOption = question.options.first;
      return QuestionResult(
        questionId: question.id,
        selectedOptionId: selectedOptions[question.id]!,
        correctOptionId: correctOption.id,
        isCorrect: selectedOptions[question.id] == correctOption.id,
        explanation: 'Test explanation.',
      );
    }).toList();
    final score = details.where((item) => item.isCorrect).length;
    return AssessmentSubmission.completed(
      AssessmentResult(
        score: score,
        totalQuestions: details.length,
        details: details,
        synchronized: syncProgress,
      ),
      requestId: 'test-request-$submissionCount',
    );
  }

  @override
  Future<AssessmentSubmission?> retryPending(String requestId) async {
    final result = retryResult;
    if (result != null && !result.isPending) {
      pending.removeWhere((item) => item.requestId == requestId);
    }
    return result;
  }
}

class FakeLearningProgressStore implements LearningProgressStore {
  final Map<String, LearningProgress> _progressByUser = {};
  bool? lastSyncChoice;
  int clearCalls = 0;

  @override
  Future<LearningProgress> load(String? userId) async =>
      _progressByUser[userId ?? 'guest'] ??
      const LearningProgress(syncEnabled: false, articles: [], attempts: []);

  @override
  Future<bool> setSyncEnabled(String? userId, bool enabled) async {
    if (userId == null) return false;
    lastSyncChoice = enabled;
    final current = await load(userId);
    _progressByUser[userId] = LearningProgress(
      syncEnabled: enabled,
      articles: current.articles,
      attempts: current.attempts,
    );
    return true;
  }

  @override
  Future<void> markArticleCompleted({
    required String? userId,
    required String articleId,
    required String locale,
    required bool syncEnabled,
  }) async {
    final key = userId ?? 'guest';
    final current = await load(userId);
    _progressByUser[key] = LearningProgress(
      syncEnabled: current.syncEnabled,
      articles: [
        ...current.articles,
        ArticleCompletion(
          articleId: articleId,
          locale: locale,
          completedAt: DateTime.utc(2026),
        ),
      ],
      attempts: current.attempts,
    );
  }

  @override
  Future<void> recordAttempt({
    required String? userId,
    required String requestId,
    required String versionId,
    required String locale,
    required int score,
    required int totalQuestions,
  }) async {
    final key = userId ?? 'guest';
    final current = await load(userId);
    _progressByUser[key] = LearningProgress(
      syncEnabled: current.syncEnabled,
      articles: current.articles,
      attempts: [
        ...current.attempts,
        LearningAttempt(
          requestId: requestId,
          versionId: versionId,
          locale: locale,
          score: score,
          totalQuestions: totalQuestions,
          completedAt: DateTime.utc(2026),
        ),
      ],
    );
  }

  @override
  Future<void> clearSynchronizedHistory(String userId) async {
    clearCalls++;
  }
}
