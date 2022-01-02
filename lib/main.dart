import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:parking_graduation_app_1/admin/pages/add_new_location.dart';
import 'package:parking_graduation_app_1/admin/pages/add_new_user.dart';
import 'package:parking_graduation_app_1/admin/pages/view_locations.dart';
import 'package:parking_graduation_app_1/core/services/current_application_user_service.dart';
import 'package:parking_graduation_app_1/users/booking_page.dart';
import 'package:parking_graduation_app_1/users/home_page.dart';
import 'package:parking_graduation_app_1/users/login_page.dart';
import 'package:parking_graduation_app_1/users/map_page.dart';
import 'package:parking_graduation_app_1/core/services/geo_cordinates_service.dart';
import 'package:parking_graduation_app_1/core/services/storage_service.dart';
import 'package:parking_graduation_app_1/worker/pages/view_worker_locations.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ParkingApp());
}

class ParkingApp extends StatelessWidget {
  ParkingApp({Key? key}) : super(key: key);

  final _geoCordinatesService = GeoCordinatesService();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Parking App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AppInitializer(),
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
      return Scaffold(
        body: ListView(
          children: [
            ElevatedButton(
              child: const Text('ADMINS'),
              onPressed: () async {
                await CurrentApplicationUserService()
                    .setId('vQXl9PT5L9ubatxcASos');
                await CurrentApplicationUserService().setName('Ahmed');
                await CurrentApplicationUserService().setRole('admin');
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ViewLocations()));
              },
            ),
            ElevatedButton(
              child: const Text('WORKERS'),
              onPressed: () async {
                await CurrentApplicationUserService()
                    .setId('g4tA3hW2h2Bl5NLRTJG8');
                await CurrentApplicationUserService().setName('islam');
                await CurrentApplicationUserService().setRole('worker');
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const ViewWorkerLocations(),
                  ),
                );
              },
            ),
            ElevatedButton(
              child: const Text('USERS'),
              onPressed: () async {
                await CurrentApplicationUserService()
                    .setId('2NT2V8WobYs3PQjogsZb');
                await CurrentApplicationUserService().setName('محمد محمود');
                await CurrentApplicationUserService().setRole('user');
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => const HomePage()));
              },
            ),
          ],
        ),
      );
      // if (token != null)
      //   return HomePage();
      // else
      //   return LoginPage();
    }
    if (initializerFailed) {
      return const _InitializtionError();
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
