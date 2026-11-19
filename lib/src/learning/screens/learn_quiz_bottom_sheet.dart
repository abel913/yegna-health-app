import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../learning_modules_carousel.dart';

class LearnQuizBottomSheet {
  const LearnQuizBottomSheet._();

  static void show(BuildContext context, LearningModuleItem module) {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                const Icon(Icons.quiz_outlined,
                    color: Color(0xFF0284C7), size: 24),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '${l10n.takeQuizButton}: ${module.title(l10n)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0B2545),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              module.description(l10n),
              style: const TextStyle(
                fontSize: 14,
                height: 1.55,
                color: Color(0xFF475569),
              ),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F9FF),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFBAE6FD)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded,
                      color: Color(0xFF0284C7), size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      l10n.moduleComingSoon,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF0369A1),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
