import 'package:flutter/material.dart';

/// Formats chatbot markdown text into structured, elegant visual elements
/// similar to ChatGPT and Google Gemini.
///
/// Converts markdown headers, bullet lists, numbered lists, dividers,
/// and inline bold/italic syntax into high-fidelity Flutter widgets without
/// leaving raw asterisks or formatting tokens in the UI.
class FormattedChatMessage extends StatelessWidget {
  const FormattedChatMessage({
    super.key,
    required this.text,
    this.isUser = false,
    this.fontSize = 14.5,
    this.textColor,
  });

  final String text;
  final bool isUser;
  final double fontSize;
  final Color? textColor;

  /// Utility to strip markdown formatting symbols into clean plain text
  /// suitable for copying to the clipboard.
  static String toPlainText(String markdown) {
    return markdown
        .replaceAll(RegExp(r'^\s*#{1,6}\s+', multiLine: true), '')
        .replaceAll(RegExp(r'^\s*[-*•]\s+', multiLine: true), '• ')
        .replaceAllMapped(RegExp(r'\*\*(.+?)\*\*'), (m) => m[1] ?? '')
        .replaceAllMapped(
            RegExp(r'(?<!\*)\*([^*\n]+)\*(?!\*)'), (m) => m[1] ?? '')
        .replaceAllMapped(RegExp(r'`(.+?)`'), (m) => m[1] ?? '')
        .trim();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveTextColor =
        textColor ?? (isUser ? Colors.white : const Color(0xFF1E293B));
    final boldTextColor = isUser ? Colors.white : const Color(0xFF0F172A);

    final normalStyle = TextStyle(
      fontSize: fontSize,
      height: 1.5,
      color: effectiveTextColor,
      fontWeight: isUser ? FontWeight.w500 : FontWeight.w400,
      letterSpacing: 0.1,
    );

    final boldStyle = TextStyle(
      fontSize: fontSize,
      height: 1.5,
      color: boldTextColor,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.1,
    );

    final italicStyle = TextStyle(
      fontSize: fontSize,
      height: 1.5,
      color: effectiveTextColor,
      fontStyle: FontStyle.italic,
      letterSpacing: 0.1,
    );

    final elements = _parseContent(text);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: elements.map((element) {
        return _buildElementWidget(
          element,
          normalStyle: normalStyle,
          boldStyle: boldStyle,
          italicStyle: italicStyle,
        );
      }).toList(),
    );
  }

  Widget _buildElementWidget(
    _ParsedElement element, {
    required TextStyle normalStyle,
    required TextStyle boldStyle,
    required TextStyle italicStyle,
  }) {
    switch (element.type) {
      case _ElementType.heading:
        return Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 3.5,
                height: 16,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: isUser ? Colors.white : const Color(0xFF007A78),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: Text(
                  element.text,
                  style: TextStyle(
                    fontSize: fontSize + 1.5,
                    fontWeight: FontWeight.w800,
                    color: isUser ? Colors.white : const Color(0xFF08264A),
                    letterSpacing: -0.2,
                  ),
                ),
              ),
            ],
          ),
        );

      case _ElementType.divider:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Divider(
            height: 1,
            thickness: 1,
            color: isUser ? Colors.white24 : const Color(0xFFE2E8F0),
          ),
        );

      case _ElementType.bullet:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 3.5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.only(top: 8, right: 10),
                decoration: BoxDecoration(
                  color: isUser ? Colors.white : const Color(0xFF007A78),
                  shape: BoxShape.circle,
                ),
              ),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: _parseInlineSpans(
                      element.text,
                      normalStyle: normalStyle,
                      boldStyle: boldStyle,
                      italicStyle: italicStyle,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );

      case _ElementType.numbered:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 3.5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 20,
                height: 20,
                margin: const EdgeInsets.only(top: 1.5, right: 9),
                decoration: BoxDecoration(
                  color: isUser
                      ? Colors.white.withValues(alpha: 0.2)
                      : const Color(0xFFE6F4F1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isUser ? Colors.white70 : const Color(0xFF99D5CA),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    element.prefix ?? '•',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      color: isUser ? Colors.white : const Color(0xFF007A78),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: _parseInlineSpans(
                      element.text,
                      normalStyle: normalStyle,
                      boldStyle: boldStyle,
                      italicStyle: italicStyle,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );

      case _ElementType.paragraph:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text.rich(
            TextSpan(
              children: _parseInlineSpans(
                element.text,
                normalStyle: normalStyle,
                boldStyle: boldStyle,
                italicStyle: italicStyle,
              ),
            ),
          ),
        );
    }
  }

  List<_ParsedElement> _parseContent(String text) {
    final elements = <_ParsedElement>[];
    final lines = text.split('\n');

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.isEmpty) {
        continue;
      }

      // 1. Horizontal Dividers
      if (line == '---' || line == '***' || line == '___') {
        elements.add(const _ParsedElement(type: _ElementType.divider));
        continue;
      }

      // 2. Headings (#, ##, ###)
      final headingMatch = RegExp(r'^#{1,6}\s+(.*)$').firstMatch(line);
      if (headingMatch != null) {
        final headingText = headingMatch.group(1) ?? '';
        elements.add(_ParsedElement(
          type: _ElementType.heading,
          text: _stripInlineTokens(headingText),
        ));
        continue;
      }

      // 3. Bullet points (*, -, •)
      final bulletMatch = RegExp(r'^\s*[-*•]\s+(.*)$').firstMatch(line);
      if (bulletMatch != null) {
        elements.add(_ParsedElement(
          type: _ElementType.bullet,
          text: bulletMatch.group(1) ?? '',
        ));
        continue;
      }

      // 4. Numbered list items (1. , 2. )
      final numberedMatch = RegExp(r'^\s*(\d+)[\.\)]\s+(.*)$').firstMatch(line);
      if (numberedMatch != null) {
        elements.add(_ParsedElement(
          type: _ElementType.numbered,
          prefix: numberedMatch.group(1),
          text: numberedMatch.group(2) ?? '',
        ));
        continue;
      }

      // 5. Standard paragraph
      elements.add(_ParsedElement(
        type: _ElementType.paragraph,
        text: line,
      ));
    }

    return elements;
  }

  static String _stripInlineTokens(String raw) {
    return raw
        .replaceAll(RegExp(r'\*\*(.+?)\*\*'), r'$1')
        .replaceAll(RegExp(r'\*(.+?)\*'), r'$1')
        .replaceAll(RegExp(r'`(.+?)`'), r'$1')
        .trim();
  }

  List<InlineSpan> _parseInlineSpans(
    String raw, {
    required TextStyle normalStyle,
    required TextStyle boldStyle,
    required TextStyle italicStyle,
  }) {
    final spans = <InlineSpan>[];
    // Regex matching bold (**text**), italic (*text*), or inline code (`code`)
    final regex = RegExp(r'\*\*(.+?)\*\*|\*(.+?)\*|`(.+?)`');
    int lastIndex = 0;

    for (final match in regex.allMatches(raw)) {
      if (match.start > lastIndex) {
        spans.add(TextSpan(
          text: raw.substring(lastIndex, match.start),
          style: normalStyle,
        ));
      }

      if (match.group(1) != null) {
        // Bold
        spans.add(TextSpan(
          text: match.group(1),
          style: boldStyle,
        ));
      } else if (match.group(2) != null) {
        // Italic
        spans.add(TextSpan(
          text: match.group(2),
          style: italicStyle,
        ));
      } else if (match.group(3) != null) {
        // Code / Highlight pill
        spans.add(WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: isUser
                  ? Colors.white.withValues(alpha: 0.2)
                  : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: isUser ? Colors.white38 : const Color(0xFFCBD5E1),
                width: 0.75,
              ),
            ),
            child: Text(
              match.group(3)!,
              style: normalStyle.copyWith(
                fontSize: fontSize - 1,
                fontFamily: 'monospace',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ));
      }

      lastIndex = match.end;
    }

    if (lastIndex < raw.length) {
      spans.add(TextSpan(
        text: raw.substring(lastIndex),
        style: normalStyle,
      ));
    }

    return spans.isEmpty ? [TextSpan(text: raw, style: normalStyle)] : spans;
  }
}

enum _ElementType {
  heading,
  divider,
  bullet,
  numbered,
  paragraph,
}

class _ParsedElement {
  const _ParsedElement({
    required this.type,
    this.text = '',
    this.prefix,
  });

  final _ElementType type;
  final String text;
  final String? prefix;
}
