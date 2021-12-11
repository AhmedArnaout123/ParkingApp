import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:parking_graduation_app_1/admin/widgets/app_drawer.dart';
import 'package:parking_graduation_app_1/core/models/user.dart';

class AddNewLocation extends StatefulWidget {
  const AddNewLocation({Key? key}) : super(key: key);

  @override
  _AddNewLocationState createState() => _AddNewLocationState();
}

class _AddNewLocationState extends State<AddNewLocation> {
  bool isLoading = false;

  Map<String, dynamic> form = {
    'name': '',
    'lat': 0.0,
    'long': 0.0,
    'isReserved': false,
    'workerId': ''
  };

  List<User> workers = [];

  var locationsCollection = FirebaseFirestore.instance.collection('locations');

  void changeLoadingState() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  Future<void> addLocation() {
    changeLoadingState();
    return locationsCollection.add(form).then((value) {
      changeLoadingState();
      print('success');
    }).catchError((e) {
      if (isLoading) changeLoadingState();
      print(e);
    });
  }

  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'worker')
        .get()
        .then((value) {
      for (var doc in value.docs) {
        var data = <String, dynamic>{...doc.data(), 'id': doc.id};
        print(data);
        workers.add(User.fromMap(data));
      }
      setState(() {});
      print(workers);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            appBar: AppBar(
              title: Text("موقع جديد"),
            ),
            drawer: AppDrawer(),
            body: ListView(
              padding: EdgeInsets.symmetric(horizontal: 25),
              children: [
                SizedBox(height: 40),
                TextFormField(
                  decoration: InputDecoration(hintText: 'اسم الموقع'),
                  onChanged: (value) {
                    form['name'] = value;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'lat',
                  ),
                  onChanged: (value) {
                    form['lat'] = value;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'long',
                  ),
                  onChanged: (value) {
                    form['long'] = double.parse(value);
                  },
                ),
                SizedBox(height: 30),
                DropdownButtonFormField<String>(
                  hint: Text("العامل المسؤول"),
                  onChanged: (value) {
                    form['workerId'] = double.parse(value ?? "0.0");
                  },
                  items: [
                    for (var worker in workers)
                      DropdownMenuItem(
                          child: Text(worker.name ?? ''), value: worker.id)
                  ],
                ),
                SizedBox(height: 60),
                _AddButton(
                  onPressed: addLocation,
                  showLoading: isLoading,
                )
              ],
            )),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({Key? key, this.showLoading = false, this.onPressed})
      : super(key: key);

  final bool showLoading;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: const Color(0xFF61A4F1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: onPressed,
      child: const Text(
        'إضافة',
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}
