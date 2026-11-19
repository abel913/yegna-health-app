import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../../widgets/curriculum/curriculum_accordion_card.dart';
import 'hepatitis_sections_part1.dart';
import 'hepatitis_sections_part2.dart';

/// Builds the 6 accordion sections for Hepatitis module.
Widget buildHepatitisSections({
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
        title: l10n.hepatitisSection1Title,
        isExpanded: expanded.contains(0),
        isRead: read.contains(0),
        useCrossFade: false,
        onToggle: () => toggle(0),
        children: buildHepatitisSection1Children(l10n),
      ),
      CurriculumAccordionCard(
        sectionNumber: 2,
        title: l10n.hepatitisSection2Title,
        isExpanded: expanded.contains(1),
        isRead: read.contains(1),
        useCrossFade: false,
        onToggle: () => toggle(1),
        children: buildHepatitisSection2Children(l10n),
      ),
      CurriculumAccordionCard(
        sectionNumber: 3,
        title: l10n.hepatitisSection3Title,
        isExpanded: expanded.contains(2),
        isRead: read.contains(2),
        useCrossFade: false,
        onToggle: () => toggle(2),
        children: buildHepatitisSection3Children(l10n),
      ),
      CurriculumAccordionCard(
        sectionNumber: 4,
        title: l10n.hepatitisSection4Title,
        isExpanded: expanded.contains(3),
        isRead: read.contains(3),
        useCrossFade: false,
        onToggle: () => toggle(3),
        children: buildHepatitisSection4Children(l10n),
      ),
      CurriculumAccordionCard(
        sectionNumber: 5,
        title: l10n.hepatitisSection5Title,
        isExpanded: expanded.contains(4),
        isRead: read.contains(4),
        useCrossFade: false,
        onToggle: () => toggle(4),
        children: buildHepatitisSection5Children(l10n),
      ),
      CurriculumAccordionCard(
        sectionNumber: 6,
        title: l10n.hepatitisSection6Title,
        isExpanded: expanded.contains(5),
        isRead: read.contains(5),
        useCrossFade: false,
        onToggle: () => toggle(5),
        children: buildHepatitisSection6Children(l10n),
      ),
    ],
  );
}
