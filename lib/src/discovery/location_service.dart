import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart' hide Path;

abstract class LocationService {
  Future<LatLng?> getCurrentLocation();
  Future<bool> requestPermission();
  double calculateDistanceKm(LatLng from, LatLng to);
}

class GeolocatorLocationService implements LocationService {
  const GeolocatorLocationService();

  static const Distance _distance = Distance();

  @override
  Future<LatLng?> getCurrentLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return null;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return null;
      }

      // Try current position with timeout, fallback to last known
      try {
        final position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.medium,
            timeLimit: Duration(seconds: 6),
          ),
        );
        return LatLng(position.latitude, position.longitude);
      } catch (e) {
        debugPrint(
            'Geolocator getCurrentPosition failed, trying last known: $e');
        final lastKnown = await Geolocator.getLastKnownPosition();
        if (lastKnown != null) {
          return LatLng(lastKnown.latitude, lastKnown.longitude);
        }
        return null;
      }
    } catch (e) {
      debugPrint('LocationService getCurrentLocation error: $e');
      return null;
    }
  }

  @override
  Future<bool> requestPermission() async {
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      return permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always;
    } catch (e) {
      debugPrint('LocationService requestPermission error: $e');
      return false;
    }
  }

  @override
  double calculateDistanceKm(LatLng from, LatLng to) =>
      _distance.as(LengthUnit.Meter, from, to) / 1000.0;
}

class FakeLocationService implements LocationService {
  const FakeLocationService({this.fixedLocation});

  final LatLng? fixedLocation;
  static const Distance _distance = Distance();

  @override
  Future<LatLng?> getCurrentLocation() async => fixedLocation;

  @override
  Future<bool> requestPermission() async => fixedLocation != null;

  @override
  double calculateDistanceKm(LatLng from, LatLng to) =>
      _distance.as(LengthUnit.Meter, from, to) / 1000.0;
}
