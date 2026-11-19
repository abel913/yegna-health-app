import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../learning_progress_controller.dart';
import 'curriculum_action_buttons.dart';
import 'curriculum_hero_card.dart';
import 'curriculum_note_card.dart';
import 'curriculum_section_header.dart';

class CurriculumDetailScaffold extends StatefulWidget {
  const CurriculumDetailScaffold({
    required this.moduleId,
    required this.imageAsset,
    required this.title,
    required this.heroDesc,
    required this.noteTitle,
    required this.noteText,
    required this.totalSections,
    required this.sectionsBuilder,
    required this.progressController,
    required this.onTakeQuiz,
    this.initialExpandedSections,
    this.initialReadSections,
    this.assessmentCard,
    super.key,
  });

  final String moduleId;
  final String imageAsset;
  final String Function(AppLocalizations) title;
  final String Function(AppLocalizations) heroDesc;
  final String Function(AppLocalizations) noteTitle;
  final String Function(AppLocalizations) noteText;
  final int totalSections;
  final Set<int>? initialExpandedSections;
  final Set<int>? initialReadSections;
  final Widget Function(BuildContext context, AppLocalizations l10n,
      Set<int> expanded, Set<int> read, void Function(int) toggle) sectionsBuilder;
  final LearningProgressController progressController;
  final VoidCallback onTakeQuiz;
  final Widget? assessmentCard;

  @override
  State<CurriculumDetailScaffold> createState() =>
      _CurriculumDetailScaffoldState();
}

class _CurriculumDetailScaffoldState extends State<CurriculumDetailScaffold> {
  late final Set<int> _expandedSections;
  late final Set<int> _readSections;

  @override
  void initState() {
    super.initState();
    _expandedSections = widget.initialExpandedSections != null
        ? Set<int>.from(widget.initialExpandedSections!)
        : {0};
    _readSections = widget.initialReadSections != null
        ? Set<int>.from(widget.initialReadSections!)
        : {0};
  }

  void _toggleSection(int index) {
    setState(() {
      _readSections.add(index);
      if (_expandedSections.contains(index)) {
        _expandedSections.remove(index);
      } else {
        _expandedSections.add(index);
      }
    });
  }

  Future<void> _markCompleted(
      BuildContext context, AppLocalizations l10n) async {
    final locale = Localizations.localeOf(context).languageCode;
    await widget.progressController
        .markArticleComplete(widget.moduleId, locale);

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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

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
          l10n.learningModulesTitle,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: const Color(0xFF005A71),
            fontSize: 18,
          ),
        ),
      ),
      body: ListenableBuilder(
        listenable: widget.progressController,
        builder: (context, _) {
          final isCompleted = widget.progressController.progress?.articles
                  .any((a) => a.articleId == widget.moduleId) ??
              false;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CurriculumHeroCard(
                  imageAsset: widget.imageAsset,
                  title: widget.title(l10n),
                  description: widget.heroDesc(l10n),
                ),
                const SizedBox(height: 20),
                CurriculumNoteCard(
                  title: widget.noteTitle(l10n),
                  text: widget.noteText(l10n),
                ),
                const SizedBox(height: 24),
                CurriculumSectionHeader(
                  readCount: _readSections.length,
                  totalSections: widget.totalSections,
                  l10n: l10n,
                ),
                const SizedBox(height: 14),
                widget.sectionsBuilder(context, l10n, _expandedSections,
                    _readSections, _toggleSection),
                CurriculumActionButtons(
                  isCompleted: isCompleted,
                  l10n: l10n,
                  onMarkCompleted: () => _markCompleted(context, l10n),
                  onTakeQuiz: widget.onTakeQuiz,
                  assessmentCard: widget.assessmentCard,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
