import 'package:geolocator/geolocator.dart';

class StandortService {
  static Future<Position?> getStandort() async {
    bool serviceAktiv = await Geolocator.isLocationServiceEnabled();
    if (!serviceAktiv) return null;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}
