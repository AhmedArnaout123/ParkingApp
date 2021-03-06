import 'package:flutter/material.dart';
import 'package:parking_graduation_app_1/core/services/logout_service.dart';
import 'package:parking_graduation_app_1/worker/pages/view_worker_locations.dart';
import 'package:parking_graduation_app_1/worker/pages/view_worker_payments.dart';

class WorkerDrawer extends StatelessWidget {
  const WorkerDrawer({Key? key}) : super(key: key);

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
              child: Text(' '),
            ),
            const SizedBox(height: 20),
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
                        builder: (context) => const ViewWorkerLocations()),
                  ),
                  icon: const Icon(Icons.place, color: Colors.black),
                ),
              ),
            ),
            ListTile(
              title: Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  label: const Text(
                    'الدفعات',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  onPressed: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => const ViewWorkerPayments()),
                  ),
                  icon: const Icon(Icons.place, color: Colors.black),
                ),
              ),
            ),
            ListTile(
              title: Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  label: const Text(
                    'تسجيل الخروج',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  onPressed: () => LogoutService().logout(context),
                  icon: const Icon(Icons.logout_outlined, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
