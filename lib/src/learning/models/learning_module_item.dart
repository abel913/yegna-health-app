import '../../../l10n/app_localizations.dart';

class LearningModuleItem {
  const LearningModuleItem({
    required this.id,
    required this.number,
    required this.title,
    required this.description,
    required this.imageAsset,
    required this.illustrationOnTop,
    this.category = 'srh',
    this.contentEn = '',
    this.contentAm = '',
    this.readTimeMin = 4,
    this.authorName,
  });

  final String id;
  final String number;
  final String Function(AppLocalizations) title;
  final String Function(AppLocalizations) description;
  final String imageAsset;
  final bool illustrationOnTop;
  final String category;
  final String contentEn;
  final String contentAm;
  final int readTimeMin;
  final String? authorName;

  static String resolveImageAsset(String id, String category) {
    switch (id) {
      case 'module-01':
        return 'assets/images/learning/module_01_puberty.jpg';
      case 'module-02':
        return 'assets/images/learning/module_02_sti.png';
      case 'module-03':
        return 'assets/images/learning/module_03_hepatitis.png';
      case 'module-04':
        return 'assets/images/learning/module_04_gbv.png';
      case 'module-05':
        return 'assets/images/learning/module_05_srh.png';
      case 'module-06':
        return 'assets/images/learning/module_06_mental_health.jpg';
      case 'module-07':
        return 'assets/images/learning/module_07_hiv.png';
      case 'module-08':
        return 'assets/images/learning/module_08_substance_abuse.png';
    }

    final cat = category.toLowerCase();
    if (cat.contains('puberty')) {
      return 'assets/images/learning/module_01_puberty.jpg';
    } else if (cat.contains('sti')) {
      return 'assets/images/learning/module_02_sti.png';
    } else if (cat.contains('hepatitis')) {
      return 'assets/images/learning/module_03_hepatitis.png';
    } else if (cat.contains('gbv') || cat.contains('violence') || cat.contains('consent')) {
      return 'assets/images/learning/module_04_gbv.png';
    } else if (cat.contains('srh') || cat.contains('reproduct')) {
      return 'assets/images/learning/module_05_srh.png';
    } else if (cat.contains('mental') || cat.contains('stress')) {
      return 'assets/images/learning/module_06_mental_health.jpg';
    } else if (cat.contains('hiv') || cat.contains('aids')) {
      return 'assets/images/learning/module_07_hiv.png';
    } else if (cat.contains('substance') || cat.contains('addiction')) {
      return 'assets/images/learning/module_08_substance_abuse.png';
    }
    return 'assets/images/learning/module_05_srh.png';
  }

  factory LearningModuleItem.fromMap(Map<String, dynamic> data, int index) {
    final id = data['id']?.toString() ?? 'module-${index + 1}';
    final number = (index + 1).toString().padLeft(2, '0');
    final titleEn = data['titleEn']?.toString() ?? '';
    final titleAm = data['titleAm']?.toString() ?? '';
    final summaryEn = data['summaryEn']?.toString() ?? '';
    final summaryAm = data['summaryAm']?.toString() ?? '';
    final category = data['category']?.toString() ?? 'srh';
    final imageUrl = data['imageUrl']?.toString();

    return LearningModuleItem(
      id: id,
      number: number,
      title: (l10n) {
        final isAmharic = l10n.localeName.startsWith('am');
        if (isAmharic && titleAm.isNotEmpty) return titleAm;
        if (titleEn.isNotEmpty) return titleEn;
        return _fallbackTitle(id, l10n);
      },
      description: (l10n) {
        final isAmharic = l10n.localeName.startsWith('am');
        if (isAmharic && summaryAm.isNotEmpty) return summaryAm;
        if (summaryEn.isNotEmpty) return summaryEn;
        return _fallbackDescription(id, l10n);
      },
      imageAsset: (imageUrl != null && imageUrl.isNotEmpty)
          ? imageUrl
          : resolveImageAsset(id, category),
      illustrationOnTop: index % 2 == 0,
      category: category,
      contentEn: data['contentEn']?.toString() ?? '',
      contentAm: data['contentAm']?.toString() ?? '',
      readTimeMin: (data['readTimeMin'] as num?)?.toInt() ?? 4,
      authorName: data['authorName']?.toString(),
    );
  }

  static String _fallbackTitle(String id, AppLocalizations l10n) {
    switch (id) {
      case 'module-01':
        return l10n.module01Title;
      case 'module-02':
        return l10n.module02Title;
      case 'module-03':
        return l10n.module03Title;
      case 'module-04':
        return l10n.module04Title;
      case 'module-05':
        return l10n.module05Title;
      case 'module-06':
        return l10n.module06Title;
      case 'module-07':
        return l10n.module07Title;
      case 'module-08':
        return l10n.module08Title;
      default:
        return 'Youth Health Module';
    }
  }

  static String _fallbackDescription(String id, AppLocalizations l10n) {
    switch (id) {
      case 'module-01':
        return l10n.module01Desc;
      case 'module-02':
        return l10n.module02Desc;
      case 'module-03':
        return l10n.module03Desc;
      case 'module-04':
        return l10n.module04Desc;
      case 'module-05':
        return l10n.module05Desc;
      case 'module-06':
        return l10n.module06Desc;
      case 'module-07':
        return l10n.module07Desc;
      case 'module-08':
        return l10n.module08Desc;
      default:
        return '';
    }
  }
}
