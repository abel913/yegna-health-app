import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../l10n/app_localizations.dart';
import '../theme/app_glass_theme.dart';
import 'chat_history_drawer.dart';
import 'chat_history_repository.dart';
import 'chatbot_models.dart';
import 'chatbot_repository.dart';
import 'formatted_chat_message.dart';
import 'luminous_chatbot_orb.dart';

/// Full-screen conversational AI health assistant screen featuring
/// advanced glassmorphism in both Dark (Cosmic Obsidian) and Light (Frosted Arctic)
/// themes, 3D animated luminous orb, floating capsule header, and multi-session history.
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

class _YegnaChatbotPageState extends State<YegnaChatbotPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late final ChatHistoryRepository _historyRepository;
  List<ChatConversation> _conversations = [];
  String? _currentSessionId;
  String? _currentSessionTitle;
  DateTime? _currentSessionCreatedAt;

  final List<ChatMessage> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;
  bool _showDisclaimer = true;

  @override
  void initState() {
    super.initState();
    _historyRepository =
        widget.historyRepository ?? SharedPreferencesChatHistoryRepository();
    _currentSessionId = 'session_${DateTime.now().millisecondsSinceEpoch}';
    _currentSessionCreatedAt = DateTime.now();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeWelcome();
      _loadHistory();
      if (widget.initialQuery != null &&
          widget.initialQuery!.trim().isNotEmpty) {
        _handleSubmitted(widget.initialQuery!.trim());
      }
    });
  }

  Future<void> _loadHistory() async {
    try {
      final list = await _historyRepository.loadConversations();
      if (mounted) {
        setState(() {
          _conversations = list;
        });
      }
    } catch (_) {
      // Graceful fallback
    }
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

  String _generateTitle(String text) {
    var cleaned = text.replaceAll(RegExp(r'[\r\n]+'), ' ').trim();
    if (cleaned.length > 36) {
      cleaned = '${cleaned.substring(0, 36).trim()}...';
    }
    return cleaned;
  }

  Future<void> _persistCurrentSession() async {
    if (_currentSessionId == null) return;
    // Don't persist empty welcome-only sessions
    if (_messages.length <= 1 && !_messages.any((m) => m.isUser)) return;

    final conv = ChatConversation(
      id: _currentSessionId!,
      title: _currentSessionTitle ?? 'Health Conversation',
      createdAt: _currentSessionCreatedAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
      messages: List.from(_messages),
    );
    await _historyRepository.saveConversation(conv);
    final updatedList = await _historyRepository.loadConversations();
    if (mounted) {
      setState(() {
        _conversations = updatedList;
      });
    }
  }

  Future<void> _startNewChat({
    bool saveCurrent = true,
    bool closeDrawer = true,
  }) async {
    if (saveCurrent && _messages.length > 1 && _currentSessionId != null) {
      await _persistCurrentSession();
    }

    if (!mounted) return;

    if (closeDrawer && (_scaffoldKey.currentState?.isDrawerOpen ?? false)) {
      Navigator.of(context).pop();
    }

    setState(() {
      _currentSessionId = 'session_${DateTime.now().millisecondsSinceEpoch}';
      _currentSessionTitle = null;
      _currentSessionCreatedAt = DateTime.now();
      _messages.clear();
      _initializeWelcome();
    });
    _scrollToBottom();
  }

  void _selectConversation(ChatConversation conversation) {
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
      Navigator.of(context).pop();
    }

    setState(() {
      _currentSessionId = conversation.id;
      _currentSessionTitle = conversation.title;
      _currentSessionCreatedAt = conversation.createdAt;
      _messages.clear();
      _messages.addAll(conversation.messages);
      if (_messages.isEmpty) {
        _initializeWelcome();
      }
    });
    _scrollToBottom();
  }

  Future<void> _deleteConversation(String id) async {
    await _historyRepository.deleteConversation(id);
    final updated = await _historyRepository.loadConversations();
    if (mounted) {
      setState(() {
        _conversations = updated;
      });
      if (_currentSessionId == id) {
        await _startNewChat(saveCurrent: false, closeDrawer: false);
      }
    }
  }

  Future<void> _clearAllHistory() async {
    await _historyRepository.clearAll();
    if (mounted) {
      setState(() {
        _conversations = [];
      });
      await _startNewChat(saveCurrent: false, closeDrawer: false);
    }
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

    _currentSessionTitle ??= _generateTitle(trimmed);
    _currentSessionId ??= 'session_${DateTime.now().millisecondsSinceEpoch}';

    final languageCode = Localizations.localeOf(context).languageCode;

    setState(() {
      _messages.add(userMessage);
      _isTyping = true;
    });
    _scrollToBottom();
    await _persistCurrentSession();

    try {
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
        await _persistCurrentSession();
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
        await _persistCurrentSession();
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
    _persistCurrentSession();
  }

  bool get _isWelcomeState =>
      _messages.length <= 1 && !_messages.any((m) => m.isUser);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = context.isDark;

    return _AmbientGlassCanvas(
      isDark: isDark,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.transparent,
        drawer: ChatHistoryDrawer(
          conversations: _conversations,
          activeConversationId: _currentSessionId,
          onSelectConversation: _selectConversation,
          onNewChat: () => _startNewChat(),
          onDeleteConversation: _deleteConversation,
          onClearAll: _clearAllHistory,
        ),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(68),
          child: _FloatingGlassCapsuleBar(
            title:
                _currentSessionTitle != null && _currentSessionTitle!.isNotEmpty
                    ? _currentSessionTitle!
                    : l10n.chatbotTitle,
            subtitle: l10n.chatbotSubtitle,
            isDark: isDark,
            onBack: () => Navigator.of(context).pop(),
            onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
            onNewChat: () => _startNewChat(),
            onClearChat: _clearChat,
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Safety Disclaimer Banner (dismissible)
              if (_showDisclaimer)
                _GlassDisclaimerBanner(
                  disclaimer: l10n.chatbotDisclaimer,
                  isDark: isDark,
                  onDismiss: () => setState(() => _showDisclaimer = false),
                ),

              // Main Conversation Thread / Welcome Hero
              Expanded(
                child: GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: _isWelcomeState
                      ? _WelcomeHeroView(
                          messages: _messages,
                          userName: widget.userName,
                          isDark: isDark,
                          onSelectPrompt: _handleSubmitted,
                          onCallPhone: _callPhone,
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 12),
                          itemCount: _messages.length + (_isTyping ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == _messages.length && _isTyping) {
                              return _GlassTypingBubble(
                                label: l10n.chatbotTyping,
                                isDark: isDark,
                              );
                            }
                            final msg = _messages[index];
                            return _MessageTile(
                              message: msg,
                              isDark: isDark,
                              onSelectPrompt: _handleSubmitted,
                              onCallPhone: _callPhone,
                            );
                          },
                        ),
                ),
              ),

              // Suggested Chips Row (docked above input)
              _SuggestedChipsBar(
                onSelectPrompt: _handleSubmitted,
                chips: _getLatestSuggestedChips(l10n),
                isDark: isDark,
              ),

              // Floating Bottom Input Capsule
              _ChatInputBar(
                controller: _textController,
                isTyping: _isTyping,
                isDark: isDark,
                onSubmitted: _handleSubmitted,
              ),
            ],
          ),
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

