import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

class CurriculumActionButtons extends StatelessWidget {
  const CurriculumActionButtons({
    required this.isCompleted,
    required this.l10n,
    required this.onMarkCompleted,
    required this.onTakeQuiz,
    this.assessmentCard,
    super.key,
  });

  final bool isCompleted;
  final AppLocalizations l10n;
  final VoidCallback onMarkCompleted;
  final VoidCallback onTakeQuiz;
  final Widget? assessmentCard;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 14),
        if (isCompleted)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFA5D6A7)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle_rounded,
                    color: Color(0xFF2E7D32), size: 20),
                const SizedBox(width: 8),
                Text(
                  l10n.completedStatus,
                  style: const TextStyle(
                    color: Color(0xFF1B5E20),
                    fontWeight: FontWeight.w700,
                    fontSize: 14.5,
                  ),
                ),
              ],
            ),
          )
        else
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF16A34A),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(Icons.check_circle_outline_rounded),
              label: Text(
                l10n.markCompleted,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              onPressed: onMarkCompleted,
            ),
          ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF005A71),
              side: const BorderSide(
                color: Color(0xFF005A71),
                width: 1.4,
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            icon: const Icon(Icons.quiz_outlined),
            label: Text(
              l10n.takeQuizButton,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
            onPressed: onTakeQuiz,
          ),
        ),
        if (assessmentCard != null) ...[
          const SizedBox(height: 14),
          assessmentCard!,
        ],
      ],
    );
  }
}
