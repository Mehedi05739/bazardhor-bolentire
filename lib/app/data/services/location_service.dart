import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

/// Wraps device location access: checks that location services are enabled,
/// requests permission, and returns the current position.
///
/// Throws [LocationException] with a user-friendly message on any failure so
/// callers can surface it directly.
class LocationService extends GetxService {
  Future<Position> getCurrentPosition() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const LocationException(
        'Location services are turned off. Please enable them and retry.',
      );
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw const LocationException(
        'Location permission denied. Please allow access to find your zone.',
      );
    }
    if (permission == LocationPermission.deniedForever) {
      throw const LocationException(
        'Location permission permanently denied. Enable it from settings.',
      );
    }

    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
  }
}

class LocationException implements Exception {
  const LocationException(this.message);

  final String message;

  @override
  String toString() => 'LocationException: $message';
}