/// Ambient background canvas featuring atmospheric light pools that shine
/// through frosted glass surfaces in Dark and Light themes.
class _AmbientGlassCanvas extends StatelessWidget {
  const _AmbientGlassCanvas({
    required this.child,
    required this.isDark,
  });

  final Widget child;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? const [
                  Color(0xFF060B18),
                  Color(0xFF0A1329),
                  Color(0xFF0E1B38),
                ]
              : const [
                  Color(0xFFEAF5FD),
                  Color(0xFFF0F8FF),
                  Color(0xFFE0F2FE),
                ],
        ),
      ),
      child: Stack(
        children: [
          // Ambient Glow Orb 1 (Top Center-Right: Cyan Aura)
          Positioned(
            top: -50,
            right: -30,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: isDark
                      ? [
                          const Color(0xFF00F2FE).withValues(alpha: 0.18),
                          Colors.transparent,
                        ]
                      : [
                          const Color(0xFFBAE6FD).withValues(alpha: 0.55),
                          Colors.transparent,
                        ],
                ),
              ),
            ),
          ),

          // Ambient Glow Orb 2 (Mid Left: Violet / Soft White Aura)
          Positioned(
            top: 260,
            left: -60,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: isDark
                      ? [
                          const Color(0xFF8B5CF6).withValues(alpha: 0.16),
                          Colors.transparent,
                        ]
                      : [
                          Colors.white.withValues(alpha: 0.65),
                          Colors.transparent,
                        ],
                ),
              ),
            ),
          ),

          // Ambient Glow Orb 3 (Bottom Center: Electric Azure Aura)
          Positioned(
            bottom: -60,
            right: 40,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: isDark
                      ? [
                          const Color(0xFF0284C7).withValues(alpha: 0.20),
                          Colors.transparent,
                        ]
                      : [
                          const Color(0xFFBAE6FD).withValues(alpha: 0.45),
                          Colors.transparent,
                        ],
                ),
              ),
            ),
          ),

          // Foreground child
          child,
        ],
      ),
    );
  }
}

