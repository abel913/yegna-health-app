import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yegna_health_app/l10n/app_localizations.dart';
import 'package:yegna_health_app/src/chatbot/chat_history_repository.dart';
import 'package:yegna_health_app/src/chatbot/chatbot_models.dart';
import 'package:yegna_health_app/src/chatbot/local_curriculum_chatbot_repository.dart';
import 'package:yegna_health_app/src/chatbot/yegna_chatbot_page.dart';

Widget _buildTestApp({
  required InMemoryChatHistoryRepository historyRepo,
  Locale locale = const Locale('en'),
  String? initialQuery,
}) {
  return MaterialApp(
    locale: locale,
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    home: YegnaChatbotPage(
      repository: const LocalCurriculumChatbotRepository(),
      historyRepository: historyRepo,
      initialQuery: initialQuery,
    ),
  );
}

void main() {
  group('Chat History & Multi-Session UI Tests', () {
    testWidgets(
        'creating a new chat preserves old conversation and displays it in drawer',
        (tester) async {
      final historyRepo = InMemoryChatHistoryRepository();
      await tester.pumpWidget(_buildTestApp(historyRepo: historyRepo));
      await tester.pumpAndSettle();

      final l10n = await AppLocalizations.delegate.load(const Locale('en'));

      // 1. Send first message in conversation 1
      final inputField = find.byType(TextField);
      await tester.enterText(inputField, 'How is HIV prevented?');
      await tester.pump();
      await tester.tap(find.byIcon(Icons.arrow_upward_rounded));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();

      expect(find.text('How is HIV prevented?'), findsOneWidget);
      expect(
          find.textContaining('Human Immunodeficiency Virus'), findsOneWidget);

      // Verify conversation was persisted
      final storedAfterFirst = await historyRepo.loadConversations();
      expect(storedAfterFirst.length, 1);
      expect(storedAfterFirst.first.title, 'How is HIV prevented?');

      // 2. Tap "+ New Chat" button in the AppBar
      final newChatButton = find.byTooltip(l10n.newChatAction);
      expect(newChatButton, findsOneWidget);
      await tester.tap(newChatButton);
      await tester.pumpAndSettle();

      // Thread is now reset to fresh welcome state
      expect(find.text('How is HIV prevented?'), findsNothing);
      expect(find.text(l10n.chatbotWelcomeMessage), findsOneWidget);

      // 3. Send message in conversation 2
      await tester.enterText(inputField, 'Puberty body odor tips');
      await tester.pump();
      await tester.tap(find.byIcon(Icons.arrow_upward_rounded));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();

      expect(find.text('Puberty body odor tips'), findsOneWidget);

      // Verify history repository now holds both sessions
      final storedAfterSecond = await historyRepo.loadConversations();
      expect(storedAfterSecond.length, 2);

      // 4. Open Chat History Drawer via AppBar icon
      final historyButton = find.byTooltip(l10n.chatHistoryTitle);
      expect(historyButton, findsOneWidget);
      await tester.tap(historyButton);
      await tester.pumpAndSettle();

      // Drawer is visible with both conversations
      expect(find.text('Puberty body odor tips'), findsWidgets);
      expect(find.text('How is HIV prevented?'), findsOneWidget);

      // 5. Tap the older conversation ("How is HIV prevented?") in drawer
      await tester.tap(find.text('How is HIV prevented?'));
      await tester.pumpAndSettle();

      // Drawer closes, and first conversation's thread is restored!
      expect(find.text('How is HIV prevented?'), findsOneWidget);
      expect(
          find.textContaining('Human Immunodeficiency Virus'), findsOneWidget);
    });

    testWidgets(
        'can delete single conversation and clear all history from drawer',
        (tester) async {
      final historyRepo = InMemoryChatHistoryRepository([
        ChatConversation(
          id: 'conv_1',
          title: 'Older conversation',
          createdAt: DateTime(2026, 11, 1),
          updatedAt: DateTime(2026, 11, 1),
          messages: [
            ChatMessage(
              id: 'm1',
              text: 'Older message',
              isUser: true,
              timestamp: DateTime(2026, 11, 1),
            ),
          ],
        ),
        ChatConversation(
          id: 'conv_2',
          title: 'Recent conversation',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          messages: [
            ChatMessage(
              id: 'm2',
              text: 'Recent message',
              isUser: true,
              timestamp: DateTime.now(),
            ),
          ],
        ),
      ]);

      await tester.pumpWidget(_buildTestApp(historyRepo: historyRepo));
      await tester.pumpAndSettle();

      final l10n = await AppLocalizations.delegate.load(const Locale('en'));

      // Open drawer
      await tester.tap(find.byTooltip(l10n.chatHistoryTitle));
      await tester.pumpAndSettle();

      expect(find.text('Older conversation'), findsOneWidget);
      expect(find.text('Recent conversation'), findsOneWidget);

      // Delete "Older conversation"
      final deleteButtons = find.byTooltip(l10n.deleteChatAction);
      expect(deleteButtons, findsNWidgets(2));

      await tester.tap(deleteButtons.last);
      await tester.pumpAndSettle();

      // Dialog confirmation appears
      expect(find.text(l10n.deleteChatConfirmTitle), findsOneWidget);
      await tester
          .tap(find.widgetWithText(FilledButton, l10n.deleteChatAction));
      await tester.pumpAndSettle();

      // "Older conversation" was removed
      expect(find.text('Older conversation'), findsNothing);
      expect(find.text('Recent conversation'), findsOneWidget);

      // Now clear all history
      await tester.tap(find.text(l10n.clearAllChatsAction));
      await tester.pumpAndSettle();

      expect(find.text(l10n.clearAllChatsConfirmTitle), findsOneWidget);
      await tester
          .tap(find.widgetWithText(FilledButton, l10n.clearAllChatsAction));
      await tester.pumpAndSettle();

      // Empty state is shown in drawer
      expect(find.text(l10n.noChatHistory), findsOneWidget);
      expect(await historyRepo.loadConversations(), isEmpty);
    });

    testWidgets('Chat history renders properly in Amharic', (tester) async {
      final historyRepo = InMemoryChatHistoryRepository([
        ChatConversation(
          id: 'conv_am',
          title: 'የኤችአይቪ መከላከያ',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          messages: [
            ChatMessage(
              id: 'm_am',
              text: 'ስለ ኤችአይቪ ንገረኝ',
              isUser: true,
              timestamp: DateTime.now(),
            ),
          ],
        ),
      ]);

      await tester.pumpWidget(_buildTestApp(
        historyRepo: historyRepo,
        locale: const Locale('am'),
      ));
      await tester.pumpAndSettle();

      final l10n = await AppLocalizations.delegate.load(const Locale('am'));

      // Open drawer in Amharic
      await tester.tap(find.byTooltip(l10n.chatHistoryTitle));
      await tester.pumpAndSettle();

      expect(find.text(l10n.newChatAction), findsOneWidget);
      expect(find.text(l10n.chatHistoryTitle), findsOneWidget);
      expect(find.text('የኤችአይቪ መከላከያ'), findsWidgets);
      expect(find.text(l10n.chatHistoryToday), findsOneWidget);
      expect(find.text(l10n.clearAllChatsAction), findsOneWidget);
    });
  });
}
