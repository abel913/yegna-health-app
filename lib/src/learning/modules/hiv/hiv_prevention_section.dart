import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../widgets/curriculum/curriculum_accordion_card.dart';
import '../../widgets/curriculum/curriculum_bullet_item.dart';
import 'hiv_cinema_modal.dart';
import 'hiv_video_constants.dart';
import 'hiv_video_preview_card.dart';

Widget buildHivPreventionSection(
  BuildContext context,
  AppLocalizations l10n,
  bool isExpanded,
  bool isRead,
  VoidCallback onToggle,
) {
  return CurriculumAccordionCard(
    title: l10n.hivPreventionTitle,
    isExpanded: isExpanded,
    isRead: isRead,
    onToggle: onToggle,
    children: [
      Text(
        l10n.hivPreventionIntro,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF334155),
          height: 1.55,
        ),
      ),
      const SizedBox(height: 14),

      CurriculumAlphaBadgeItem(letter: 'A', text: l10n.hivMethodA),
      CurriculumAlphaBadgeItem(letter: 'B', text: l10n.hivMethodB),
      CurriculumAlphaBadgeItem(letter: 'C', text: l10n.hivMethodC),
      CurriculumAlphaBadgeItem(letter: 'D', text: l10n.hivMethodD),
      const SizedBox(height: 10),

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

      CurriculumAlphaBadgeItem(letter: 'E', text: l10n.hivMethodE),
      CurriculumAlphaBadgeItem(letter: 'F', text: l10n.hivMethodF),
      const SizedBox(height: 12),

      Text(
        l10n.prepDesc,
        style: const TextStyle(
          fontSize: 13.5,
          color: Color(0xFF334155),
          height: 1.55,
        ),
      ),
      const SizedBox(height: 16),

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

      HivVideoPreviewCard(
        imageAsset: 'assets/images/learning/hiv_video_lubricants.png',
        videoId: kHivVideo1Id,
        videoUrl: kHivVideo1Url,
        title: l10n.videoDialogTitle,
        description: l10n.lubricantsVideoDesc,
        watchLabel: l10n.watchVideo,
        cinemaLabel: l10n.cinemaMode,
        playingInAppLabel: l10n.playingInApp,
        closePlayerLabel: l10n.closePlayer,
        onOpenCinema: () {
          showHivVideoCinemaModal(
            context,
            videoId: kHivVideo1Id,
            videoUrl: kHivVideo1Url,
            title: l10n.videoDialogTitle,
            description: l10n.lubricantsVideoDesc,
            l10n: l10n,
          );
        },
      ),
      const SizedBox(height: 18),

      CurriculumStepItem(number: 1, text: l10n.condomStep1),
      CurriculumStepItem(number: 2, text: l10n.condomStep2),
      CurriculumStepItem(number: 3, text: l10n.condomStep3),
      CurriculumStepItem(number: 4, text: l10n.condomStep4),
      CurriculumStepItem(number: 5, text: l10n.condomStep5),
      CurriculumStepItem(number: 6, text: l10n.condomStep6),
      CurriculumStepItem(number: 7, text: l10n.condomStep7),
      CurriculumStepItem(number: 8, text: l10n.condomStep8),
      CurriculumStepItem(number: 9, text: l10n.condomStep9),
      CurriculumStepItem(number: 10, text: l10n.condomStep10),
      const SizedBox(height: 14),

      HivVideoPreviewCard(
        imageAsset: 'assets/images/learning/hiv_video_counselling.png',
        videoId: kHivVideo2Id,
        videoUrl: kHivVideo2Url,
        title: l10n.videoDialogTitle,
        description: l10n.counsellingVideoDesc,
        watchLabel: l10n.watchVideo,
        cinemaLabel: l10n.cinemaMode,
        playingInAppLabel: l10n.playingInApp,
        closePlayerLabel: l10n.closePlayer,
        onOpenCinema: () {
          showHivVideoCinemaModal(
            context,
            videoId: kHivVideo2Id,
            videoUrl: kHivVideo2Url,
            title: l10n.videoDialogTitle,
            description: l10n.counsellingVideoDesc,
            l10n: l10n,
          );
        },
      ),
    ],
  );
}
