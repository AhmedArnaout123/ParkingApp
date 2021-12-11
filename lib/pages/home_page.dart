import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parking_graduation_app_1/core/services/geo_locator_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GoogleMapController? mapController;
  CollectionReference? locations;
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    GeoLocatorService().getLocation().then((Position position) async {
      while (mapController == null) {
        await Future.delayed(const Duration(seconds: 1));
      }
      mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 15,
          ),
        ),
      );
    });
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
                initialCameraPosition: const CameraPosition(
                    target: LatLng(36.202105, 37.134260), zoom: 15),
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
                            children: const [
                              Icon(Icons.place),
                              Text('Al-Jamiliah - Iskandaron Street'),
                              Text('No:12')
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: const [
                              Icon(Icons.car_rental),
                              Text('3km')
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
                            locations = FirebaseFirestore.instance
                                .collection('locations');
                            locations?.get().then((value) {
                              for (var doc in value.docs) {
                                var data = doc.data()! as Map<String, dynamic>;
                                print(data);
                                markers.add(Marker(
                                  markerId: MarkerId('${data['number']}'),
                                  position: LatLng(data['lat'], data['long']),
                                ));
                              }
                              setState(() {});
                            });
                            // FirebaseFirestore.instance
                            //     .collection('locations')
                            //     .add({
                            //   'number': 2,
                            //   'address': 'Salah Al-deen',
                            //   'lat': 36.1866124,
                            //   'long': 37.124222
                            // });
                          },
                          child: const Text(
                            'Select',
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
}
