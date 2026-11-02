// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';

final Set<String> _registeredViewTypes = <String>{};

/// Web implementation using an embedded YouTube IFrame via HtmlElementView.
Widget createInAppVideoEmbed({
  required String videoId,
  double? width,
  double? height,
}) {
  final viewType = 'youtube-embed-$videoId';

  if (!_registeredViewTypes.contains(viewType)) {
    ui_web.platformViewRegistry.registerViewFactory(
      viewType,
      (int viewId) {
        final iframe = html.IFrameElement()
          ..src =
              'https://www.youtube.com/embed/$videoId?autoplay=1&rel=0&modestbranding=1&playsinline=1'
          ..style.border = 'none'
          ..style.width = '100%'
          ..style.height = '100%'
          ..style.borderRadius = '16px'
          ..allow =
              'accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share'
          ..allowFullscreen = true;
        return iframe;
      },
    );
    _registeredViewTypes.add(viewType);
  }

  return SizedBox(
    width: width ?? double.infinity,
    height: height ?? 220,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: HtmlElementView(viewType: viewType),
    ),
  );
}
