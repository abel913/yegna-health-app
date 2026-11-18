import 'package:flutter/material.dart';

class ChatInlineSpanParser {
  static List<InlineSpan> parseInlineSpans(
    String raw, {
    required TextStyle normalStyle,
    required TextStyle boldStyle,
    required TextStyle italicStyle,
    required double fontSize,
    required bool isUser,
  }) {
    final spans = <InlineSpan>[];
    final regex = RegExp(r'\*\*(.+?)\*\*|\*(.+?)\*|`(.+?)`');
    int lastIndex = 0;

    for (final match in regex.allMatches(raw)) {
      if (match.start > lastIndex) {
        spans.add(TextSpan(text: raw.substring(lastIndex, match.start), style: normalStyle));
      }
      if (match.group(1) != null) {
        spans.add(TextSpan(text: match.group(1), style: boldStyle));
      } else if (match.group(2) != null) {
        spans.add(TextSpan(text: match.group(2), style: italicStyle));
      } else if (match.group(3) != null) {
        spans.add(WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: isUser ? Colors.white.withValues(alpha: 0.2) : const Color(0xFFF1F5F9),
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
      spans.add(TextSpan(text: raw.substring(lastIndex), style: normalStyle));
    }
    return spans.isEmpty ? [TextSpan(text: raw, style: normalStyle)] : spans;
  }
}
