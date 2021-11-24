import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:parking_graduation_app_1/pages/booking_page.dart';
import 'package:parking_graduation_app_1/pages/home_page.dart';
import 'package:parking_graduation_app_1/pages/login_page.dart';
import 'package:parking_graduation_app_1/pages/map_page.dart';
import 'package:parking_graduation_app_1/services/geo_locator_service.dart';
import 'package:parking_graduation_app_1/services/storage_service.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ParkingApp());
}

class ParkingApp extends StatelessWidget {
  ParkingApp({Key? key}) : super(key: key);

  final _locatorService = GeoLocatorService();
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureProvider<Position>(
      initialData: _locatorService.initialPosition,
      create: (context) => _locatorService.getLocation(),
      child: MaterialApp(
        title: 'Parking App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const AppInitializer(),
      ),
    );
  }
}

class AppInitializer extends StatefulWidget {
  const AppInitializer({Key? key}) : super(key: key);

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  bool initializerSucceeded = false;
  bool initializerFailed = false;
  String? token;
  @override
  void initState() {
    super.initState();
    Firebase.initializeApp()
        .then((_) async {
          token = await StorageService().read('token');
        })
        .then((_) => {
              setState(() {
                initializerSucceeded = true;
              })
            })
        .catchError((e) {
          setState(() {
            initializerFailed = true;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    if (initializerSucceeded) {
      return BookingPage();
      // if (token != null)
      //   return HomePage();
      // else
      //   return LoginPage();
    }
    if (initializerFailed) {
      return _InitializtionError();
    }
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

class _InitializtionError extends StatelessWidget {
  const _InitializtionError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Firebase Initialization Error',
          style: TextStyle(color: Colors.red, fontSize: 14),
        ),
      ),
    );
  }
}
