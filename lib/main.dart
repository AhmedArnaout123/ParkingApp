import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:parking_graduation_app_1/admin/pages/locations/view_locations.dart';
import 'package:parking_graduation_app_1/common/pages/login_page.dart';
import 'package:parking_graduation_app_1/core/services/notifications_service.dart';
import 'package:parking_graduation_app_1/core/services/storage_service.dart';
import 'package:parking_graduation_app_1/users/pages/home_page.dart';

import 'core/Providers/current_user_provider.dart';
import 'core/Providers/current_worker_provider.dart';

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
        .then((value) async => await NotificationService().init())
        .then((_) => {
              setState(() {
                initializerSucceeded = true;
              })
            })
        .catchError((e) {
      print("errrroorrr");
      print(e);
      setState(() {
        initializerFailed = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (initializerSucceeded) {
      return const _MainNavigator();
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

class _MainNavigator extends StatefulWidget {
  const _MainNavigator({Key? key}) : super(key: key);

  @override
  State<_MainNavigator> createState() => __MainNavigatorState();
}

class __MainNavigatorState extends State<_MainNavigator> {
  Future<Widget> navigate() async {
    var id = await StorageService().read('userId');
    var role = await StorageService().read('userRole');

    if (id == null || role == null) {
      return const LoginPage();
    }

    if (role == 'user') {
      await CurrentUserProvider.initialize(id);
      return const UserHomePage();
    } else if (role == 'worker') {
      await CurrentWorkerProvider.initialize(id);
      return const ViewAdminLocations();
    } else {
      return const ViewAdminLocations();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: navigate(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data!;
        }

        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
