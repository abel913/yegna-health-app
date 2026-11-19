import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../../widgets/curriculum/curriculum_bullet_item.dart';

/// Builds children for Section 1: Definition of STI.
List<Widget> buildStiSection1Children(AppLocalizations l10n) {
  return [
    Text(
      l10n.stiDefinitionSubtitle,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Color(0xFF0F172A),
      ),
    ),
    const SizedBox(height: 8),
    Text(
      l10n.stiDefinitionDesc1,
      style: const TextStyle(
        fontSize: 13.5,
        color: Color(0xFF334155),
        height: 1.55,
      ),
    ),
    const SizedBox(height: 10),
    Text(
      l10n.stiDefinitionDesc2,
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
            Icons.verified_rounded,
            color: Color(0xFF16A34A),
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              l10n.stiDefinitionDesc3,
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

/// Builds children for Section 2: Signs and Symptoms of STI.
List<Widget> buildStiSection2Children(AppLocalizations l10n) {
  return [
    Text(
      l10n.stiSymptomsSubtitle,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Color(0xFF0F172A),
      ),
    ),
    const SizedBox(height: 8),
    Text(
      l10n.stiSymptomsIntro,
      style: const TextStyle(
        fontSize: 13.5,
        color: Color(0xFF334155),
        height: 1.5,
      ),
    ),
    const SizedBox(height: 10),
    CurriculumBulletItem(body: l10n.stiSymptom1),
    const SizedBox(height: 8),
    CurriculumBulletItem(body: l10n.stiSymptom2),
    const SizedBox(height: 8),
    CurriculumBulletItem(body: l10n.stiSymptom3),
    const SizedBox(height: 8),
    CurriculumBulletItem(body: l10n.stiSymptom4),
    const SizedBox(height: 8),
    CurriculumBulletItem(body: l10n.stiSymptom5),
    const SizedBox(height: 14),
    Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFED7AA)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Color(0xFFEA580C),
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              l10n.stiSymptomsAsymptomaticAlert,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF9A3412),
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

/// Builds children for Section 3: Diagnosis of STI.
List<Widget> buildStiSection3Children(AppLocalizations l10n) {
  return [
    Text(
      l10n.stiDiagnosisSubtitle,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Color(0xFF0F172A),
      ),
    ),
    const SizedBox(height: 8),
    Text(
      l10n.stiDiagnosisIntro,
      style: const TextStyle(
        fontSize: 13.5,
        color: Color(0xFF334155),
        height: 1.55,
      ),
    ),
    const SizedBox(height: 10),
    CurriculumBulletItem(body: l10n.stiDiagnosisItem1),
    const SizedBox(height: 8),
    CurriculumBulletItem(body: l10n.stiDiagnosisItem2),
    const SizedBox(height: 8),
    CurriculumBulletItem(body: l10n.stiDiagnosisItem3),
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
            Icons.lock_outline_rounded,
            color: Color(0xFF16A34A),
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              l10n.stiDiagnosisYouthFriendly,
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
