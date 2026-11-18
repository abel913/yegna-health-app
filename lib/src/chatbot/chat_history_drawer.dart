import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import 'chatbot_models.dart';
import 'widgets/chat_conversation_group.dart';
import 'widgets/chat_conversation_tile.dart';
import 'widgets/chat_drawer_header.dart';

/// Navigation drawer for browsing, resuming, and managing chat history sessions.
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
    final grouped = groupConversations(conversations, l10n);

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
            ChatDrawerHeader(onNewChat: onNewChat),
            const Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9)),
            Expanded(
              child: conversations.isEmpty
                  ? _buildEmptyState(l10n)
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      itemCount: grouped.length,
                      itemBuilder: (context, index) {
                        final group = grouped[index];
                        return _buildGroupSection(context, group: group, activeId: activeConversationId, l10n: l10n);
                      },
                    ),
            ),
            if (conversations.isNotEmpty) ...[
              const Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9)),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFFEF4444),
                    padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.delete_sweep_outlined, size: 20),
                  label: Text(l10n.clearAllChatsAction, style: const TextStyle(fontWeight: FontWeight.w700)),
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
              child: const Icon(Icons.chat_bubble_outline_rounded, size: 28, color: Color(0xFF94A3B8)),
            ),
            const SizedBox(height: 14),
            Text(
              l10n.noChatHistory,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF334155)),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.noChatHistorySubtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12.5, height: 1.4, color: Color(0xFF64748B)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupSection(
    BuildContext context, {
    required ConversationGroup group,
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
          return ChatConversationTile(
            conversation: conv,
            isActive: isActive,
            onSelect: () => onSelectConversation(conv),
            onDelete: () => onDeleteConversation(conv.id),
          );
        }),
      ],
    );
  }

  void _confirmClearAll(BuildContext context, AppLocalizations l10n) {
    showDialog<void>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: Text(l10n.clearAllChatsConfirmTitle, style: const TextStyle(fontWeight: FontWeight.w800)),
        content: Text(l10n.clearAllChatsConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: Text(l10n.cancelAction),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
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
}
