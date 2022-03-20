import 'package:flutter/material.dart';
import 'package:parking_graduation_app_1/admin/widgets/admin_drawer.dart';
import 'package:parking_graduation_app_1/core/models/reservation.dart';
import 'package:parking_graduation_app_1/core/services/Api/reservations_api_service.dart';

class ViewReservation extends StatefulWidget {
  const ViewReservation({Key? key}) : super(key: key);

  @override
  _ViewReservationState createState() => _ViewReservationState();
}

class _ViewReservationState extends State<ViewReservation> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الحجوزات'),
        ),
        drawer: const AdminDrawer(),
        body: StreamBuilder<List<Reservation>>(
            stream: ReservationsApiService().getReservationsStream(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }
              var reservations = snapshot.data!;
              return ListView(
                children:
                    reservations.map((res) => _ReservationCard(res)).toList(),
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
  @override
  void initState() {
    super.initState();
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
          Text('الموقع:${widget.reservation.locationName}'),
          Text('المستخدم:${widget.reservation.userFullName}'),
          Text('رقم الهاتف:${widget.reservation.userPhoneNumber}'),
          Text('البدء:${widget.reservation.startDate}'),
          Text('الانتهاء:${widget.reservation.endDate}'),
          Text('السعر:${widget.reservation.cost}'),
        ],
      ),
    );
  }
}
