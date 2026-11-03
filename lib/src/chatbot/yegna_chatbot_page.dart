import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../l10n/app_localizations.dart';
import 'chatbot_models.dart';
import 'chatbot_repository.dart';
import 'formatted_chat_message.dart';

/// Full-screen conversational AI health assistant screen.
class YegnaChatbotPage extends StatefulWidget {
  const YegnaChatbotPage({
    required this.repository,
    this.initialQuery,
    super.key,
  });

  final ChatbotRepository repository;
  final String? initialQuery;

  @override
  State<YegnaChatbotPage> createState() => _YegnaChatbotPageState();
}

class _YegnaChatbotPageState extends State<YegnaChatbotPage> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;
  bool _showDisclaimer = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeWelcome();
      if (widget.initialQuery != null &&
          widget.initialQuery!.trim().isNotEmpty) {
        _handleSubmitted(widget.initialQuery!.trim());
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _initializeWelcome() {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _messages.add(
        ChatMessage(
          id: 'welcome_0',
          text: l10n.chatbotWelcomeMessage,
          isUser: false,
          timestamp: DateTime.now(),
          suggestedPrompts: [
            l10n.chatbotSuggestedHiv,
            l10n.chatbotSuggestedPuberty,
            l10n.chatbotSuggestedClinics,
            l10n.chatbotSuggestedContraception,
          ],
        ),
      );
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  Future<void> _handleSubmitted(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || _isTyping) return;

    _textController.clear();
    final l10n = AppLocalizations.of(context);
    final userMessage = ChatMessage(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      text: trimmed,
      isUser: true,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(userMessage);
      _isTyping = true;
    });
    _scrollToBottom();

    try {
      final languageCode = Localizations.localeOf(context).languageCode;
      final response = await widget.repository.sendMessage(
        trimmed,
        languageCode: languageCode,
        history: _messages,
      );

      if (mounted) {
        setState(() {
          _messages.add(response);
          _isTyping = false;
        });
        _scrollToBottom();
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _messages.add(
            ChatMessage(
              id: 'err_${DateTime.now().millisecondsSinceEpoch}',
              text: l10n.errorUnexpected,
              isUser: false,
              timestamp: DateTime.now(),
            ),
          );
          _isTyping = false;
        });
        _scrollToBottom();
      }
    }
  }

  Future<void> _callPhone(String number) async {
    final uri = Uri.parse('tel:$number');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    } catch (_) {
      // Graceful fallback if device lacks telephony support
    }
  }

  void _clearChat() {
    setState(() {
      _messages.clear();
      _initializeWelcome();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F8FC),
      appBar: AppBar(
        backgroundColor: Colors.white.withValues(alpha: 0.85),
        elevation: 0,
        scrolledUnderElevation: 0,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF08264A), size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF007A78), Color(0xFF005A71)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF007A78).withValues(alpha: 0.25),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(Icons.smart_toy_rounded,
                        color: Colors.white, size: 20),
                  ),
                ),
                Positioned(
                  bottom: -1,
                  right: -1,
                  child: Container(
                    width: 11,
                    height: 11,
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.chatbotTitle,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF08264A),
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    l10n.chatbotSubtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF5A758E),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep_outlined,
                color: Color(0xFF5A758E), size: 22),
            tooltip: l10n.chatbotClearChat,
            onPressed: _clearChat,
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Safety Disclaimer Banner
            if (_showDisclaimer)
              Container(
                margin: const EdgeInsets.fromLTRB(14, 10, 14, 4),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xFFBAE6FD),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.health_and_safety_outlined,
                        color: Color(0xFF0284C7), size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        l10n.chatbotDisclaimer,
                        style: const TextStyle(
                          fontSize: 11.5,
                          height: 1.35,
                          color: Color(0xFF0369A1),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded,
                          size: 16, color: Color(0xFF0284C7)),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => setState(() => _showDisclaimer = false),
                    ),
                  ],
                ),
              ),

            // Scrollable Messages Thread
            Expanded(
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: ListView.builder(
                  controller: _scrollController,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  itemCount: _messages.length + (_isTyping ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _messages.length && _isTyping) {
                      return _TypingBubble(label: l10n.chatbotTyping);
                    }
                    final msg = _messages[index];
                    return _MessageTile(
                      message: msg,
                      onSelectPrompt: _handleSubmitted,
                      onCallPhone: _callPhone,
                    );
                  },
                ),
              ),
            ),

            // Suggested Chips Row (shows latest suggestions or defaults)
            _SuggestedChipsBar(
              onSelectPrompt: _handleSubmitted,
              chips: _getLatestSuggestedChips(l10n),
            ),

            // Bottom Input Row
            _ChatInputBar(
              controller: _textController,
              isTyping: _isTyping,
              onSubmitted: _handleSubmitted,
            ),
          ],
        ),
      ),
    );
  }

  List<String> _getLatestSuggestedChips(AppLocalizations l10n) {
    for (int i = _messages.length - 1; i >= 0; i--) {
      if (!_messages[i].isUser && _messages[i].suggestedPrompts.isNotEmpty) {
        return _messages[i].suggestedPrompts;
      }
    }
    return [
      l10n.chatbotSuggestedHiv,
      l10n.chatbotSuggestedPuberty,
      l10n.chatbotSuggestedClinics,
      l10n.chatbotSuggestedContraception,
    ];
  }
}

