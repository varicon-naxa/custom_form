import 'package:geolocator/geolocator.dart';


class LocationsRepository {
  const LocationsRepository();

  Future<Position> getCurrentLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) throw const LocationServiceDisabledException();

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw LocationPermissionDeniedException();
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw LocationPermissionDeniedForeverException();
    }

    final position = await Geolocator.getCurrentPosition();

    return position;
  }
}

class LocationPermissionDeniedForeverException implements Exception {
  @override
  String toString() {
    return 'Access to location has been permanently denied. '
        'To change your decision, modify your device settings';
  }
}

class LocationPermissionDeniedException implements Exception {
  @override
  String toString() {
    return 'Location access has not been authorized.';
  }
}
