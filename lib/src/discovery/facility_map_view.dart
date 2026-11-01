import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import 'facility_detail_sheet.dart';
import 'facility_model.dart';

class FacilityMapView extends StatefulWidget {
  const FacilityMapView({
    required this.facilities,
    super.key,
  });

  final List<Facility> facilities;

  @override
  State<FacilityMapView> createState() => _FacilityMapViewState();
}

class _FacilityMapViewState extends State<FacilityMapView> {
  Facility? _selectedFacility;
  double _zoomLevel = 1.0;

  @override
  void initState() {
    super.initState();
    if (widget.facilities.isNotEmpty) {
      _selectedFacility = widget.facilities.first;
    }
  }

  @override
  void didUpdateWidget(FacilityMapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.facilities.isNotEmpty &&
        (_selectedFacility == null ||
            !widget.facilities.contains(_selectedFacility))) {
      _selectedFacility = widget.facilities.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isAmharic = Localizations.localeOf(context).languageCode == 'am';

    return Stack(
      children: [
        // Map Canvas Area
        ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFFE2E8F0),
            ),
            child: CustomPaint(
              painter: _MapCanvasPainter(
                facilities: widget.facilities,
                selectedFacility: _selectedFacility,
                zoomLevel: _zoomLevel,
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final w = constraints.maxWidth;
                  final h = constraints.maxHeight;

                  return Stack(
                    children: [
                      // Interactive Pin Buttons
                      for (var i = 0; i < widget.facilities.length; i++) ...[
                        _buildPin(
                          facility: widget.facilities[i],
                          index: i,
                          total: widget.facilities.length,
                          width: w,
                          height: h,
                        ),
                      ],
                    ],
                  );
                },
              ),
            ),
          ),
        ),

        // Map Control Buttons (Zoom in, Zoom out, Locate Me)
        Positioned(
          top: 16,
          right: 16,
          child: Column(
            children: [
              _MapFloatingButton(
                icon: Icons.add_rounded,
                onPressed: () {
                  setState(() {
                    _zoomLevel = (_zoomLevel + 0.2).clamp(0.8, 2.0);
                  });
                },
              ),
              const SizedBox(height: 8),
              _MapFloatingButton(
                icon: Icons.remove_rounded,
                onPressed: () {
                  setState(() {
                    _zoomLevel = (_zoomLevel - 0.2).clamp(0.8, 2.0);
                  });
                },
              ),
              const SizedBox(height: 8),
              _MapFloatingButton(
                icon: Icons.my_location_rounded,
                onPressed: () {
                  if (widget.facilities.isNotEmpty) {
                    setState(() {
                      _selectedFacility = widget.facilities.first;
                      _zoomLevel = 1.0;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(isAmharic
                            ? 'በአቅራቢያዎ ያሉ የጤና ተቋማት ተገኝተዋል'
                            : 'Showing facilities closest to your location'),
                        backgroundColor: const Color(0xFF0284C7),
                        duration: const Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),

        // Bottom Selected Facility Preview Card
        if (_selectedFacility != null)
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: _FacilityPreviewCard(
              facility: _selectedFacility!,
              isAmharic: isAmharic,
              l10n: l10n,
            ),
          ),
      ],
    );
  }

  Widget _buildPin({
    required Facility facility,
    required int index,
    required int total,
    required double width,
    required double height,
  }) {
    // Generate harmonious aesthetic map positions across the canvas
    final positions = [
      Offset(width * 0.46, height * 0.42), // Arada (Center)
      Offset(width * 0.58, height * 0.26), // AAU Sidist Kilo (North-East)
      Offset(width * 0.42, height * 0.62), // Kirkos (South-Central)
      Offset(width * 0.76, height * 0.54), // Bole 17 (East)
      Offset(width * 0.32, height * 0.82), // AASTU (Far South)
    ];

    final basePos = index < positions.length
        ? positions[index]
        : Offset(width * 0.5, height * 0.5);
    final isSelected = _selectedFacility?.id == facility.id;

    return Positioned(
      left: basePos.dx - 22,
      top: basePos.dy - 44,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedFacility = facility;
          });
        },
        child: AnimatedScale(
          scale: isSelected ? 1.25 : 1.0,
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutBack,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF0284C7)
                      : const Color(0xFF0284C7).withValues(alpha: 0.85),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: isSelected
                          ? const Color(0x660284C7)
                          : const Color(0x33000000),
                      blurRadius: isSelected ? 12 : 6,
                      spreadRadius: isSelected ? 3 : 0,
                    ),
                  ],
                  border: Border.all(
                    color: Colors.white,
                    width: 2.2,
                  ),
                ),
                child: Icon(
                  facility.type == FacilityType.campusClinic
                      ? Icons.school_rounded
                      : Icons.local_hospital_rounded,
                  color: Colors.white,
                  size: isSelected ? 20 : 16,
                ),
              ),
              Container(
                width: 3,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF0284C7),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(2),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FacilityPreviewCard extends StatelessWidget {
  const _FacilityPreviewCard({
    required this.facility,
    required this.isAmharic,
    required this.l10n,
  });

  final Facility facility;
  final bool isAmharic;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color(0x240284C7),
              blurRadius: 20,
              offset: Offset(0, 6),
            ),
          ],
          border: Border.all(
            color: const Color(0xFFBAE6FD),
            width: 1.4,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        facility.localizedName(isAmharic),
                        style: const TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 15.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF08264A),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        facility.localizedSubCity(isAmharic),
                        style: const TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 12,
                          color: Color(0xFF64748B),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F9FF),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFBAE6FD)),
                  ),
                  child: Text(
                    l10n.distanceKm(facility.distanceKm.toStringAsFixed(1)),
                    style: const TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0284C7),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () =>
                        FacilityDetailSheet.show(context, facility),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFBAE6FD)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    child: Text(
                      l10n.viewDetailsAction,
                      style: const TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0284C7),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog<void>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          title: Text(l10n.directionsAction),
                          content: Text(
                            '${facility.localizedName(isAmharic)}\n\n'
                            '${facility.localizedAddress(isAmharic)}\n'
                            '${l10n.landmarkLabel}: ${facility.localizedLandmark(isAmharic)}',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0284C7),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    child: Text(
                      l10n.directionsAction,
                      style: const TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}

