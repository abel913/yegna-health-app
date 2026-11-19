import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../assessment/module_assessment_launcher_card.dart';
import 'assessment_repository.dart';
import 'learning_modules_carousel.dart';
import 'learning_progress_controller.dart';
import 'modules/dynamic/dynamic_accordion_card.dart';
import 'modules/dynamic/dynamic_doctor_note_card.dart';
import 'modules/dynamic/dynamic_module_actions.dart';
import 'modules/dynamic/dynamic_module_hero.dart';
import 'modules/dynamic/dynamic_module_parser.dart';
import 'modules/dynamic/dynamic_section_content.dart';
import 'modules/dynamic/dynamic_section_header.dart';

/// Universal dynamic educational learning module page for admin-created
/// curriculum modules or edited curriculum topics.
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(children: [
          const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Text(l10n.moduleCompletedSuccess),
        ]),
        backgroundColor: const Color(0xFF16A34A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ));
    }
  }

  void _toggleSection(int index) {
    setState(() {
      _readSections.add(index);
      if (!_expandedSections.remove(index)) {
        _expandedSections.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isAmharic = Localizations.localeOf(context).languageCode == 'am';
    final content = isAmharic && widget.module.contentAm.isNotEmpty
        ? widget.module.contentAm
        : widget.module.contentEn;

    final parsedDoctorNote = DynamicModuleParser.extractDoctorNote(content);
    final sections = DynamicModuleParser.parseSections(content, isAmharic);
    final totalSections = sections.length;
    final dynamicHero = DynamicModuleHeroCard(module: widget.module, l10n: l10n);
    final doctorNote = DynamicDoctorNoteCard(
      noteText: parsedDoctorNote,
      isAmharic: isAmharic,
    );

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
            dynamicHero,
            const SizedBox(height: 20),
            doctorNote,
            const SizedBox(height: 24),
            DynamicSectionHeader(
              l10n: l10n,
              readCount: _readSections.length,
              totalSections: totalSections,
            ),
            const SizedBox(height: 14),
            for (int i = 0; i < sections.length; i++) ...[
              DynamicAccordionCard(
                sectionNumber: i + 1,
                title: sections[i].title,
                isExpanded: _expandedSections.contains(i),
                isRead: _readSections.contains(i),
                onToggle: () => _toggleSection(i),
                children: buildDynamicSectionChildren(sections[i]),
              ),
              const SizedBox(height: 12),
            ],
            const SizedBox(height: 16),
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
            if (widget.onOpenQuiz != null) ...[
              DynamicQuizBannerCard(
                onOpenQuiz: widget.onOpenQuiz!,
                isAmharic: isAmharic,
                l10n: l10n,
              ),
              const SizedBox(height: 20),
            ],
            DynamicMarkCompletedButton(
              onPressed: () => _markCompleted(context, l10n),
              l10n: l10n,
            ),
          ],
        ),
      ),
    );
  }
}
