import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yegna_health_app/src/chatbot/chat_history_repository.dart';
import 'package:yegna_health_app/src/chatbot/chatbot_models.dart';

void main() {
  group('ChatConversation & ChatMessage Serialization', () {
    test('ChatMessage serializes to and from JSON cleanly', () {
      final message = ChatMessage(
        id: 'msg_1',
        text: 'What is HIV prevention?',
        isUser: true,
        timestamp: DateTime(2026, 11, 3, 10, 30),
        isEmergency: false,
        emergencyHotlines: const [
          EmergencyHotlineAction(
            name: 'Emergency',
            number: '952',
            description: 'Toll-free line',
          ),
        ],
        suggestedPrompts: const ['Where to test?'],
      );

      final json = message.toJson();
      final revived = ChatMessage.fromJson(json);

      expect(revived.id, message.id);
      expect(revived.text, message.text);
      expect(revived.isUser, isTrue);
      expect(revived.isEmergency, isFalse);
      expect(revived.emergencyHotlines.length, 1);
      expect(revived.emergencyHotlines.first.number, '952');
      expect(revived.suggestedPrompts.first, 'Where to test?');
    });

    test('ChatConversation serializes to and from JSON cleanly', () {
      final conversation = ChatConversation(
        id: 'conv_123',
        title: 'Puberty and bodily changes',
        createdAt: DateTime(2026, 11, 3, 9, 0),
        updatedAt: DateTime(2026, 11, 3, 9, 15),
        messages: [
          ChatMessage(
            id: 'm1',
            text: 'Tell me about puberty',
            isUser: true,
            timestamp: DateTime(2026, 11, 3, 9, 0),
          ),
          ChatMessage(
            id: 'm2',
            text: 'Puberty is a natural phase of growth.',
            isUser: false,
            timestamp: DateTime(2026, 11, 3, 9, 1),
          ),
        ],
      );

      final json = conversation.toJson();
      final revived = ChatConversation.fromJson(json);

      expect(revived.id, 'conv_123');
      expect(revived.title, 'Puberty and bodily changes');
      expect(revived.messages.length, 2);
      expect(revived.previewText, 'Puberty is a natural phase of growth.');
    });
  });

  group('InMemoryChatHistoryRepository', () {
    test('saves, loads ordered by recency, deletes, and clears', () async {
      final repo = InMemoryChatHistoryRepository();

      final conv1 = ChatConversation(
        id: 'c1',
        title: 'First chat',
        createdAt: DateTime(2026, 11, 1),
        updatedAt: DateTime(2026, 11, 1),
      );

      final conv2 = ChatConversation(
        id: 'c2',
        title: 'Second chat',
        createdAt: DateTime(2026, 11, 2),
        updatedAt: DateTime(2026, 11, 2),
      );

      await repo.saveConversation(conv1);
      await repo.saveConversation(conv2);

      final list = await repo.loadConversations();
      expect(list.length, 2);
      // Newest first
      expect(list.first.id, 'c2');
      expect(list.last.id, 'c1');

      // Delete c1
      await repo.deleteConversation('c1');
      final listAfterDelete = await repo.loadConversations();
      expect(listAfterDelete.length, 1);
      expect(listAfterDelete.first.id, 'c2');

      // Clear all
      await repo.clearAll();
      expect(await repo.loadConversations(), isEmpty);
    });
  });

  group('SharedPreferencesChatHistoryRepository', () {
    test('persists to SharedPreferences and handles corrupted JSON gracefully',
        () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final repo = SharedPreferencesChatHistoryRepository(prefs);

      expect(await repo.loadConversations(), isEmpty);

      final conv = ChatConversation(
        id: 'c_stored',
        title: 'Contraception guidance',
        createdAt: DateTime(2026, 11, 3, 10, 0),
        updatedAt: DateTime(2026, 11, 3, 10, 5),
        messages: [
          ChatMessage(
            id: 'm_1',
            text: 'What are safe contraceptive methods?',
            isUser: true,
            timestamp: DateTime(2026, 11, 3, 10, 0),
          ),
        ],
      );

      await repo.saveConversation(conv);

      // Verify raw storage contains JSON
      final raw =
          prefs.getString(SharedPreferencesChatHistoryRepository.storageKey);
      expect(raw, isNotNull);
      expect(raw!.contains('Contraception guidance'), isTrue);

      final loaded = await repo.loadConversations();
      expect(loaded.length, 1);
      expect(loaded.first.title, 'Contraception guidance');

      // Simulate corrupted data
      await prefs.setString(
          SharedPreferencesChatHistoryRepository.storageKey, 'invalid-json');
      expect(await repo.loadConversations(), isEmpty);
    });
  });
}
