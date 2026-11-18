import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../models/mentor.dart';

class MentorContactsHeader extends StatelessWidget {
  const MentorContactsHeader({
    required this.mentor,
    required this.l10n,
    required this.isAmharic,
    required this.isDark,
    required this.brandBlue,
    required this.brandNavy,
    required this.slateText,
    super.key,
  });

  final Mentor mentor;
  final AppLocalizations l10n;
  final bool isAmharic;
  final bool isDark;
  final Color brandBlue;
  final Color brandNavy;
  final Color slateText;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE0F2FE),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.connect_without_contact_rounded,
            color: brandBlue,
            size: 20,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.directContactsHeading,
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: brandNavy,
                ),
              ),
              Text(
                l10n.workingHoursLabel(
                    mentor.localizedWorkingHours(isAmharic)),
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 11.5,
                  color: slateText,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
