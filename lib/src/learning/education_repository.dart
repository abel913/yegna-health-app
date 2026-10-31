import 'learning_models.dart';

abstract interface class EducationRepository {
  Future<CachedValue<List<LearningCategory>>> categories(String locale);
  Future<CachedValue<List<ArticlePreview>>> articles(String locale,
      {String? categoryId});
  Future<CachedValue<EducationArticle>?> article(String id, String locale);
}

class EducationUnavailable implements Exception {
  const EducationUnavailable();
}

class EducationNotFound implements Exception {
  const EducationNotFound();
}

class UnconfiguredEducationRepository implements EducationRepository {
  const UnconfiguredEducationRepository();

  @override
  Future<CachedValue<List<LearningCategory>>> categories(String locale) async =>
      throw const EducationUnavailable();

  @override
  Future<CachedValue<List<ArticlePreview>>> articles(String locale,
          {String? categoryId}) async =>
      throw const EducationUnavailable();

  @override
  Future<CachedValue<EducationArticle>?> article(
          String id, String locale) async =>
      throw const EducationUnavailable();
}
