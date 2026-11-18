import '../../../l10n/app_localizations.dart';
import '../chatbot_models.dart';

class ConversationGroup {
  const ConversationGroup({
    required this.title,
    required this.conversations,
  });

  final String title;
  final List<ChatConversation> conversations;
}

List<ConversationGroup> groupConversations(
  List<ChatConversation> list,
  AppLocalizations l10n,
) {
  if (list.isEmpty) return [];

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final sevenDaysAgo = today.subtract(const Duration(days: 7));

  final todayList = <ChatConversation>[];
  final yesterdayList = <ChatConversation>[];
  final prev7DaysList = <ChatConversation>[];
  final olderList = <ChatConversation>[];

  for (final conv in list) {
    final convDate = DateTime(
      conv.updatedAt.year,
      conv.updatedAt.month,
      conv.updatedAt.day,
    );

    if (convDate.isAtSameMomentAs(today) || convDate.isAfter(today)) {
      todayList.add(conv);
    } else if (convDate.isAtSameMomentAs(yesterday)) {
      yesterdayList.add(conv);
    } else if (convDate.isAfter(sevenDaysAgo)) {
      prev7DaysList.add(conv);
    } else {
      olderList.add(conv);
    }
  }

  final groups = <ConversationGroup>[];
  if (todayList.isNotEmpty) {
    groups.add(ConversationGroup(title: l10n.chatHistoryToday, conversations: todayList));
  }
  if (yesterdayList.isNotEmpty) {
    groups.add(ConversationGroup(title: l10n.chatHistoryYesterday, conversations: yesterdayList));
  }
  if (prev7DaysList.isNotEmpty) {
    groups.add(ConversationGroup(title: l10n.chatHistoryPreviousDays, conversations: prev7DaysList));
  }
  if (olderList.isNotEmpty) {
    groups.add(ConversationGroup(title: l10n.chatHistoryOlder, conversations: olderList));
  }
  return groups;
}