/// Floating frosted acrylic capsule header that elevates above the chat canvas.
class _FloatingGlassCapsuleBar extends StatelessWidget {
  const _FloatingGlassCapsuleBar({
    required this.title,
    required this.subtitle,
    required this.isDark,
    required this.onBack,
    required this.onOpenDrawer,
    required this.onNewChat,
    required this.onClearChat,
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
                    color: isDark
                        ? const Color(0x60000000)
                        : const Color(0x10005A71),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Back Action
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: isDark
                          ? const Color(0xFFF8FAFC)
                          : const Color(0xFF08264A),
                      size: 19,
                    ),
                    onPressed: onBack,
                  ),

                  // Mini Ambient Luminous Orb
                  const SizedBox(width: 2),
                  LuminousChatbotOrb(
                    size: 30,
                    isDark: isDark,
                    animate: true,
                  ),
                  const SizedBox(width: 10),

                  // Title & Subtitle
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
                            color: isDark
                                ? const Color(0xFFF8FAFC)
                                : const Color(0xFF08264A),
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
                            color: isDark
                                ? const Color(0xFF94A3B8)
                                : const Color(0xFF5A758E),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 1. History Drawer Toggle
                  IconButton(
                    icon: Icon(
                      Icons.history_rounded,
                      color: isDark
                          ? const Color(0xFF38BDF8)
                          : const Color(0xFF005A71),
                      size: 22,
                    ),
                    tooltip: l10n.chatHistoryTitle,
                    onPressed: onOpenDrawer,
                  ),

                  // 2. Instant "+ New Chat" Action
                  IconButton(
                    icon: Icon(
                      Icons.add_comment_outlined,
                      color: isDark
                          ? const Color(0xFF38BDF8)
                          : const Color(0xFF007A78),
                      size: 21,
                    ),
                    tooltip: l10n.newChatAction,
                    onPressed: onNewChat,
                  ),

