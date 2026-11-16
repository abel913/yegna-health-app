import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../assessment/module_assessment_launcher_card.dart';
import 'assessment_repository.dart';
import 'learning_modules_carousel.dart';
import 'learning_progress_controller.dart';

/// Universal dynamic educational learning module page for admin-created
/// curriculum modules (Module 09, 10, etc.) or edited curriculum topics.
///
/// Features authentic optical glass styling matching the core 8 module screens:
/// 1. Hero banner with optical glass border and custom cover illustration
/// 2. Clinical note / Doctor's takeaway callout container
/// 3. Dynamic expandable accordion learning sections parsed from Markdown
/// 4. Integrated Modular Self-Assessment Checklist Card
/// 5. Knowledge check quiz launcher card
/// 6. Mark module as completed progress tracking
class DynamicModuleDetailPage extends StatefulWidget {
  const DynamicModuleDetailPage({
    required this.module,
    required this.progressController,
    this.assessmentRepository,
    this.onOpenQuiz,
    super.key,
  });

  final LearningModuleItem module;
  final LearningProgressController progressController;
  final AssessmentRepository? assessmentRepository;
  final VoidCallback? onOpenQuiz;

  @override
  State<DynamicModuleDetailPage> createState() =>
      _DynamicModuleDetailPageState();
}

class _DynamicModuleDetailPageState extends State<DynamicModuleDetailPage> {
  final Set<int> _expandedSections = {0};
  final Set<int> _readSections = {0};

