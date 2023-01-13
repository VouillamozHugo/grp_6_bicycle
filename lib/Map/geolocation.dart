import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class geolocation {
  static const String _LocationServiceDisable =
      'Location services are disabled';
  static const String _LocationPermissionDenied = 'Permission denied';
  static const String _LocationPermissionGranted = 'Permission granted';

  final GeolocatorPlatform _geolocatorPlateform = GeolocatorPlatform.instance;

  Future _getCurrentPosition() async {
    bool serviceEnabled;

    serviceEnabled = await _geolocatorPlateform.isLocationServiceEnabled();
    if (serviceEnabled) {
      final position = await _geolocatorPlateform.getCurrentPosition();
      return LatLng(position.latitude, position.longitude);
    }
  }
}
