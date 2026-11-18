import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' hide Path;

import '../../../../l10n/app_localizations.dart';
import '../models/facility.dart';
import 'map_controls_column.dart';
import 'map_facility_pin.dart';
import 'map_facility_preview_card.dart';
import 'map_user_location_marker.dart';

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
    setState(() => _selectedFacility = facility);
    _mapController.move(LatLng(facility.latitude, facility.longitude), 14.5);
  }

  void _zoomIn() {
    final nextZoom = (_mapController.camera.zoom + 1.0).clamp(9.0, 18.0);
    _mapController.move(_mapController.camera.center, nextZoom);
  }

  void _zoomOut() {
    final nextZoom = (_mapController.camera.zoom - 1.0).clamp(9.0, 18.0);
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
        _showMapSnackBar(context, isAmharic ? 'የእርስዎ ወቅታዊ መገኛ ተገኝቷል' : 'Centered on your current location');
      }
      return;
    }

    if (widget.facilities.isEmpty) return;
    _onFacilitySelected(widget.facilities.first);
    if (context.mounted) {
      _showMapSnackBar(context, isAmharic ? 'በአቅራቢያዎ ያሉ የጤና ተቋማት ተገኝተዋል' : 'Showing facilities closest to your location');
    }
  }

  void _showMapSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF0284C7),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  LatLng _getInitialCenter() {
    if (_selectedFacility != null) {
      return LatLng(_selectedFacility!.latitude, _selectedFacility!.longitude);
    }
    if (widget.facilities.isNotEmpty) {
      return LatLng(widget.facilities.first.latitude, widget.facilities.first.longitude);
    }
    return _centralAddisAbaba;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isAmharic = Localizations.localeOf(context).languageCode == 'am';

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _getInitialCenter(),
              initialZoom: 13.0,
              minZoom: 8.5,
              maxZoom: 18.5,
              interactionOptions: const InteractionOptions(flags: InteractiveFlag.all),
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
                      child: const UserLocationMarker(key: ValueKey('user_location_marker')),
                    ),
                  for (final facility in widget.facilities)
                    Marker(
                      point: LatLng(facility.latitude, facility.longitude),
                      width: 52,
                      height: 56,
                      alignment: Alignment.topCenter,
                      child: FacilityMapPin(
                        facility: facility,
                        isSelected: _selectedFacility?.id == facility.id,
                        onTap: () => _onFacilitySelected(facility),
                      ),
                    ),
                ],
              ),
            ],
          ),
          MapControlsColumn(
            onZoomIn: _zoomIn,
            onZoomOut: _zoomOut,
            onLocateMe: () => _locateMe(context, isAmharic),
          ),
          if (_selectedFacility != null)
            Positioned(
              left: 14,
              right: 14,
              bottom: 14,
              child: FacilityPreviewCard(
                facility: _selectedFacility!,
                isAmharic: isAmharic,
                l10n: l10n,
              ),
            ),
        ],
      ),
    );
  }
}
