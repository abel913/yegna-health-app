import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../widgets/curriculum/curriculum_accordion_card.dart';

Widget buildHivTestingSection(
  BuildContext context,
  AppLocalizations l10n,
  bool isExpanded,
  bool isRead,
  VoidCallback onToggle,
) {
  return CurriculumAccordionCard(
    title: l10n.hivTesting,
    isExpanded: isExpanded,
    isRead: isRead,
    onToggle: onToggle,
    children: [
      Text(
        l10n.hivTestingDesc,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF334155),
          height: 1.55,
        ),
      ),
      const SizedBox(height: 16),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.pitcTitle,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.pitcDesc,
            style: const TextStyle(
              fontSize: 13.5,
              color: Color(0xFF475569),
              height: 1.5,
            ),
          ),
        ],
      ),
      const SizedBox(height: 14),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.vctTitle,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.vctDesc,
            style: const TextStyle(
              fontSize: 13.5,
              color: Color(0xFF475569),
              height: 1.5,
            ),
          ),
        ],
      ),
    ],
  );
}

Widget buildHivTreatmentSection(
  BuildContext context,
  AppLocalizations l10n,
  bool isExpanded,
  bool isRead,
  VoidCallback onToggle,
) {
  return CurriculumAccordionCard(
    title: l10n.treatmentForHivPositive,
    isExpanded: isExpanded,
    isRead: isRead,
    onToggle: onToggle,
    children: [
      Text(
        l10n.artDesc1,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF334155),
          height: 1.55,
        ),
      ),
      const SizedBox(height: 14),
      Text(
        l10n.artDesc2,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF334155),
          height: 1.55,
        ),
      ),
      const SizedBox(height: 14),
      Text(
        l10n.artDesc3,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF334155),
          height: 1.55,
        ),
      ),
    ],
  );
}
