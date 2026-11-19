import 'package:flutter/material.dart';

import '../../in_app_video_embed.dart';
import 'hiv_video_thumbnail.dart';

class HivVideoPreviewCard extends StatefulWidget {
  const HivVideoPreviewCard({
    required this.imageAsset,
    required this.videoId,
    required this.videoUrl,
    required this.title,
    required this.description,
    required this.watchLabel,
    required this.cinemaLabel,
    required this.playingInAppLabel,
    required this.closePlayerLabel,
    required this.onOpenCinema,
    super.key,
  });

  final String imageAsset;
  final String videoId;
  final String videoUrl;
  final String title;
  final String description;
  final String watchLabel;
  final String cinemaLabel;
  final String playingInAppLabel;
  final String closePlayerLabel;
  final VoidCallback onOpenCinema;

  @override
  State<HivVideoPreviewCard> createState() => _HivVideoPreviewCardState();
}

class _HivVideoPreviewCardState extends State<HivVideoPreviewCard> {
  bool _isPlayingInline = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _isPlayingInline
              ? const Color(0xFF0284C7)
              : const Color(0xFFD6E4F0),
          width: _isPlayingInline ? 1.8 : 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: _isPlayingInline
                ? const Color(0x200284C7)
                : const Color(0x06000000),
            blurRadius: _isPlayingInline ? 16 : 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_isPlayingInline) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: const BoxDecoration(
                color: Color(0xFF0F172A),
                borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF22C55E),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.playingInAppLabel,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.open_in_full_rounded,
                        color: Color(0xFF38BDF8), size: 18),
                    tooltip: widget.cinemaLabel,
                    onPressed: widget.onOpenCinema,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded,
                        color: Colors.white70, size: 20),
                    tooltip: widget.closePlayerLabel,
                    onPressed: () => setState(() => _isPlayingInline = false),
                  ),
                ],
              ),
            ),
            createInAppVideoEmbed(
              videoId: widget.videoId,
              height: 220,
            ),
          ] else
            HivVideoThumbnail(
              imageAsset: widget.imageAsset,
              onTap: () => setState(() => _isPlayingInline = true),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF08264A),
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF475569),
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    if (!_isPlayingInline)
                      FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF0284C7),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.play_arrow_rounded, size: 18),
                        label: Text(
                          widget.watchLabel,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                        onPressed: () =>
                            setState(() => _isPlayingInline = true),
                      ),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF005A71),
                        side: const BorderSide(
                            color: Color(0xFF005A71), width: 1.2),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.open_in_full_rounded, size: 15),
                      label: Text(
                        widget.cinemaLabel,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                      onPressed: widget.onOpenCinema,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
