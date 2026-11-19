import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../assessment/self_assessment_page.dart';
import 'home_action_card.dart';

class HomeQuickActionsGrid extends StatelessWidget {
  const HomeQuickActionsGrid({
    required this.onOpenLearning,
    required this.onOpenFacilities,
    required this.onOpenMentors,
    this.onOpenSelfAssessment,
    super.key,
  });

  final VoidCallback onOpenLearning;
  final VoidCallback onOpenFacilities;
  final VoidCallback onOpenMentors;
  final VoidCallback? onOpenSelfAssessment;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 14,
      mainAxisSpacing: 14,
      childAspectRatio: 0.96,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        HomeActionCard(
          icon: Icons.assignment_turned_in_rounded,
          iconGradient: const [
            Color(0xFF0284C7),
            Color(0xFF38BDF8),
          ],
          title: l10n.selfAssessmentTitle,
          description: l10n.selfAssessmentDesc,
          onTap: onOpenSelfAssessment ??
              () {
                Navigator.of(context).push<void>(
                  MaterialPageRoute<void>(
                    builder: (_) => SelfAssessmentPage(
                      onOpenMentors: onOpenMentors,
                      onOpenFacilities: onOpenFacilities,
                      onOpenLearning: onOpenLearning,
                    ),
                  ),
                );
              },
        ),
        HomeActionCard(
          icon: Icons.menu_book_rounded,
          iconGradient: const [
            Color(0xFF4F46E5),
            Color(0xFF06B6D4),
          ],
          title: l10n.learnTab,
          description: l10n.learnDesc,
          onTap: onOpenLearning,
        ),
        HomeActionCard(
          icon: Icons.location_on_rounded,
          iconGradient: const [
            Color(0xFF0D9488),
            Color(0xFF2DD4BF),
          ],
          title: l10n.findFacilitiesTitle,
          description: l10n.findFacilitiesDesc,
          onTap: onOpenFacilities,
        ),
        HomeActionCard(
          icon: Icons.people_alt_rounded,
          iconGradient: const [
            Color(0xFF0284C7),
            Color(0xFF818CF8),
          ],
          title: l10n.peerMentorTitle,
          description: l10n.peerMentorDesc,
          onTap: onOpenMentors,
        ),
      ],
    );
  }
}
