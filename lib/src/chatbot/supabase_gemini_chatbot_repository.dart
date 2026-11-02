import 'dart:math' as math;
import 'package:supabase_flutter/supabase_flutter.dart';

import 'chatbot_models.dart';
import 'chatbot_repository.dart';

/// Calls the Supabase Edge Function "ask-assistant" which coordinates with Google Gemini.
class SupabaseGeminiChatbotRepository implements ChatbotRepository {
  SupabaseGeminiChatbotRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<ChatMessage> sendMessage(
    String query, {
    required String languageCode,
    List<ChatMessage> history = const [],
  }) async {
    final payload = {
      'prompt': query,
      'language': languageCode,
      'history': history
          .map((m) => {
                'role': m.isUser ? 'user' : 'model',
                'parts': [
                  {'text': m.text}
                ],
              })
          .toList(),
    };

    final response = await _client.functions.invoke(
      'ask-assistant',
      body: payload,
    );

    if (response.status >= 200 && response.status < 300) {
      final data = response.data;
      if (data is Map<String, dynamic>) {
        final answer = data['answer'] as String? ?? '';
        final isEmergency = data['isEmergency'] as bool? ?? false;
        final prompts = (data['suggestedPrompts'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            const <String>[];

        final id =
            'msg_${DateTime.now().millisecondsSinceEpoch}_${math.Random().nextInt(9999)}';
        return ChatMessage(
          id: id,
          text: answer,
          isUser: false,
          timestamp: DateTime.now(),
          isEmergency: isEmergency,
          suggestedPrompts: prompts,
        );
      }
    }
    throw StateError('Edge function returned status ${response.status}');
  }
}
