import 'dart:ui';
import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../luminous_chatbot_orb.dart';

class ChatTopBar extends StatelessWidget {
  const ChatTopBar({
    required this.title,
    required this.subtitle,
    required this.isDark,
    required this.onBack,
    required this.onOpenDrawer,
    required this.onNewChat,
    required this.onClearChat,
    super.key,
  });

  final String title;
  final String subtitle;
  final bool isDark;
  final VoidCallback onBack;
  final VoidCallback onOpenDrawer;
  final VoidCallback onNewChat;
  final VoidCallback onClearChat;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(26),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              height: 58,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF0B1428).withValues(alpha: 0.78)
                    : Colors.white.withValues(alpha: 0.82),
                borderRadius: BorderRadius.circular(26),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF38BDF8).withValues(alpha: 0.22)
                      : Colors.white.withValues(alpha: 0.90),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark ? const Color(0x60000000) : const Color(0x10005A71),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: isDark ? const Color(0xFFF8FAFC) : const Color(0xFF08264A),
                      size: 19,
                    ),
                    onPressed: onBack,
                  ),
                  const SizedBox(width: 2),
                  LuminousChatbotOrb(
                    size: 30,
                    isDark: isDark,
                    animate: true,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: isDark ? const Color(0xFFF8FAFC) : const Color(0xFF08264A),
                            letterSpacing: -0.2,
                          ),
                        ),
                        Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w500,
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF5A758E),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.history_rounded,
                      color: isDark ? const Color(0xFF38BDF8) : const Color(0xFF005A71),
                      size: 22,
                    ),
                    tooltip: l10n.chatHistoryTitle,
                    onPressed: onOpenDrawer,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.add_comment_outlined,
                      color: isDark ? const Color(0xFF38BDF8) : const Color(0xFF007A78),
                      size: 21,
                    ),
                    tooltip: l10n.newChatAction,
                    onPressed: onNewChat,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete_sweep_outlined,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                      size: 21,
                    ),
                    tooltip: l10n.chatbotClearChat,
                    onPressed: onClearChat,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
