import 'package:flutter/material.dart';
import 'package:parking_graduation_app_1/worker/pages/view_worker_locations.dart';

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
              child: Text('Drawer Header'),
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
          ],
        ),
      ),
    );
  }
}
