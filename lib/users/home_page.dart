import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parking_graduation_app_1/core/models/location.dart';
import 'package:parking_graduation_app_1/core/services/geo_cordinates_service.dart';
import 'package:parking_graduation_app_1/core/services/locations_api_service.dart';
import 'package:parking_graduation_app_1/users/booking_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GoogleMapController? mapController;

  List<Location> availableLocations = [];
  Set<Marker> markers = {};

  var locationsApiService = LocationsApiService();
  var geoCordinatesService = GeoCordinatesService();

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
                    geoCordinatesService.deafultPosition.latitude,
                    geoCordinatesService.deafultPosition.longitude,
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
                              Text(
                                  selectedLocation?.name ?? 'اضغط لاختيار موقع')
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              const Icon(Icons.car_rental),
                              Text(
                                  distanceFromCurrentPosition?.toString() ?? '')
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 25),
                    Center(
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
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => BookingPage()),
                            );
                            // locations = FirebaseFirestore.instance
                            //     .collection('locations');
                            // locations?.get().then((value) {
                            //   for (var doc in value.docs) {
                            //     var data = doc.data()! as Map<String, dynamic>;
                            //     print(data);
                            //     markers.add(Marker(
                            //       markerId: MarkerId('${data['number']}'),
                            //       position: LatLng(data['lat'], data['long']),
                            //     ));
                            //   }
                            //   setState(() {});
                            // });
                          },
                          child: const Text(
                            'اختيار',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  void getCurrentPosition() async {
    currentPosition = await geoCordinatesService.getLocation();

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
    availableLocations = await locationsApiService.getAvailableLocations();
    for (var location in availableLocations) {
      markers.add(Marker(
        markerId: MarkerId(location.id ?? ''),
        position: LatLng(location.lat ?? 0, location.long ?? 0),
        onTap: () async {
          while (currentPosition == null) {
            await Future.delayed(const Duration(milliseconds: 300));
          }
          distanceFromCurrentPosition =
              await geoCordinatesService.getDistanceBetween(
            currentPosition?.latitude ?? 0,
            currentPosition?.longitude ?? 0,
            location.lat ?? 0,
            location.long ?? 0,
          );
          print(distanceFromCurrentPosition);
          distanceFromCurrentPosition =
              distanceFromCurrentPosition ?? 0 / 1000.0;
          print(distanceFromCurrentPosition ?? 0 / 1000.0);
          setState(() {
            selectedLocation = location;
          });
        },
      ));
    }
    setState(() {});
  }
}
