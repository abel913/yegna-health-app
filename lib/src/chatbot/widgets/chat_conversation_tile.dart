import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../chatbot_models.dart';

class ChatConversationTile extends StatelessWidget {
  const ChatConversationTile({
    required this.conversation,
    required this.isActive,
    required this.onSelect,
    required this.onDelete,
    super.key,
  });

  final ChatConversation conversation;
  final bool isActive;
  final VoidCallback onSelect;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
          onTap: onSelect,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Icon(
                  Icons.chat_bubble_outline_rounded,
                  size: 19,
                  color: isActive ? const Color(0xFF007A78) : const Color(0xFF64748B),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        conversation.title.isNotEmpty ? conversation.title : l10n.newChatAction,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
                          color: isActive ? const Color(0xFF08264A) : const Color(0xFF1E293B),
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
                            color: isActive ? const Color(0xFF005A71) : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Color(0xFF94A3B8)),
                  tooltip: l10n.deleteChatAction,
                  onPressed: () => _confirmDelete(context, l10n),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, AppLocalizations l10n) {
    showDialog<void>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: Text(l10n.deleteChatConfirmTitle, style: const TextStyle(fontWeight: FontWeight.w800)),
        content: Text(l10n.deleteChatConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: Text(l10n.cancelAction),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
            onPressed: () {
              Navigator.of(dialogCtx).pop();
              onDelete();
            },
            child: Text(l10n.deleteChatAction),
          ),
        ],
      ),
    );
  }
}
