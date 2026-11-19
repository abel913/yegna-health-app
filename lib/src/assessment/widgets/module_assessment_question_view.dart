import 'package:flutter/material.dart';

import '../../onboarding/onboarding_survey_models.dart';
import 'module_assessment_option_tile.dart';

/// Question layout view with segmented bar, title, choices, and back/next actions.
class ModuleAssessmentQuestionView extends StatelessWidget {
  const ModuleAssessmentQuestionView({
    required this.question,
    required this.currentIndex,
    required this.totalQuestions,
    required this.selectedOption,
    required this.titleEn,
    required this.titleAm,
    required this.isDark,
    required this.isAmharic,
    required this.onSelectOption,
    required this.onNext,
    required this.onBack,
    required this.onClose,
    super.key,
  });

  final DynamicSurveyQuestion question;
  final int currentIndex;
  final int totalQuestions;
  final String? selectedOption;
  final String titleEn;
  final String titleAm;
  final bool isDark;
  final bool isAmharic;
  final ValueChanged<String> onSelectOption;
  final VoidCallback onNext;
  final VoidCallback onBack;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final currentQNumber = currentIndex + 1;
    final hasSelection = selectedOption != null && selectedOption!.isNotEmpty;

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProgressHeader(onClose),
          const SizedBox(height: 20),
          _buildBadgeAndNumber(currentQNumber),
          const SizedBox(height: 12),
          Text(
            question.localizedTitle(isAmharic),
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w800,
              height: 1.35,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isAmharic ? 'አንድ አማራጭ ብቻ ይምረጡ' : 'SELECT ONLY 1',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 18),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: question.options.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, optIdx) {
              final opt = question.options[optIdx];
              return ModuleAssessmentOptionTile(
                option: opt,
                isSelected: selectedOption == opt.value,
                isDark: isDark,
                isAmharic: isAmharic,
                onTap: () => onSelectOption(opt.value),
              );
            },
          ),
          const SizedBox(height: 24),
          _buildActionFooter(currentQNumber, hasSelection),
        ],
      ),
    );
  }

  Widget _buildProgressHeader(VoidCallback onClose) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: List.generate(totalQuestions, (idx) {
              final isCurrent = idx == currentIndex;
              final isDone = idx < currentIndex;
              return Expanded(
                child: Container(
                  height: 4,
                  margin: EdgeInsets.only(right: idx < totalQuestions - 1 ? 6 : 0),
                  decoration: BoxDecoration(
                    color: isCurrent
                        ? const Color(0xFFFF5252)
                        : (isDone ? const Color(0xFF10B981) : (isDark ? const Color(0x26FFFFFF) : const Color(0xFFE2E8F0))),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(width: 14),
        IconButton(
          onPressed: onClose,
          icon: const Icon(Icons.close_rounded, size: 18, color: Color(0xFF64748B)),
          style: IconButton.styleFrom(
            backgroundColor: isDark ? const Color(0x14FFFFFF) : const Color(0xFFF1F5F9),
            padding: const EdgeInsets.all(7),
            minimumSize: const Size(32, 32),
          ),
        ),
      ],
    );
  }

  Widget _buildBadgeAndNumber(int currentQNumber) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0x1A0284C7),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            isAmharic ? titleAm : titleEn,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0284C7)),
          ),
        ),
        Text(
          'Q.${currentQNumber.toString().padLeft(2, '0')}',
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  Widget _buildActionFooter(int currentQNumber, bool hasSelection) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (currentIndex > 0)
          TextButton(
            onPressed: onBack,
            child: Text(
              isAmharic ? 'ተመለስ' : 'Back',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              ),
            ),
          )
        else
          const SizedBox.shrink(),
        ElevatedButton(
          onPressed: hasSelection ? onNext : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: hasSelection
                ? const Color(0xFF0284C7)
                : (isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: Text(
            currentQNumber == totalQuestions ? (isAmharic ? 'አጠናቅቅ' : 'Complete') : (isAmharic ? 'ቀጣይ' : 'Next'),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
      ],
    );
  }
}
