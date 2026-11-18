import 'chat_history_repository.dart';
import 'chatbot_models.dart';

/// Manages multi-session state and persistence for the AI chatbot.
class ChatPageSessionManager {
  ChatPageSessionManager({required this.repository});

  final ChatHistoryRepository repository;
  List<ChatConversation> conversations = [];
  String? currentSessionId;
  String? currentSessionTitle;
  DateTime? currentSessionCreatedAt;

  void initSession() {
    currentSessionId = 'session_${DateTime.now().millisecondsSinceEpoch}';
    currentSessionCreatedAt = DateTime.now();
  }

  Future<void> loadHistory() async {
    try {
      conversations = await repository.loadConversations();
    } catch (_) {
      // Graceful fallback
    }
  }

  String generateTitle(String text) {
    var cleaned = text.replaceAll(RegExp(r'[\r\n]+'), ' ').trim();
    if (cleaned.length > 36) {
      cleaned = '${cleaned.substring(0, 36).trim()}...';
    }
    return cleaned;
  }

  Future<void> persistSession(List<ChatMessage> messages) async {
    if (currentSessionId == null) return;
    if (messages.length <= 1 && !messages.any((m) => m.isUser)) return;

    final conv = ChatConversation(
      id: currentSessionId!,
      title: currentSessionTitle ?? 'Health Conversation',
      createdAt: currentSessionCreatedAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
      messages: List.from(messages),
    );
    await repository.saveConversation(conv);
    conversations = await repository.loadConversations();
  }

  void startNewSession() {
    currentSessionId = 'session_${DateTime.now().millisecondsSinceEpoch}';
    currentSessionTitle = null;
    currentSessionCreatedAt = DateTime.now();
  }

  void selectSession(ChatConversation conv) {
    currentSessionId = conv.id;
    currentSessionTitle = conv.title;
    currentSessionCreatedAt = conv.createdAt;
  }

  Future<void> deleteSession(String id) async {
    await repository.deleteConversation(id);
    conversations = await repository.loadConversations();
  }

  Future<void> clearAll() async {
    await repository.clearAll();
    conversations = [];
  }
}
