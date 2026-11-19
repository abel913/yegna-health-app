import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../learning/models/learning_module_item.dart';

class HomeLearningTileCover extends StatelessWidget {
  const HomeLearningTileCover({
    required this.module,
    required this.isCompleted,
    super.key,
  });

  final LearningModuleItem module;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(22),
          ),
          child: Image.asset(
            module.imageAsset,
            height: 125,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              height: 125,
              color: const Color(0xFFBAE6FD),
              child: const Icon(
                Icons.image_not_supported_rounded,
                color: Color(0xFF0284C7),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 35,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.35),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 10,
          left: 10,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 3.5,
            ),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.65),
              borderRadius: BorderRadius.circular(9),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.4),
                width: 0.8,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x35000000),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              'MODULE ${module.number}',
              style: const TextStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
        if (isCompleted)
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 3.5,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF16A34A).withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(9),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x4016A34A),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    size: 11,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    l10n.completedStatus,
                    style: const TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
