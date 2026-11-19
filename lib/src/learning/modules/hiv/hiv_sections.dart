import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import 'hiv_prevention_section.dart';
import 'hiv_sections_part1.dart';
import 'hiv_sections_part2.dart';

Widget buildHivSections(
  BuildContext context,
  AppLocalizations l10n,
  Set<int> expandedSections,
  Set<int> readSections,
  void Function(int) onToggle,
) {
  return Column(
    children: [
      buildHivDefinitionSection(
        context,
        l10n,
        expandedSections.contains(0),
        readSections.contains(0),
        () => onToggle(0),
      ),
      buildHivTransmissionSection(
        context,
        l10n,
        expandedSections.contains(1),
        readSections.contains(1),
        () => onToggle(1),
      ),
      buildHivPreventionSection(
        context,
        l10n,
        expandedSections.contains(2),
        readSections.contains(2),
        () => onToggle(2),
      ),
      buildHivTestingSection(
        context,
        l10n,
        expandedSections.contains(3),
        readSections.contains(3),
        () => onToggle(3),
      ),
      buildHivTreatmentSection(
        context,
        l10n,
        expandedSections.contains(4),
        readSections.contains(4),
        () => onToggle(4),
      ),
    ],
  );
}
