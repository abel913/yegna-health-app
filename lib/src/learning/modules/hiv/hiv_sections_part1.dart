import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../widgets/curriculum/curriculum_accordion_card.dart';
import '../../widgets/curriculum/curriculum_bullet_item.dart';

Widget buildHivDefinitionSection(
  BuildContext context,
  AppLocalizations l10n,
  bool isExpanded,
  bool isRead,
  VoidCallback onToggle,
) {
  return CurriculumAccordionCard(
    title: l10n.hivDefinitionTitle,
    isExpanded: isExpanded,
    isRead: isRead,
    onToggle: onToggle,
    children: [
      Text(
        l10n.hivDefinitionSubtitle,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Color(0xFF0F172A),
        ),
      ),
      const SizedBox(height: 8),
      Text(
        l10n.hivDefinitionDesc1,
        style: const TextStyle(
          fontSize: 13.5,
          color: Color(0xFF334155),
          height: 1.55,
        ),
      ),
      const SizedBox(height: 10),
      Text(
        l10n.hivDefinitionDesc2,
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
                l10n.hivDefinitionDesc3,
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
    ],
  );
}

Widget buildHivTransmissionSection(
  BuildContext context,
  AppLocalizations l10n,
  bool isExpanded,
  bool isRead,
  VoidCallback onToggle,
) {
  return CurriculumAccordionCard(
    title: l10n.hivTransmissionTitle,
    isExpanded: isExpanded,
    isRead: isRead,
    onToggle: onToggle,
    children: [
      Text(
        l10n.hivTransmissionSubtitle,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Color(0xFF0F172A),
        ),
      ),
      const SizedBox(height: 8),
      Text(
        l10n.hivTransmissionIntro,
        style: const TextStyle(
          fontSize: 13.5,
          color: Color(0xFF334155),
          height: 1.5,
        ),
      ),
      const SizedBox(height: 10),
      CurriculumBulletItem(body: l10n.hivTransmissionItem1),
      const SizedBox(height: 8),
      CurriculumBulletItem(body: l10n.hivTransmissionItem2),
      const SizedBox(height: 8),
      CurriculumBulletItem(body: l10n.hivTransmissionItem3),
      const SizedBox(height: 8),
      CurriculumBulletItem(body: l10n.hivTransmissionItem4),
      const SizedBox(height: 14),
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.shield_outlined,
                  color: Color(0xFF0284C7),
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.hivNotTransmittedTitle,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              l10n.hivNotTransmittedDesc,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF475569),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
