import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../learning/models/learning_module_item.dart';
import 'deep_glass_container.dart';
import 'home_learning_tile_cover.dart';

class HomeLearningModuleTile extends StatelessWidget {
  const HomeLearningModuleTile({
    required this.module,
    required this.isCompleted,
    required this.isAmharic,
    required this.onTap,
    super.key,
  });

  final LearningModuleItem module;
  final bool isCompleted;
  final bool isAmharic;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SizedBox(
      width: 275,
      child: DeepGlassContainer(
        borderRadius: 22,
        padding: EdgeInsets.zero,
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeLearningTileCover(
              module: module,
              isCompleted: isCompleted,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      module.title(l10n),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF08264A),
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: Text(
                        module.description(l10n),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          height: 1.35,
                          color: Color(0xFF4A6277),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0F2FE),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            isAmharic ? 'ጤና ትምህርት' : 'Youth Health',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0369A1),
                            ),
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          size: 16,
                          color: Color(0xFF0284C7),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
