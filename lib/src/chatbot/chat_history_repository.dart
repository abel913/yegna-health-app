import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'chatbot_models.dart';

/// Abstract storage interface for preserving chat conversations.
abstract interface class ChatHistoryRepository {
  /// Loads all stored chat conversations sorted by recency (newest first).
  Future<List<ChatConversation>> loadConversations();

  /// Saves or updates a conversation session.
  Future<void> saveConversation(ChatConversation conversation);

  /// Deletes a specific conversation by ID.
  Future<void> deleteConversation(String conversationId);

  /// Permanently removes all stored conversations.
  Future<void> clearAll();
}

/// Offline-first implementation of [ChatHistoryRepository] backed by [SharedPreferences].
class SharedPreferencesChatHistoryRepository implements ChatHistoryRepository {
  SharedPreferencesChatHistoryRepository([SharedPreferences? preferences])
      : _preferences = preferences;

  final SharedPreferences? _preferences;
  static const String storageKey = 'yegna_chat_conversations_v1';

  Future<SharedPreferences?> _getPrefs() async {
    if (_preferences != null) return _preferences;
    try {
      return await SharedPreferences.getInstance();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<ChatConversation>> loadConversations() async {
    try {
      final prefs = await _getPrefs();
      if (prefs == null) return [];
      final rawJson = prefs.getString(storageKey);
      if (rawJson == null || rawJson.trim().isEmpty) {
        return [];
      }

      final decoded = jsonDecode(rawJson);
      if (decoded is! List) {
        return [];
      }

      final conversations = decoded
          .whereType<Map<String, dynamic>>()
          .map((item) => ChatConversation.fromJson(item))
          .toList();

      conversations.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      return conversations;
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> saveConversation(ChatConversation conversation) async {
    try {
      final prefs = await _getPrefs();
      if (prefs == null) return;
      final list = await loadConversations();

      final existingIndex = list.indexWhere((c) => c.id == conversation.id);
      if (existingIndex >= 0) {
        list[existingIndex] = conversation;
      } else {
        list.insert(0, conversation);
      }

      list.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      final encoded = jsonEncode(list.map((c) => c.toJson()).toList());
      await prefs.setString(storageKey, encoded);
    } catch (_) {
      // Graceful fallback
    }
  }

  @override
  Future<void> deleteConversation(String conversationId) async {
    try {
      final prefs = await _getPrefs();
      if (prefs == null) return;
      final list = await loadConversations();
      list.removeWhere((c) => c.id == conversationId);

      final encoded = jsonEncode(list.map((c) => c.toJson()).toList());
      await prefs.setString(storageKey, encoded);
    } catch (_) {
      // Graceful fallback
    }
  }

  @override
  Future<void> clearAll() async {
    try {
      final prefs = await _getPrefs();
      if (prefs == null) return;
      await prefs.remove(storageKey);
    } catch (_) {
      // Graceful fallback
    }
  }
}

/// In-memory implementation of [ChatHistoryRepository] for unit & widget tests.
class InMemoryChatHistoryRepository implements ChatHistoryRepository {
  InMemoryChatHistoryRepository([List<ChatConversation>? initial]) {
    if (initial != null) {
      for (final c in initial) {
        _store[c.id] = c;
      }
    }
  }

  final Map<String, ChatConversation> _store = {};

  @override
  Future<List<ChatConversation>> loadConversations() async {
    final list = _store.values.toList();
    list.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return list;
  }

  @override
  Future<void> saveConversation(ChatConversation conversation) async {
    _store[conversation.id] = conversation;
  }

  @override
  Future<void> deleteConversation(String conversationId) async {
    _store.remove(conversationId);
  }

  @override
  Future<void> clearAll() async {
    _store.clear();
  }
}
