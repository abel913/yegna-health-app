import 'package:flutter/widgets.dart';

import 'video_player_stub.dart' if (dart.library.html) 'video_player_web.dart'
    as video_impl;

/// Renders an in-app interactive video embed:
/// - On Web: uses an official YouTube iframe with autoplay, native controls, and fullscreen.
/// - On VM / non-web: uses high-contrast fallback player container.
Widget createInAppVideoEmbed({
  required String videoId,
  double? width,
  double? height,
}) =>
    video_impl.createInAppVideoEmbed(
      videoId: videoId,
      width: width,
      height: height,
    );
