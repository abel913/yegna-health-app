import 'package:url_launcher/url_launcher.dart';

import '../../l10n/app_localizations.dart';
import 'chatbot_models.dart';

/// Utility methods for the AI Chatbot page.
class ChatPageHelpers {
  const ChatPageHelpers._();

  static Future<void> callPhone(String number) async {
    final uri = Uri.parse('tel:$number');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    } catch (_) {}
  }

  static ChatMessage createWelcomeMessage(AppLocalizations l10n) {
    return ChatMessage(
      id: 'welcome_0',
      text: l10n.chatbotWelcomeMessage,
      isUser: false,
      timestamp: DateTime.now(),
      suggestedPrompts: [
        l10n.chatbotSuggestedHiv,
        l10n.chatbotSuggestedPuberty,
        l10n.chatbotSuggestedClinics,
        l10n.chatbotSuggestedContraception,
      ],
    );
  }

  static List<String> getSuggestedChips(
    List<ChatMessage> messages,
    AppLocalizations l10n,
  ) {
    for (int i = messages.length - 1; i >= 0; i--) {
      if (!messages[i].isUser && messages[i].suggestedPrompts.isNotEmpty) {
        return messages[i].suggestedPrompts;
      }
    }
    return [
      l10n.chatbotSuggestedHiv,
      l10n.chatbotSuggestedPuberty,
      l10n.chatbotSuggestedClinics,
      l10n.chatbotSuggestedContraception,
    ];
  }
}
