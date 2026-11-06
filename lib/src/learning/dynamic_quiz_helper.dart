import '../../l10n/app_localizations.dart';
import '../sync/offline_sync_store.dart';

/// Unified model for module quiz questions supporting both True/False and Multiple Choice formats.
class QuizQuestionModel {
  const QuizQuestionModel({
    required this.id,
    required this.category,
    required this.questionText,
    required this.options,
    required this.correctIndex,
    required this.insight,
  });

  final String id;
  final String Function(AppLocalizations) category;
  final String Function(AppLocalizations) questionText;
  final List<String Function(AppLocalizations)> options;
  final int correctIndex;
  final String Function(AppLocalizations) insight;
}

/// Helper that resolves module quiz questions from the local synced cache.
/// Preserves Zero-Knowledge student privacy by resolving and evaluating questions locally.
class DynamicQuizHelper {
  const DynamicQuizHelper._();

  /// Loads questions from the offline cache for a specific module ID and category.
  /// If matching cached questions exist, converts them to [QuizQuestionModel].
  /// Otherwise returns null so the caller falls back to bundled questions.
  static Future<List<QuizQuestionModel>?> loadFromCache({
    required String moduleId,
    required String category,
  }) async {
    try {
      final store = OfflineSyncStore();
      final rawList = await store.getCachedQuizzes();
      if (rawList == null || rawList.isEmpty) return null;

      final targetModId = moduleId.toLowerCase().trim();
      final targetCategory = category.toLowerCase().trim();

      final matched = rawList.where((item) {
        final itemModId = item['moduleId']?.toString().toLowerCase().trim() ?? '';
        final modInfo = item['module'] as Map<String, dynamic>?;
        final itemCategory = modInfo?['category']?.toString().toLowerCase().trim() ?? '';

        return itemModId == targetModId ||
            itemCategory == targetCategory ||
            itemModId == targetCategory ||
            (targetModId.isNotEmpty && itemModId.contains(targetModId)) ||
            (targetCategory.isNotEmpty && itemCategory.contains(targetCategory));
      }).toList();

      if (matched.isEmpty) return null;

      final results = <QuizQuestionModel>[];
      for (final raw in matched) {
        final id = raw['id']?.toString() ?? '';
        final qEn = raw['questionEn']?.toString() ?? '';
        final qAm = raw['questionAm']?.toString() ?? '';
        final optsEn = (raw['optionsEn'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [];
        final optsAm = (raw['optionsAm'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [];
        final correctIdx = (raw['correctIndex'] as num?)?.toInt() ?? 0;
        final expEn = raw['explanationEn']?.toString() ?? '';
        final expAm = raw['explanationAm']?.toString() ?? '';
        final modInfo = raw['module'] as Map<String, dynamic>?;
        final titleEn = modInfo?['titleEn']?.toString() ?? '';
        final titleAm = modInfo?['titleAm']?.toString() ?? '';

        if (qEn.isEmpty && qAm.isEmpty) continue;
        if (optsEn.isEmpty && optsAm.isEmpty) continue;

        final optionCount = optsEn.isNotEmpty ? optsEn.length : optsAm.length;
        final options = List.generate(optionCount, (idx) {
          return (AppLocalizations l10n) {
            final isAm = l10n.localeName.startsWith('am');
            if (isAm && idx < optsAm.length && optsAm[idx].isNotEmpty) {
              return optsAm[idx];
            }
            if (idx < optsEn.length && optsEn[idx].isNotEmpty) {
              return optsEn[idx];
            }
            return isAm ? 'አማራጭ ${idx + 1}' : 'Option ${idx + 1}';
          };
        });

        results.add(QuizQuestionModel(
          id: id,
          category: (l10n) {
            final isAm = l10n.localeName.startsWith('am');
            if (isAm && titleAm.isNotEmpty) return titleAm;
            if (titleEn.isNotEmpty) return titleEn;
            return category;
          },
          questionText: (l10n) {
            final isAm = l10n.localeName.startsWith('am');
            if (isAm && qAm.isNotEmpty) return qAm;
            if (qEn.isNotEmpty) return qEn;
            return qAm;
          },
          options: options,
          correctIndex: correctIdx < options.length ? correctIdx : 0,
          insight: (l10n) {
            final isAm = l10n.localeName.startsWith('am');
            if (isAm && expAm.isNotEmpty) return expAm;
            if (expEn.isNotEmpty) return expEn;
            return expAm;
          },
        ));
      }

      return results.isNotEmpty ? results : null;
    } catch (_) {
      return null;
    }
  }
}
