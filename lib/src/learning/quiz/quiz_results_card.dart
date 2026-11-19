import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

class QuizResultsCard extends StatelessWidget {
  const QuizResultsCard({
    required this.score,
    required this.total,
    required this.l10n,
    required this.onReview,
    required this.onRetake,
    required this.onReturn,
    super.key,
  });

  final int score;
  final int total;
  final AppLocalizations l10n;
  final VoidCallback onReview;
  final VoidCallback onRetake;
  final VoidCallback onReturn;

  @override
  Widget build(BuildContext context) {
    final percent = total > 0 ? ((score / total) * 100).round() : 0;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Celebration Trophy & Halo
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFBAE6FD),
                  width: 3,
                ),
              ),
              child: const Icon(
                Icons.emoji_events_rounded,
                color: Color(0xFF0284C7),
                size: 52,
              ),
            ),
            const SizedBox(height: 20),

            Text(
              l10n.quizScoreCelebration,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Color(0xFF08264A),
              ),
            ),
            const SizedBox(height: 8),

            Text(
              l10n.quizScoreSummary(score, total, percent),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF475569),
              ),
            ),
            const SizedBox(height: 28),

            // Review Answers Button
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF0284C7),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(Icons.check_circle_outline_rounded, size: 20),
                label: Text(
                  l10n.reviewAnswersBtn,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                onPressed: onReview,
              ),
            ),
            const SizedBox(height: 12),

            // Retake Quiz Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF005A71),
                  side: const BorderSide(color: Color(0xFF005A71), width: 1.4),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(Icons.refresh_rounded, size: 20),
                label: Text(
                  l10n.retakeQuizBtn,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                onPressed: onRetake,
              ),
            ),
            const SizedBox(height: 12),

            // Return to Lesson Button
            TextButton(
              onPressed: onReturn,
              child: Text(
                l10n.returnToLesson,
                style: const TextStyle(
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