                  // 3. Clear Chat Action
                  IconButton(
                    icon: Icon(
                      Icons.delete_sweep_outlined,
                      color: isDark
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF64748B),
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

/// Glassmorphic Disclaimer Banner
class _GlassDisclaimerBanner extends StatelessWidget {
  const _GlassDisclaimerBanner({
    required this.disclaimer,
    required this.isDark,
    required this.onDismiss,
  });

  final String disclaimer;
  final bool isDark;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 6, 14, 4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF0C192E).withValues(alpha: 0.72)
                  : const Color(0xFFE0F2FE).withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark
                    ? const Color(0xFF38BDF8).withValues(alpha: 0.25)
                    : const Color(0xFFBAE6FD),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.health_and_safety_outlined,
                  color: isDark
                      ? const Color(0xFF38BDF8)
                      : const Color(0xFF0284C7),
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    disclaimer,
                    style: TextStyle(
                      fontSize: 11.5,
                      height: 1.35,
                      color: isDark
                          ? const Color(0xFFE2E8F0)
                          : const Color(0xFF0369A1),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.close_rounded,
                    size: 16,
                    color: isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF0284C7),
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: onDismiss,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Hero presentation when starting a new chat session, featuring
/// the centered 3D Luminous Orb, personalized greeting, and initial card.
class _WelcomeHeroView extends StatelessWidget {
  const _WelcomeHeroView({
    required this.messages,
    required this.userName,
    required this.isDark,
    required this.onSelectPrompt,
    required this.onCallPhone,
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

          // Centered 3D Luminous Orb (matches reference mockup Screen 1)
          Center(
            child: LuminousChatbotOrb(
              size: 118,
              isDark: isDark,
              animate: true,
            ),
          ),

          const SizedBox(height: 24),

          // Prominent Hero Greeting Typography
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

          // Initial Welcome Message Frosted Glass Card
          if (messages.isNotEmpty)
            _MessageTile(
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

/// Glassmorphic message bubble for User and Assistant messages.
class _MessageTile extends StatelessWidget {
  const _MessageTile({
    required this.message,
    required this.isDark,
    required this.onSelectPrompt,
    required this.onCallPhone,
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
                  margin: const EdgeInsets.only(right: 8, bottom: 2),
                  child: LuminousChatbotOrb(
                    size: 28,
                    isDark: isDark,
                    animate: false,
                  ),
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
                            : (MediaQuery.of(context).size.width * 0.88)
                                .clamp(280.0, 580.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: isUser
                            ? (isDark
                                ? const Color(0xFF0284C7)
                                    .withValues(alpha: 0.38)
                                : null)
                            : (isDark
                                ? const Color(0xFF0F1E36)
                                    .withValues(alpha: 0.70)
                                : Colors.white.withValues(alpha: 0.85)),
                        gradient: isUser
                            ? (isDark
                                ? null
                                : const LinearGradient(
                                    colors: [
                                      Color(0xFF007A78),
                                      Color(0xFF005A71)
                                    ],
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
                                ? (isDark
                                    ? const Color(0x3038BDF8)
                                    : const Color(0xFF007A78)
                                        .withValues(alpha: 0.18))
                                : (isDark
                                    ? const Color(0x50000000)
                                    : const Color(0x0A005A71)),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                        border: Border.all(
                          color: isUser
                              ? (isDark
                                  ? const Color(0xFF38BDF8)
                                      .withValues(alpha: 0.35)
                                  : Colors.white.withValues(alpha: 0.30))
                              : (message.isEmergency
                                  ? const Color(0xFFFCA5A5)
                                  : (isDark
                                      ? const Color(0xFF38BDF8)
                                          .withValues(alpha: 0.20)
                                      : const Color(0xFFBAE6FD)
                                          .withValues(alpha: 0.60))),
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

                          // Message Body (Markdown formatted)
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
                                    final clean =
                                        FormattedChatMessage.toPlainText(
                                            message.text);
                                    Clipboard.setData(
                                        ClipboardData(text: clean));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:
                                            Text(l10n.responseCopiedMessage),
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
                                        Icon(
                                          Icons.copy_rounded,
                                          size: 13,
                                          color: isDark
                                              ? const Color(0xFF94A3B8)
                                              : const Color(0xFF64748B),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          l10n.copyResponseAction,
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: isDark
                                                ? const Color(0xFF94A3B8)
                                                : const Color(0xFF64748B),
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
                              children:
                                  message.emergencyHotlines.map((hotline) {
                                return ElevatedButton.icon(
                                  onPressed: () => onCallPhone(hotline.number),
                                  icon: const Icon(Icons.phone_in_talk_rounded,
                                      size: 16),
                                  label: Text(
                                    '${hotline.name} (${hotline.number})',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
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
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Animated 3-dot waving typing indicator pill (matches Screen 2 in mockup).
class _GlassTypingBubble extends StatefulWidget {
  const _GlassTypingBubble({
    required this.label,
    required this.isDark,
  });

  final String label;
  final bool isDark;

  @override
  State<_GlassTypingBubble> createState() => _GlassTypingBubbleState();
}

class _GlassTypingBubbleState extends State<_GlassTypingBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    final isTest =
        WidgetsBinding.instance.runtimeType.toString().contains('Test');
    if (!isTest) {
      _controller.repeat();
    } else {
      _controller.value = 0.5;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dotColor =
        widget.isDark ? const Color(0xFF38BDF8) : const Color(0xFF007A78);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: LuminousChatbotOrb(
              size: 28,
              isDark: widget.isDark,
              animate: true,
            ),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(4),
              bottomRight: Radius.circular(20),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: widget.isDark
                      ? const Color(0xFF0F1E36).withValues(alpha: 0.70)
                      : Colors.white.withValues(alpha: 0.85),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(4),
                    bottomRight: Radius.circular(20),
                  ),
                  border: Border.all(
                    color: widget.isDark
                        ? const Color(0xFF38BDF8).withValues(alpha: 0.20)
                        : const Color(0xFFBAE6FD).withValues(alpha: 0.60),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Accessible label for screen readers & tests
                    Semantics(
                      label: widget.label,
                      child: Text(
                        widget.label,
                        style: TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          color: widget.isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF64748B),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),

                    // 3-dot Animated Waving Indicator
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, _) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(3, (index) {
                            final delay = index * 0.20;
                            final t = (_controller.value + delay) % 1.0;
                            final bounce = math.sin(t * math.pi);

                            return Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 2.2),
                              transform: Matrix4.translationValues(
                                  0, -bounce * 4.5, 0),
                              width: 6.5,
                              height: 6.5,
                              decoration: BoxDecoration(
                                color: dotColor.withValues(
                                    alpha: 0.40 + (bounce * 0.60)),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  if (bounce > 0.4)
                                    BoxShadow(
                                      color: dotColor.withValues(
                                          alpha: 0.45 * bounce),
                                      blurRadius: 5,
                                    ),
                                ],
                              ),
                            );
                          }),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Docked horizontal row of frosted glass suggestion pills.
class _SuggestedChipsBar extends StatelessWidget {
  const _SuggestedChipsBar({
    required this.chips,
    required this.onSelectPrompt,
    required this.isDark,
  });

  final List<String> chips;
  final ValueChanged<String> onSelectPrompt;
  final bool isDark;

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
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color:
                    isDark ? const Color(0xFF38BDF8) : const Color(0xFF005A71),
              ),
            ),
            backgroundColor: isDark
                ? const Color(0xFF0F1E36).withValues(alpha: 0.72)
                : Colors.white.withValues(alpha: 0.85),
            side: BorderSide(
              color: isDark
                  ? const Color(0xFF38BDF8).withValues(alpha: 0.35)
                  : const Color(0xFFBAE6FD),
              width: 1,
            ),
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

/// Floating glassmorphic input capsule with upward-arrow circular send button.
class _ChatInputBar extends StatelessWidget {
  const _ChatInputBar({
    required this.controller,
    required this.isTyping,
    required this.isDark,
    required this.onSubmitted,
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
                  color: isDark
                      ? const Color(0x60000000)
                      : const Color(0x0A005A71),
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
                          vertical: 10, horizontal: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: controller,
                  builder: (context, value, _) {
                    final canSend = value.text.trim().isNotEmpty && !isTyping;
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
