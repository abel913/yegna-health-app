class ModuleSectionDraft {
  const ModuleSectionDraft({
    required this.titleEn,
    required this.titleAm,
    required this.contentEn,
    required this.contentAm,
    required this.order,
  });

  final String titleEn;
  final String titleAm;
  final String contentEn;
  final String contentAm;
  final int order;
}

class ModuleDraft {
  const ModuleDraft({
    required this.id,
    required this.titleEn,
    required this.titleAm,
    required this.descriptionEn,
    required this.descriptionAm,
    required this.iconAsset,
    required this.estimatedReadTimeMinutes,
    required this.sections,
  });

  final String id;
  final String titleEn;
  final String titleAm;
  final String descriptionEn;
  final String descriptionAm;
  final String iconAsset;
  final int estimatedReadTimeMinutes;
  final List<ModuleSectionDraft> sections;
}

class QuestionOptionDraft {
  const QuestionOptionDraft({
    required this.id,
    required this.labelEn,
    required this.labelAm,
    required this.isCorrect,
  });

  final String id;
  final String labelEn;
  final String labelAm;
  final bool isCorrect;
}

class QuestionDraft {
  const QuestionDraft({
    required this.id,
    required this.quizId,
    required this.promptEn,
    required this.promptAm,
    required this.options,
    required this.explanationEn,
    required this.explanationAm,
  });

  final String id;
  final String quizId;
  final String promptEn;
  final String promptAm;
  final List<QuestionOptionDraft> options;
  final String explanationEn;
  final String explanationAm;
}

class ArticleDraft {
  const ArticleDraft({
    required this.id,
    required this.titleEn,
    required this.titleAm,
    required this.summaryEn,
    required this.summaryAm,
    required this.bodyMarkdownEn,
    required this.bodyMarkdownAm,
    required this.authorName,
    required this.category,
    required this.sources,
  });

  final String id;
  final String titleEn;
  final String titleAm;
  final String summaryEn;
  final String summaryAm;
  final String bodyMarkdownEn;
  final String bodyMarkdownAm;
  final String authorName;
  final String category;
  final List<String> sources;
}
