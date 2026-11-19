import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

class QuizBottomBar extends StatelessWidget {
  const QuizBottomBar({
    required this.currentIndex,
    required this.isLast,
    required this.hasSelectedOption,
    required this.l10n,
    required this.onPrevious,
    required this.onNext,
    super.key,
  });

  final int currentIndex;
  final bool isLast;
  final bool hasSelectedOption;
  final AppLocalizations l10n;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        boxShadow: [
          BoxShadow(
            color: Color(0x0C003648),
            blurRadius: 12,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Circular Back Arrow Button
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(
                color: const Color(0xFFD6E4F0),
                width: 1.2,
              ),
            ),
            child: IconButton(
              style: IconButton.styleFrom(
                foregroundColor: const Color(0xFF005A71),
                shape: const CircleBorder(),
              ),
              icon: const Icon(Icons.arrow_back_rounded, size: 22),
              onPressed: currentIndex > 0 ? onPrevious : null,
            ),
          ),
          const SizedBox(width: 14),

          // Large Floating Action Pill
          Expanded(
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: hasSelectedOption
                    ? const Color(0xFF0284C7)
                    : const Color(0xFF90B9DE),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: const StadiumBorder(),
                elevation: 0,
              ),
              onPressed: onNext,
              child: Row(
                children: [
                  const Spacer(),
                  Text(
                    isLast ? l10n.finishQuizBtn : l10n.nextQuestionBtn,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 34,
                    height: 34,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      size: 18,
                      color: hasSelectedOption
                          ? const Color(0xFF0284C7)
                          : const Color(0xFF90B9DE),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
