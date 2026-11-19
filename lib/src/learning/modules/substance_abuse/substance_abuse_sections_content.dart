import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../../widgets/curriculum/curriculum_bullet_item.dart';

/// Builds children for Section 1: Definition of substance abuse.
List<Widget> buildSubstanceAbuseSection1Children(AppLocalizations l10n) {
  return [
    Text(
      l10n.substanceDefDesc1,
      style: const TextStyle(
        fontSize: 13.5,
        color: Color(0xFF334155),
        height: 1.55,
      ),
    ),
    const SizedBox(height: 12),
    Text(
      l10n.substanceDefDesc2,
      style: const TextStyle(
        fontSize: 13.5,
        color: Color(0xFF334155),
        height: 1.55,
      ),
    ),
    const SizedBox(height: 14),
    Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFBBF7D0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.psychology_outlined,
            color: Color(0xFF16A34A),
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              l10n.substanceDefDesc3,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF166534),
                height: 1.45,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    ),
  ];
}

/// Builds children for Section 2: Types of drugs/Substances.
List<Widget> buildSubstanceAbuseSection2Children(AppLocalizations l10n) {
  return [
    CurriculumStepItem(number: 1, text: l10n.substanceTypeDepressants),
    CurriculumStepItem(number: 2, text: l10n.substanceTypeStimulants),
    CurriculumStepItem(number: 3, text: l10n.substanceTypeOpioids),
    CurriculumStepItem(number: 4, text: l10n.substanceTypeHallucinogens),
  ];
}

/// Builds children for Section 3: Effects of substance abuse.
List<Widget> buildSubstanceAbuseSection3Children(AppLocalizations l10n) {
  return [
    Text(
      l10n.substanceEffectsIntro,
      style: const TextStyle(
        fontSize: 13.5,
        color: Color(0xFF334155),
        height: 1.55,
      ),
    ),
    const SizedBox(height: 12),
    CurriculumBulletItem(body: l10n.substanceEffect1),
    const SizedBox(height: 8),
    CurriculumBulletItem(body: l10n.substanceEffect2),
    const SizedBox(height: 8),
    CurriculumBulletItem(body: l10n.substanceEffect3),
    const SizedBox(height: 8),
    CurriculumBulletItem(body: l10n.substanceEffect4),
    const SizedBox(height: 8),
    CurriculumBulletItem(body: l10n.substanceEffect5),
    const SizedBox(height: 8),
    CurriculumBulletItem(body: l10n.substanceEffect6),
    const SizedBox(height: 8),
    CurriculumBulletItem(body: l10n.substanceEffect7),
  ];
}

/// Builds children for Section 4: Signs of a Substance Use Problem.
List<Widget> buildSubstanceAbuseSection4Children(AppLocalizations l10n) {
  return [
    Text(
      l10n.substanceSignsIntro,
      style: const TextStyle(
        fontSize: 13.5,
        color: Color(0xFF334155),
        height: 1.55,
      ),
    ),
    const SizedBox(height: 12),
    CurriculumBulletItem(body: l10n.substanceSign1),
    const SizedBox(height: 8),
    CurriculumBulletItem(body: l10n.substanceSign2),
    const SizedBox(height: 8),
    CurriculumBulletItem(body: l10n.substanceSign3),
    const SizedBox(height: 8),
    CurriculumBulletItem(body: l10n.substanceSign4),
    const SizedBox(height: 8),
    CurriculumBulletItem(body: l10n.substanceSign5),
    const SizedBox(height: 8),
    CurriculumBulletItem(body: l10n.substanceSign6),
    const SizedBox(height: 14),
    Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFBBF7D0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.support_agent_rounded,
            color: Color(0xFF16A34A),
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              l10n.substanceSignsHelpAlert,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF166534),
                height: 1.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    ),
  ];
}
