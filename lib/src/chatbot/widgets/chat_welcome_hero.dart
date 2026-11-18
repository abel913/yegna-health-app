import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../chatbot_models.dart';
import '../luminous_chatbot_orb.dart';
import 'chat_message_tile.dart';

class ChatWelcomeHero extends StatelessWidget {
  const ChatWelcomeHero({
    required this.messages,
    required this.userName,
    required this.isDark,
    required this.onSelectPrompt,
    required this.onCallPhone,
    super.key,
  });

  final List<ChatMessage> messages;
  final String? userName;
  final bool isDark;
  final ValueChanged<String> onSelectPrompt;
  final ValueChanged<String> onCallPhone;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hasName = userName != null && userName!.trim().isNotEmpty;
    final greeting = hasName
        ? l10n.chatbotHeroGreetingWithUser(userName!.trim())
        : l10n.chatbotHeroGreetingDefault;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 24),
          Center(
            child: LuminousChatbotOrb(
              size: 118,
              isDark: isDark,
              animate: true,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            greeting,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              height: 1.25,
              color: isDark ? const Color(0xFFF8FAFC) : const Color(0xFF08264A),
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 18),
          if (messages.isNotEmpty)
            ChatMessageTile(
              message: messages.first,
              isDark: isDark,
              onSelectPrompt: onSelectPrompt,
              onCallPhone: onCallPhone,
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
