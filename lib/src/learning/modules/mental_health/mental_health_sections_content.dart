import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../../widgets/curriculum/curriculum_bullet_item.dart';

/// Builds children for Section 1: Understanding Mental Health.
List<Widget> buildMentalHealthSection1Children(AppLocalizations l10n) {
  return [
    Text(
      l10n.mentalHealthSection1Desc1,
      style: const TextStyle(
        fontSize: 13.5,
        color: Color(0xFF334155),
        height: 1.55,
      ),
    ),
    const SizedBox(height: 10),
    Text(
      l10n.mentalHealthSection1Desc2,
      style: const TextStyle(
        fontSize: 13.5,
        color: Color(0xFF334155),
        height: 1.55,
      ),
    ),
    const SizedBox(height: 12),
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
            Icons.favorite_outline_rounded,
            color: Color(0xFF16A34A),
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              l10n.mentalHealthSection1Alert,
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

/// Builds children for Section 2: Common Challenges in Youth.
List<Widget> buildMentalHealthSection2Children(AppLocalizations l10n) {
  return [
    Text(
      l10n.mentalHealthSection2Intro,
      style: const TextStyle(
        fontSize: 13.5,
        color: Color(0xFF334155),
        height: 1.5,
      ),
    ),
    const SizedBox(height: 10),
    CurriculumBulletItem(body: l10n.mentalHealthChallenge1),
    const SizedBox(height: 8),
    CurriculumBulletItem(body: l10n.mentalHealthChallenge2),
    const SizedBox(height: 8),
    CurriculumBulletItem(body: l10n.mentalHealthChallenge3),
    const SizedBox(height: 8),
    CurriculumBulletItem(body: l10n.mentalHealthChallenge4),
  ];
}

/// Builds children for Section 3: Positive Coping & Self-Care Strategies.
List<Widget> buildMentalHealthSection3Children(AppLocalizations l10n) {
  return [
    Text(
      l10n.mentalHealthSection3Intro,
      style: const TextStyle(
        fontSize: 13.5,
        color: Color(0xFF334155),
        height: 1.55,
      ),
    ),
    const SizedBox(height: 10),
    CurriculumBulletItem(body: l10n.mentalHealthStrategy1),
    const SizedBox(height: 8),
    CurriculumBulletItem(body: l10n.mentalHealthStrategy2),
    const SizedBox(height: 8),
    CurriculumBulletItem(body: l10n.mentalHealthStrategy3),
    const SizedBox(height: 8),
    CurriculumBulletItem(body: l10n.mentalHealthStrategy4),
    const SizedBox(height: 8),
    CurriculumBulletItem(body: l10n.mentalHealthStrategy5),
  ];
}

/// Builds children for Section 4: Recognizing Warning Signs & Seeking Support.
List<Widget> buildMentalHealthSection4Children(AppLocalizations l10n) {
  return [
    Text(
      l10n.mentalHealthSection4Intro,
      style: const TextStyle(
        fontSize: 13.5,
        color: Color(0xFF334155),
        height: 1.55,
      ),
    ),
    const SizedBox(height: 10),
    CurriculumBulletItem(body: l10n.mentalHealthSign1),
    const SizedBox(height: 8),
    CurriculumBulletItem(body: l10n.mentalHealthSign2),
    const SizedBox(height: 8),
    CurriculumBulletItem(body: l10n.mentalHealthSign3),
    const SizedBox(height: 8),
    CurriculumBulletItem(body: l10n.mentalHealthSign4),
    const SizedBox(height: 8),
    CurriculumBulletItem(body: l10n.mentalHealthSign5),
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
              l10n.mentalHealthHelpAlert,
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
