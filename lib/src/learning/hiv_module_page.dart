import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../l10n/app_localizations.dart';
import 'assessment_repository.dart';
import 'learning_progress_controller.dart';

const String kHivVideo1Url = 'https://youtu.be/EdSq2HB7jqU?si=TkGVTHA3TmYIXI-S';
const String kHivVideo2Url = 'https://youtu.be/ii8ezLev2PU?si=QRNmr68hzDcRZZD6';

/// Detailed learning page for Module 07 (Human immune virus - HIV/AIDS).
///
/// Features authentic optical glass styling and 5 clinical accordion sections:
/// 1. Defination (Definition & immune impact)
/// 2. Mode of transmission (Body fluids & dispelling myths)
/// 3. HIV-Prevention (A-F prevention methods, PrEP/PEP, 10-step condom usage, YouTube videos)
/// 4. HIV testing (PITC and VCT modalities)
/// 5. Treatment for HIV positive client (ART regimen, access, and viral suppression)
class HivModuleDetailPage extends StatefulWidget {
  const HivModuleDetailPage({
    required this.progressController,
    this.assessmentRepository,
    this.onOpenQuiz,
    super.key,
  });

  final LearningProgressController progressController;
  final AssessmentRepository? assessmentRepository;
  final VoidCallback? onOpenQuiz;

  @override
  State<HivModuleDetailPage> createState() => _HivModuleDetailPageState();
}

class _HivModuleDetailPageState extends State<HivModuleDetailPage> {
  // Expansion state for the 5 accordion sections.
  final Set<int> _expandedSections = <int>{};

  // Track sections read by user (defaults to all 5 read matching reference).
  final Set<int> _readSections = <int>{0, 1, 2, 3, 4};

