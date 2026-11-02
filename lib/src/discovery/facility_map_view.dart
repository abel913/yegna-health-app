import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' hide Path;
import 'package:url_launcher/url_launcher.dart';

import '../../l10n/app_localizations.dart';
import 'facility_detail_sheet.dart';
import 'facility_model.dart';

class FacilityMapView extends StatefulWidget {
  const FacilityMapView({
    required this.facilities,
    this.userLocation,
    this.onLocateMeRequested,
    this.tileProvider,
    this.mapController,
    super.key,
  });

  final List<Facility> facilities;
  final LatLng? userLocation;
  final Future<LatLng?> Function()? onLocateMeRequested;
  final TileProvider? tileProvider;
  final MapController? mapController;

  @override
  State<FacilityMapView> createState() => _FacilityMapViewState();
}

class _FacilityMapViewState extends State<FacilityMapView> {
  late final MapController _mapController;
  Facility? _selectedFacility;

  static const LatLng _centralAddisAbaba = LatLng(9.0222, 38.7468);

  @override
  void initState() {
    super.initState();
    _mapController = widget.mapController ?? MapController();
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
    if (widget.userLocation != null &&
        widget.userLocation != oldWidget.userLocation) {
      _mapController.move(widget.userLocation!, _mapController.camera.zoom);
    }
  }

  void _onFacilitySelected(Facility facility) {
    setState(() {
      _selectedFacility = facility;
    });
    _mapController.move(
      LatLng(facility.latitude, facility.longitude),
      14.5,
    );
  }

  void _zoomIn() {
    final currentZoom = _mapController.camera.zoom;
    final nextZoom = (currentZoom + 1.0).clamp(9.0, 18.0);
    _mapController.move(_mapController.camera.center, nextZoom);
  }

  void _zoomOut() {
    final currentZoom = _mapController.camera.zoom;
    final nextZoom = (currentZoom - 1.0).clamp(9.0, 18.0);
    _mapController.move(_mapController.camera.center, nextZoom);
  }

  Future<void> _locateMe(BuildContext context, bool isAmharic) async {
    LatLng? target = widget.userLocation;
    if (target == null && widget.onLocateMeRequested != null) {
      target = await widget.onLocateMeRequested!();
    }

    if (target != null) {
      _mapController.move(target, 15.0);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isAmharic
                ? 'የእርስዎ ወቅታዊ መገኛ ተገኝቷል'
                : 'Centered on your current location'),
            backgroundColor: const Color(0xFF0284C7),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
      return;
    }

