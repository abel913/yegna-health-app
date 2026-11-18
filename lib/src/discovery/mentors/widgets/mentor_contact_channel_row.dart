import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

export 'mentor_voice_contact_channel_row.dart';

class MentorContactChannelRow extends StatelessWidget {
  const MentorContactChannelRow({
    required this.icon,
    required this.iconBgColor,
    required this.title,
    required this.subtitle,
    required this.subtitleColor,
    required this.copyTooltip,
    required this.copyContent,
    required this.actionLabel,
    required this.actionBgColor,
    required this.onAction,
    required this.isDark,
    super.key,
  });

  final IconData icon;
  final Color iconBgColor;
  final String title;
  final String subtitle;
  final Color subtitleColor;
  final String copyTooltip;
  final String copyContent;
  final String actionLabel;
  final Color actionBgColor;
  final VoidCallback onAction;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final rowBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final rowBorder =
        isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);
    final titleColor =
        isDark ? const Color(0xFFF8FAFC) : const Color(0xFF08264A);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: rowBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: rowBorder, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: titleColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 1),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: subtitleColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          SizedBox(
            width: 32,
            height: 32,
            child: IconButton(
              padding: EdgeInsets.zero,
              tooltip: copyTooltip,
              icon: Icon(
                Icons.copy_rounded,
                size: 16,
                color:
                    isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7),
              ),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: copyContent));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$copyTooltip ($copyContent)'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 4),
          ElevatedButton(
            onPressed: onAction,
            style: ElevatedButton.styleFrom(
              backgroundColor: actionBgColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              minimumSize: const Size(0, 34),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            child: Text(
              actionLabel,
              style: const TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
