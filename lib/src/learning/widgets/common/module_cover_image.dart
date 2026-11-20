import 'dart:convert';
import 'package:flutter/material.dart';

import '../../../theme/app_glass_theme.dart';
import '../../models/learning_module_item.dart';

/// Hybrid cover image widget for learning modules.
/// Seamlessly handles remote URLs, Base64 data URIs, local asset paths,
/// and web illustration paths, with automatic category-based fallback.
class ModuleCoverImage extends StatelessWidget {
  const ModuleCoverImage({
    required this.imagePath,
    this.fallbackCategory,
    this.fit = BoxFit.contain,
    this.width = double.infinity,
    this.height,
    this.alignment = Alignment.center,
    this.iconSize = 56,
    super.key,
  });

  final String imagePath;
  final String? fallbackCategory;
  final BoxFit fit;
  final double? width;
  final double? height;
  final Alignment alignment;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final path = imagePath.trim();
    if (path.startsWith('data:image')) {
      final commaIndex = path.indexOf(',');
      if (commaIndex != -1) {
        try {
          final bytes = base64Decode(path.substring(commaIndex + 1));
          return Image.memory(
            bytes,
            fit: fit,
            width: width,
            height: height,
            alignment: alignment,
            errorBuilder: (context, _, __) => _buildFallback(context),
          );
        } catch (_) {}
      }
    }

    if (path.startsWith('http://') || path.startsWith('https://')) {
      return Image.network(
        path,
        fit: fit,
        width: width,
        height: height,
        alignment: alignment,
        errorBuilder: (context, _, __) => _buildFallback(context),
      );
    }

    final assetPath = _resolveAssetPath(path);
    return Image.asset(
      assetPath,
      fit: fit,
      width: width,
      height: height,
      alignment: alignment,
      errorBuilder: (context, _, __) => _buildFallback(context),
    );
  }

  String _resolveAssetPath(String rawPath) {
    if (rawPath.startsWith('assets/')) return rawPath;
    final filename = rawPath.split('/').last.split(r'\').last;
    if (filename.isNotEmpty &&
        (filename.endsWith('.jpg') ||
            filename.endsWith('.png') ||
            filename.endsWith('.webp'))) {
      return 'assets/images/learning/$filename';
    }
    if (fallbackCategory != null && fallbackCategory!.isNotEmpty) {
      return LearningModuleItem.resolveImageAsset('', fallbackCategory!);
    }
    return 'assets/images/learning/module_01_puberty.jpg';
  }

  Widget _buildFallback(BuildContext context) {
    if (fallbackCategory != null && fallbackCategory!.isNotEmpty) {
      final fallbackAsset =
          LearningModuleItem.resolveImageAsset('', fallbackCategory!);
      if (fallbackAsset != imagePath) {
        return Image.asset(
          fallbackAsset,
          fit: fit,
          width: width,
          height: height,
          alignment: alignment,
          errorBuilder: (ctx, _, __) => _buildIconPlaceholder(ctx),
        );
      }
    }
    return _buildIconPlaceholder(context);
  }

  Widget _buildIconPlaceholder(BuildContext context) {
    final glass = context.glassTheme;
    return Container(
      width: width,
      height: height,
      color: glass.isDark
          ? const Color(0xFF1E293B).withValues(alpha: 0.5)
          : const Color(0xFFE0F2FE),
      alignment: Alignment.center,
      child: Icon(
        Icons.menu_book_rounded,
        size: iconSize,
        color: glass.accentColor,
      ),
    );
  }
}
