import 'package:flutter/material.dart';

import '../../theme/app_glass_theme.dart';
import '../club_controller.dart';
import '../club_models.dart';

class ClubRosterSection extends StatelessWidget {
  const ClubRosterSection({
    required this.clubId,
    required this.controller,
    required this.isAmharic,
    required this.isDark,
    required this.glass,
    super.key,
  });

  final String clubId;
  final ClubController controller;
  final bool isAmharic;
  final bool isDark;
  final AppGlassTheme glass;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ClubMembership>>(
      future: controller.getClubMembers(clubId),
      builder: (context, snapshot) {
        final members = snapshot.data ?? [];
        if (members.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isAmharic ? 'የክበቡ አባላት' : 'Club Members',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: glass.titleText,
                  ),
                ),
                Text(
                  '${members.length} ${isAmharic ? "ተማሪዎች" : "enrolled"}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: glass.subtitleText,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF131D36).withValues(alpha: 0.70)
                    : Colors.white.withValues(alpha: 0.65),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF38BDF8).withValues(alpha: 0.20)
                      : Colors.white.withValues(alpha: 0.90),
                ),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: members.length,
                separatorBuilder: (_, __) => Divider(
                  height: 1,
                  color: isDark
                      ? const Color(0xFF1E293B)
                      : const Color(0xFFF1F5F9),
                ),
                itemBuilder: (context, idx) {
                  final m = members[idx];
                  final isLead = m.role == 'lead';
                  return ListTile(
                    dense: true,
                    leading: CircleAvatar(
                      radius: 16,
                      backgroundColor: isLead
                          ? const Color(0xFF0284C7)
                          : const Color(0xFF64748B),
                      child: Text(
                        m.userName.isNotEmpty ? m.userName[0].toUpperCase() : 'U',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    title: Text(
                      m.userName,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: glass.titleText,
                      ),
                    ),
                    subtitle: Text(
                      m.userEmail,
                      style: TextStyle(
                        fontSize: 11,
                        color: glass.subtitleText,
                      ),
                    ),
                    trailing: isLead
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0284C7).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              isAmharic ? 'መሪ' : 'Lead',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0284C7),
                              ),
                            ),
                          )
                        : null,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
