import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../widgets/curriculum/curriculum_accordion_card.dart';
import '../../widgets/curriculum/curriculum_bullet_item.dart';

Widget buildPubertySections(
  BuildContext context,
  AppLocalizations l10n,
  Set<int> expandedSections,
  Set<int> readSections,
  void Function(int) onToggle,
) {
  return Column(
    children: [
      // Section 1: Understanding Puberty & Adolescence
      CurriculumAccordionCard(
        sectionNumber: 1,
        title: l10n.pubertySection1Title,
        isExpanded: expandedSections.contains(0),
        isRead: readSections.contains(0),
        onToggle: () => onToggle(0),
        children: [
          Text(
            l10n.pubertySection1Subtitle,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.pubertySection1Intro,
            style: const TextStyle(
              fontSize: 13.5,
              color: Color(0xFF334155),
              height: 1.55,
            ),
          ),
          const SizedBox(height: 12),
          CurriculumBulletItem(body: l10n.pubertySection1Item1),
          const SizedBox(height: 8),
          CurriculumBulletItem(body: l10n.pubertySection1Item2),
          const SizedBox(height: 8),
          CurriculumBulletItem(body: l10n.pubertySection1Item3),
        ],
      ),

      // Section 2: Physical Changes in Females & Males
      CurriculumAccordionCard(
        sectionNumber: 2,
        title: l10n.pubertySection2Title,
        isExpanded: expandedSections.contains(1),
        isRead: readSections.contains(1),
        onToggle: () => onToggle(1),
        children: [
          Text(
            l10n.pubertySection2Subtitle,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.pubertySection2FemaleTitle,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0284C7),
            ),
          ),
          const SizedBox(height: 6),
          CurriculumBulletItem(body: l10n.pubertySection2FemaleItem1),
          const SizedBox(height: 6),
          CurriculumBulletItem(body: l10n.pubertySection2FemaleItem2),
          const SizedBox(height: 6),
          CurriculumBulletItem(body: l10n.pubertySection2FemaleItem3),
          const SizedBox(height: 14),
          Text(
            l10n.pubertySection2MaleTitle,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0284C7),
            ),
          ),
          const SizedBox(height: 6),
          CurriculumBulletItem(body: l10n.pubertySection2MaleItem1),
          const SizedBox(height: 6),
          CurriculumBulletItem(body: l10n.pubertySection2MaleItem2),
          const SizedBox(height: 6),
          CurriculumBulletItem(body: l10n.pubertySection2MaleItem3),
        ],
      ),

      // Section 3: Emotional & Psychological Changes
      CurriculumAccordionCard(
        sectionNumber: 3,
        title: l10n.pubertySection3Title,
        isExpanded: expandedSections.contains(2),
        isRead: readSections.contains(2),
        onToggle: () => onToggle(2),
        children: [
          Text(
            l10n.pubertySection3Subtitle,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.pubertySection3Intro,
            style: const TextStyle(
              fontSize: 13.5,
              color: Color(0xFF334155),
              height: 1.55,
            ),
          ),
          const SizedBox(height: 12),
          CurriculumBulletItem(body: l10n.pubertySection3Item1),
          const SizedBox(height: 8),
          CurriculumBulletItem(body: l10n.pubertySection3Item2),
          const SizedBox(height: 8),
          CurriculumBulletItem(body: l10n.pubertySection3Item3),
          const SizedBox(height: 8),
          CurriculumBulletItem(body: l10n.pubertySection3Item4),
        ],
      ),

      // Section 4: Hygiene & Self-Care during Adolescence
      CurriculumAccordionCard(
        sectionNumber: 4,
        title: l10n.pubertySection4Title,
        isExpanded: expandedSections.contains(3),
        isRead: readSections.contains(3),
        onToggle: () => onToggle(3),
        children: [
          Text(
            l10n.pubertySection4Subtitle,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 12),
          CurriculumAlphaBadgeItem(
              letter: 'A', text: l10n.pubertySection4Item1),
          CurriculumAlphaBadgeItem(
              letter: 'B', text: l10n.pubertySection4Item2),
          CurriculumAlphaBadgeItem(
              letter: 'C', text: l10n.pubertySection4Item3),
          CurriculumAlphaBadgeItem(
              letter: 'D', text: l10n.pubertySection4Item4),
        ],
      ),
    ],
  );
}
