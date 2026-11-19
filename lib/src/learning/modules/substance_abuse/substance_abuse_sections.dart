import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../../widgets/curriculum/curriculum_accordion_card.dart';
import 'substance_abuse_sections_content.dart';

/// Builds the 4 accordion sections for Substance Abuse module.
Widget buildSubstanceAbuseSections({
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
        title: l10n.substanceDefTitle,
        isExpanded: expanded.contains(0),
        isRead: read.contains(0),
        onToggle: () => toggle(0),
        children: buildSubstanceAbuseSection1Children(l10n),
      ),
      CurriculumAccordionCard(
        sectionNumber: 2,
        title: l10n.substanceTypesTitle,
        isExpanded: expanded.contains(1),
        isRead: read.contains(1),
        onToggle: () => toggle(1),
        children: buildSubstanceAbuseSection2Children(l10n),
      ),
      CurriculumAccordionCard(
        sectionNumber: 3,
        title: l10n.substanceEffectsTitle,
        isExpanded: expanded.contains(2),
        isRead: read.contains(2),
        onToggle: () => toggle(2),
        children: buildSubstanceAbuseSection3Children(l10n),
      ),
      CurriculumAccordionCard(
        sectionNumber: 4,
        title: l10n.substanceSignsTitle,
        isExpanded: expanded.contains(3),
        isRead: read.contains(3),
        onToggle: () => toggle(3),
        children: buildSubstanceAbuseSection4Children(l10n),
      ),
    ],
  );
}
