import 'package:flutter/material.dart';

import 'mentor_detail_cards.dart';

class MentorLanguagesCard extends StatelessWidget {
  const MentorLanguagesCard({
    required this.languages,
    required this.title,
    required this.isDark,
    super.key,
  });

  final List<String> languages;
  final String title;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return MentorDetailCard(
      title: title,
      icon: Icons.translate_rounded,
      isDark: isDark,
      child: Wrap(
        spacing: 8,
        runSpacing: 6,
        children: [
          for (final lang in languages)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF1E293B)
                    : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                lang,
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? const Color(0xFFF8FAFC)
                      : const Color(0xFF334155),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
