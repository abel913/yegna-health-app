import 'package:flutter/material.dart';

class QuizOptionCard extends StatelessWidget {
  const QuizOptionCard({
    required this.optIdx,
    required this.optionText,
    required this.isSelected,
    required this.isReviewing,
    required this.isCorrect,
    required this.onTap,
    super.key,
  });

  final int optIdx;
  final String optionText;
  final bool isSelected;
  final bool isReviewing;
  final bool isCorrect;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final letter = String.fromCharCode(65 + optIdx);
    final isReviewCorrect = isReviewing && isCorrect;
    final isReviewWrong = isReviewing && isSelected && !isCorrect;

    Color bgColor = Colors.white;
    Color borderColor = const Color(0xFFD6E8F6);
    Color textColor = const Color(0xFF1E293B);

    if (isReviewCorrect) {
      bgColor = const Color(0xFFF0FDF4);
      borderColor = const Color(0xFF22C55E);
      textColor = const Color(0xFF15803D);
    } else if (isReviewWrong) {
      bgColor = const Color(0xFFFEF2F2);
      borderColor = const Color(0xFFEF4444);
      textColor = const Color(0xFFB91C1C);
    } else if (isSelected) {
      bgColor = const Color(0xFFF0F9FF);
      borderColor = const Color(0xFF0284C7);
      textColor = const Color(0xFF0369A1);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: borderColor,
              width: isSelected || isReviewCorrect ? 1.8 : 1.2,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isReviewCorrect
                      ? const Color(0xFF16A34A)
                      : isReviewWrong
                          ? const Color(0xFFDC2626)
                          : isSelected
                              ? const Color(0xFF0284C7)
                              : const Color(0xFFF1F5F9),
                ),
                alignment: Alignment.center,
                child: Text(
                  letter,
                  style: TextStyle(
                    color: isSelected || isReviewCorrect || isReviewWrong
                        ? Colors.white
                        : const Color(0xFF64748B),
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  optionText,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: isSelected || isReviewCorrect
                        ? FontWeight.w700
                        : FontWeight.w500,
                    color: textColor,
                    height: 1.35,
                  ),
                ),
              ),
              if (isReviewCorrect)
                const Icon(Icons.check_circle_rounded,
                    color: Color(0xFF16A34A), size: 22)
              else if (isReviewWrong)
                const Icon(Icons.cancel_rounded,
                    color: Color(0xFFDC2626), size: 22),
            ],
          ),
        ),
      ),
    );
  }
}
