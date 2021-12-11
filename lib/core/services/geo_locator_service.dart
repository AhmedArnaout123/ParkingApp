import 'package:geolocator/geolocator.dart';

class GeoLocatorService {
  GeoLocatorService();

  Future<Position> getLocation() async {
    print(await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    ));
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Position get initialPosition {
    return Position(
      latitude: 0,
      longitude: 0,
      timestamp: DateTime.now(),
      accuracy: 0.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
    );
  }

  bool isInitialPostion(Position p) {
    return p.latitude == 0 && p.longitude == 0;
  }

  Future<double> getDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) async {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }
}
