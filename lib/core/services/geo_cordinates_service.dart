import 'package:geolocator/geolocator.dart';

class GeoCordinatesService {
  Future<Position> getLocation() async {
    print(await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    ));
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Position get deafultPosition {
    return Position(
      latitude: 36.216667,
      longitude: 37.166668,
      timestamp: DateTime.now(),
      accuracy: 0.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
    );
  }

  bool isDefaultPosition(Position p) {
    return p.latitude == 36.216667 && p.longitude == 37.166668;
  }

  Future<double> getDistanceBetween(double startLatitude, double startLongitude,
      double endLatitude, double endLongitude,
      [int fractionDigits = 2]) async {
    var d = Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
    d = double.parse(d.toStringAsFixed(fractionDigits));
    return d;
  }
}