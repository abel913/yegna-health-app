import 'package:flutter/material.dart';

import 'chat_inline_span_parser.dart';
import 'chat_markdown_parser.dart';

/// Renders individual parsed markdown elements into styled widgets.
class ChatElementRenderer {
  const ChatElementRenderer._();

  static Widget buildElement(
    ChatParsedElement element, {
    required TextStyle normalStyle,
    required TextStyle boldStyle,
    required TextStyle italicStyle,
    required Color headingColor,
    required Color accentColor,
    required Color numberBg,
    required Color numberBorder,
    required double fontSize,
    required bool isUser,
  }) {
    switch (element.type) {
      case ChatElementType.heading:
        return Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 4),
          child: Row(
            children: [
              Container(
                width: 3.5,
                height: 16,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: Text(
                  element.text,
                  style: TextStyle(
                    fontSize: fontSize + 1.5,
                    fontWeight: FontWeight.w800,
                    color: headingColor,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
            ],
          ),
        );

      case ChatElementType.divider:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Divider(
            height: 1,
            thickness: 1,
            color: isUser ? Colors.white24 : const Color(0xFFE2E8F0),
          ),
        );

      case ChatElementType.bullet:
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
                  color: accentColor,
                  shape: BoxShape.circle,
                ),
              ),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: ChatInlineSpanParser.parseInlineSpans(
                      element.text,
                      normalStyle: normalStyle,
                      boldStyle: boldStyle,
                      italicStyle: italicStyle,
                      fontSize: fontSize,
                      isUser: isUser,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );

      case ChatElementType.numbered:
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
                  color: numberBg,
                  shape: BoxShape.circle,
                  border: Border.all(color: numberBorder, width: 1),
                ),
                child: Center(
                  child: Text(
                    element.prefix ?? '•',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      color: accentColor,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: ChatInlineSpanParser.parseInlineSpans(
                      element.text,
                      normalStyle: normalStyle,
                      boldStyle: boldStyle,
                      italicStyle: italicStyle,
                      fontSize: fontSize,
                      isUser: isUser,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );

      case ChatElementType.paragraph:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text.rich(
            TextSpan(
              children: ChatInlineSpanParser.parseInlineSpans(
                element.text,
                normalStyle: normalStyle,
                boldStyle: boldStyle,
                italicStyle: italicStyle,
                fontSize: fontSize,
                isUser: isUser,
              ),
            ),
          ),
        );
    }
  }
}
