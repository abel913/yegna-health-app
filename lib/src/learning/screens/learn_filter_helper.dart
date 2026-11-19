import '../../../../l10n/app_localizations.dart';
import '../data/bundled_learning_modules.dart';
import '../models/learning_module_item.dart';

/// Helper for filtering curriculum modules by category and text search query.
class LearnFilterHelper {
  static List<LearningModuleItem> filter({
    required List<LearningModuleItem>? rawModules,
    required String selectedCategory,
    required String searchQuery,
    required AppLocalizations l10n,
  }) {
    final list = (rawModules != null && rawModules.isNotEmpty)
        ? rawModules
        : kLearningModules;

    return list.where((item) {
      if (selectedCategory != 'All') {
        final cat = item.category.toLowerCase();
        final sel = selectedCategory.toLowerCase();
        final matchesCat = cat.contains(sel) ||
            sel.contains(cat) ||
            (sel == 'substance' && (cat.contains('addiction') || cat.contains('drug'))) ||
            (sel == 'stis' && cat.contains('sti')) ||
            (sel == 'srh' && cat.contains('reproduct')) ||
            (sel == 'gbv' && (cat.contains('violence') || cat.contains('consent')));
        if (!matchesCat) return false;
      }

      if (searchQuery.trim().isNotEmpty) {
        final query = searchQuery.trim().toLowerCase();
        final title = item.title(l10n).toLowerCase();
        final desc = item.description(l10n).toLowerCase();
        if (!title.contains(query) && !desc.contains(query)) {
          return false;
        }
      }

      return true;
    }).toList();
  }
}
