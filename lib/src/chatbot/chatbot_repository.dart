import 'chatbot_models.dart';

/// Abstract contract for conversational AI health assistant services.
abstract class ChatbotRepository {
  /// Delivers a user prompt and returns the assistant's grounded answer.
  Future<ChatMessage> sendMessage(
    String query, {
    required String languageCode,
    List<ChatMessage> history = const [],
  });
}
