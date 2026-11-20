import 'dart:async';
import 'package:flutter/foundation.dart';

import '../../content/content_templates.dart';
import '../../sync/api_client.dart';
import '../../sync/offline_sync_store.dart';
import '../education_repository.dart';
import '../models/assessment_models.dart';
import '../models/education_article.dart';
import '../models/learning_module_item.dart';
import 'sync_education_defaults.dart';

class SyncEducationRepository extends ChangeNotifier
    implements EducationRepository {
  SyncEducationRepository({
    required OfflineSyncStore store,
    ApiClient? apiClient,
  })  : _store = store,
        _apiClient = apiClient;

  final OfflineSyncStore _store;
  final ApiClient? _apiClient;

  @override
  Future<CachedValue<List<LearningCategory>>> categories(String locale) async {
    final list = locale.startsWith('am')
        ? SyncEducationDefaults.fallbackCategoriesAm
        : SyncEducationDefaults.fallbackCategoriesEn;
    return CachedValue(
      value: list,
      isStale: false,
      fetchedAt: DateTime.now(),
    );
  }

  @override
  Future<CachedValue<List<ArticlePreview>>> articles(
    String locale, {
    String? categoryId,
  }) async {
    final isAmharic = locale.startsWith('am');
    var rawModules = await _store.getCachedModules();

    if (rawModules == null && !(await _store.hasSynced('modules'))) {
      final templates = ContentTemplates.moduleTemplates;
      rawModules = templates
          .map((m) => {
                'id': m.id,
                'titleEn': m.titleEn,
                'titleAm': m.titleAm,
                'summaryEn': m.descriptionEn,
                'summaryAm': m.descriptionAm,
                'category': 'puberty',
              })
          .toList();
      unawaited(_store.saveModules(rawModules));
    }
    rawModules ??= [];

    if (_apiClient != null) {
      unawaited(_revalidateModules());
    }

    final previews = <ArticlePreview>[];
    for (final m in rawModules) {
      final id = m['id']?.toString() ?? 'mod_0';
      final title = isAmharic
          ? (m['titleAm'] as String? ?? m['titleEn'] as String? ?? 'ሞጁል')
          : (m['titleEn'] as String? ?? 'Module');
      final summary = isAmharic
          ? (m['summaryAm'] as String? ?? m['summaryEn'] as String? ?? '')
          : (m['summaryEn'] as String? ?? '');
      final cat = m['category'] as String? ?? 'cat_puberty';

      if (categoryId == null ||
          cat.toLowerCase().contains(categoryId.toLowerCase())) {
        previews.add(ArticlePreview(
          id: id,
          slug: id,
          categoryId: cat,
          locale: locale,
          title: title,
          summary: summary,
        ));
      }
    }

    return CachedValue(
      value: previews,
      isStale: false,
      fetchedAt: DateTime.now(),
    );
  }

  @override
  Future<CachedValue<EducationArticle>?> article(
    String id,
    String locale,
  ) async {
    final isAmharic = locale.startsWith('am');
    final rawModules = await _store.getCachedModules() ?? [];

    Map<String, dynamic>? match;
    for (final m in rawModules) {
      if (m['id']?.toString() == id) {
        match = m;
        break;
      }
    }

    match ??= SyncEducationDefaults.findTemplateModule(id);
    if (match == null) return null;

    final title = isAmharic
        ? (match['titleAm'] as String? ?? match['titleEn'] as String? ?? '')
        : (match['titleEn'] as String? ?? '');
    final summary = isAmharic
        ? (match['summaryAm'] as String? ?? match['summaryEn'] as String? ?? '')
        : (match['summaryEn'] as String? ?? '');
    final bodyMarkdown = isAmharic
        ? (match['contentAm'] as String? ??
            match['contentEn'] as String? ??
            summary)
        : (match['contentEn'] as String? ?? summary);

    final article = EducationArticle(
      id: id,
      slug: id,
      categoryId: match['category'] as String? ?? 'cat_puberty',
      locale: locale,
      title: title,
      summary: summary,
      bodyMarkdown: bodyMarkdown,
      reviewedAt: DateTime.now().subtract(const Duration(days: 7)),
      reviewDueAt: DateTime.now().add(const Duration(days: 90)),
      sources: const [
        ArticleSource(
          citationTitle: 'Adolescent Health & Development Guidelines',
          publisher: 'Ministry of Health & WHO Ethiopia',
        ),
      ],
    );

    return CachedValue(
      value: article,
      isStale: false,
      fetchedAt: DateTime.now(),
    );
  }

  Future<List<LearningModuleItem>> getCurriculumModuleItems({
    bool forceRefresh = false,
  }) async {
    if (forceRefresh && _apiClient != null) {
      await _revalidateModules();
    } else if (_apiClient != null) {
      unawaited(_revalidateModules());
    }

    final raw = await _store.getCachedModules();
    final hasSynced = await _store.hasSynced('modules');
    return SyncEducationDefaults.parseCurriculumItems(raw, hasSynced);
  }

  Future<void> refresh() async {
    await _revalidateModules();
  }

  Future<void> _revalidateModules() async {
    try {
      final remoteList = await _apiClient?.fetchModules();
      final remoteQuizzes = await _apiClient?.fetchQuizzes();
      bool changed = false;

      if (remoteList != null) {
        await _store.saveModules(remoteList);
        changed = true;
      }
      if (remoteQuizzes != null) {
        await _store.saveQuizzes(remoteQuizzes);
        changed = true;
      }
      if (changed) {
        notifyListeners();
      }
    } catch (_) {}
  }
}