class _MapFloatingButton extends StatelessWidget {
  const _MapFloatingButton({
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: IconButton(
          icon: Icon(icon, color: const Color(0xFF0284C7), size: 20),
          onPressed: onPressed,
          constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
          padding: EdgeInsets.zero,
        ),
      );
}

class _MapCanvasPainter extends CustomPainter {
  const _MapCanvasPainter({
    required this.facilities,
    required this.selectedFacility,
    required this.zoomLevel,
  });

  final List<Facility> facilities;
  final Facility? selectedFacility;
  final double zoomLevel;

  @override
  void paint(Canvas canvas, Size size) {
    // Map Background
    final bgPaint = Paint()..color = const Color(0xFFE0F2FE);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Park / Green zones
    final greenPaint = Paint()..color = const Color(0xFFD1FAE5);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.1, size.height * 0.15, size.width * 0.28,
            size.height * 0.22),
        const Radius.circular(30),
      ),
      greenPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.65, size.height * 0.65, size.width * 0.25,
            size.height * 0.2),
        const Radius.circular(25),
      ),
      greenPaint,
    );

    // Major Arterial Roads
    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 12 * zoomLevel
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final secondaryRoadPaint = Paint()
      ..color = const Color(0xFFF1F5F9)
      ..strokeWidth = 6 * zoomLevel
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Churchill Road & Main Highway (Vertical artery)
    final mainPath = Path()
      ..moveTo(size.width * 0.5, 0)
      ..cubicTo(size.width * 0.48, size.height * 0.35, size.width * 0.52,
          size.height * 0.65, size.width * 0.38, size.height);
    canvas.drawPath(mainPath, roadPaint);

    // Bole Road (Diagonal artery)
    final bolePath = Path()
      ..moveTo(size.width * 0.46, size.height * 0.5)
      ..lineTo(size.width, size.height * 0.7);
    canvas.drawPath(bolePath, roadPaint);

    // Ring Road / Cross streets
    final ringPath = Path()
      ..moveTo(0, size.height * 0.3)
      ..cubicTo(size.width * 0.35, size.height * 0.28, size.width * 0.7,
          size.height * 0.38, size.width, size.height * 0.32);
    canvas.drawPath(ringPath, secondaryRoadPaint);

    final southCross = Path()
      ..moveTo(0, size.height * 0.72)
      ..lineTo(size.width, size.height * 0.75);
    canvas.drawPath(southCross, secondaryRoadPaint);
  }

  @override
  bool shouldRepaint(covariant _MapCanvasPainter oldDelegate) =>
      oldDelegate.zoomLevel != zoomLevel ||
      oldDelegate.selectedFacility != selectedFacility ||
      oldDelegate.facilities != facilities;
}
