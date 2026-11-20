import 'package:flutter/material.dart';

import 'uog_assessment_section_meta.dart';
import 'widgets/self_assessment_hero_banner.dart';
import 'widgets/self_assessment_section_card.dart';

export 'uog_assessment_section_meta.dart' show UogAssessmentSectionMeta, kUogSections;

/// Comprehensive hub presenting the 8 official University of Gondar SRHR assessment sections.
class SelfAssessmentPage extends StatelessWidget {
  const SelfAssessmentPage({
    super.key,
    this.onOpenMentors,
    this.onOpenFacilities,
    this.onOpenLearning,
  });

  final VoidCallback? onOpenMentors;
  final VoidCallback? onOpenFacilities;
  final VoidCallback? onOpenLearning;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isAmharic = Localizations.localeOf(context).languageCode == 'am';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isAmharic ? 'የስነ-ተዋልዶ ጤና ምዘና ማዕከል' : 'SRHR Self-Assessment Hub',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SelfAssessmentHeroBanner(isDark: isDark, isAmharic: isAmharic),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    isAmharic ? 'የክሊኒካል ምዘና ክፍሎች (7 ክፍሎች)' : 'Clinical Assessment Sections (7 Total)',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  isAmharic ? '46 ጥያቄዎች' : '46 Questions',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: kClinicalAssessmentSections.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, idx) {
                return SelfAssessmentSectionCard(
                  section: kClinicalAssessmentSections[idx],
                  isDark: isDark,
                  isAmharic: isAmharic,
                  onOpenMentors: onOpenMentors,
                  onOpenFacilities: onOpenFacilities,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
