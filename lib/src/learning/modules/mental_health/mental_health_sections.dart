import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../../widgets/curriculum/curriculum_accordion_card.dart';
import 'mental_health_sections_content.dart';

/// Builds the 4 accordion sections for Mental Health module.
Widget buildMentalHealthSections({
  required BuildContext context,
  required AppLocalizations l10n,
  required Set<int> expanded,
  required Set<int> read,
  required void Function(int) toggle,
}) {
  return Column(
    children: [
      CurriculumAccordionCard(
        sectionNumber: 1,
        title: l10n.mentalHealthSection1Title,
        isExpanded: expanded.contains(0),
        isRead: read.contains(0),
        onToggle: () => toggle(0),
        children: buildMentalHealthSection1Children(l10n),
      ),
      CurriculumAccordionCard(
        sectionNumber: 2,
        title: l10n.mentalHealthSection2Title,
        isExpanded: expanded.contains(1),
        isRead: read.contains(1),
        onToggle: () => toggle(1),
        children: buildMentalHealthSection2Children(l10n),
      ),
      CurriculumAccordionCard(
        sectionNumber: 3,
        title: l10n.mentalHealthSection3Title,
        isExpanded: expanded.contains(2),
        isRead: read.contains(2),
        onToggle: () => toggle(2),
        children: buildMentalHealthSection3Children(l10n),
      ),
      CurriculumAccordionCard(
        sectionNumber: 4,
        title: l10n.mentalHealthSection4Title,
        isExpanded: expanded.contains(3),
        isRead: read.contains(3),
        onToggle: () => toggle(3),
        children: buildMentalHealthSection4Children(l10n),
      ),
    ],
  );
}
