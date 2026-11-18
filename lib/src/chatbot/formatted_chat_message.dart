import 'package:flutter/material.dart';

import 'widgets/chat_element_renderer.dart';
import 'widgets/chat_markdown_parser.dart';

/// Formats chatbot markdown text into structured visual elements.
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

  static String toPlainText(String markdown) =>
      ChatMarkdownParser.toPlainText(markdown);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveTextColor = textColor ??
        (isUser
            ? Colors.white
            : (isDark ? const Color(0xFFF1F5F9) : const Color(0xFF1E293B)));
    final boldTextColor = isUser
        ? Colors.white
        : (isDark ? Colors.white : const Color(0xFF0F172A));
    final headingColor = isUser
        ? Colors.white
        : (isDark ? const Color(0xFF38BDF8) : const Color(0xFF08264A));
    final accentColor = isUser
        ? Colors.white
        : (isDark ? const Color(0xFF38BDF8) : const Color(0xFF007A78));
    final numberBg = isUser
        ? Colors.white.withValues(alpha: 0.2)
        : (isDark ? const Color(0xFF1E293B) : const Color(0xFFE6F4F1));
    final numberBorder = isUser
        ? Colors.white70
        : (isDark
            ? const Color(0xFF38BDF8).withValues(alpha: 0.4)
            : const Color(0xFF99D5CA));

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

    final elements = ChatMarkdownParser.parseContent(text);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: elements.map((element) {
        return ChatElementRenderer.buildElement(
          element,
          normalStyle: normalStyle,
          boldStyle: boldStyle,
          italicStyle: italicStyle,
          headingColor: headingColor,
          accentColor: accentColor,
          numberBg: numberBg,
          numberBorder: numberBorder,
          fontSize: fontSize,
          isUser: isUser,
        );
      }).toList(),
    );
  }
}
