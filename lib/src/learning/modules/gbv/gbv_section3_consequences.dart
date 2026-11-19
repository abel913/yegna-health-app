import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import 'gbv_consequences_table.dart';
import 'gbv_section_components.dart';

/// Builds children for Section 3: Consequences of gender-based violence.
List<Widget> buildGbvSection3Children(AppLocalizations l10n) {
  return [
    GbvBulletItem(
      boldPrefix: '',
      body: l10n.gbvConsequenceBullet1,
    ),
    GbvBulletItem(
      boldPrefix: '',
      body: l10n.gbvConsequenceBullet2,
    ),
    GbvBulletItem(
      boldPrefix: '',
      body: l10n.gbvConsequenceBullet3,
    ),
    GbvBulletItem(
      boldPrefix: '',
      body: l10n.gbvConsequenceBullet4,
    ),
    GbvBulletItem(
      boldPrefix: '',
      body: l10n.gbvConsequenceBullet5,
    ),
    const SizedBox(height: 16),
    GbvConsequencesTable(l10n: l10n),
  ];
}
