import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../../widgets/curriculum/curriculum_accordion_card.dart';
import 'gbv_section3_consequences.dart';
import 'gbv_section4_prevention.dart';
import 'gbv_sections_part1.dart';

/// Builds the 4 accordion sections for GBV module.
Widget buildGbvSections({
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
        title: l10n.gbvSection1Title,
        isExpanded: expanded.contains(1),
        isRead: read.contains(1),
        onToggle: () => toggle(1),
        children: buildGbvSection1Children(l10n),
      ),
      CurriculumAccordionCard(
        sectionNumber: 2,
        title: l10n.gbvSection2Title,
        isExpanded: expanded.contains(2),
        isRead: read.contains(2),
        onToggle: () => toggle(2),
        children: buildGbvSection2Children(l10n),
      ),
      CurriculumAccordionCard(
        sectionNumber: 3,
        title: l10n.gbvSection3Title,
        isExpanded: expanded.contains(3),
        isRead: read.contains(3),
        onToggle: () => toggle(3),
        children: buildGbvSection3Children(l10n),
      ),
      CurriculumAccordionCard(
        sectionNumber: 4,
        title: l10n.gbvSection4Title,
        isExpanded: expanded.contains(4),
        isRead: read.contains(4),
        onToggle: () => toggle(4),
        children: buildGbvSection4Children(l10n),
      ),
    ],
  );
}
