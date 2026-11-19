import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';

/// Section header displaying title and read count pill for dynamic modules.
class DynamicSectionHeader extends StatelessWidget {
  const DynamicSectionHeader({
    required this.l10n,
    required this.readCount,
    required this.totalSections,
    super.key,
  });

  final AppLocalizations l10n;
  final int readCount;
  final int totalSections;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3.5,
          height: 18,
          decoration: BoxDecoration(
            color: const Color(0xFF0284C7),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          l10n.learningSectionsTitle,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: Color(0xFF08264A),
            letterSpacing: -0.2,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFDDF0FD),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            l10n.readSectionsCount(readCount, totalSections),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0369A1),
            ),
          ),
        ),
      ],
    );
  }
}
