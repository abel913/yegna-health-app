import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../../models/learning_module_item.dart';
import '../../widgets/common/module_cover_image.dart';

/// Top hero card for dynamic modules displaying cover image, title, and author.
class DynamicModuleHeroCard extends StatelessWidget {
  const DynamicModuleHeroCard({
    required this.module,
    required this.l10n,
    super.key,
  });

  final LearningModuleItem module;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFBAE6FD),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0284C7).withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Center(
              child: ModuleCoverImage(
                imagePath: module.imageAsset,
                fallbackCategory: module.category,
                height: 195,
                fit: BoxFit.contain,
                iconSize: 48,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            module.title(l10n),
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w800,
              color: Color(0xFF08264A),
              letterSpacing: -0.3,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            module.description(l10n),
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF475569),
              height: 1.55,
            ),
          ),
          if (module.authorName != null && module.authorName!.isNotEmpty) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                const Icon(
                  Icons.verified_user_outlined,
                  size: 15,
                  color: Color(0xFF0284C7),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    module.authorName!,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0369A1),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
