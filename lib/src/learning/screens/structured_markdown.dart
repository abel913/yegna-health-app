import 'package:flutter/material.dart';

/// Clean custom parser and renderer for structured Markdown text.
class StructuredMarkdown extends StatelessWidget {
  const StructuredMarkdown({required this.markdown, super.key});

  final String markdown;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final blocks = markdown.split(RegExp(r'\r?\n\s*\r?\n'));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: blocks.map((block) {
        final text = block.trim();
        if (text.isEmpty) return const SizedBox.shrink();
        final heading = RegExp(r'^(#{1,3})\s+(.+)$').firstMatch(text);
        if (heading != null) {
          final style = heading.group(1)!.length == 1
              ? theme.textTheme.headlineSmall
              : theme.textTheme.titleLarge;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(heading.group(2)!, style: style),
          );
        }
        if (text.split('\n').every(
            (line) => RegExp(r'^\s*(?:[-*]|\d+[.)])\s+').hasMatch(line))) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: text.split('\n').map((line) {
              final content = line.replaceFirst(
                RegExp(r'^\s*(?:[-*]|\d+[.)])\s+'),
                '',
              );
              return Padding(
                padding: const EdgeInsetsDirectional.only(start: 12, bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('•  '),
                    Expanded(child: Text(content)),
                  ],
                ),
              );
            }).toList(),
          );
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(text, style: theme.textTheme.bodyLarge),
        );
      }).toList(),
    );
  }
}
