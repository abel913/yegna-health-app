import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../in_app_video_embed.dart';

/// Interactive video card displayed at the bottom of a module section
/// when an educational YouTube video is provided.
class SectionVideoCard extends StatelessWidget {
  const SectionVideoCard({
    required this.videoId,
    required this.videoUrl,
    required this.sectionTitle,
    this.isAmharic = false,
    super.key,
  });

  final String videoId;
  final String videoUrl;
  final String sectionTitle;
  final bool isAmharic;

  @override
  Widget build(BuildContext context) {
    final thumbUrl = 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';

    return Container(
      margin: const EdgeInsets.only(top: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF0284C7).withValues(alpha: 0.35),
          width: 1.2,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _handlePlay(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(),
              _buildThumbnail(thumbUrl),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() => Padding(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text('YOUTUBE',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 9.5,
                      fontWeight: FontWeight.w900)),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                isAmharic ? 'የትምህርት ቪዲዮ' : 'Educational Video',
                style: const TextStyle(
                    color: Color(0xFFE2E8F0),
                    fontSize: 12,
                    fontWeight: FontWeight.w700),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );

  Widget _buildThumbnail(String thumbUrl) => AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(thumbUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                    color: const Color(0xFF1E293B),
                    alignment: Alignment.center,
                    child: const Icon(Icons.smart_display_rounded,
                        color: Colors.white38, size: 48))),
            Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Color(0xB30F172A)]))),
            Center(
                child: Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                        color: Color(0xEBEE4444), shape: BoxShape.circle),
                    child: const Icon(Icons.play_arrow_rounded,
                        color: Colors.white, size: 30))),
          ],
        ),
      );

  Widget _buildFooter() => Padding(
        padding: const EdgeInsets.fromLTRB(14, 9, 14, 11),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(isAmharic ? 'ቪዲዮውን ለማየት ይንኩ' : 'Tap to watch video',
                style: const TextStyle(
                    color: Color(0xFF38BDF8),
                    fontSize: 12,
                    fontWeight: FontWeight.w700)),
            const Icon(Icons.open_in_new_rounded,
                color: Color(0xFF94A3B8), size: 15),
          ],
        ),
      );

  Future<void> _handlePlay(BuildContext context) async {
    final uri = Uri.tryParse(videoUrl.startsWith('http')
        ? videoUrl
        : 'https://www.youtube.com/watch?v=$videoId');
    if (!kIsWeb && uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      return;
    }
    if (!context.mounted) return;
    _showCinemaModal(context);
  }

  void _showCinemaModal(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.8),
      builder: (ctx) => Dialog(
        backgroundColor: const Color(0xFF0F172A),
        insetPadding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 8, 6),
                child: Row(children: [
                  Expanded(
                    child: Text(sectionTitle,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 14),
                        overflow: TextOverflow.ellipsis),
                  ),
                  IconButton(
                    icon:
                        const Icon(Icons.close_rounded, color: Colors.white70),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ]),
              ),
              createInAppVideoEmbed(videoId: videoId, height: 280),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
