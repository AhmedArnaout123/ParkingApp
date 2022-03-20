import 'package:flutter/material.dart';
import 'package:parking_graduation_app_1/admin/pages/add_new_accounts/user.dart';
import 'package:parking_graduation_app_1/admin/pages/locations/view_locations.dart';
import 'package:parking_graduation_app_1/admin/pages/view_reservations.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            const SizedBox(height: 20),
            ListTile(
              title: Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  label: const Text(
                    'الحجوزات',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  onPressed: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => const ViewReservation())),
                  icon: const Icon(Icons.list, color: Colors.black),
                ),
              ),
            ),
            ListTile(
              title: Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  label: const Text(
                    'مستخدم جديد',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  onPressed: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => const AddNewUser())),
                  icon: const Icon(Icons.person, color: Colors.black),
                ),
              ),
            ),
            ListTile(
              title: Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  label: const Text(
                    'المواقع',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  onPressed: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => const ViewLocations()),
                  ),
                  icon: const Icon(Icons.place, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
