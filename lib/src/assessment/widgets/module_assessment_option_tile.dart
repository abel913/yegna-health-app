import 'package:flutter/material.dart';

import '../../onboarding/onboarding_survey_models.dart';

/// Single selectable option card inside the Module Assessment dialog.
class ModuleAssessmentOptionTile extends StatelessWidget {
  const ModuleAssessmentOptionTile({
    required this.option,
    required this.isSelected,
    required this.isDark,
    required this.isAmharic,
    required this.onTap,
    super.key,
  });

  final DynamicSurveyOption option;
  final bool isSelected;
  final bool isDark;
  final bool isAmharic;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark
                    ? const Color(0xFF0284C7).withValues(alpha: 0.15)
                    : const Color(0xFFF0F9FF))
                : (isDark
                    ? Colors.white.withValues(alpha: 0.04)
                    : const Color(0xFFF8FAFC)),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF0284C7)
                  : (isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : const Color(0xFFE2E8F0)),
              width: isSelected ? 1.8 : 1.2,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF0284C7)
                        : const Color(0xFF94A3B8),
                    width: 2,
                  ),
                  color: isSelected ? const Color(0xFF0284C7) : Colors.transparent,
                ),
                child: isSelected
                    ? const Center(
                        child: Icon(Icons.check, size: 14, color: Colors.white),
                      )
                    : null,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  option.localizedLabel(isAmharic),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? (isDark ? Colors.white : const Color(0xFF0284C7))
                        : (isDark ? const Color(0xFFE2E8F0) : const Color(0xFF334155)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
