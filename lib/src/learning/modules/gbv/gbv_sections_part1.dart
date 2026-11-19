import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import 'gbv_section_components.dart';

/// Builds children for Section 1: Definition of GBV.
List<Widget> buildGbvSection1Children(AppLocalizations l10n) {
  return [
    Text(
      l10n.gbvSection1Desc1,
      style: const TextStyle(
        fontSize: 14,
        color: Color(0xFF334155),
        height: 1.55,
      ),
    ),
    const SizedBox(height: 12),
    Text(
      l10n.gbvSection1Desc2,
      style: const TextStyle(
        fontSize: 14,
        color: Color(0xFF334155),
        height: 1.55,
      ),
    ),
    const SizedBox(height: 16),
    GbvNumberedCategory(
      number: 1,
      title: l10n.gbvForm1Title,
      items: [
        GbvBulletItem(
          boldPrefix: l10n.gbvForm1Item1Title,
          body: l10n.gbvForm1Item1Body,
        ),
        GbvBulletItem(
          boldPrefix: l10n.gbvForm1Item2Title,
          body: l10n.gbvForm1Item2Body,
        ),
      ],
    ),
    GbvNumberedCategory(
      number: 2,
      title: l10n.gbvForm2Title,
      items: [
        GbvBulletItem(
          boldPrefix: l10n.gbvForm2Item1Title,
          body: l10n.gbvForm2Item1Body,
        ),
        GbvBulletItem(
          boldPrefix: l10n.gbvForm2Item2Title,
          body: l10n.gbvForm2Item2Body,
        ),
        GbvBulletItem(
          boldPrefix: l10n.gbvForm2Item3Title,
          body: l10n.gbvForm2Item3Body,
        ),
      ],
    ),
    GbvNumberedCategory(
      number: 3,
      title: l10n.gbvForm3Title,
      items: [
        GbvBulletItem(
          boldPrefix: l10n.gbvForm3Item1Title,
          body: l10n.gbvForm3Item1Body,
        ),
        GbvBulletItem(
          boldPrefix: l10n.gbvForm3Item2Title,
          body: l10n.gbvForm3Item2Body,
        ),
        GbvBulletItem(
          boldPrefix: l10n.gbvForm3Item3Title,
          body: l10n.gbvForm3Item3Body,
        ),
      ],
    ),
    GbvNumberedCategory(
      number: 4,
      title: l10n.gbvForm4Title,
      items: [
        GbvBulletItem(
          boldPrefix: l10n.gbvForm4Item1Title,
          body: l10n.gbvForm4Item1Body,
        ),
        GbvBulletItem(
          boldPrefix: l10n.gbvForm4Item2Title,
          body: l10n.gbvForm4Item2Body,
        ),
      ],
    ),
    GbvNumberedCategory(
      number: 5,
      title: l10n.gbvForm5Title,
      items: [
        GbvBulletItem(
          boldPrefix: l10n.gbvForm5Item1Title,
          body: l10n.gbvForm5Item1Body,
        ),
        GbvBulletItem(
          boldPrefix: l10n.gbvForm5Item2Title,
          body: l10n.gbvForm5Item2Body,
        ),
        GbvBulletItem(
          boldPrefix: l10n.gbvForm5Item3Title,
          body: l10n.gbvForm5Item3Body,
        ),
      ],
    ),
  ];
}

/// Builds children for Section 2: Sex and Gender.
List<Widget> buildGbvSection2Children(AppLocalizations l10n) {
  return [
    Text(
      l10n.gbvSection2Desc1,
      style: const TextStyle(
        fontSize: 14,
        color: Color(0xFF334155),
        height: 1.55,
      ),
    ),
    const SizedBox(height: 12),
    Text(
      l10n.gbvSection2Desc2,
      style: const TextStyle(
        fontSize: 14,
        color: Color(0xFF334155),
        height: 1.55,
      ),
    ),
  ];
}
