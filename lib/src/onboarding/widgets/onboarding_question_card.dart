import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../onboarding_survey_models.dart';
import 'onboarding_survey_option_tile.dart';

/// Survey question display card featuring progress indicator, dynamic options, and navigation buttons.
class OnboardingQuestionCard extends StatelessWidget {
  const OnboardingQuestionCard({
    required this.question,
    required this.currentIndex,
    required this.totalQuestions,
    required this.selectedAnswers,
    required this.isSubmitting,
    required this.canProceed,
    required this.isDark,
    required this.onSelectAnswer,
    required this.onNext,
    required this.onBack,
    required this.onSkip,
    super.key,
  });

  final DynamicSurveyQuestion question;
  final int currentIndex;
  final int totalQuestions;
  final Map<String, String> selectedAnswers;
  final bool isSubmitting;
  final bool canProceed;
  final bool isDark;
  final void Function(String questionId, String value) onSelectAnswer;
  final VoidCallback onNext;
  final VoidCallback onBack;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isAmharic = Localizations.localeOf(context).languageCode == 'am';

    return Column(
      key: ValueKey<int>(currentIndex),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTopRow(isDark),
        const SizedBox(height: 20),
        Text(
          l10n.onboardingSurveyQuestionNumber('0${currentIndex + 1}'),
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.4,
            fontFamily: 'monospace',
            color: Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          question.localizedTitle(isAmharic),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            height: 1.3,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          question.type == 'MULTI_CHOICE'
              ? 'SELECT ALL THAT APPLY'
              : l10n.onboardingSurveySelectOnlyOne,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            fontFamily: 'monospace',
            color: Color(0xFF94A3B8),
          ),
        ),
        const SizedBox(height: 10),
        ...question.options.map((opt) {
          final isSelected = selectedAnswers[question.id] == opt.value;
          return OnboardingSurveyOptionTile(
            code: opt.value,
            label: opt.localizedLabel(isAmharic),
            isSelected: isSelected,
            onSelect: (val) => onSelectAnswer(question.id, val),
            isDark: isDark,
          );
        }),
        const SizedBox(height: 24),
        _buildBottomNav(l10n, isDark),
      ],
    );
  }

  Widget _buildTopRow(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: List.generate(totalQuestions, (index) {
              final isPassed = index <= currentIndex;
              return Expanded(
                child: Container(
                  height: 4.5,
                  margin: EdgeInsets.only(right: index < totalQuestions - 1 ? 6 : 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    gradient: isPassed
                        ? const LinearGradient(colors: [Color(0xFFFF7A59), Color(0xFFFF5252)])
                        : null,
                    color: isPassed
                        ? null
                        : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                  ),
                ),
              );
            }),
          ),
        ),
        InkWell(
          onTap: onSkip,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.close_rounded,
              size: 18,
              color: isDark ? Colors.white70 : const Color(0xFF64748B),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNav(AppLocalizations l10n, bool isDark) {
    final isLast = currentIndex == totalQuestions - 1;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: currentIndex > 0 ? onBack : null,
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF64748B),
            disabledForegroundColor: Colors.transparent,
            textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          child: Text(currentIndex > 0 ? l10n.onboardingSurveyBack : ''),
        ),
        ElevatedButton(
          onPressed: canProceed && !isSubmitting ? onNext : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: isDark ? Colors.white : const Color(0xFF0F172A),
            foregroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
            disabledBackgroundColor: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
            disabledForegroundColor: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 13),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          child: isSubmitting && isLast
              ? SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: isDark ? const Color(0xFF0F172A) : Colors.white,
                  ),
                )
              : Text(
                  isLast ? l10n.onboardingSurveyFinish : l10n.onboardingSurveyNext,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
        ),
      ],
    );
  }
}
