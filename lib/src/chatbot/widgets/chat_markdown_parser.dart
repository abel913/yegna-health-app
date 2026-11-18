enum ChatElementType {
  heading,
  divider,
  bullet,
  numbered,
  paragraph,
}

class ChatParsedElement {
  const ChatParsedElement({
    required this.type,
    this.text = '',
    this.prefix,
  });

  final ChatElementType type;
  final String text;
  final String? prefix;
}

class ChatMarkdownParser {
  static List<ChatParsedElement> parseContent(String text) {
    final elements = <ChatParsedElement>[];
    final lines = text.split('\n');

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.isEmpty) continue;

      if (line == '---' || line == '***' || line == '___') {
        elements.add(const ChatParsedElement(type: ChatElementType.divider));
        continue;
      }

      final headingMatch = RegExp(r'^#{1,6}\s+(.*)$').firstMatch(line);
      if (headingMatch != null) {
        final headingText = headingMatch.group(1) ?? '';
        elements.add(ChatParsedElement(
          type: ChatElementType.heading,
          text: stripInlineTokens(headingText),
        ));
        continue;
      }

      final bulletMatch = RegExp(r'^\s*[-*•]\s+(.*)$').firstMatch(line);
      if (bulletMatch != null) {
        elements.add(ChatParsedElement(
          type: ChatElementType.bullet,
          text: bulletMatch.group(1) ?? '',
        ));
        continue;
      }

      final numberedMatch = RegExp(r'^\s*(\d+)[\.\)]\s+(.*)$').firstMatch(line);
      if (numberedMatch != null) {
        elements.add(ChatParsedElement(
          type: ChatElementType.numbered,
          prefix: numberedMatch.group(1),
          text: numberedMatch.group(2) ?? '',
        ));
        continue;
      }

      elements.add(ChatParsedElement(
        type: ChatElementType.paragraph,
        text: line,
      ));
    }

    return elements;
  }

  static String stripInlineTokens(String raw) {
    return raw
        .replaceAll(RegExp(r'\*\*(.+?)\*\*'), r'$1')
        .replaceAll(RegExp(r'\*(.+?)\*'), r'$1')
        .replaceAll(RegExp(r'`(.+?)`'), r'$1')
        .trim();
  }

  static String toPlainText(String markdown) {
    return markdown
        .replaceAll(RegExp(r'^\s*#{1,6}\s+', multiLine: true), '')
        .replaceAll(RegExp(r'^\s*[-*•]\s+', multiLine: true), '• ')
        .replaceAllMapped(RegExp(r'\*\*(.+?)\*\*'), (m) => m[1] ?? '')
        .replaceAllMapped(RegExp(r'(?<!\*)\*([^*\n]+)\*(?!\*)'), (m) => m[1] ?? '')
        .replaceAllMapped(RegExp(r'`(.+?)`'), (m) => m[1] ?? '')
        .trim();
  }
}
