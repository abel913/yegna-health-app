import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import 'chat_history_repository.dart';
import 'chat_page_helpers.dart';
import 'chat_page_session_manager.dart';
import 'chatbot_models.dart';
import 'yegna_chatbot_page.dart';

mixin ChatPageFlowMixin on State<YegnaChatbotPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late final ChatPageSessionManager sessionManager;

  final List<ChatMessage> messages = [];
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  bool isTyping = false;
  bool showDisclaimer = true;

  void initChatFlow() {
    sessionManager = ChatPageSessionManager(
      repository:
          widget.historyRepository ?? SharedPreferencesChatHistoryRepository(),
    )..initSession();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initializeWelcome();
      await sessionManager.loadHistory();
      if (mounted) setState(() {});
      if (widget.initialQuery != null &&
          widget.initialQuery!.trim().isNotEmpty) {
        handleSubmitted(widget.initialQuery!.trim());
      }
    });
  }

  void disposeChatFlow() {
    textController.dispose();
    scrollController.dispose();
  }

  void initializeWelcome() {
    final l10n = AppLocalizations.of(context);
    setState(() {
      messages.add(ChatPageHelpers.createWelcomeMessage(l10n));
    });
  }

  Future<void> startNewChat({
    bool saveCurrent = true,
    bool closeDrawer = true,
  }) async {
    if (saveCurrent &&
        messages.length > 1 &&
        sessionManager.currentSessionId != null) {
      await sessionManager.persistSession(messages);
    }
    if (!mounted) return;
    if (closeDrawer && (scaffoldKey.currentState?.isDrawerOpen ?? false)) {
      Navigator.of(context).pop();
    }
    setState(() {
      sessionManager.startNewSession();
      messages.clear();
      initializeWelcome();
    });
    scrollToBottom();
  }

  void selectConversation(ChatConversation conversation) {
    if (scaffoldKey.currentState?.isDrawerOpen ?? false) {
      Navigator.of(context).pop();
    }
    setState(() {
      sessionManager.selectSession(conversation);
      messages.clear();
      messages.addAll(conversation.messages);
      if (messages.isEmpty) initializeWelcome();
    });
    scrollToBottom();
  }

  Future<void> deleteConversation(String id) async {
    await sessionManager.deleteSession(id);
    if (mounted) {
      setState(() {});
      if (sessionManager.currentSessionId == id) {
        await startNewChat(saveCurrent: false, closeDrawer: false);
      }
    }
  }

  Future<void> clearAllHistory() async {
    await sessionManager.clearAll();
    if (mounted) {
      setState(() {});
      await startNewChat(saveCurrent: false, closeDrawer: false);
    }
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  Future<void> handleSubmitted(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || isTyping) return;

    textController.clear();
    final l10n = AppLocalizations.of(context);
    final userMessage = ChatMessage(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      text: trimmed,
      isUser: true,
      timestamp: DateTime.now(),
    );

    sessionManager.currentSessionTitle ??=
        sessionManager.generateTitle(trimmed);
    if (sessionManager.currentSessionId == null) {
      sessionManager.initSession();
    }

    final languageCode = Localizations.localeOf(context).languageCode;
    setState(() {
      messages.add(userMessage);
      isTyping = true;
    });
    scrollToBottom();
    await sessionManager.persistSession(messages);

    try {
      final response = await widget.repository.sendMessage(
        trimmed,
        languageCode: languageCode,
        history: messages,
      );
      if (mounted) {
        setState(() {
          messages.add(response);
          isTyping = false;
        });
        scrollToBottom();
        await sessionManager.persistSession(messages);
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          messages.add(
            ChatMessage(
              id: 'err_${DateTime.now().millisecondsSinceEpoch}',
              text: l10n.errorUnexpected,
              isUser: false,
              timestamp: DateTime.now(),
            ),
          );
          isTyping = false;
        });
        scrollToBottom();
        await sessionManager.persistSession(messages);
      }
    }
  }

  Future<void> callPhone(String number) => ChatPageHelpers.callPhone(number);

  void clearChat() {
    setState(() {
      messages.clear();
      initializeWelcome();
    });
    sessionManager.persistSession(messages);
  }

  bool get isWelcomeState =>
      messages.length <= 1 && !messages.any((m) => m.isUser);

  List<String> getLatestSuggestedChips(AppLocalizations l10n) =>
      ChatPageHelpers.getSuggestedChips(messages, l10n);
}
