import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../../widgets/curriculum/curriculum_bullet_item.dart';

/// Builds children for Section 1: Definition of Hepatitis.
List<Widget> buildHepatitisSection1Children(AppLocalizations l10n) {
  return [
    Text(
      l10n.hepatitisSection1Desc1,
      style: const TextStyle(
        fontSize: 13.5,
        color: Color(0xFF334155),
        height: 1.55,
      ),
    ),
    const SizedBox(height: 12),
    Text(
      l10n.hepatitisSection1Desc2,
      style: const TextStyle(
        fontSize: 13.5,
        color: Color(0xFF334155),
        height: 1.55,
      ),
    ),
  ];
}

/// Builds children for Section 2: Signs and Symptoms of Hepatitis.
List<Widget> buildHepatitisSection2Children(AppLocalizations l10n) {
  return [
    Text(
      l10n.hepatitisSection2Intro,
      style: const TextStyle(
        fontSize: 13.5,
        color: Color(0xFF334155),
        height: 1.55,
      ),
    ),
    const SizedBox(height: 10),
    CurriculumBulletItem(body: l10n.hepatitisSymptom1),
    const SizedBox(height: 6),
    CurriculumBulletItem(body: l10n.hepatitisSymptom2),
    const SizedBox(height: 6),
    CurriculumBulletItem(body: l10n.hepatitisSymptom3),
    const SizedBox(height: 6),
    CurriculumBulletItem(body: l10n.hepatitisSymptom4),
    const SizedBox(height: 6),
    CurriculumBulletItem(body: l10n.hepatitisSymptom5),
    const SizedBox(height: 6),
    CurriculumBulletItem(body: l10n.hepatitisSymptom6),
    const SizedBox(height: 6),
    CurriculumBulletItem(body: l10n.hepatitisSymptom7),
    const SizedBox(height: 14),
    Text(
      l10n.hepatitisSection2ChronicNote,
      style: const TextStyle(
        fontSize: 13.5,
        color: Color(0xFF334155),
        height: 1.55,
      ),
    ),
    const SizedBox(height: 18),
    Text(
      l10n.hepatitisBTitle,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: Color(0xFF08264A),
      ),
    ),
    const SizedBox(height: 8),
    Text(
      l10n.hepatitisBDesc,
      style: const TextStyle(
        fontSize: 13.5,
        color: Color(0xFF334155),
        height: 1.55,
      ),
    ),
    const SizedBox(height: 10),
    Text(
      l10n.hepatitisBTransmissionIntro,
      style: const TextStyle(
        fontSize: 13.5,
        color: Color(0xFF334155),
        height: 1.5,
      ),
    ),
    const SizedBox(height: 8),
    CurriculumBulletItem(body: l10n.hepatitisBTransmission1),
    const SizedBox(height: 6),
    CurriculumBulletItem(body: l10n.hepatitisBTransmission2),
    const SizedBox(height: 6),
    CurriculumBulletItem(body: l10n.hepatitisBTransmission3),
    const SizedBox(height: 6),
    CurriculumBulletItem(body: l10n.hepatitisBTransmission4),
    const SizedBox(height: 14),
    Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F7FD),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFBAE6FD),
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.lightbulb_outline_rounded,
            color: Color(0xFF0284C7),
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              l10n.hepatitisBAlert,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0369A1),
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    ),
    const SizedBox(height: 20),
    Text(
      l10n.hepatitisCTitle,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: Color(0xFF08264A),
      ),
    ),
    const SizedBox(height: 8),
    Text(
      l10n.hepatitisCDesc,
      style: const TextStyle(
        fontSize: 13.5,
        color: Color(0xFF334155),
        height: 1.55,
      ),
    ),
    const SizedBox(height: 10),
    CurriculumBulletItem(body: l10n.hepatitisCTransmission1),
    const SizedBox(height: 6),
    CurriculumBulletItem(body: l10n.hepatitisCTransmission2),
    const SizedBox(height: 6),
    CurriculumBulletItem(body: l10n.hepatitisCTransmission3),
    const SizedBox(height: 14),
    Text(
      l10n.hepatitisCChronicDesc,
      style: const TextStyle(
        fontSize: 13.5,
        color: Color(0xFF334155),
        height: 1.55,
      ),
    ),
    const SizedBox(height: 10),
    Text(
      l10n.hepatitisCTreatmentDesc,
      style: const TextStyle(
        fontSize: 13.5,
        color: Color(0xFF334155),
        height: 1.55,
      ),
    ),
  ];
}
