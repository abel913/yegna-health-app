// ignore_for_file: depend_on_referenced_packages, avoid_print
import 'dart:io';
import 'dart:math';
import 'package:image/image.dart' as img;

void main() {
  final bytes = File('C:/Users/natna/.gemini/antigravity/brain/98acf4d0-4055-449f-b886-7bae9105e3e3/.user_uploaded/media_1793788926694_c3de9a54.jpg').readAsBytesSync();
  final source = img.decodeJpg(bytes)!;

  // 1. Crop region [150..885, 195..845]
  const cropX = 150;
  const cropY = 195;
  const cropW = 885 - cropX + 1; // 736
  const cropH = 845 - cropY + 1; // 651

  final cropped = img.copyCrop(source, x: cropX, y: cropY, width: cropW, height: cropH);

  // 2. Scale proportionally
  const double scale = 0.70;
  final targetW = (cropW * scale).round(); // 515
  final targetH = (cropH * scale).round(); // 456

  final scaled = img.copyResize(
    cropped,
    width: targetW,
    height: targetH,
    interpolation: img.Interpolation.cubic,
  );

  // 3. Create 1024x1024 canvas with solid white (#FFFFFF)
  final canvas = img.Image(width: 1024, height: 1024);
  img.fill(canvas, color: img.ColorRgba8(255, 255, 255, 255));

  final posX = ((1024 - targetW) / 2).round();
  final posY = ((1024 - targetH) / 2).round();

  // Create foreground canvas with transparency
  final foreground = img.Image(width: 1024, height: 1024, numChannels: 4);
  img.fill(foreground, color: img.ColorRgba8(255, 255, 255, 0));

  for (int y = 0; y < scaled.height; y++) {
    for (int x = 0; x < scaled.width; x++) {
      final p = scaled.getPixel(x, y);
      final r = p.r.toInt();
      final g = p.g.toInt();
      final b = p.b.toInt();

      final maxDiff = max(255 - r, max(255 - g, 255 - b));
      if (maxDiff > 12) {
        // Smooth alpha feathering at edge
        final alpha = (maxDiff >= 28) ? 255 : (((maxDiff - 12) * 255) / 16).round().clamp(0, 255);

        // Put onto solid white canvas (for iOS and standard launcher)
        canvas.setPixel(posX + x, posY + y, img.ColorRgba8(r, g, b, 255));

        // Put onto foreground (for Android adaptive icons)
        foreground.setPixel(posX + x, posY + y, img.ColorRgba8(r, g, b, alpha));
      }
    }
  }

  // Ensure assets/icon directory exists
  final iconDir = Directory('assets/icon');
  if (!iconDir.existsSync()) {
    iconDir.createSync(recursive: true);
  }

  // 4. Save assets/icon/app_icon.png
  final appIconFile = File('assets/icon/app_icon.png');
  appIconFile.writeAsBytesSync(img.encodePng(canvas));
  print('Saved: ${appIconFile.path} (${appIconFile.lengthSync()} bytes)');

  // 5. Save assets/icon/app_icon_foreground.png
  final fgFile = File('assets/icon/app_icon_foreground.png');
  fgFile.writeAsBytesSync(img.encodePng(foreground));
  print('Saved: ${fgFile.path} (${fgFile.lengthSync()} bytes)');

  // 6. Test circular mask safe zone:
  // Android adaptive icon safe zone is central 66.6% circle (radius = 341 from center 512, 512)
  int clippedCount = 0;
  double maxDistance = 0;
  for (int y = 0; y < 1024; y++) {
    for (int x = 0; x < 1024; x++) {
      final p = foreground.getPixel(x, y);
      if (p.a > 10) {
        final dist = sqrt(pow(x - 512, 2) + pow(y - 512, 2));
        if (dist > maxDistance) {
          maxDistance = dist;
        }
        if (dist > 341) {
          clippedCount++;
        }
      }
    }
  }
  print('Max distance from center for any logo pixel: $maxDistance px (Safe circle radius is 341 px)');
  print('Pixels outside 66% circle safe zone: $clippedCount');
}
