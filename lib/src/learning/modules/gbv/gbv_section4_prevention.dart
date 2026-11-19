import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import 'gbv_section_components.dart';

/// Builds children for Section 4: Management and Prevention of GBV.
List<Widget> buildGbvSection4Children(AppLocalizations l10n) {
  return [
    _buildImmediateResponseCategory(l10n),
    _buildPreventingGbvCategory(l10n),
    _buildLongTermStrategiesCategory(l10n),
    const SizedBox(height: 12),
    _buildHelpAlert(l10n),
  ];
}

Widget _buildImmediateResponseCategory(AppLocalizations l10n) {
  return GbvNumberedCategory(
    number: 1,
    title: l10n.gbvSec4Main1Title,
    items: [
      Text(
        l10n.gbvSec4Main1Intro,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF334155),
          height: 1.55,
        ),
      ),
      const SizedBox(height: 8),
      GbvLetterSubcategory(
        letter: 'A',
        title: l10n.gbvSec4SubATitle,
        items: [
          GbvBulletItem(boldPrefix: l10n.gbvSec4SubA1Title, body: l10n.gbvSec4SubA1Body),
          GbvBulletItem(boldPrefix: l10n.gbvSec4SubA2Title, body: l10n.gbvSec4SubA2Body),
          GbvBulletItem(boldPrefix: l10n.gbvSec4SubA3Title, body: l10n.gbvSec4SubA3Body),
          GbvBulletItem(boldPrefix: l10n.gbvSec4SubA4Title, body: l10n.gbvSec4SubA4Body),
        ],
      ),
      GbvLetterSubcategory(
        letter: 'B',
        title: l10n.gbvSec4SubBTitle,
        items: [
          GbvBulletItem(boldPrefix: l10n.gbvSec4SubB1Title, body: l10n.gbvSec4SubB1Body),
          GbvBulletItem(boldPrefix: l10n.gbvSec4SubB2Title, body: l10n.gbvSec4SubB2Body),
          GbvBulletItem(boldPrefix: l10n.gbvSec4SubB3Title, body: l10n.gbvSec4SubB3Body),
        ],
      ),
    ],
  );
}

Widget _buildPreventingGbvCategory(AppLocalizations l10n) {
  return GbvNumberedCategory(
    number: 2,
    title: l10n.gbvSec4Main2Title,
    items: [
      Text(
        l10n.gbvSec4Main2Intro,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF334155),
          height: 1.55,
        ),
      ),
      const SizedBox(height: 8),
      GbvLetterSubcategory(
        letter: 'A',
        title: l10n.gbvSec4Sub2ATitle,
        items: [
          GbvBulletItem(boldPrefix: l10n.gbvSec4Sub2A1Title, body: l10n.gbvSec4Sub2A1Body),
          GbvBulletItem(boldPrefix: l10n.gbvSec4Sub2A2Title, body: l10n.gbvSec4Sub2A2Body),
          GbvBulletItem(boldPrefix: l10n.gbvSec4Sub2A3Title, body: l10n.gbvSec4Sub2A3Body),
          GbvBulletItem(boldPrefix: l10n.gbvSec4Sub2A4Title, body: l10n.gbvSec4Sub2A4Body),
        ],
      ),
      GbvLetterSubcategory(
        letter: 'B',
        title: l10n.gbvSec4Sub2BTitle,
        items: [
          GbvBulletItem(boldPrefix: l10n.gbvSec4Sub2B1Title, body: l10n.gbvSec4Sub2B1Body),
          GbvBulletItem(boldPrefix: l10n.gbvSec4Sub2B2Title, body: l10n.gbvSec4Sub2B2Body),
          GbvBulletItem(boldPrefix: l10n.gbvSec4Sub2B3Title, body: l10n.gbvSec4Sub2B3Body),
        ],
      ),
      GbvLetterSubcategory(
        letter: 'C',
        title: l10n.gbvSec4Sub2CTitle,
        items: [
          GbvBulletItem(boldPrefix: l10n.gbvSec4Sub2C1Title, body: l10n.gbvSec4Sub2C1Body),
          GbvBulletItem(boldPrefix: l10n.gbvSec4Sub2C2Title, body: l10n.gbvSec4Sub2C2Body),
          GbvBulletItem(boldPrefix: l10n.gbvSec4Sub2C3Title, body: l10n.gbvSec4Sub2C3Body),
        ],
      ),
      GbvLetterSubcategory(
        letter: 'D',
        title: l10n.gbvSec4Sub2DTitle,
        items: [
          GbvBulletItem(boldPrefix: l10n.gbvSec4Sub2D1Title, body: l10n.gbvSec4Sub2D1Body),
          GbvBulletItem(boldPrefix: l10n.gbvSec4Sub2D2Title, body: l10n.gbvSec4Sub2D2Body),
        ],
      ),
      GbvLetterSubcategory(
        letter: 'E',
        title: l10n.gbvSec4Sub2ETitle,
        items: [
          GbvBulletItem(boldPrefix: l10n.gbvSec4Sub2E1Title, body: l10n.gbvSec4Sub2E1Body),
          GbvBulletItem(boldPrefix: l10n.gbvSec4Sub2E2Title, body: l10n.gbvSec4Sub2E2Body),
          GbvBulletItem(boldPrefix: l10n.gbvSec4Sub2E3Title, body: l10n.gbvSec4Sub2E3Body),
        ],
      ),
    ],
  );
}

Widget _buildLongTermStrategiesCategory(AppLocalizations l10n) {
  return GbvNumberedCategory(
    number: 3,
    title: l10n.gbvSec4Main3Title,
    items: [
      Text(
        l10n.gbvSec4Main3Intro,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF334155),
          height: 1.55,
        ),
      ),
      const SizedBox(height: 8),
      GbvLetterSubcategory(
        letter: 'A',
        title: l10n.gbvSec4Sub3ATitle,
        items: [
          GbvBulletItem(boldPrefix: l10n.gbvSec4Sub3A1Title, body: l10n.gbvSec4Sub3A1Body),
          GbvBulletItem(boldPrefix: l10n.gbvSec4Sub3A2Title, body: l10n.gbvSec4Sub3A2Body),
          GbvBulletItem(boldPrefix: l10n.gbvSec4Sub3A3Title, body: l10n.gbvSec4Sub3A3Body),
        ],
      ),
      GbvLetterSubcategory(
        letter: 'B',
        title: l10n.gbvSec4Sub3BTitle,
        items: [
          GbvBulletItem(boldPrefix: l10n.gbvSec4Sub3B1Title, body: l10n.gbvSec4Sub3B1Body),
          GbvBulletItem(boldPrefix: l10n.gbvSec4Sub3B2Title, body: l10n.gbvSec4Sub3B2Body),
        ],
      ),
    ],
  );
}

Widget _buildHelpAlert(AppLocalizations l10n) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: const Color(0xFFFEE2E2),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: const Color(0xFFFCA5A5),
        width: 1,
      ),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.support_agent_rounded,
          color: Color(0xFFDC2626),
          size: 22,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            l10n.gbvSection4HelpAlert,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF991B1B),
              height: 1.45,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );
}
