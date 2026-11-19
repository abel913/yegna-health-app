import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../../widgets/curriculum/curriculum_bullet_item.dart';

/// Numbered badge item for critical medical rules.
class StiNumberedRuleItem extends StatelessWidget {
  const StiNumberedRuleItem({
    required this.number,
    required this.text,
    super.key,
  });

  final int number;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: const BoxDecoration(
              color: Color(0xFF005A71),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '$number',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13.5,
                color: Color(0xFF1E293B),
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Builds children for Section 4: Complications of STI.
List<Widget> buildStiSection4Children(AppLocalizations l10n) {
  return [
    Text(
      l10n.stiComplicationsSubtitle,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Color(0xFF0F172A),
      ),
    ),
    const SizedBox(height: 8),
    Text(
      l10n.stiComplicationsIntro,
      style: const TextStyle(
        fontSize: 13.5,
        color: Color(0xFF334155),
        height: 1.55,
      ),
    ),
    const SizedBox(height: 10),
    CurriculumBulletItem(body: l10n.stiComplication1),
    const SizedBox(height: 8),
    CurriculumBulletItem(body: l10n.stiComplication2),
    const SizedBox(height: 8),
    CurriculumBulletItem(body: l10n.stiComplication3),
    const SizedBox(height: 8),
    CurriculumBulletItem(body: l10n.stiComplication4),
  ];
}

/// Builds children for Section 5: Management and treatment of STI.
List<Widget> buildStiSection5Children(AppLocalizations l10n) {
  return [
    Text(
      l10n.stiTreatmentSubtitle,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Color(0xFF0F172A),
      ),
    ),
    const SizedBox(height: 8),
    Text(
      l10n.stiTreatmentDesc1,
      style: const TextStyle(
        fontSize: 13.5,
        color: Color(0xFF334155),
        height: 1.55,
      ),
    ),
    const SizedBox(height: 10),
    Text(
      l10n.stiTreatmentDesc2,
      style: const TextStyle(
        fontSize: 13.5,
        color: Color(0xFF334155),
        height: 1.55,
      ),
    ),
    const SizedBox(height: 14),
    const Text(
      'Important Rules for Effective STI Recovery:',
      style: TextStyle(
        fontSize: 13.5,
        fontWeight: FontWeight.w700,
        color: Color(0xFF0F172A),
      ),
    ),
    const SizedBox(height: 10),
    StiNumberedRuleItem(number: 1, text: l10n.stiTreatmentRule1),
    StiNumberedRuleItem(number: 2, text: l10n.stiTreatmentRule2),
    StiNumberedRuleItem(number: 3, text: l10n.stiTreatmentRule3),
    StiNumberedRuleItem(number: 4, text: l10n.stiTreatmentRule4),
  ];
}

/// Builds children for Section 6: Prevention of STI.
List<Widget> buildStiSection6Children(AppLocalizations l10n) {
  return [
    Text(
      l10n.stiPreventionSubtitle,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Color(0xFF0F172A),
      ),
    ),
    const SizedBox(height: 8),
    Text(
      l10n.stiPreventionIntro,
      style: const TextStyle(
        fontSize: 13.5,
        color: Color(0xFF334155),
        height: 1.55,
      ),
    ),
    const SizedBox(height: 12),
    CurriculumAlphaBadgeItem(letter: 'A', text: l10n.stiPreventionItem1),
    CurriculumAlphaBadgeItem(letter: 'B', text: l10n.stiPreventionItem2),
    CurriculumAlphaBadgeItem(letter: 'C', text: l10n.stiPreventionItem3),
    CurriculumAlphaBadgeItem(letter: 'D', text: l10n.stiPreventionItem4),
    CurriculumAlphaBadgeItem(letter: 'E', text: l10n.stiPreventionItem5),
    CurriculumAlphaBadgeItem(letter: 'F', text: l10n.stiPreventionItem6),
  ];
}