  Future<void> _markCompleted(
      BuildContext context, AppLocalizations l10n) async {
    final locale = Localizations.localeOf(context).languageCode;
    await widget.progressController
        .markArticleComplete(widget.module.id, locale);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded,
                  color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(l10n.moduleCompletedSuccess),
            ],
          ),
          backgroundColor: const Color(0xFF16A34A),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  List<_ParsedSection> _parseSections(String content, bool isAmharic) {
    if (content.trim().isEmpty) {
      return [
        _ParsedSection(
          title: isAmharic ? 'አጠቃላይ ትምህርት' : 'Core Guidance',
          body: isAmharic
              ? 'ይህ የጤና ሞጁል በባለሙያዎች የተዘጋጀ የወጣቶች የትምህርት መመሪያ ነው።'
              : 'This health module provides verified youth health guidance.',
          bullets: const [],
          note: null,
        ),
      ];
    }

    final rawBlocks = content.split(RegExp(r'\r?\n##\s+'));
    final sections = <_ParsedSection>[];

    for (int i = 0; i < rawBlocks.length; i++) {
      final block = rawBlocks[i].trim();
      if (block.isEmpty) continue;

      final lines = block.split(RegExp(r'\r?\n'));
      final title = lines.first.replaceAll(RegExp(r'^#+\s*'), '').trim();
      final rest = lines.skip(1).join('\n').trim();
      sections.add(_extractSection(
        title.isNotEmpty
            ? title
            : (isAmharic ? 'ክፍል ${i + 1}' : 'Section ${i + 1}'),
        rest,
      ));
    }

    if (sections.isEmpty) {
      sections.add(_ParsedSection(
        title: isAmharic ? 'የትምህርት ይዘት' : 'Curriculum Content',
        body: content,
        bullets: const [],
        note: null,
      ));
    }

    return sections;
  }

  String? _extractDoctorNote(String content) {
    // Look for top-level doctor note in preamble before the first "## " section
    final firstSectionIdx = content.indexOf(RegExp(r'(?:^|\n)##\s+'));
    final preamble =
        firstSectionIdx != -1 ? content.substring(0, firstSectionIdx) : content;
    final noteMatch = RegExp(
      r'(?:^|\n)>\s*(?:(?:Clinical Tip|Medical Note|Doctor Note|የዶክተር ማስታወሻ|Note):\s*)?([^\n\r]+)',
      caseSensitive: false,
    ).firstMatch(preamble);
    if (noteMatch != null && noteMatch.groupCount >= 1) {
      final note = noteMatch.group(1)?.trim();
      if (note != null && note.isNotEmpty) return note;
    }
    return null;
  }

  _ParsedSection _extractSection(String title, String body) {
    final lines = body.split(RegExp(r'\r?\n'));
    final proseLines = <String>[];
    final bullets = <String>[];
    String? note;

    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) continue;

      if (trimmed.startsWith('- ') || trimmed.startsWith('* ')) {
        bullets.add(trimmed.substring(2).trim());
      } else if (trimmed.startsWith('> ')) {
        note = trimmed.substring(2).trim();
      } else {
        proseLines.add(trimmed);
      }
    }

    return _ParsedSection(
      title: title,
      body: proseLines.join('\n\n'),
      bullets: bullets,
      note: note,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isAmharic = Localizations.localeOf(context).languageCode == 'am';
    final content = isAmharic && widget.module.contentAm.isNotEmpty
        ? widget.module.contentAm
        : widget.module.contentEn;

    final parsedDoctorNote = _extractDoctorNote(content);
    final sections = _parseSections(content, isAmharic);
    final totalSections = sections.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F9FD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F9FD),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Color(0xFF005A71),
            size: 24,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          l10n.moduleLabel(widget.module.number).toUpperCase(),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Color(0xFF005A71),
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 14),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2FE),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.timer_outlined,
                    color: Color(0xFF0284C7), size: 14),
                const SizedBox(width: 4),
                Text(
                  '${widget.module.readTimeMin} MIN',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0284C7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Hero Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: const Color(0xFFBAE6FD),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0284C7).withValues(alpha: 0.06),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Center(
                      child: widget.module.imageAsset.startsWith('http://') ||
                              widget.module.imageAsset.startsWith('https://')
                          ? Image.network(
                              widget.module.imageAsset,
                              height: 195,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => Container(
                                height: 160,
                                color: const Color(0xFFE0F2FE),
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.auto_stories_rounded,
                                  size: 48,
                                  color: Color(0xFF0284C7),
                                ),
                              ),
                            )
                          : Image.asset(
                              widget.module.imageAsset,
                              height: 195,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => Container(
                                height: 160,
                                color: const Color(0xFFE0F2FE),
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.auto_stories_rounded,
                                  size: 48,
                                  color: Color(0xFF0284C7),
                                ),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    widget.module.title(l10n),
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF08264A),
                      letterSpacing: -0.3,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.module.description(l10n),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF475569),
                      height: 1.55,
                    ),
                  ),
                  if (widget.module.authorName != null &&
                      widget.module.authorName!.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        const Icon(
                          Icons.verified_user_outlined,
                          size: 15,
                          color: Color(0xFF0284C7),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            widget.module.authorName!,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0369A1),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 2. Doctor's Note Container
            Row(
              children: [
                Container(
                  width: 3.5,
                  height: 18,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0284C7),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  isAmharic ? 'የዶክተር ማስታወሻ' : 'Note',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF08264A),
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF7FD),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: const Color(0xFFCFE5F7),
                  width: 1.2,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Color(0xFFD8EDFB),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.lightbulb_outline_rounded,
                      color: Color(0xFF0284C7),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      parsedDoctorNote ??
                          (isAmharic
                              ? 'የግል ጤና ጥበቃ እና ግንዛቤ ለወጣቶች ሁለንተናዊ እድገት ወሳኝ ነው። ማንኛውም ጥያቄ ሲኖርዎት በግቢው ውስጥ ያሉ የአቻ አማካሪዎችን ያነጋግሩ።'
                              : 'Health awareness empowers youth to make informed, safe choices. University peer counselors and campus focal persons are available for confidential support.'),
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: Color(0xFF1E3A5F),
                        height: 1.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 3. Learning Sections Header
            Row(
              children: [
                Container(
                  width: 3.5,
                  height: 18,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0284C7),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.learningSectionsTitle,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF08264A),
                    letterSpacing: -0.2,
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDDF0FD),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    l10n.readSectionsCount(
                        _readSections.length, totalSections),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0369A1),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // 4. Dynamic Expandable Sections
            for (int i = 0; i < sections.length; i++) ...[
              _DynamicAccordionCard(
                sectionNumber: i + 1,
                title: sections[i].title,
                isExpanded: _expandedSections.contains(i),
                isRead: _readSections.contains(i),
                onToggle: () {
                  setState(() {
                    _readSections.add(i);
                    if (_expandedSections.contains(i)) {
                      _expandedSections.remove(i);
                    } else {
                      _expandedSections.add(i);
                    }
                  });
                },
                children: [
                  if (sections[i].body.isNotEmpty) ...[
                    Text(
                      sections[i].body,
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: Color(0xFF334155),
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  for (final bullet in sections[i].bullets) ...[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 7, right: 10),
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Color(0xFF0284C7),
                              shape: BoxShape.circle,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              bullet,
                              style: const TextStyle(
                                fontSize: 13.5,
                                color: Color(0xFF334155),
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (sections[i].note != null) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FDF4),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFBBF7D0)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.check_circle_outline_rounded,
                              color: Color(0xFF16A34A), size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              sections[i].note!,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF166534),
                                height: 1.45,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 12),
            ],

            const SizedBox(height: 16),

            // 5. Modular Self-Assessment Launcher Card
            ModuleAssessmentLauncherCard(
              sectionNumber: 1,
              sectionKey: 'section_${widget.module.id}',
              moduleKey: widget.module.category,
              titleEn: '${widget.module.title(l10n)} Self-Assessment',
              titleAm: '${widget.module.title(l10n)} የራስ ምዘና',
              questionRangeTextEn: 'Confidential • Self-Assessment Questions',
              questionRangeTextAm: 'ሚስጥራዊ • የራስ ምዘና ጥያቄዎች',
              badgeColor: const Color(0xFF0284C7),
            ),
            const SizedBox(height: 20),

            // 6. Test Your Knowledge Quiz Card (if onOpenQuiz provided)
            if (widget.onOpenQuiz != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF005A71), Color(0xFF0284C7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0284C7).withValues(alpha: 0.3),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.quiz_outlined,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isAmharic ? 'የእውቀት ምዘና' : 'Knowledge Check',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isAmharic
                                ? 'የሞጁሉን ዋና ነጥቦች ይፈትሹ'
                                : 'Review core takeaways from this module',
                            style: TextStyle(
                              fontSize: 12.5,
                              color: Colors.white.withValues(alpha: 0.85),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: widget.onOpenQuiz,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF005A71),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        l10n.takeQuizButton,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // 7. Mark as Completed Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _markCompleted(context, l10n),
                icon: const Icon(Icons.check_circle_rounded, size: 20),
                label: Text(
                  l10n.markCompleted,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF005A71),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ParsedSection {
  const _ParsedSection({
    required this.title,
    required this.body,
    required this.bullets,
    required this.note,
  });

  final String title;
  final String body;
  final List<String> bullets;
  final String? note;
}

class _DynamicAccordionCard extends StatelessWidget {
  const _DynamicAccordionCard({
    required this.sectionNumber,
    required this.title,
    required this.isExpanded,
    required this.isRead,
    required this.onToggle,
    required this.children,
  });

  final int sectionNumber;
  final String title;
  final bool isExpanded;
  final bool isRead;
  final VoidCallback onToggle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isExpanded
              ? const Color(0xFF0284C7)
              : const Color(0xFFE2E8F0),
          width: isExpanded ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onToggle,
              borderRadius: BorderRadius.circular(18),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: isRead
                            ? const Color(0xFFE0F2FE)
                            : const Color(0xFFF1F5F9),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '$sectionNumber',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: isRead
                              ? const Color(0xFF0284C7)
                              : const Color(0xFF64748B),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: isExpanded
                              ? const Color(0xFF0284C7)
                              : const Color(0xFF0F172A),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 240),
                      child: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Color(0xFF005A71),
                        size: 26,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 240),
          ),
        ],
      ),
    );
  }
}
