import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../dynamic_quiz_helper.dart';
import 'quiz_option_card.dart';

class QuizQuestionCard extends StatelessWidget {
  const QuizQuestionCard({
    required this.question,
    required this.selectedOption,
    required this.isReviewing,
    required this.l10n,
    required this.onOptionSelected,
    super.key,
  });

  final QuizQuestionModel question;
  final int? selectedOption;
  final bool isReviewing;
  final AppLocalizations l10n;
  final ValueChanged<int> onOptionSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: const Color(0xFFD6E8F6),
              width: 1.4,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0A005A71),
                blurRadius: 16,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            question.questionText(l10n),
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: Color(0xFF08264A),
              height: 1.4,
              letterSpacing: -0.2,
            ),
          ),
        ),
        const SizedBox(height: 18),
        ...List.generate(question.options.length, (optIdx) {
          return QuizOptionCard(
            optIdx: optIdx,
            optionText: question.options[optIdx](l10n),
            isSelected: selectedOption == optIdx,
            isReviewing: isReviewing,
            isCorrect: optIdx == question.correctIndex,
            onTap: isReviewing ? null : () => onOptionSelected(optIdx),
          );
        }),
        if (isReviewing) ...[
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFBBF7D0),
                width: 1.2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.lightbulb_rounded,
                        color: Color(0xFF16A34A), size: 18),
                    const SizedBox(width: 8),
                    Text(
                      l10n.educationalInsight,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF166534),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  question.insight(l10n),
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF1E293B),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
