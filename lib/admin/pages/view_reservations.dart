import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:parking_graduation_app_1/admin/widgets/admin_drawer.dart';
import 'package:parking_graduation_app_1/core/models/reservation.dart';

class ViewReservation extends StatefulWidget {
  const ViewReservation({Key? key}) : super(key: key);

  @override
  _ViewReservationState createState() => _ViewReservationState();
}

class _ViewReservationState extends State<ViewReservation> {
  List<Reservation> reservations = [];

  final Stream<QuerySnapshot> reservationsStream =
      FirebaseFirestore.instance.collection('reservations').snapshots();
  void getReservations() {
    reservationsStream.listen((event) {
      reservations = [];
      for (var doc in event.docs) {
        var data = doc.data() as Map<String, dynamic>? ?? <String, dynamic>{};
        var map = {'id': doc.id, ...data};
        print(map);
        reservations.add(Reservation.fromMap(map));
      }
      setState(() {});
    });
    FirebaseFirestore.instance.collection('reservations').get().then((value) {
      for (var doc in value.docs) {
        var map = {...doc.data(), 'id': doc.id};
        print(map);
        reservations.add(Reservation.fromMap(map));
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('الحجوزات'),
        ),
        drawer: AdminDrawer(),
        body: StreamBuilder(
            stream: reservationsStream,
            builder: (context, snapshot) {
              return ListView(
                children: [
                  for (var reservation in reservations)
                    _ReservationCard(reservation)
                ],
              );
            }),
      ),
    );
  }
}

class _ReservationCard extends StatefulWidget {
  const _ReservationCard(this.reservation, {Key? key}) : super(key: key);

  final Reservation reservation;

  @override
  State<_ReservationCard> createState() => _ReservationCardState();
}

class _ReservationCardState extends State<_ReservationCard> {
  String locationName = "", userName = "", phoneNumber = "";

  void getData() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.reservation.userId)
        .get()
        .then((value) {
      userName = value.data()?['name'];
      phoneNumber = value.data()?['phoneNumber'];
      setState(() {});
    });

    FirebaseFirestore.instance
        .collection('locations')
        .doc(widget.reservation.userId)
        .get()
        .then((value) {
      locationName = value.data()?['name'];
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();

    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF73AEF5),
            Color(0xFF61A4F1),
            Color(0xFF478DE0),
            Color(0xFF398AE5),
          ],
          stops: [0.1, 0.4, 0.7, 0.9],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('الموقع:$locationName'),
          Text('المستخدم:$userName'),
          Text('رقم الهاتف:$phoneNumber'),
          Text('البدء:${widget.reservation.startDate}'),
          Text('الانتهاء:${widget.reservation.endDate}'),
          Text('السعر:${widget.reservation.cost}'),
          Text('المدة:${widget.reservation.time}/سا'),
        ],
      ),
    );
  }
}
