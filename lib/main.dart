import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:parking_graduation_app_1/admin/pages/view_locations.dart';
import 'package:parking_graduation_app_1/core/Providers/current_user_provider.dart';
import 'package:parking_graduation_app_1/core/Providers/worker_locations_provider.dart';
import 'package:parking_graduation_app_1/core/Providers/worker_payments_provider.dart';
import 'package:parking_graduation_app_1/core/models/worker.dart';
import 'package:parking_graduation_app_1/users/home_page.dart';
import 'package:parking_graduation_app_1/core/services/storage_service.dart';
import 'package:parking_graduation_app_1/worker/pages/view_worker_locations.dart';

import 'core/models/admin.dart';
import 'core/models/user.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ParkingApp());
}

class ParkingApp extends StatelessWidget {
  const ParkingApp({Key? key}) : super(key: key);

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
          var role = await StorageService().read('role');
          var id = await StorageService().read('id');
          WorkerPaymentsProvider.initialize('g4tA3hW2h2Bl5NLRTJG8');
          WorkerLocationsProvider.initialize('g4tA3hW2h2Bl5NLRTJG8');
          CurrentUserProvider.initialize('fUjA9g7Lbyr46F6Equ1F');
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
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ViewLocations()));
              },
            ),
            ElevatedButton(
              child: const Text('WORKERS'),
              onPressed: () async {
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
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => const HomePage()));
              },
            ),
          ],
        ),
      );
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
