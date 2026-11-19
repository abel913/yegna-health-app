import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../../widgets/curriculum/curriculum_bullet_item.dart';

/// Numbered header item for complication sections (1, 2, 3, 4 with bold title & bullet).
class HepatitisNumberedHeaderItem extends StatelessWidget {
  const HepatitisNumberedHeaderItem({
    required this.number,
    required this.title,
    required this.bulletText,
    super.key,
  });

  final int number;
  final String title;
  final String bulletText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: const BoxDecoration(
                  color: Color(0xFF0284C7),
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
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF08264A),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          CurriculumBulletItem(body: bulletText),
        ],
      ),
    );
  }
}

/// Builds children for Section 3: Diagnosis of Hepatitis.
List<Widget> buildHepatitisSection3Children(AppLocalizations l10n) {
  return [
    Text(
      l10n.hepatitisSection3Desc,
      style: const TextStyle(
        fontSize: 13.5,
        color: Color(0xFF334155),
        height: 1.55,
      ),
    ),
  ];
}

/// Builds children for Section 4: Complication of Hepatitis.
List<Widget> buildHepatitisSection4Children(AppLocalizations l10n) {
  return [
    Text(
      l10n.hepatitisSection4Intro,
      style: const TextStyle(
        fontSize: 13.5,
        color: Color(0xFF334155),
        height: 1.55,
      ),
    ),
    const SizedBox(height: 14),
    HepatitisNumberedHeaderItem(
      number: 1,
      title: l10n.hepatitisComp1Title,
      bulletText: l10n.hepatitisComp1Desc,
    ),
    HepatitisNumberedHeaderItem(
      number: 2,
      title: l10n.hepatitisComp2Title,
      bulletText: l10n.hepatitisComp2Desc,
    ),
    HepatitisNumberedHeaderItem(
      number: 3,
      title: l10n.hepatitisComp3Title,
      bulletText: l10n.hepatitisComp3Desc,
    ),
    HepatitisNumberedHeaderItem(
      number: 4,
      title: l10n.hepatitisComp4Title,
      bulletText: l10n.hepatitisComp4Desc,
    ),
    Text(
      l10n.hepatitisSection4Conclusion,
      style: const TextStyle(
        fontSize: 13.5,
        color: Color(0xFF334155),
        height: 1.55,
      ),
    ),
  ];
}

/// Builds children for Section 5: Management and treatment of Hepatitis.
List<Widget> buildHepatitisSection5Children(AppLocalizations l10n) {
  return [
    Text(
      l10n.hepatitisSection5Desc,
      style: const TextStyle(
        fontSize: 13.5,
        color: Color(0xFF334155),
        height: 1.55,
      ),
    ),
  ];
}

/// Builds children for Section 6: Prevention Of Hepatitis.
List<Widget> buildHepatitisSection6Children(AppLocalizations l10n) {
  return [
    Text(
      l10n.hepatitisSection6Subtitle,
      style: const TextStyle(
        fontSize: 14.5,
        fontWeight: FontWeight.w800,
        color: Color(0xFF08264A),
      ),
    ),
    const SizedBox(height: 12),
    CurriculumBulletItem(body: l10n.hepatitisPreventionMeasure1),
    const SizedBox(height: 8),
    CurriculumBulletItem(body: l10n.hepatitisPreventionMeasure2),
    const SizedBox(height: 8),
    CurriculumBulletItem(body: l10n.hepatitisPreventionMeasure3),
    const SizedBox(height: 8),
    CurriculumBulletItem(body: l10n.hepatitisPreventionMeasure4),
  ];
}
