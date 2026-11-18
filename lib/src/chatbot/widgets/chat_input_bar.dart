import 'dart:ui';
import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

/// Floating glassmorphic input capsule with upward-arrow circular send button.
class ChatInputBar extends StatelessWidget {
  const ChatInputBar({
    required this.controller,
    required this.isTyping,
    required this.isDark,
    required this.onSubmitted,
    super.key,
  });

  final TextEditingController controller;
  final bool isTyping;
  final bool isDark;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      margin: const EdgeInsets.fromLTRB(14, 4, 14, 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF0B1428).withValues(alpha: 0.82)
                  : Colors.white.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: isDark
                    ? const Color(0xFF38BDF8).withValues(alpha: 0.25)
                    : const Color(0xFFDCEAF5),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color:
                      isDark ? const Color(0x60000000) : const Color(0x0A005A71),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.send,
                    onSubmitted: onSubmitted,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark
                          ? const Color(0xFFF8FAFC)
                          : const Color(0xFF08264A),
                    ),
                    decoration: InputDecoration(
                      hintText: l10n.chatbotInputHint,
                      hintStyle: TextStyle(
                        fontSize: 13,
                        color: isDark
                            ? const Color(0xFF64748B)
                            : const Color(0xFF94A3B8),
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 8,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: controller,
                  builder: (context, value, _) {
                    final canSend =
                        value.text.trim().isNotEmpty && !isTyping;
                    return Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        gradient: canSend
                            ? LinearGradient(
                                colors: isDark
                                    ? const [
                                        Color(0xFF00F2FE),
                                        Color(0xFF4FACFE),
                                      ]
                                    : const [
                                        Color(0xFF007A78),
                                        Color(0xFF005A71),
                                      ],
                              )
                            : null,
                        color: canSend
                            ? null
                            : (isDark
                                ? const Color(0xFF1E293B)
                                : const Color(0xFFE2E8F0)),
                        shape: BoxShape.circle,
                        boxShadow: canSend
                            ? [
                                BoxShadow(
                                  color: isDark
                                      ? const Color(0xFF00F2FE)
                                          .withValues(alpha: 0.35)
                                      : const Color(0xFF007A78)
                                          .withValues(alpha: 0.25),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_upward_rounded,
                          color: canSend
                              ? Colors.white
                              : (isDark
                                  ? const Color(0xFF64748B)
                                  : const Color(0xFF94A3B8)),
                          size: 20,
                        ),
                        onPressed:
                            canSend ? () => onSubmitted(value.text) : null,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
