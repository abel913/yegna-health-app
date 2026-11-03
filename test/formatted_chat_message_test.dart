import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yegna_health_app/src/chatbot/formatted_chat_message.dart';

Widget _buildWrapper(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: SingleChildScrollView(
        child: child,
      ),
    ),
  );
}

void main() {
  group('FormattedChatMessage Widget Tests', () {
    testWidgets('renders plain text and strips asterisks for bold highlights',
        (tester) async {
      const raw = 'Hello! **Yegna Health** is a youth platform.';
      await tester.pumpWidget(_buildWrapper(
        const FormattedChatMessage(text: raw),
      ));
      await tester.pumpAndSettle();

      // Ensure no raw asterisks exist anywhere in the rendered text
      expect(find.textContaining('**'), findsNothing);

      // Verify text content is rendered
      final richTextFinder = find.byType(RichText);
      expect(richTextFinder, findsWidgets);

      final richText = tester.firstWidget<RichText>(richTextFinder);
      final textSpan = richText.text as TextSpan;
      final textContent = textSpan.toPlainText();

      expect(textContent, contains('Hello! '));
      expect(textContent, contains('Yegna Health'));
      expect(textContent, contains(' is a youth platform.'));
    });

    testWidgets('renders bullet points with custom bullet indicator',
        (tester) async {
      const raw = '''
Our services include:
* **Puberty & Hygiene:** Physical changes and care.
* **HIV Prevention:** Condoms and testing.
''';

      await tester.pumpWidget(_buildWrapper(
        const FormattedChatMessage(text: raw),
      ));
      await tester.pumpAndSettle();

      // Zero asterisks
      expect(find.textContaining('**'), findsNothing);

      // Bullet items should be present
      final richTexts = tester.widgetList<RichText>(find.byType(RichText));
      final allText =
          richTexts.map((r) => (r.text as TextSpan).toPlainText()).join(' ');

      expect(allText, contains('Puberty & Hygiene:'));
      expect(allText, contains('HIV Prevention:'));
    });

    testWidgets('renders numbered list with numeric badges', (tester) async {
      const raw = '''
Top Clinics:
1. **FGAE Youth Center** (Sarbet)
2. **Selam Children Village** (Kotebe)
''';

      await tester.pumpWidget(_buildWrapper(
        const FormattedChatMessage(text: raw),
      ));
      await tester.pumpAndSettle();

      expect(find.textContaining('**'), findsNothing);
      expect(find.text('1'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);

      final richTexts = tester.widgetList<RichText>(find.byType(RichText));
      final allText =
          richTexts.map((r) => (r.text as TextSpan).toPlainText()).join(' ');
      expect(allText, contains('FGAE Youth Center'));
      expect(allText, contains('Selam Children Village'));
    });

    testWidgets('renders markdown headings with styled header bar',
        (tester) async {
      const raw = '### What is HIV?';
      await tester.pumpWidget(_buildWrapper(
        const FormattedChatMessage(text: raw),
      ));
      await tester.pumpAndSettle();

      expect(find.textContaining('###'), findsNothing);
      expect(find.text('What is HIV?'), findsOneWidget);
    });

    testWidgets('renders horizontal divider for ---', (tester) async {
      const raw = '''
Section One
---
Section Two
''';

      await tester.pumpWidget(_buildWrapper(
        const FormattedChatMessage(text: raw),
      ));
      await tester.pumpAndSettle();

      expect(find.byType(Divider), findsOneWidget);
      expect(find.textContaining('---'), findsNothing);
    });

    testWidgets('renders Amharic markdown text cleanly without artifacts',
        (tester) async {
      const raw = '''
• **ኤችአይቪ ምንድን ነው?** የሰውነት በሽታ መከላከያን የሚያጠቃ ቫይረስ ነው።
• **መከላከያ መንገዶች፡** ኮንዶም በአግባቡ መጠቀም።
''';

      await tester.pumpWidget(_buildWrapper(
        const FormattedChatMessage(text: raw),
      ));
      await tester.pumpAndSettle();

      expect(find.textContaining('**'), findsNothing);
      expect(find.textContaining('• **'), findsNothing);

      final richTexts = tester.widgetList<RichText>(find.byType(RichText));
      final allText =
          richTexts.map((r) => (r.text as TextSpan).toPlainText()).join(' ');

      expect(allText, contains('ኤችአይቪ ምንድን ነው?'));
      expect(allText, contains('መከላከያ መንገዶች፡'));
    });

    test('toPlainText strips markdown formatting for clipboard copy', () {
      const input = '''
### Prevention Guide
Hello! **Yegna Health** is here.
* **Point 1:** First *italic* item.
1. `Code item` for clinic.
---
''';

      final clean = FormattedChatMessage.toPlainText(input);
      expect(clean, isNot(contains('**')));
      expect(clean, isNot(contains('###')));
      expect(clean, isNot(contains('`')));
      expect(clean, contains('Prevention Guide'));
      expect(clean, contains('Hello! Yegna Health is here.'));
      expect(clean, contains('Point 1: First italic item.'));
      expect(clean, contains('Code item for clinic.'));
    });
  });
}