  Future<void> _launchVideoUrl(String url) async {
    final uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      try {
        await launchUrl(uri);
      } catch (_) {}
    }
  }

  Future<void> _markCompleted(
      BuildContext context, AppLocalizations l10n) async {
    final locale = Localizations.localeOf(context).languageCode;
    await widget.progressController.markArticleComplete('module-07', locale);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white),
            const SizedBox(width: 10),
            Text(l10n.moduleCompletedSuccess),
          ],
        ),
        backgroundColor: const Color(0xFF00796B),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showVideoModal({
    required BuildContext context,
    required String imageAsset,
    required String videoUrl,
    required String title,
    required String description,
    required AppLocalizations l10n,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF08264A),
                ),
              ),
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  onTap: () {
                    Navigator.of(ctx).pop();
                    _launchVideoUrl(videoUrl);
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        imageAsset,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 190,
                      ),
                      Container(
                        height: 190,
                        color: Colors.black.withValues(alpha: 0.25),
                      ),
                      Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.95),
                          shape: BoxShape.circle,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.play_arrow_rounded,
                          size: 38,
                          color: Color(0xFFEF4444),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.55,
                  color: Color(0xFF334155),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFEF4444),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon:
                      const Icon(Icons.play_arrow_rounded, color: Colors.white),
                  label: Text(
                    l10n.watchOnYouTube,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    _launchVideoUrl(videoUrl);
                  },
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF475569),
                    side: const BorderSide(color: Color(0xFFCBD5E1)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text(
                    l10n.closeButton,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
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
                  .any((a) => a.articleId == 'module-07') ??
              false;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Top Hero Card with Medical Illustration & Summary
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(
                      color: const Color(0xFFD6E8F6),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF005A71).withValues(alpha: 0.06),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Center(
                          child: Image.asset(
                            'assets/images/learning/module_07_hiv.png',
                            height: 195,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        l10n.module07Title,
                        style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF08264A),
                          letterSpacing: -0.3,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.hivHeroDesc,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF475569),
                          height: 1.55,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // 2. Note Section
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
                      l10n.hivNoteTitle,
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
                    color: const Color(0xFFEBF5FB),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFBAE6FD).withValues(alpha: 0.65),
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          color: Color(0xFFD0E8F8),
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
                          l10n.hivNoteContent,
                          style: const TextStyle(
                            fontSize: 13.5,
                            color: Color(0xFF1E293B),
                            height: 1.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 3. Learning Sections Header with Reading Progress Pill
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCEEFA),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        l10n.readSectionsCount(_readSections.length, 5),
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF005A71),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Section 1: Defination
                _AccordionCard(
                  title: l10n.hivDefinitionTitle,
                  isExpanded: _expandedSections.contains(0),
                  isRead: _readSections.contains(0),
                  onToggle: () {
                    setState(() {
                      _readSections.add(0);
                      if (_expandedSections.contains(0)) {
                        _expandedSections.remove(0);
                      } else {
                        _expandedSections.add(0);
                      }
                    });
                  },
                  children: [
                    Text(
                      l10n.hivDefinitionSubtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.hivDefinitionDesc1,
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: Color(0xFF334155),
                        height: 1.55,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      l10n.hivDefinitionDesc2,
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: Color(0xFF334155),
                        height: 1.55,
                      ),
                    ),
                    const SizedBox(height: 12),
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
                          const Icon(
                            Icons.verified_rounded,
                            color: Color(0xFF16A34A),
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              l10n.hivDefinitionDesc3,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF166534),
                                height: 1.45,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Section 2: Mode of transmission
                _AccordionCard(
                  title: l10n.hivTransmissionTitle,
                  isExpanded: _expandedSections.contains(1),
                  isRead: _readSections.contains(1),
                  onToggle: () {
                    setState(() {
                      _readSections.add(1);
                      if (_expandedSections.contains(1)) {
                        _expandedSections.remove(1);
                      } else {
                        _expandedSections.add(1);
                      }
                    });
                  },
                  children: [
                    Text(
                      l10n.hivTransmissionSubtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.hivTransmissionIntro,
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: Color(0xFF334155),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _BulletItem(title: '• ', body: l10n.hivTransmissionItem1),
                    const SizedBox(height: 8),
                    _BulletItem(title: '• ', body: l10n.hivTransmissionItem2),
                    const SizedBox(height: 8),
                    _BulletItem(title: '• ', body: l10n.hivTransmissionItem3),
                    const SizedBox(height: 8),
                    _BulletItem(title: '• ', body: l10n.hivTransmissionItem4),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.shield_outlined,
                                color: Color(0xFF0284C7),
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                l10n.hivNotTransmittedTitle,
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            l10n.hivNotTransmittedDesc,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF475569),
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Section 3: HIV-Prevention (with A-F badges, PrEP/PEP, and YouTube videos)
                _AccordionCard(
                  title: l10n.hivPreventionTitle,
                  isExpanded: _expandedSections.contains(2),
                  isRead: _readSections.contains(2),
                  onToggle: () {
                    setState(() {
                      _readSections.add(2);
                      if (_expandedSections.contains(2)) {
                        _expandedSections.remove(2);
                      } else {
                        _expandedSections.add(2);
                      }
                    });
                  },
                  children: [
                    // Intro Paragraph
                    Text(
                      l10n.hivPreventionIntro,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF334155),
                        height: 1.55,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Primary Prevention Methods A - D
                    _AlphaBadgeItem(letter: 'A', text: l10n.hivMethodA),
                    _AlphaBadgeItem(letter: 'B', text: l10n.hivMethodB),
                    _AlphaBadgeItem(letter: 'C', text: l10n.hivMethodC),
                    _AlphaBadgeItem(letter: 'D', text: l10n.hivMethodD),
                    const SizedBox(height: 10),

                    // Intermediary paragraph
                    Text(
                      l10n.hivAdditionalPreventionIntro,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF0F172A),
                        height: 1.55,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Clinical Prevention Methods E - F
                    _AlphaBadgeItem(letter: 'E', text: l10n.hivMethodE),
                    _AlphaBadgeItem(letter: 'F', text: l10n.hivMethodF),
                    const SizedBox(height: 12),

                    // PrEP Full Clinical Description
                    Text(
                      l10n.prepDesc,
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: Color(0xFF334155),
                        height: 1.55,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // PEP Section
                    Text(
                      l10n.pepTitle,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.pepDesc,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF334155),
                        height: 1.55,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Condom Heading & Subtitle
                    Text(
                      l10n.condomStepsTitle,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.condomStepsSubtitle,
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: Color(0xFF475569),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Video 1: Condom Lubricants Warning Demonstration (YouTube linked)
                    _VideoPreviewCard(
                      imageAsset:
                          'assets/images/learning/hiv_video_lubricants.png',
                      videoUrl: kHivVideo1Url,
                      watchLabel: l10n.watchVideo,
                      onTap: () {
                        _showVideoModal(
                          context: context,
                          imageAsset:
                              'assets/images/learning/hiv_video_lubricants.png',
                          videoUrl: kHivVideo1Url,
                          title: l10n.videoDialogTitle,
                          description: l10n.lubricantsVideoDesc,
                          l10n: l10n,
                        );
                      },
                    ),
                    const SizedBox(height: 18),

                    // 10 Numbered Condom Steps
                    _StepItem(number: 1, text: l10n.condomStep1),
                    _StepItem(number: 2, text: l10n.condomStep2),
                    _StepItem(number: 3, text: l10n.condomStep3),
                    _StepItem(number: 4, text: l10n.condomStep4),
                    _StepItem(number: 5, text: l10n.condomStep5),
                    _StepItem(number: 6, text: l10n.condomStep6),
                    _StepItem(number: 7, text: l10n.condomStep7),
                    _StepItem(number: 8, text: l10n.condomStep8),
                    _StepItem(number: 9, text: l10n.condomStep9),
                    _StepItem(number: 10, text: l10n.condomStep10),
                    const SizedBox(height: 14),

                    // Video 2: Condom Counselling Demonstration (YouTube linked)
                    _VideoPreviewCard(
                      imageAsset:
                          'assets/images/learning/hiv_video_counselling.png',
                      videoUrl: kHivVideo2Url,
                      watchLabel: l10n.watchVideo,
                      onTap: () {
                        _showVideoModal(
                          context: context,
                          imageAsset:
                              'assets/images/learning/hiv_video_counselling.png',
                          videoUrl: kHivVideo2Url,
                          title: l10n.videoDialogTitle,
                          description: l10n.counsellingVideoDesc,
                          l10n: l10n,
                        );
                      },
                    ),
                  ],
                ),

                // Section 4: HIV testing
                _AccordionCard(
                  title: l10n.hivTesting,
                  isExpanded: _expandedSections.contains(3),
                  isRead: _readSections.contains(3),
                  onToggle: () {
                    setState(() {
                      _readSections.add(3);
                      if (_expandedSections.contains(3)) {
                        _expandedSections.remove(3);
                      } else {
                        _expandedSections.add(3);
                      }
                    });
                  },
                  children: [
                    Text(
                      l10n.hivTestingDesc,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF334155),
                        height: 1.55,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _BulletItem(
                      title: l10n.pitcTitle,
                      body: l10n.pitcDesc,
                    ),
                    const SizedBox(height: 14),
                    _BulletItem(
                      title: l10n.vctTitle,
                      body: l10n.vctDesc,
                    ),
                  ],
                ),

                // Section 5: Treatment for HIV positive client
                _AccordionCard(
                  title: l10n.treatmentForHivPositive,
                  isExpanded: _expandedSections.contains(4),
                  isRead: _readSections.contains(4),
                  onToggle: () {
                    setState(() {
                      _readSections.add(4);
                      if (_expandedSections.contains(4)) {
                        _expandedSections.remove(4);
                      } else {
                        _expandedSections.add(4);
                      }
                    });
                  },
                  children: [
                    Text(
                      l10n.artDesc1,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF334155),
                        height: 1.55,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      l10n.artDesc2,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF334155),
                        height: 1.55,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      l10n.artDesc3,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF334155),
                        height: 1.55,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Completion State and Quiz Actions
                if (isCompleted)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFA5D6A7),
                        width: 1.2,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.check_circle_rounded,
                          color: Color(0xFF2E7D32),
                          size: 22,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          l10n.completedStatus,
                          style: const TextStyle(
                            color: Color(0xFF1B5E20),
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF0284C7),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: const Icon(Icons.check_circle_outline_rounded),
                      label: Text(
                        l10n.markCompleted,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      onPressed: () => _markCompleted(context, l10n),
                    ),
                  ),

                if (widget.onOpenQuiz != null) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF005A71),
                        side: const BorderSide(
                          color: Color(0xFF005A71),
                          width: 1.4,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: const Icon(Icons.quiz_outlined),
                      label: Text(
                        l10n.takeQuizButton,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      onPressed: widget.onOpenQuiz,
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Polished accordion dropdown card matching the reference design.
class _AccordionCard extends StatelessWidget {
  const _AccordionCard({
    required this.title,
    required this.isExpanded,
    required this.isRead,
    required this.onToggle,
    required this.children,
  });

  final String title;
  final bool isExpanded;
  final bool isRead;
  final VoidCallback onToggle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFD6E4F0),
          width: 1.2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08003648),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: onToggle,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: isRead
                            ? const Color(0xFF0284C7)
                            : const Color(0xFFE2E8F0),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isRead ? Icons.check_rounded : Icons.circle_outlined,
                        color: isRead ? Colors.white : const Color(0xFF94A3B8),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15.5,
                          color: Color(0xFF08264A),
                          letterSpacing: -0.2,
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

/// Alphabetical circular badge item (A, B, C, D, E, F) matching the reference design.
class _AlphaBadgeItem extends StatelessWidget {
  const _AlphaBadgeItem({
    required this.letter,
    required this.text,
  });

  final String letter;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: const BoxDecoration(
              color: Color(0xFF0284C7),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              letter,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13.5,
                color: Color(0xFF1E293B),
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Interactive video preview container matching the reference card design with YouTube launch.
class _VideoPreviewCard extends StatelessWidget {
  const _VideoPreviewCard({
    required this.imageAsset,
    required this.videoUrl,
    required this.watchLabel,
    required this.onTap,
  });

  final String imageAsset;
  final String videoUrl;
  final String watchLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFD6E4F0),
              width: 1.2,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x06000000),
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(15)),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      imageAsset,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 160,
                    ),
                    Container(
                      height: 160,
                      color: Colors.black.withValues(alpha: 0.2),
                    ),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.95),
                        shape: BoxShape.circle,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        size: 32,
                        color: Color(0xFFEF4444),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Row(
                  children: [
                    const Icon(
                      Icons.play_circle_outline_rounded,
                      color: Color(0xFFEF4444),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      watchLabel,
                      style: const TextStyle(
                        color: Color(0xFFEF4444),
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.open_in_new_rounded,
                      color: Color(0xFF94A3B8),
                      size: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Clinical step item with numbered badge.
class _StepItem extends StatelessWidget {
  const _StepItem({
    required this.number,
    required this.text,
  });

  final int number;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: const BoxDecoration(
              color: Color(0xFF0284C7),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '$number',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13.5,
                color: Color(0xFF1E293B),
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Bullet item for clinical counseling modalities.
class _BulletItem extends StatelessWidget {
  const _BulletItem({
    required this.title,
    required this.body,
  });

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 6),
          child: Icon(
            Icons.circle,
            size: 7,
            color: Color(0xFF0284C7),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 13.5,
                color: Color(0xFF334155),
                height: 1.5,
              ),
              children: [
                TextSpan(
                  text: title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                ),
                TextSpan(text: body),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
