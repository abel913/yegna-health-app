import 'chatbot_models.dart';
import 'chatbot_repository.dart';
import 'local_curriculum_chatbot_repository.dart';

/// Resilient composite repository that routes to the remote Gemini/Supabase backend
/// when online and configured, and seamlessly falls back to the on-device curriculum
/// engine if offline or when network errors occur.
class CompositeChatbotRepository implements ChatbotRepository {
  CompositeChatbotRepository({
    this.remoteRepository,
    ChatbotRepository? localRepository,
  }) : localRepository =
            localRepository ?? const LocalCurriculumChatbotRepository();

  final ChatbotRepository? remoteRepository;
  final ChatbotRepository localRepository;

  @override
  Future<ChatMessage> sendMessage(
    String query, {
    required String languageCode,
    List<ChatMessage> history = const [],
  }) async {
    if (remoteRepository != null) {
      try {
        return await remoteRepository!.sendMessage(
          query,
          languageCode: languageCode,
          history: history,
        );
      } catch (_) {
        // Fall back gracefully to on-device grounded curriculum
      }
    }

    return localRepository.sendMessage(
      query,
      languageCode: languageCode,
      history: history,
    );
  }
}
