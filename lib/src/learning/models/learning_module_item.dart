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
    final lowerId = id.toLowerCase();
    if (lowerId.contains('01') || lowerId == 'module-01') {
      return 'assets/images/learning/module_01_puberty.jpg';
    } else if (lowerId.contains('02') || lowerId == 'module-02') {
      return 'assets/images/learning/module_02_sti.png';
    } else if (lowerId.contains('03') || lowerId == 'module-03') {
      return 'assets/images/learning/module_03_hepatitis.png';
    } else if (lowerId.contains('04') || lowerId == 'module-04') {
      return 'assets/images/learning/module_04_gbv.png';
    } else if (lowerId.contains('05') || lowerId == 'module-05') {
      return 'assets/images/learning/module_05_srh.png';
    } else if (lowerId.contains('06') || lowerId == 'module-06') {
      return 'assets/images/learning/module_06_mental_health.jpg';
    } else if (lowerId.contains('07') || lowerId == 'module-07') {
      return 'assets/images/learning/module_07_hiv.png';
    } else if (lowerId.contains('08') || lowerId == 'module-08') {
      return 'assets/images/learning/module_08_substance_abuse.png';
    }

    final cat = category.toLowerCase();
    if (cat.contains('puberty') ||
        cat.contains('adolescen') ||
        cat.contains('growth')) {
      return 'assets/images/learning/module_01_puberty.jpg';
    } else if (cat.contains('sti')) {
      return 'assets/images/learning/module_02_sti.png';
    } else if (cat.contains('hepatitis')) {
      return 'assets/images/learning/module_03_hepatitis.png';
    } else if (cat.contains('gbv') ||
        cat.contains('violence') ||
        cat.contains('consent')) {
      return 'assets/images/learning/module_04_gbv.png';
    } else if (cat.contains('srh') || cat.contains('reproduct')) {
      return 'assets/images/learning/module_05_srh.png';
    } else if (cat.contains('mental') ||
        cat.contains('stress') ||
        cat.contains('psych')) {
      return 'assets/images/learning/module_06_mental_health.jpg';
    } else if (cat.contains('hiv') || cat.contains('aids')) {
      return 'assets/images/learning/module_07_hiv.png';
    } else if (cat.contains('substance') ||
        cat.contains('addiction') ||
        cat.contains('drug')) {
      return 'assets/images/learning/module_08_substance_abuse.png';
    }
    return 'assets/images/learning/module_01_puberty.jpg';
  }

  static String normalizeImagePath(
    String? rawUrl,
    String id,
    String category,
  ) {
    if (rawUrl == null || rawUrl.trim().isEmpty) {
      return resolveImageAsset(id, category);
    }
    final trimmed = rawUrl.trim();
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }
    if (trimmed.startsWith('assets/')) {
      return trimmed;
    }
    final filename = trimmed.split('/').last.split(r'\').last;
    if (filename.isNotEmpty &&
        (filename.endsWith('.jpg') ||
            filename.endsWith('.png') ||
            filename.endsWith('.webp'))) {
      return 'assets/images/learning/$filename';
    }
    return resolveImageAsset(id, category);
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
      imageAsset: normalizeImagePath(imageUrl, id, category),
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
