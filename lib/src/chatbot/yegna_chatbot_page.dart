import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../theme/app_glass_theme.dart';
import 'chat_history_drawer.dart';
import 'chat_history_repository.dart';
import 'chat_page_flow_mixin.dart';
import 'chatbot_repository.dart';
import 'widgets/chat_ambient_canvas.dart';
import 'widgets/chat_disclaimer_banner.dart';
import 'widgets/chat_input_bar.dart';
import 'widgets/chat_message_tile.dart';
import 'widgets/chat_suggested_chips.dart';
import 'widgets/chat_top_bar.dart';
import 'widgets/chat_typing_indicator.dart';
import 'widgets/chat_welcome_hero.dart';

/// Full-screen conversational AI health assistant screen featuring
/// advanced glassmorphism in both Dark and Light themes.
class YegnaChatbotPage extends StatefulWidget {
  const YegnaChatbotPage({
    required this.repository,
    this.historyRepository,
    this.initialQuery,
    this.userName,
    super.key,
  });

  final ChatbotRepository repository;
  final ChatHistoryRepository? historyRepository;
  final String? initialQuery;
  final String? userName;

  @override
  State<YegnaChatbotPage> createState() => _YegnaChatbotPageState();
}

class _YegnaChatbotPageState extends State<YegnaChatbotPage>
    with ChatPageFlowMixin {
  @override
  void initState() {
    super.initState();
    initChatFlow();
  }

  @override
  void dispose() {
    disposeChatFlow();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = context.isDark;

    return ChatAmbientCanvas(
      isDark: isDark,
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.transparent,
        drawer: ChatHistoryDrawer(
          conversations: sessionManager.conversations,
          activeConversationId: sessionManager.currentSessionId,
          onSelectConversation: selectConversation,
          onNewChat: () => startNewChat(),
          onDeleteConversation: deleteConversation,
          onClearAll: clearAllHistory,
        ),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(68),
          child: ChatTopBar(
            title: sessionManager.currentSessionTitle != null &&
                    sessionManager.currentSessionTitle!.isNotEmpty
                ? sessionManager.currentSessionTitle!
                : l10n.chatbotTitle,
            subtitle: l10n.chatbotSubtitle,
            isDark: isDark,
            onBack: () => Navigator.of(context).pop(),
            onOpenDrawer: () => scaffoldKey.currentState?.openDrawer(),
            onNewChat: () => startNewChat(),
            onClearChat: clearChat,
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              if (showDisclaimer)
                ChatDisclaimerBanner(
                  disclaimer: l10n.chatbotDisclaimer,
                  isDark: isDark,
                  onDismiss: () => setState(() => showDisclaimer = false),
                ),
              Expanded(
                child: GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: isWelcomeState
                      ? ChatWelcomeHero(
                          messages: messages,
                          userName: widget.userName,
                          isDark: isDark,
                          onSelectPrompt: handleSubmitted,
                          onCallPhone: callPhone,
                        )
                      : ListView.builder(
                          controller: scrollController,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          itemCount: messages.length + (isTyping ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == messages.length && isTyping) {
                              return ChatTypingIndicator(
                                label: l10n.chatbotTyping,
                                isDark: isDark,
                              );
                            }
                            final msg = messages[index];
                            return ChatMessageTile(
                              message: msg,
                              isDark: isDark,
                              onSelectPrompt: handleSubmitted,
                              onCallPhone: callPhone,
                            );
                          },
                        ),
                ),
              ),
              ChatSuggestedChips(
                onSelectPrompt: handleSubmitted,
                chips: getLatestSuggestedChips(l10n),
                isDark: isDark,
              ),
              ChatInputBar(
                controller: textController,
                isTyping: isTyping,
                isDark: isDark,
                onSubmitted: handleSubmitted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
