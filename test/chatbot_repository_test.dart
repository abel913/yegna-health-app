import 'package:flutter_test/flutter_test.dart';
import 'package:yegna_health_app/src/chatbot/chatbot_models.dart';
import 'package:yegna_health_app/src/chatbot/chatbot_repository.dart';
import 'package:yegna_health_app/src/chatbot/composite_chatbot_repository.dart';
import 'package:yegna_health_app/src/chatbot/local_curriculum_chatbot_repository.dart';

class _ThrowingRemoteChatbotRepository implements ChatbotRepository {
  @override
  Future<ChatMessage> sendMessage(
    String query, {
    required String languageCode,
    List<ChatMessage> history = const [],
  }) async {
    throw Exception('Network connection refused');
  }
}

class _SuccessRemoteChatbotRepository implements ChatbotRepository {
  @override
  Future<ChatMessage> sendMessage(
    String query, {
    required String languageCode,
    List<ChatMessage> history = const [],
  }) async {
    return ChatMessage(
      id: 'remote_1',
      text: 'Response from remote: $query',
      isUser: false,
      timestamp: DateTime.now(),
    );
  }
}

void main() {
  group('LocalCurriculumChatbotRepository', () {
    const repo = LocalCurriculumChatbotRepository();

    test('returns grounded HIV prevention and testing response in English',
        () async {
      final response =
          await repo.sendMessage('How can I prevent HIV?', languageCode: 'en');
      expect(response.isUser, isFalse);
      expect(response.isEmergency, isFalse);
      expect(response.text, contains('Human Immunodeficiency Virus'));
      expect(response.text, contains('ART'));
      expect(response.text, contains('PEP'));
      expect(response.suggestedPrompts, isNotEmpty);
    });

    test('returns grounded STI response highlighting partner treatment',
        () async {
      final response = await repo.sendMessage('What are the symptoms of STIs?',
          languageCode: 'en');
      expect(response.text, contains('discharge'));
      expect(response.text, contains('simultaneously'));
      expect(response.suggestedPrompts, isNotEmpty);
    });

    test('returns puberty changes and hygiene advice', () async {
      final response = await repo.sendMessage('Tell me about puberty changes',
          languageCode: 'en');
      expect(response.text, contains('transition from childhood'));
      expect(response.text, contains('menstruation'));
      expect(response.text, contains('wet dreams'));
      expect(response.suggestedPrompts, isNotEmpty);
    });

    test('returns SRH contraception and consent guidance', () async {
      final response = await repo.sendMessage(
          'How does emergency contraception work?',
          languageCode: 'en');
      expect(response.text, contains('Family Planning Methods'));
      expect(response.text, contains('72 to 120 hours'));
      expect(response.text, contains('Consent'));
    });

    test('returns GBV categories and survivor care', () async {
      final response = await repo.sendMessage('What should I know about GBV?',
          languageCode: 'en');
      expect(response.text, contains('gender inequality'));
      expect(response.text, contains('952'));
      expect(response.text, contains('8335'));
    });

    test('returns verified Addis Ababa youth clinics', () async {
      final response = await repo.sendMessage(
          'Where is a youth friendly clinic in Addis Ababa?',
          languageCode: 'en');
      expect(response.text, contains('FGAE Youth Center'));
      expect(response.text, contains('Selam Children\'s Village'));
      expect(response.text, contains('AAU Student Health Center'));
      expect(response.text, contains('St. Paul\'s'));
      expect(response.text, contains('ALERT'));
    });

    test(
        'detects crisis keywords and flags emergency with 952 and 8335 hotlines',
        () async {
      final response = await repo.sendMessage(
          'I feel so overwhelmed and want to kill myself',
          languageCode: 'en');
      expect(response.isEmergency, isTrue);
      expect(response.emergencyHotlines, hasLength(2));
      expect(response.emergencyHotlines.first.number, '952');
      expect(response.emergencyHotlines.last.number, '8335');
    });

    test('responds in fluent Amharic when languageCode is am', () async {
      final response =
          await repo.sendMessage('ስለ ኤችአይቪ መረጃ ንገረኝ', languageCode: 'am');
      expect(response.isUser, isFalse);
      expect(response.text, contains('ኤችአይቪ'));
      expect(response.text, contains('ምርመራ'));
      expect(response.text, contains('መድሃኒት'));
      expect(response.suggestedPrompts.first, contains('የአባላዘር'));
    });

    test('detects Amharic emergency crisis triggers', () async {
      final response =
          await repo.sendMessage('እራሴን መግደል እፈልጋለሁ አግዙኝ', languageCode: 'am');
      expect(response.isEmergency, isTrue);
      expect(response.emergencyHotlines, hasLength(2));
      expect(response.emergencyHotlines.first.number, '952');
      expect(response.emergencyHotlines.last.number, '8335');
      expect(response.text, contains('አስቸኳይ እርዳታ'));
    });

    test(
        'declines non-health query such as physics in English and redirects to health',
        () async {
      final response =
          await repo.sendMessage('What is physics?', languageCode: 'en');
      expect(response.isUser, isFalse);
      expect(response.isEmergency, isFalse);
      expect(
          response.text,
          contains(
              'I am designed specifically as a health, reproductive, and youth wellbeing guide'));
      expect(
          response.text,
          contains(
              'Please feel free to ask me any question about your health'));
      expect(response.suggestedPrompts, contains('How to prevent HIV?'));
    });

    test('declines non-health query in Amharic and redirects to health',
        () async {
      final response =
          await repo.sendMessage('ስለ ፊዚክስ ንገረኝ', languageCode: 'am');
      expect(response.isUser, isFalse);
      expect(response.isEmergency, isFalse);
      expect(response.text,
          contains('ከጤና፣ ከጉርምስና፣ ከስነ-ተዋልዶ እና ከአእምሮ ደህንነት ውጭ ያሉ'));
      expect(response.suggestedPrompts, contains('ኤችአይቪን እንዴት መከላከል ይቻላል?'));
    });

    test('warmly responds to general greeting and invites health inquiries',
        () async {
      final response = await repo.sendMessage('Hello', languageCode: 'en');
      expect(response.isUser, isFalse);
      expect(
          response.text,
          contains(
              'Hello! I am your Yegna Health Assistant. How can I help you today?'));
    });
  });

  group('CompositeChatbotRepository', () {
    test('uses remote repository when available and successful', () async {
      final composite = CompositeChatbotRepository(
        remoteRepository: _SuccessRemoteChatbotRepository(),
        localRepository: const LocalCurriculumChatbotRepository(),
      );

      final result = await composite.sendMessage('Hello', languageCode: 'en');
      expect(result.text, 'Response from remote: Hello');
    });

    test('falls back safely to local curriculum when remote repository fails',
        () async {
      final composite = CompositeChatbotRepository(
        remoteRepository: _ThrowingRemoteChatbotRepository(),
        localRepository: const LocalCurriculumChatbotRepository(),
      );

      final result = await composite.sendMessage('How to prevent HIV?',
          languageCode: 'en');
      expect(result.text, contains('Human Immunodeficiency Virus'));
    });
  });
}
