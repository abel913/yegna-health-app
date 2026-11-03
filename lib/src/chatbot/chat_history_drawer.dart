import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import 'chatbot_models.dart';

/// ChatGPT / Gemini-style slide-out navigation drawer for browsing, resuming,
/// and managing chat history sessions.
class ChatHistoryDrawer extends StatelessWidget {
  const ChatHistoryDrawer({
    required this.conversations,
    required this.activeConversationId,
    required this.onSelectConversation,
    required this.onNewChat,
    required this.onDeleteConversation,
    required this.onClearAll,
    super.key,
  });

  final List<ChatConversation> conversations;
  final String? activeConversationId;
  final ValueChanged<ChatConversation> onSelectConversation;
  final VoidCallback onNewChat;
  final ValueChanged<String> onDeleteConversation;
  final VoidCallback onClearAll;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final grouped = _groupConversations(conversations, l10n);

    return Drawer(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Drawer Header with App Identity and "+ New Chat" Action
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF007A78), Color(0xFF005A71)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF007A78)
                                  .withValues(alpha: 0.25),
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
                            Text(
                              l10n.chatHistoryTitle,
                              style: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF007A78),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Large "+ New Chat" Button
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onNewChat,
                      borderRadius: BorderRadius.circular(16),
                      child: Ink(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 13),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF007A78), Color(0xFF005A71)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF007A78)
                                  .withValues(alpha: 0.28),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.add_rounded,
                                color: Colors.white, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              l10n.newChatAction,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 14.5,
                                letterSpacing: 0.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9)),

            // 2. Scrollable List of Grouped Past Conversations
            Expanded(
              child: conversations.isEmpty
                  ? _buildEmptyState(l10n)
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      itemCount: grouped.length,
                      itemBuilder: (context, index) {
                        final group = grouped[index];
                        return _buildGroupSection(
                          context,
                          group: group,
                          activeId: activeConversationId,
                          l10n: l10n,
                        );
                      },
                    ),
            ),

            // 3. Drawer Footer: Clear All History
            if (conversations.isNotEmpty) ...[
              const Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9)),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFFEF4444),
                    padding: const EdgeInsets.symmetric(
                        vertical: 11, horizontal: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.delete_sweep_outlined, size: 20),
                  label: Text(
                    l10n.clearAllChatsAction,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  onPressed: () => _confirmClearAll(context, l10n),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: const Icon(Icons.chat_bubble_outline_rounded,
                  size: 28, color: Color(0xFF94A3B8)),
            ),
            const SizedBox(height: 14),
            Text(
              l10n.noChatHistory,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF334155),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.noChatHistorySubtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12.5,
                height: 1.4,
                color: Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupSection(
    BuildContext context, {
    required _ConversationGroup group,
    required String? activeId,
    required AppLocalizations l10n,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 14, 10, 6),
          child: Text(
            group.title,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: Color(0xFF64748B),
              letterSpacing: 0.6,
            ),
          ),
        ),
        ...group.conversations.map((conv) {
          final isActive = conv.id == activeId;
          return _buildConversationTile(
            context,
            conversation: conv,
            isActive: isActive,
            l10n: l10n,
          );
        }),
      ],
    );
  }

  Widget _buildConversationTile(
    BuildContext context, {
    required ChatConversation conversation,
    required bool isActive,
    required AppLocalizations l10n,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2.5),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFE6F4F1) : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isActive ? const Color(0xFF007A78) : Colors.transparent,
          width: 1.2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onSelectConversation(conversation),
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Icon(
                  Icons.chat_bubble_outline_rounded,
                  size: 19,
                  color: isActive
                      ? const Color(0xFF007A78)
                      : const Color(0xFF64748B),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        conversation.title.isNotEmpty
                            ? conversation.title
                            : l10n.newChatAction,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight:
                              isActive ? FontWeight.w800 : FontWeight.w600,
                          color: isActive
                              ? const Color(0xFF08264A)
                              : const Color(0xFF1E293B),
                        ),
                      ),
                      if (conversation.previewText.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          conversation.previewText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11.5,
                            color: isActive
                                ? const Color(0xFF005A71)
                                : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded,
                      size: 18, color: Color(0xFF94A3B8)),
                  tooltip: l10n.deleteChatAction,
                  onPressed: () => _confirmDelete(context, conversation, l10n),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _confirmDelete(
    BuildContext context,
    ChatConversation conversation,
    AppLocalizations l10n,
  ) {
    showDialog<void>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: Text(l10n.deleteChatConfirmTitle,
            style: const TextStyle(fontWeight: FontWeight.w800)),
        content: Text(l10n.deleteChatConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: Text(l10n.cancelAction),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
            ),
            onPressed: () {
              Navigator.of(dialogCtx).pop();
              onDeleteConversation(conversation.id);
            },
            child: Text(l10n.deleteChatAction),
          ),
        ],
      ),
    );
  }

  void _confirmClearAll(BuildContext context, AppLocalizations l10n) {
    showDialog<void>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: Text(l10n.clearAllChatsConfirmTitle,
            style: const TextStyle(fontWeight: FontWeight.w800)),
        content: Text(l10n.clearAllChatsConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: Text(l10n.cancelAction),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
            ),
            onPressed: () {
              Navigator.of(dialogCtx).pop();
              onClearAll();
            },
            child: Text(l10n.clearAllChatsAction),
          ),
        ],
      ),
    );
  }

  List<_ConversationGroup> _groupConversations(
    List<ChatConversation> list,
    AppLocalizations l10n,
  ) {
    if (list.isEmpty) return [];

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final sevenDaysAgo = today.subtract(const Duration(days: 7));

    final todayList = <ChatConversation>[];
    final yesterdayList = <ChatConversation>[];
    final prev7DaysList = <ChatConversation>[];
    final olderList = <ChatConversation>[];

    for (final conv in list) {
      final convDate = DateTime(
        conv.updatedAt.year,
        conv.updatedAt.month,
        conv.updatedAt.day,
      );

      if (convDate.isAtSameMomentAs(today) || convDate.isAfter(today)) {
        todayList.add(conv);
      } else if (convDate.isAtSameMomentAs(yesterday)) {
        yesterdayList.add(conv);
      } else if (convDate.isAfter(sevenDaysAgo)) {
        prev7DaysList.add(conv);
      } else {
        olderList.add(conv);
      }
    }

    final groups = <_ConversationGroup>[];
    if (todayList.isNotEmpty) {
      groups.add(_ConversationGroup(
          title: l10n.chatHistoryToday, conversations: todayList));
    }
    if (yesterdayList.isNotEmpty) {
      groups.add(_ConversationGroup(
          title: l10n.chatHistoryYesterday, conversations: yesterdayList));
    }
    if (prev7DaysList.isNotEmpty) {
      groups.add(_ConversationGroup(
          title: l10n.chatHistoryPreviousDays, conversations: prev7DaysList));
    }
    if (olderList.isNotEmpty) {
      groups.add(_ConversationGroup(
          title: l10n.chatHistoryOlder, conversations: olderList));
    }
    return groups;
  }
}

class _ConversationGroup {
  const _ConversationGroup({
    required this.title,
    required this.conversations,
  });

  final String title;
  final List<ChatConversation> conversations;
}
