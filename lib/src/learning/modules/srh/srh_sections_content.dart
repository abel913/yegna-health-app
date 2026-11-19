import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../../widgets/curriculum/curriculum_bullet_item.dart';

/// Builds children for Section 1: Understanding SRH.
List<Widget> buildSrhSection1Children(AppLocalizations l10n) {
  return [
    Text(
      l10n.srhSection1Subtitle,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Color(0xFF0F172A),
      ),
    ),
    const SizedBox(height: 8),
    Text(
      l10n.srhSection1Intro,
      style: const TextStyle(
        fontSize: 13.5,
        color: Color(0xFF334155),
        height: 1.55,
      ),
    ),
    const SizedBox(height: 12),
    CurriculumBulletItem(body: l10n.srhSection1Item1),
    const SizedBox(height: 8),
    CurriculumBulletItem(body: l10n.srhSection1Item2),
    const SizedBox(height: 8),
    CurriculumBulletItem(body: l10n.srhSection1Item3),
  ];
}

/// Builds children for Section 2: Anatomy & Reproductive Systems.
List<Widget> buildSrhSection2Children(AppLocalizations l10n) {
  return [
    Text(
      l10n.srhSection2Subtitle,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Color(0xFF0F172A),
      ),
    ),
    const SizedBox(height: 8),
    Text(
      l10n.srhSection2Intro,
      style: const TextStyle(
        fontSize: 13.5,
        color: Color(0xFF334155),
        height: 1.55,
      ),
    ),
    const SizedBox(height: 12),
    CurriculumBulletItem(body: l10n.srhSection2Item1),
    const SizedBox(height: 8),
    CurriculumBulletItem(body: l10n.srhSection2Item2),
    const SizedBox(height: 8),
    CurriculumBulletItem(body: l10n.srhSection2Item3),
  ];
}

/// Builds children for Section 3: Family Planning & Contraceptive Methods.
List<Widget> buildSrhSection3Children(AppLocalizations l10n) {
  return [
    Text(
      l10n.srhSection3Subtitle,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Color(0xFF0F172A),
      ),
    ),
    const SizedBox(height: 8),
    Text(
      l10n.srhSection3Intro,
      style: const TextStyle(
        fontSize: 13.5,
        color: Color(0xFF334155),
        height: 1.55,
      ),
    ),
    const SizedBox(height: 12),
    CurriculumAlphaBadgeItem(letter: 'A', text: l10n.srhSection3Item1),
    CurriculumAlphaBadgeItem(letter: 'B', text: l10n.srhSection3Item2),
    CurriculumAlphaBadgeItem(letter: 'C', text: l10n.srhSection3Item3),
    CurriculumAlphaBadgeItem(letter: 'D', text: l10n.srhSection3Item4),
  ];
}

/// Builds children for Section 4: Consent, Rights & Healthy Relationships.
List<Widget> buildSrhSection4Children(AppLocalizations l10n) {
  return [
    Text(
      l10n.srhSection4Subtitle,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Color(0xFF0F172A),
      ),
    ),
    const SizedBox(height: 8),
    Text(
      l10n.srhSection4Intro,
      style: const TextStyle(
        fontSize: 13.5,
        color: Color(0xFF334155),
        height: 1.55,
      ),
    ),
    const SizedBox(height: 12),
    CurriculumBulletItem(body: l10n.srhSection4Item1),
    const SizedBox(height: 8),
    CurriculumBulletItem(body: l10n.srhSection4Item2),
    const SizedBox(height: 8),
    CurriculumBulletItem(body: l10n.srhSection4Item3),
  ];
}
