import 'package:flutter/material.dart';

import 'map_floating_button.dart';

class MapControlsColumn extends StatelessWidget {
  const MapControlsColumn({
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onLocateMe,
    super.key,
  });

  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onLocateMe;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 16,
      right: 16,
      child: Column(
        children: [
          MapFloatingButton(
            icon: Icons.add_rounded,
            tooltip: 'Zoom in',
            onPressed: onZoomIn,
          ),
          const SizedBox(height: 8),
          MapFloatingButton(
            icon: Icons.remove_rounded,
            tooltip: 'Zoom out',
            onPressed: onZoomOut,
          ),
          const SizedBox(height: 8),
          MapFloatingButton(
            icon: Icons.my_location_rounded,
            tooltip: 'My location',
            onPressed: onLocateMe,
          ),
        ],
      ),
    );
  }
}
