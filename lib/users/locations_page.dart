import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parking_graduation_app_1/core/Providers/current_user_provider.dart';
import 'package:parking_graduation_app_1/core/models/location.dart';
import 'package:parking_graduation_app_1/core/services/geo_cordinates_service.dart';
import 'package:parking_graduation_app_1/core/services/locations_api_service.dart';
import 'package:parking_graduation_app_1/users/booking_page.dart';

class LocationsPage extends StatefulWidget {
  const LocationsPage({Key? key, this.onBookingSuccess}) : super(key: key);

  final onBookingSuccess;
  @override
  _LocationsPageState createState() => _LocationsPageState();
}

class _LocationsPageState extends State<LocationsPage>
    with AutomaticKeepAliveClientMixin<LocationsPage> {
  GoogleMapController? mapController;

  Set<Marker> markers = {};

  Location? selectedLocation;
  Position? currentPosition;
  double? distanceFromCurrentPosition;

  @override
  void initState() {
    super.initState();
    getCurrentPosition();
    getLocations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    GeoCordinatesService().deafultPosition.latitude,
                    GeoCordinatesService().deafultPosition.longitude,
                  ),
                  zoom: 15,
                ),
                onMapCreated: (c) {
                  mapController = c;
                },
                myLocationEnabled: true,
                markers: markers,
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.6,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.4 -
                    MediaQuery.of(context).padding.bottom,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.white,
                ),
                child: ListView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              const Icon(Icons.place),
                              Text(getMessage())
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              const Icon(Icons.car_rental),
                              Text(
                                  '${distanceFromCurrentPosition?.toString() ?? ''} km')
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 25),
                    _BookingButton(
                      onPressed: selectedLocation != null &&
                              CurrentUserProvider().user.currentReservationId ==
                                  null
                          ? () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => BookingPage(
                                    location: selectedLocation!,
                                    onBookingSuccess: widget.onBookingSuccess,
                                  ),
                                ),
                              );
                            }
                          : null,
                    ),
                    const SizedBox(height: 25),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void getCurrentPosition() async {
    currentPosition = await GeoCordinatesService().getLocation();

    while (mapController == null) {
      await Future.delayed(const Duration(milliseconds: 300));
    }

    if (currentPosition != null) {
      mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              currentPosition?.latitude ?? 0,
              currentPosition?.longitude ?? 0,
            ),
            zoom: 15,
          ),
        ),
      );
    }
  }

  void getLocations() async {
    var locationsStream = LocationsApiService().getLocationsStream();
    locationsStream.listen((locations) {
      selectedLocation = null;
      markers.clear();
      for (var location in locations.where((l) => !l.isReserved())) {
        markers.add(Marker(
          markerId: MarkerId(location.id ?? ''),
          position: LatLng(location.lat ?? 0, location.long ?? 0),
          onTap: () async {
            while (currentPosition == null) {
              await Future.delayed(const Duration(milliseconds: 300));
            }
            distanceFromCurrentPosition =
                await GeoCordinatesService().getDistanceBetween(
              currentPosition?.latitude ?? 0,
              currentPosition?.longitude ?? 0,
              location.lat ?? 0,
              location.long ?? 0,
            );
            setState(() {
              selectedLocation = location;
            });
          },
        ));
      }
      if (this.mounted) {
        setState(() {});
      }
    });
  }

  String getMessage() {
    var user = CurrentUserProvider().user;
    if (user.currentReservationId != null) {
      return 'لا يمكنك الحجز قبل انتهاء الحجز الحالي';
    }

    if (selectedLocation == null) return 'اضغط لاختيار موقع';

    return selectedLocation!.name ?? "---";
  }

  @override
  bool get wantKeepAlive => true;
}

class _BookingButton extends StatelessWidget {
  const _BookingButton({Key? key, this.onPressed}) : super(key: key);

  final onPressed;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 50,
        width: 160,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: const Color(0xFF61A4F1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: onPressed,
          child: const Text(
            'حجز',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
