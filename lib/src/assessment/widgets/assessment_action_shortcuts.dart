import 'package:flutter/material.dart';

/// Side-by-side action shortcut cards for mentors and facilities.
class AssessmentActionShortcuts extends StatelessWidget {
  const AssessmentActionShortcuts({
    required this.onOpenMentors,
    required this.onOpenFacilities,
    required this.isDark,
    required this.isAmharic,
    super.key,
  });

  final VoidCallback? onOpenMentors;
  final VoidCallback? onOpenFacilities;
  final bool isDark;
  final bool isAmharic;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionCard(
            icon: Icons.people_alt_rounded,
            iconColor: const Color(0xFF0284C7),
            bgColor: const Color(0xFFE0F2FE),
            buttonLabel: isAmharic ? 'አማካሪ አግኝ' : 'Talk to Mentor',
            buttonIcon: Icons.person_rounded,
            onTap: onOpenMentors,
            isDark: isDark,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _ActionCard(
            icon: Icons.local_hospital_rounded,
            iconColor: const Color(0xFF0D9488),
            bgColor: const Color(0xFFCCFBF1),
            buttonLabel: isAmharic ? 'አገልግሎት አግኝ' : 'Get Service',
            buttonIcon: Icons.add_rounded,
            onTap: onOpenFacilities,
            isDark: isDark,
          ),
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.buttonLabel,
    required this.buttonIcon,
    required this.onTap,
    required this.isDark,
  });

  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final String buttonLabel;
  final IconData buttonIcon;
  final VoidCallback? onTap;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: isDark ? iconColor.withValues(alpha: 0.15) : bgColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(icon, color: iconColor, size: 28),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onTap,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF00587A),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: Icon(buttonIcon, size: 15),
              label: Text(
                buttonLabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
