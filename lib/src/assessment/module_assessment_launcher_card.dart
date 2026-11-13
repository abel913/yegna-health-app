import 'package:flutter/material.dart';

import 'module_assessment_dialog.dart';

/// Interactive card embedded inside learning modules promoting the official
/// University of Gondar SRHR Self-Assessment section matching that module.
/// Tapping it launches the stacked-card modal assessment dialog.
class ModuleAssessmentLauncherCard extends StatelessWidget {
  const ModuleAssessmentLauncherCard({
    required this.sectionNumber,
    required this.sectionKey,
    required this.moduleKey,
    required this.titleEn,
    required this.titleAm,
    required this.questionRangeTextEn,
    required this.questionRangeTextAm,
    this.badgeColor = const Color(0xFF0284C7),
    this.onCompleted,
    super.key,
  });

  final int sectionNumber;
  final String sectionKey;
  final String moduleKey;
  final String titleEn;
  final String titleAm;
  final String questionRangeTextEn;
  final String questionRangeTextAm;
  final Color badgeColor;
  final VoidCallback? onCompleted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isAmharic = Localizations.localeOf(context).languageCode == 'am';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: badgeColor.withValues(alpha: isDark ? 0.3 : 0.25),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: badgeColor.withValues(alpha: isDark ? 0.15 : 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            ModuleAssessmentDialog.show(
              context,
              sectionNumber: sectionNumber,
              sectionKey: sectionKey,
              moduleKey: moduleKey,
              titleEn: titleEn,
              titleAm: titleAm,
              onCompleted: onCompleted,
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: badgeColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.assignment_turned_in_rounded,
                      color: badgeColor,
                      size: 26,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: badgeColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'UoG Section $sectionNumber',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: badgeColor,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            isAmharic ? questionRangeTextAm : questionRangeTextEn,
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isAmharic ? titleAm : titleEn,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isAmharic
                            ? 'የራስዎን ግንዛቤ እና ተጋላጭነት ይገምግሙ • 100% ሚስጥራዊ'
                            : 'Evaluate your knowledge and risks • 100% Confidential',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: badgeColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      color: badgeColor,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
