import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parking_graduation_app_1/core/services/geo_locator_service.dart';
import 'package:provider/provider.dart';

class MapPage extends StatelessWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Position currentPosition = Provider.of<Position>(context);
    return SafeArea(
      child: Scaffold(
        body: !GeoLocatorService().isInitialPostion(currentPosition)
            ? Stack(
                children: [
                  FutureBuilder(
                    builder: (context, snapshot) {
                      return GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                            currentPosition.latitude,
                            currentPosition.longitude,
                          ),
                          zoom: 17.0,
                        ),
                        zoomGesturesEnabled: true,
                      );
                    },
                  ),
                ],
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
