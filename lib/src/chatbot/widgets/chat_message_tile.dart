import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../l10n/app_localizations.dart';
import '../chatbot_models.dart';
import '../formatted_chat_message.dart';
import '../luminous_chatbot_orb.dart';
import 'chat_hotlines_card.dart';

class ChatMessageTile extends StatelessWidget {
  const ChatMessageTile({
    required this.message,
    required this.isDark,
    required this.onSelectPrompt,
    required this.onCallPhone,
    super.key,
  });

  final ChatMessage message;
  final bool isDark;
  final ValueChanged<String> onSelectPrompt;
  final ValueChanged<String> onCallPhone;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isUser) ...[
                Container(
                  margin: const EdgeInsets.only(right: 8, bottom: 2),
                  child: LuminousChatbotOrb(size: 28, isDark: isDark, animate: false),
                ),
              ],
              Flexible(
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20),
                    bottomLeft: Radius.circular(isUser ? 20 : 4),
                    bottomRight: Radius.circular(isUser ? 4 : 20),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: isUser
                            ? MediaQuery.of(context).size.width * 0.78
                            : (MediaQuery.of(context).size.width * 0.88).clamp(280.0, 580.0),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: isUser
                            ? (isDark ? const Color(0xFF0284C7).withValues(alpha: 0.38) : null)
                            : (isDark ? const Color(0xFF0F1E36).withValues(alpha: 0.70) : Colors.white.withValues(alpha: 0.85)),
                        gradient: isUser
                            ? (isDark
                                ? null
                                : const LinearGradient(
                                    colors: [Color(0xFF007A78), Color(0xFF005A71)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ))
                            : null,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(20),
                          topRight: const Radius.circular(20),
                          bottomLeft: Radius.circular(isUser ? 20 : 4),
                          bottomRight: Radius.circular(isUser ? 4 : 20),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isUser
                                ? (isDark ? const Color(0x3038BDF8) : const Color(0xFF007A78).withValues(alpha: 0.18))
                                : (isDark ? const Color(0x50000000) : const Color(0x0A005A71)),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                        border: Border.all(
                          color: isUser
                              ? (isDark ? const Color(0xFF38BDF8).withValues(alpha: 0.35) : Colors.white.withValues(alpha: 0.30))
                              : (message.isEmergency
                                  ? const Color(0xFFFCA5A5)
                                  : (isDark ? const Color(0xFF38BDF8).withValues(alpha: 0.20) : const Color(0xFFBAE6FD).withValues(alpha: 0.60))),
                          width: message.isEmergency ? 1.5 : 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (message.isEmergency) ...[
                            Row(
                              children: [
                                const Icon(Icons.warning_amber_rounded, color: Color(0xFFDC2626), size: 18),
                                const SizedBox(width: 6),
                                Text(
                                  l10n.chatbotEmergencyTitle,
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFFDC2626)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                          ],
                          FormattedChatMessage(text: message.text, isUser: isUser),
                          if (!isUser) ...[
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  borderRadius: BorderRadius.circular(8),
                                  onTap: () {
                                    final clean = FormattedChatMessage.toPlainText(message.text);
                                    Clipboard.setData(ClipboardData(text: clean));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(l10n.responseCopiedMessage),
                                        duration: const Duration(seconds: 2),
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.copy_rounded,
                                          size: 13,
                                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          l10n.copyResponseAction,
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                          ChatHotlinesCard(hotlines: message.emergencyHotlines, onCallPhone: onCallPhone),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
