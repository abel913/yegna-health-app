import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../../widgets/curriculum/curriculum_accordion_card.dart';
import 'sti_sections_part1.dart';
import 'sti_sections_part2.dart';

/// Builds the 6 accordion sections for STI module.
Widget buildStiSections({
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
        title: l10n.stiDefinitionTitle,
        isExpanded: expanded.contains(0),
        isRead: read.contains(0),
        onToggle: () => toggle(0),
        children: buildStiSection1Children(l10n),
      ),
      CurriculumAccordionCard(
        sectionNumber: 2,
        title: l10n.stiSymptomsTitle,
        isExpanded: expanded.contains(1),
        isRead: read.contains(1),
        onToggle: () => toggle(1),
        children: buildStiSection2Children(l10n),
      ),
      CurriculumAccordionCard(
        sectionNumber: 3,
        title: l10n.stiDiagnosisTitle,
        isExpanded: expanded.contains(2),
        isRead: read.contains(2),
        onToggle: () => toggle(2),
        children: buildStiSection3Children(l10n),
      ),
      CurriculumAccordionCard(
        sectionNumber: 4,
        title: l10n.stiComplicationsTitle,
        isExpanded: expanded.contains(3),
        isRead: read.contains(3),
        onToggle: () => toggle(3),
        children: buildStiSection4Children(l10n),
      ),
      CurriculumAccordionCard(
        sectionNumber: 5,
        title: l10n.stiTreatmentTitle,
        isExpanded: expanded.contains(4),
        isRead: read.contains(4),
        onToggle: () => toggle(4),
        children: buildStiSection5Children(l10n),
      ),
      CurriculumAccordionCard(
        sectionNumber: 6,
        title: l10n.stiPreventionTitle,
        isExpanded: expanded.contains(5),
        isRead: read.contains(5),
        onToggle: () => toggle(5),
        children: buildStiSection6Children(l10n),
      ),
    ],
  );
}
