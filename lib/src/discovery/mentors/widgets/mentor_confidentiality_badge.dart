import 'package:flutter/material.dart';

class MentorConfidentialityBadge extends StatelessWidget {
  const MentorConfidentialityBadge({
    required this.isAmharic,
    required this.isDark,
    required this.brandBlue,
    required this.slateText,
    super.key,
  });

  final bool isAmharic;
  final bool isDark;
  final Color brandBlue;
  final Color slateText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.lock_outline_rounded, size: 13, color: brandBlue),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              isAmharic
                  ? 'ውይይትዎ 100% ሚስጥራዊ እና በወጣቶች ደህንነት መመሪያ የተጠበቀ ነው።'
                  : 'All communications are 100% private & youth-safeguarded.',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 11,
                color: slateText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
