import 'package:flutter/material.dart';

import '../models/assessment_result_data.dart';

/// Top card presenting the clinical outcome assessment result.
class AssessmentResultHeaderCard extends StatelessWidget {
  const AssessmentResultHeaderCard({
    required this.resultData,
    required this.isDark,
    required this.isAmharic,
    super.key,
  });

  final AssessmentResultData resultData;
  final bool isDark;
  final bool isAmharic;

  @override
  Widget build(BuildContext context) {
    final isHighRisk = resultData.tier == AssessmentRiskTier.higherRisk;
    final iconBg = isHighRisk
        ? const Color(0xFFFEF3C7)
        : const Color(0xFFE0F2FE);
    final iconColor = isHighRisk
        ? const Color(0xFFD97706)
        : const Color(0xFF0284C7);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                Icons.info_outline_rounded,
                color: iconColor,
                size: 26,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isAmharic ? 'የምዘና ውጤት' : 'Assessment Result',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  resultData.localizedHeadline(isAmharic),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.2,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
