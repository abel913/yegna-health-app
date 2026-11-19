import '../models/education_article.dart';

void validateEducationLocale(String locale) {
  if (locale != 'en' && locale != 'am') {
    throw ArgumentError.value(locale, 'locale');
  }
}

Map<String, Object?> categoryToJson(LearningCategory category) => {
      'id': category.id,
      'slug': category.slug,
      'name': category.name,
      'description': category.description,
      'sortOrder': category.sortOrder,
    };

LearningCategory categoryFromJson(Map<String, Object?> row) => LearningCategory(
      id: row['id']! as String,
      slug: row['slug']! as String,
      name: row['name']! as String,
      description: row['description']! as String,
      sortOrder: row['sortOrder']! as int,
    );

Map<String, Object?> previewToJson(ArticlePreview article) => {
      'id': article.id,
      'slug': article.slug,
      'categoryId': article.categoryId,
      'locale': article.locale,
      'title': article.title,
      'summary': article.summary,
    };

ArticlePreview previewFromJson(Map<String, Object?> row) => ArticlePreview(
      id: row['id']! as String,
      slug: row['slug']! as String,
      categoryId: row['categoryId']! as String,
      locale: row['locale']! as String,
      title: row['title']! as String,
      summary: row['summary']! as String,
    );