    if (widget.facilities.isEmpty) return;
    final targetFacility = widget.facilities.first;
    _onFacilitySelected(targetFacility);
    if (context.mounted) {
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
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isAmharic = Localizations.localeOf(context).languageCode == 'am';

    final initialCenter = _selectedFacility != null
        ? LatLng(_selectedFacility!.latitude, _selectedFacility!.longitude)
        : (widget.facilities.isNotEmpty
            ? LatLng(widget.facilities.first.latitude,
                widget.facilities.first.longitude)
            : _centralAddisAbaba);

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        children: [
          // Real OpenStreetMap View
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: initialCenter,
              initialZoom: 13.0,
              minZoom: 8.5,
              maxZoom: 18.5,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.yegnahealth.amharic',
                tileProvider: widget.tileProvider,
                maxZoom: 19,
              ),
              MarkerLayer(
                markers: [
                  if (widget.userLocation != null)
                    Marker(
                      point: widget.userLocation!,
                      width: 44,
                      height: 44,
                      alignment: Alignment.center,
                      child: const _UserLocationMarker(
                        key: ValueKey('user_location_marker'),
                      ),
                    ),
                  for (final facility in widget.facilities)
                    Marker(
                      point: LatLng(facility.latitude, facility.longitude),
                      width: 52,
                      height: 56,
                      alignment: Alignment.topCenter,
                      child: _buildPin(facility),
                    ),
                ],
              ),
            ],
          ),

          // Top Vignette gradient for clean contrast
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 48,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.12),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Map Control Floating Buttons (Zoom In, Zoom Out, Locate)
          Positioned(
            top: 16,
            right: 16,
            child: Column(
              children: [
                _MapFloatingButton(
                  icon: Icons.add_rounded,
                  tooltip: 'Zoom in',
                  onPressed: _zoomIn,
                ),
                const SizedBox(height: 8),
                _MapFloatingButton(
                  icon: Icons.remove_rounded,
                  tooltip: 'Zoom out',
                  onPressed: _zoomOut,
                ),
                const SizedBox(height: 8),
                _MapFloatingButton(
                  icon: Icons.my_location_rounded,
                  tooltip: 'My location',
                  onPressed: () => _locateMe(context, isAmharic),
                ),
              ],
            ),
          ),

          // Bottom Selected Facility Preview Card
          if (_selectedFacility != null)
            Positioned(
              left: 14,
              right: 14,
              bottom: 14,
              child: _FacilityPreviewCard(
                facility: _selectedFacility!,
                isAmharic: isAmharic,
                l10n: l10n,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPin(Facility facility) {
    final isSelected = _selectedFacility?.id == facility.id;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _onFacilitySelected(facility),
      child: AnimatedScale(
        scale: isSelected ? 1.22 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutBack,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isSelected
                      ? const [Color(0xFF0284C7), Color(0xFF0369A1)]
                      : (facility.type == FacilityType.campusClinic
                          ? const [Color(0xFF4F46E5), Color(0xFF4338CA)]
                          : const [Color(0xFF0284C7), Color(0xFF0EA5E9)]),
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: isSelected ? 2.6 : 2.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isSelected
                        ? const Color(0x770284C7)
                        : const Color(0x40000000),
                    blurRadius: isSelected ? 12 : 6,
                    spreadRadius: isSelected ? 2 : 0,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(
                facility.type == FacilityType.campusClinic
                    ? Icons.school_rounded
                    : Icons.local_hospital_rounded,
                color: Colors.white,
                size: 19,
              ),
            ),
            CustomPaint(
              size: const Size(10, 6),
              painter: _PinTipPainter(
                color: isSelected
                    ? const Color(0xFF0369A1)
                    : (facility.type == FacilityType.campusClinic
                        ? const Color(0xFF4338CA)
                        : const Color(0xFF0284C7)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PinTipPainter extends CustomPainter {
  const _PinTipPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _PinTipPainter oldDelegate) =>
      oldDelegate.color != color;
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

  Future<void> _launchDirections(BuildContext context) async {
    final lat = facility.latitude;
    final lng = facility.longitude;
    final name = Uri.encodeComponent(facility.localizedName(isAmharic));

    final geoUri = Uri.parse('geo:$lat,$lng?q=$lat,$lng($name)');
    final webUri = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng');

    try {
      if (await canLaunchUrl(geoUri)) {
        await launchUrl(geoUri, mode: LaunchMode.externalApplication);
        return;
      }
    } catch (_) {}

    try {
      if (await canLaunchUrl(webUri)) {
        await launchUrl(webUri, mode: LaunchMode.externalApplication);
        return;
      }
    } catch (_) {}

    if (context.mounted) {
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(facility.localizedName(isAmharic)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(facility.localizedAddress(isAmharic)),
              const SizedBox(height: 8),
              Text(
                '${l10n.landmarkLabel}: ${facility.localizedLandmark(isAmharic)}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text('GPS: $lat, $lng',
                  style:
                      const TextStyle(fontFamily: 'monospace', fontSize: 12)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.96),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color(0x2E0284C7),
              blurRadius: 22,
              offset: Offset(0, 8),
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
                          fontSize: 15,
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
                  child: ElevatedButton.icon(
                    onPressed: () => _launchDirections(context),
                    icon: const Icon(Icons.navigation_rounded,
                        size: 14, color: Colors.white),
                    label: Text(
                      l10n.directionsAction,
                      style: const TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0284C7),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
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
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final button = Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Color(0x1F000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: const Color(0xFF0284C7), size: 20),
        onPressed: onPressed,
        constraints: const BoxConstraints(minWidth: 42, minHeight: 42),
        padding: EdgeInsets.zero,
      ),
    );

    if (tooltip != null) {
      return Tooltip(message: tooltip!, child: button);
    }
    return button;
  }
}

class _UserLocationMarker extends StatefulWidget {
  const _UserLocationMarker({super.key});

  @override
  State<_UserLocationMarker> createState() => _UserLocationMarkerState();
}

class _UserLocationMarkerState extends State<_UserLocationMarker>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final scale = 1.0 + (_controller.value * 0.45);
        final opacity = (1.0 - _controller.value).clamp(0.0, 0.65);
        return Stack(
          alignment: Alignment.center,
          children: [
            Transform.scale(
              scale: scale,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF0284C7).withValues(alpha: opacity),
                ),
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0284C7).withValues(alpha: 0.35),
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
            Container(
              width: 14,
              height: 14,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF0284C7),
              ),
            ),
          ],
        );
      },
    );
  }
}
