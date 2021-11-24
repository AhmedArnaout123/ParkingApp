import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  void AddParkingPlace() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: ElevatedButton(
        child: Text('Add'),
        onPressed: () {
          CollectionReference parkingPlaces =
              FirebaseFirestore.instance.collection('reservationCategories');
          [
            {'duration': 2, 'price': 1000},
            {'duration': 3, 'price': 1500},
            {'duration': 4, 'price': 2000},
            {'duration': 5, 'price': 2500},
            {'duration': 6, 'price': 3000},
          ].forEach((element) async {
            var obj = await parkingPlaces.add(element);
            print(obj.id);
          });
          print('button done!');
        },
      ),
    ));
  }
}
