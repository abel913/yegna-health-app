/// Data model representing a parsed section from dynamic module markdown content.
class ParsedSection {
  const ParsedSection({
    required this.title,
    required this.body,
    required this.bullets,
    required this.note,
    this.videoUrl,
    this.videoId,
  });

  final String title;
  final String body;
  final List<String> bullets;
  final String? note;
  final String? videoUrl;
  final String? videoId;
}

/// Helper for parsing markdown curriculum sections and doctor notes.
class DynamicModuleParser {
  const DynamicModuleParser._();

  static List<ParsedSection> parseSections(String content, bool isAmharic) {
    if (content.trim().isEmpty) {
      return [
        ParsedSection(
          title: isAmharic ? 'አጠቃላይ ትምህርት' : 'Core Guidance',
          body: isAmharic
              ? 'ይህ የጤና ሞጁል በባለሙያዎች የተዘጋጀ የወጣቶች የትምህርት መመሪያ ነው።'
              : 'This health module provides verified youth health guidance.',
          bullets: const [],
          note: null,
        ),
      ];
    }

    final firstSectionIdx = content.indexOf(RegExp(r'(?:^|\r?\n)##\s+'));
    String sectionsText = content.trim();
    if (firstSectionIdx != -1) {
      sectionsText = content.substring(firstSectionIdx).trim();
    }
    sectionsText = sectionsText.replaceFirst(RegExp(r'^##\s+'), '');

    final rawBlocks = sectionsText.split(RegExp(r'\r?\n##\s+'));
    final sections = <ParsedSection>[];

    for (int i = 0; i < rawBlocks.length; i++) {
      final block = rawBlocks[i].trim();
      if (block.isEmpty) continue;

      final lines = block.split(RegExp(r'\r?\n'));
      final title = lines.first.replaceAll(RegExp(r'^#+\s*'), '').trim();

      if (title.startsWith('|') &&
          (title.toLowerCase().contains('note') || title.contains('ማስታወሻ'))) {
        continue;
      }

      final rest = lines.skip(1).join('\n').trim();
      sections.add(extractSection(
        title.isNotEmpty
            ? title
            : (isAmharic ? 'ክፍል ${i + 1}' : 'Section ${i + 1}'),
        rest,
      ));
    }

    if (sections.isEmpty) {
      sections.add(ParsedSection(
        title: isAmharic ? 'የትምህርት ይዘት' : 'Curriculum Content',
        body: content,
        bullets: const [],
        note: null,
      ));
    }

    return sections;
  }

  static String? extractDoctorNote(String content) {
    final firstSectionIdx = content.indexOf(RegExp(r'(?:^|\r?\n)##\s+'));
    final preamble =
        firstSectionIdx != -1 ? content.substring(0, firstSectionIdx) : content;
    final noteMatch = RegExp(
      r'(?:^|\r?\n)(?:[>|]\s*|\s*)(?:Clinical Tip|Medical Note|Doctor(?:\x27s)? Note|የዶክተር ማስታወሻ|ማስታወሻ|Note):\s*([^\n\r]+(?:\r?\n(?!(?:##|#|[>|]|\s*$))[^\n\r]+)*)',
      caseSensitive: false,
    ).firstMatch(preamble);
    if (noteMatch != null && noteMatch.groupCount >= 1) {
      final note = noteMatch.group(1)?.trim();
      if (note != null && note.isNotEmpty) return note;
    }
    return null;
  }

  static String? extractYoutubeVideoId(String? urlOrId) {
    if (urlOrId == null || urlOrId.trim().isEmpty) return null;
    final trimmed = urlOrId.trim();
    if (RegExp(r'^[a-zA-Z0-9_-]{11}$').hasMatch(trimmed)) return trimmed;
    final match = RegExp(
      r'(?:youtu\.be\/|youtube\.com\/(?:embed\/|v\/|watch\?v=|watch\?.+&v=))([\w-]{11})',
    ).firstMatch(trimmed);
    return match?.group(1);
  }

  static ParsedSection extractSection(String title, String body) {
    final lines = body.split(RegExp(r'\r?\n'));
    final proseLines = <String>[];
    final bullets = <String>[];
    String? note;
    String? videoUrl;

    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) continue;

      if (trimmed.startsWith('- ') || trimmed.startsWith('* ')) {
        bullets.add(trimmed.substring(2).trim());
      } else if (trimmed.startsWith('> Video:') ||
          trimmed.startsWith('> ቪዲዮ:')) {
        videoUrl = trimmed
            .replaceFirst(
                RegExp(r'^>\s*(Video:|ቪዲዮ:)?\s*', caseSensitive: false), '')
            .trim();
      } else if (trimmed.startsWith('[video](') && trimmed.endsWith(')')) {
        videoUrl = trimmed.substring(8, trimmed.length - 1).trim();
      } else if (trimmed.startsWith('http') &&
          (trimmed.contains('youtube.com') || trimmed.contains('youtu.be'))) {
        videoUrl = trimmed;
      } else if (trimmed.startsWith('> ')) {
        note = trimmed.substring(2).trim();
      } else {
        proseLines.add(trimmed);
      }
    }

    final videoId = extractYoutubeVideoId(videoUrl);

    return ParsedSection(
      title: title,
      body: proseLines.join('\n\n'),
      bullets: bullets,
      note: note,
      videoUrl: videoUrl,
      videoId: videoId,
    );
  }
}
