import 'package:flutter/material.dart';

/// Thumbnail banner with rounded overlay and play icon.
class HivVideoThumbnail extends StatelessWidget {
  const HivVideoThumbnail({
    required this.imageAsset,
    required this.onTap,
    super.key,
  });

  final String imageAsset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(19)),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(19)),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                imageAsset,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 170,
              ),
              Container(
                height: 170,
                color: Colors.black.withValues(alpha: 0.25),
              ),
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.95),
                  shape: BoxShape.circle,
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x30000000),
                      blurRadius: 16,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: Color(0xFF0284C7),
                  size: 36,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
