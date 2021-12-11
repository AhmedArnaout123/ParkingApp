import 'package:flutter/material.dart';
import 'package:parking_graduation_app_1/admin/pages/add_new_location.dart';
import 'package:parking_graduation_app_1/admin/pages/add_new_user.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        //padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Drawer Header'),
          ),
          SizedBox(height: 100),
          ListTile(
            onTap: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => AddNewUser())),
            title: Text('إضافة مستخدم جديد'),
          ),
          ListTile(
            onTap: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => AddNewLocation())),
            title: Text('إضافة موقع جديد'),
          ),
        ],
      ),
    );
  }
}
