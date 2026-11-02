import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yegna_health_app/l10n/app_localizations.dart';
import 'package:yegna_health_app/src/chatbot/chatbot_repository.dart';
import 'package:yegna_health_app/src/chatbot/local_curriculum_chatbot_repository.dart';
import 'package:yegna_health_app/src/chatbot/yegna_chatbot_page.dart';

Widget _buildTestApp({
  required ChatbotRepository repository,
  String? initialQuery,
  Locale locale = const Locale('en'),
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
      repository: repository,
      initialQuery: initialQuery,
    ),
  );
}

void main() {
  testWidgets('YegnaChatbotPage renders title, disclaimer, and welcome message',
      (tester) async {
    const repo = LocalCurriculumChatbotRepository();
    await tester.pumpWidget(_buildTestApp(repository: repo));
    await tester.pumpAndSettle();

    expect(find.text('Yegna Health Assistant'), findsOneWidget);
    expect(find.text('Confidential youth health guidance'), findsOneWidget);
    expect(find.byIcon(Icons.health_and_safety_outlined), findsOneWidget);
    expect(
        find.textContaining('Hello! I am your private Yegna Health Assistant'),
        findsOneWidget);
  });

  testWidgets('submitting a query displays user bubble and assistant reply',
      (tester) async {
    const repo = LocalCurriculumChatbotRepository();
    await tester.pumpWidget(_buildTestApp(repository: repo));
    await tester.pumpAndSettle();

    final inputField = find.byType(TextField);
    expect(inputField, findsOneWidget);

    await tester.enterText(inputField, 'How is HIV prevented?');
    await tester.pump();

    final sendButton = find.byIcon(Icons.arrow_upward_rounded);
    expect(sendButton, findsOneWidget);
    await tester.tap(sendButton);
    await tester.pump();

    // Verify user message appears immediately
    expect(find.text('How is HIV prevented?'), findsOneWidget);

    // Wait for mock delay
    await tester.pump(const Duration(milliseconds: 350));
    await tester.pumpAndSettle();

    // Verify assistant responded with grounded content
    expect(find.textContaining('Human Immunodeficiency Virus'), findsOneWidget);
  });

  testWidgets('tapping a suggested chip automatically delivers the query',
      (tester) async {
    const repo = LocalCurriculumChatbotRepository();
    await tester.pumpWidget(_buildTestApp(repository: repo));
    await tester.pumpAndSettle();

    final chipFinder = find.widgetWithText(ActionChip, 'How to prevent HIV?');
    expect(chipFinder, findsOneWidget);

    await tester.tap(chipFinder);
    await tester.pump();

    // User message appeared in the thread in addition to the chip
    expect(find.text('How to prevent HIV?'), findsNWidgets(2));
    await tester.pump(const Duration(milliseconds: 350));
    await tester.pumpAndSettle();

    expect(find.textContaining('Human Immunodeficiency Virus'), findsOneWidget);
  });

  testWidgets('emergency query displays warning badge and hotline call buttons',
      (tester) async {
    const repo = LocalCurriculumChatbotRepository();
    await tester.pumpWidget(_buildTestApp(repository: repo));
    await tester.pumpAndSettle();

    final inputField = find.byType(TextField);
    await tester.enterText(inputField, 'I feel suicidal please help');
    await tester.pump();

    await tester.tap(find.byIcon(Icons.arrow_upward_rounded));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));
    await tester.pumpAndSettle();

    expect(find.text('Emergency Helpline Alert'), findsOneWidget);
    expect(find.textContaining('National Health Emergency Line (952)'),
        findsOneWidget);
    expect(find.textContaining('National Youth & Mental Health Line (8335)'),
        findsOneWidget);
  });

  testWidgets('clear chat resets conversation to initial welcome state',
      (tester) async {
    const repo = LocalCurriculumChatbotRepository();
    await tester.pumpWidget(_buildTestApp(repository: repo));
    await tester.pumpAndSettle();

    final inputField = find.byType(TextField);
    await tester.enterText(inputField, 'Where can I get tested?');
    await tester.pump();
    await tester.tap(find.byIcon(Icons.arrow_upward_rounded));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));
    await tester.pumpAndSettle();

    expect(find.textContaining('FGAE Youth Center'), findsOneWidget);

    // Tap clear button
    final clearButton = find.byIcon(Icons.delete_sweep_outlined);
    expect(clearButton, findsOneWidget);
    await tester.tap(clearButton);
    await tester.pumpAndSettle();

    // Verify response is cleared and welcome message is back
    expect(find.textContaining('FGAE Youth Center'), findsNothing);
    expect(
        find.textContaining('Hello! I am your private Yegna Health Assistant'),
        findsOneWidget);
  });

  testWidgets('renders properly in Amharic', (tester) async {
    const repo = LocalCurriculumChatbotRepository();
    await tester.pumpWidget(_buildTestApp(
      repository: repo,
      locale: const Locale('am'),
    ));
    await tester.pumpAndSettle();

    expect(find.text('የየኛ ጤና ረዳት'), findsOneWidget);
    expect(find.text('ሚስጥራዊ የወጣቶች ጤና መረጃ'), findsOneWidget);
    expect(find.textContaining('ሰላም! እኔ የየኛ ጤና ረዳት ነኝ'), findsOneWidget);
  });
}
