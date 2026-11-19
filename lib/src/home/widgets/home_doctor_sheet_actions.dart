import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../theme/app_glass_theme.dart';

class HomeDoctorSheetActions extends StatelessWidget {
  const HomeDoctorSheetActions({
    required this.l10n,
    required this.onOpenMentors,
    required this.onClose,
    super.key,
  });

  final AppLocalizations l10n;
  final VoidCallback onOpenMentors;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final glass = context.glassTheme;
    final isDark = glass.isDark;

    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onOpenMentors,
            icon: const Icon(Icons.people_alt_rounded, size: 18),
            label: Text(
              l10n.askMentorAction,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: glass.accentColor,
              side: BorderSide(
                color: isDark ? glass.cardBorder : const Color(0xFFBAE6FD),
              ),
              padding: const EdgeInsets.symmetric(vertical: 13),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: onClose,
            style: ElevatedButton.styleFrom(
              backgroundColor: glass.accentColor,
              foregroundColor: isDark ? Colors.black : Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 13),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: Text(
              l10n.closeArticleAction,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
