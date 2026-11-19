import '../../content/content_templates.dart';
import '../data/bundled_learning_modules.dart';
import '../models/education_article.dart';
import '../models/learning_module_item.dart';

class SyncEducationDefaults {
  const SyncEducationDefaults._();

  static const List<LearningCategory> fallbackCategoriesEn = [
    LearningCategory(
      id: 'cat_puberty',
      slug: 'puberty',
      name: 'Puberty & Growth',
      description: 'Physical and emotional changes during adolescence.',
      sortOrder: 1,
    ),
    LearningCategory(
      id: 'cat_srh',
      slug: 'srh',
      name: 'Reproductive Health',
      description: 'Safe practices, anatomy, contraception, and hygiene.',
      sortOrder: 2,
    ),
    LearningCategory(
      id: 'cat_mental',
      slug: 'mental-health',
      name: 'Mental Health & Wellness',
      description: 'Stress management, self-esteem, and peer counseling.',
      sortOrder: 3,
    ),
    LearningCategory(
      id: 'cat_substance',
      slug: 'substance-free',
      name: 'Substance-Free Living',
      description: 'Overcoming peer pressure and youth addiction prevention.',
      sortOrder: 4,
    ),
  ];

  static const List<LearningCategory> fallbackCategoriesAm = [
    LearningCategory(
      id: 'cat_puberty',
      slug: 'puberty',
      name: 'ጉርምስና እና እድገት',
      description: 'በአፍላ እድሜ ወቅት የሚከሰቱ አካላዊ እና ስሜታዊ ለውጦች።',
      sortOrder: 1,
    ),
    LearningCategory(
      id: 'cat_srh',
      slug: 'srh',
      name: 'የስነ-ተዋልዶ ጤና',
      description: 'ደህንነቱ የተጠበቀ አኗኗር፣ የሰውነት አካል እና ንጽህና አያያዝ።',
      sortOrder: 2,
    ),
    LearningCategory(
      id: 'cat_mental',
      slug: 'mental-health',
      name: 'የአእምሮ ጤና እና ደህንነት',
      description: 'የጭንቀት አያያዝ፣ በራስ መተማመን እና የአቻ ድጋፍ።',
      sortOrder: 3,
    ),
    LearningCategory(
      id: 'cat_substance',
      slug: 'substance-free',
      name: 'ከሱስ የጸዳ ህይወት',
      description: 'የአቻ ግፊትን መቋቋም እና ከጎጂ ሱሶች ራስን መጠበቅ።',
      sortOrder: 4,
    ),
  ];

  static Map<String, dynamic>? findTemplateModule(String id) {
    for (final tm in ContentTemplates.moduleTemplates) {
      if (tm.id == id) {
        return {
          'id': tm.id,
          'titleEn': tm.titleEn,
          'titleAm': tm.titleAm,
          'summaryEn': tm.descriptionEn,
          'summaryAm': tm.descriptionAm,
          'contentEn': tm.sections
              .map((s) => '## ${s.titleEn}\n\n${s.contentEn}')
              .join('\n\n'),
          'contentAm': tm.sections
              .map((s) => '## ${s.titleAm}\n\n${s.contentAm}')
              .join('\n\n'),
          'category': 'puberty',
        };
      }
    }
    return null;
  }

  static List<LearningModuleItem> parseCurriculumItems(
    List<Map<String, dynamic>>? raw,
    bool hasSynced,
  ) {
    if (raw == null && !hasSynced) {
      return kLearningModules;
    }

    final published =
        (raw ?? []).where((m) => m['isPublished'] != false).toList();
    if (published.isEmpty && !hasSynced) {
      return kLearningModules;
    }

    published.sort((a, b) {
      final aIndex = (a['orderIndex'] as num?)?.toInt() ?? 0;
      final bIndex = (b['orderIndex'] as num?)?.toInt() ?? 0;
      return aIndex.compareTo(bIndex);
    });

    final items = <LearningModuleItem>[];
    for (int i = 0; i < published.length; i++) {
      items.add(LearningModuleItem.fromMap(published[i], i));
    }
    return items;
  }
}
