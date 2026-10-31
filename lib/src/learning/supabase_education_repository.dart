import 'package:supabase_flutter/supabase_flutter.dart';

import 'education_repository.dart';
import 'learning_cache.dart';
import 'learning_models.dart';

class SupabaseEducationRepository implements EducationRepository {
  SupabaseEducationRepository(this._client, this._cache);

  final SupabaseClient _client;
  final LearningCache _cache;

  @override
  Future<CachedValue<List<LearningCategory>>> categories(String locale) async {
    _validateLocale(locale);
    try {
      final rows = await _client
          .from('education_category_translations')
          .select(
            'category_id,locale,name,description,category:education_categories!inner(slug,sort_order)',
          )
          .eq('locale', locale)
          .eq('publication_status', 'published')
          .eq('category.publication_status', 'published')
          .order('sort_order', referencedTable: 'category');
      final categories = rows.map((row) {
        final category = row['category'] as Map<String, dynamic>;
        return LearningCategory(
          id: row['category_id'] as String,
          slug: category['slug'] as String,
          name: row['name'] as String,
          description: row['description'] as String? ?? '',
          sortOrder: category['sort_order'] as int? ?? 0,
        );
      }).toList(growable: false);
      await _cache.write(
          'categories_$locale', categories.map(_categoryJson).toList());
      return CachedValue(
          value: categories, isStale: false, fetchedAt: DateTime.now());
    } on Object {
      final cached = await _cache.read<List<LearningCategory>>(
        'categories_$locale',
        (value) => (value as List<Object?>)
            .map((row) => _categoryFromJson(row! as Map<String, Object?>))
            .toList(growable: false),
      );
      if (cached != null) return cached;
      rethrow;
    }
  }

  @override
  Future<CachedValue<List<ArticlePreview>>> articles(String locale,
      {String? categoryId}) async {
    _validateLocale(locale);
    try {
      var query = _client
          .from('education_article_translations')
          .select(
            'article_id,locale,title,summary,article:education_articles!inner(id,slug,category_id)',
          )
          .eq('locale', locale)
          .eq('publication_status', 'published')
          .gte('review_due_at', DateTime.now().toUtc().toIso8601String());
      if (categoryId != null) {
        query = query.eq('article.category_id', categoryId);
      }
      final rows = await query.order('title').limit(1000);
      final articles = rows.map((row) {
        final article = row['article'] as Map<String, dynamic>;
        return ArticlePreview(
          id: row['article_id'] as String,
          slug: article['slug'] as String,
          categoryId: article['category_id'] as String,
          locale: locale,
          title: row['title'] as String,
          summary: row['summary'] as String? ?? '',
        );
      }).toList(growable: false);
      await _cache.write(
        'articles_${locale}_${categoryId ?? 'all'}',
        articles.map(_previewJson).toList(),
      );
      return CachedValue(
          value: articles, isStale: false, fetchedAt: DateTime.now());
    } on Object {
      final cached = await _cache.read<List<ArticlePreview>>(
        'articles_${locale}_${categoryId ?? 'all'}',
        (value) => (value as List<Object?>)
            .map((row) => _previewFromJson(row! as Map<String, Object?>))
            .toList(growable: false),
      );
      if (cached != null) return cached;
      rethrow;
    }
  }

  @override
  Future<CachedValue<EducationArticle>?> article(
      String id, String locale) async {
    _validateLocale(locale);
    try {
      final translation = await _client
          .from('education_article_translations')
          .select(
            'article_id,locale,title,summary,body_markdown,reviewed_at,review_due_at,article:education_articles!inner(id,slug,category_id)',
          )
          .eq('article_id', id)
          .eq('locale', locale)
          .eq('publication_status', 'published')
          .gte('review_due_at', DateTime.now().toUtc().toIso8601String())
          .maybeSingle();
      if (translation == null) {
        await _cache.remove('article_${locale}_$id');
        return null;
      }
      final sourceRows = await _client
          .from('education_article_sources')
          .select('citation_title,publisher,canonical_url,identifier')
          .eq('article_id', id)
          .or('locale.eq.$locale,locale.is.null')
          .order('sort_order');
      final relatedRows = await _client
          .from('education_article_relations')
          .select('related_article_id')
          .eq('article_id', id)
          .eq('locale', locale)
          .order('sort_order');
      final relatedIds = relatedRows
          .map((row) => row['related_article_id'] as String)
          .toList(growable: false);
      final relatedTitles = relatedIds.isEmpty
          ? <String, String>{}
          : {
              for (final row in await _client
                  .from('education_article_translations')
                  .select('article_id,title')
                  .inFilter('article_id', relatedIds)
                  .eq('locale', locale)
                  .eq('publication_status', 'published')
                  .gte('review_due_at',
                      DateTime.now().toUtc().toIso8601String()))
                row['article_id'] as String: row['title'] as String,
            };
      final article = translation['article'] as Map<String, dynamic>;
      final result = EducationArticle(
        id: id,
        slug: article['slug'] as String,
        categoryId: article['category_id'] as String,
        locale: locale,
        title: translation['title'] as String,
        summary: translation['summary'] as String? ?? '',
        bodyMarkdown: translation['body_markdown'] as String,
        reviewedAt: DateTime.parse(translation['reviewed_at'] as String),
        reviewDueAt: DateTime.parse(translation['review_due_at'] as String),
        sources: sourceRows
            .map((row) => ArticleSource(
                  citationTitle: row['citation_title'] as String,
                  publisher: row['publisher'] as String,
                  url: row['canonical_url'] as String?,
                  identifier: row['identifier'] as String?,
                ))
            .toList(growable: false),
        relatedArticles: relatedIds
            .where(relatedTitles.containsKey)
            .map((id) => RelatedArticle(id: id, title: relatedTitles[id]!))
            .toList(growable: false),
      );
      await _cache.write('article_${locale}_$id', result.toJson());
      return CachedValue(
          value: result, isStale: false, fetchedAt: DateTime.now());
    } on Object {
      final cached = await _cache.read<EducationArticle>(
        'article_${locale}_$id',
        (value) => EducationArticle.fromJson(
          (value! as Map<Object?, Object?>).cast<String, Object?>(),
        ),
      );
      if (cached != null) return cached;
      rethrow;
    }
  }

  void _validateLocale(String locale) {
    if (locale != 'en' && locale != 'am') {
      throw ArgumentError.value(locale, 'locale');
    }
  }

  Map<String, Object?> _categoryJson(LearningCategory category) => {
        'id': category.id,
        'slug': category.slug,
        'name': category.name,
        'description': category.description,
        'sortOrder': category.sortOrder,
      };

  LearningCategory _categoryFromJson(Map<String, Object?> row) =>
      LearningCategory(
        id: row['id']! as String,
        slug: row['slug']! as String,
        name: row['name']! as String,
        description: row['description']! as String,
        sortOrder: row['sortOrder']! as int,
      );

  Map<String, Object?> _previewJson(ArticlePreview article) => {
        'id': article.id,
        'slug': article.slug,
        'categoryId': article.categoryId,
        'locale': article.locale,
        'title': article.title,
        'summary': article.summary,
      };

  ArticlePreview _previewFromJson(Map<String, Object?> row) => ArticlePreview(
        id: row['id']! as String,
        slug: row['slug']! as String,
        categoryId: row['categoryId']! as String,
        locale: row['locale']! as String,
        title: row['title']! as String,
        summary: row['summary']! as String,
      );
}