class _MessageTile extends StatelessWidget {
  const _MessageTile({
    required this.message,
    required this.onSelectPrompt,
    required this.onCallPhone,
  });

  final ChatMessage message;
  final ValueChanged<String> onSelectPrompt;
  final ValueChanged<String> onCallPhone;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isUser) ...[
                Container(
                  width: 30,
                  height: 30,
                  margin: const EdgeInsets.only(right: 8, bottom: 2),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF007A78), Color(0xFF005A71)],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(Icons.smart_toy_rounded,
                        color: Colors.white, size: 16),
                  ),
                ),
              ],
              Flexible(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: isUser
                        ? MediaQuery.of(context).size.width * 0.78
                        : (MediaQuery.of(context).size.width * 0.88)
                            .clamp(280.0, 580.0),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isUser ? null : Colors.white,
                    gradient: isUser
                        ? const LinearGradient(
                            colors: [Color(0xFF007A78), Color(0xFF005A71)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(isUser ? 18 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 18),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isUser
                            ? const Color(0xFF007A78).withValues(alpha: 0.18)
                            : Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    border: isUser
                        ? null
                        : Border.all(
                            color: message.isEmergency
                                ? const Color(0xFFFCA5A5)
                                : const Color(0xFFE2E8F0),
                            width: message.isEmergency ? 1.5 : 1,
                          ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Emergency Alert Header
                      if (message.isEmergency) ...[
                        Row(
                          children: [
                            const Icon(Icons.warning_amber_rounded,
                                color: Color(0xFFDC2626), size: 18),
                            const SizedBox(width: 6),
                            Text(
                              l10n.chatbotEmergencyTitle,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFFDC2626),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],

                      // Message Body (Formatted Structured Markdown)
                      FormattedChatMessage(
                        text: message.text,
                        isUser: isUser,
                      ),

                      // Assistant Actions Footer: One-tap Copy
                      if (!isUser) ...[
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              borderRadius: BorderRadius.circular(8),
                              onTap: () {
                                final clean = FormattedChatMessage.toPlainText(
                                    message.text);
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 3),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.copy_rounded,
                                      size: 13,
                                      color: Color(0xFF64748B),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      l10n.copyResponseAction,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF64748B),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],

                      // Emergency Hotline Action Buttons
                      if (message.isEmergency &&
                          message.emergencyHotlines.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: message.emergencyHotlines.map((hotline) {
                            return ElevatedButton.icon(
                              onPressed: () => onCallPhone(hotline.number),
                              icon: const Icon(Icons.phone_in_talk_rounded,
                                  size: 16),
                              label: Text('${hotline.name} (${hotline.number})',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFDC2626),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ],
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

class _TypingBubble extends StatelessWidget {
  const _TypingBubble({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            margin: const EdgeInsets.only(right: 8),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF007A78), Color(0xFF005A71)],
              ),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child:
                  Icon(Icons.smart_toy_rounded, color: Colors.white, size: 16),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(18),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(width: 8),
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFF007A78)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SuggestedChipsBar extends StatelessWidget {
  const _SuggestedChipsBar({
    required this.chips,
    required this.onSelectPrompt,
  });

  final List<String> chips;
  final ValueChanged<String> onSelectPrompt;

  @override
  Widget build(BuildContext context) {
    if (chips.isEmpty) return const SizedBox.shrink();

    return Container(
      height: 44,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: chips.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final chip = chips[index];
          return ActionChip(
            label: Text(
              chip,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF005A71),
              ),
            ),
            backgroundColor: Colors.white,
            side: const BorderSide(color: Color(0xFFBAE6FD), width: 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            onPressed: () => onSelectPrompt(chip),
          );
        },
      ),
    );
  }
}

class _ChatInputBar extends StatelessWidget {
  const _ChatInputBar({
    required this.controller,
    required this.isTyping,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final bool isTyping;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color(0xFFE2E8F0),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: TextField(
                controller: controller,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.send,
                onSubmitted: onSubmitted,
                decoration: InputDecoration(
                  hintText: l10n.chatbotInputHint,
                  hintStyle: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF94A3B8),
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, _) {
              final canSend = value.text.trim().isNotEmpty && !isTyping;
              return Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: canSend
                      ? const LinearGradient(
                          colors: [Color(0xFF007A78), Color(0xFF005A71)],
                        )
                      : null,
                  color: canSend ? null : const Color(0xFFE2E8F0),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_upward_rounded,
                    color: canSend ? Colors.white : const Color(0xFF94A3B8),
                    size: 22,
                  ),
                  onPressed: canSend ? () => onSubmitted(value.text) : null,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
