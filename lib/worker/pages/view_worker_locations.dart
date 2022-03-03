import 'package:flutter/material.dart';
import 'package:parking_graduation_app_1/core/Helpers/ui_helper.dart';
import 'package:parking_graduation_app_1/core/models/location.dart';
import 'package:parking_graduation_app_1/core/models/reservation.dart';
import 'package:parking_graduation_app_1/core/services/locations_api_service.dart';
import 'package:parking_graduation_app_1/core/services/reservations_api_service.dart';
import 'package:parking_graduation_app_1/worker/pages/add_reservation.dart';
import 'package:parking_graduation_app_1/worker/widgets/worker_drawer.dart';

class ViewWorkerLocations extends StatefulWidget {
  const ViewWorkerLocations({Key? key}) : super(key: key);

  @override
  _ViewWorkerLocationsState createState() => _ViewWorkerLocationsState();
}

class _ViewWorkerLocationsState extends State<ViewWorkerLocations> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: Text('المواقع'),
          ),
          drawer: const WorkerDrawer(),
          body: ListView(
            children: [
              StreamBuilder<List<Location>>(
                stream: LocationsApiService().getLocationsStream(),
                builder: (context, snap) {
                  if (!snap.hasData) {
                    return Container();
                  }
                  List<Location> locations = snap.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (var location in locations)
                        _LocationCard(
                          location: location,
                          onTraillingTap: (location.isReserved())
                              ? () => releasLocation(location)
                              : () => reserveLocation(location),
                        ),
                    ],
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  void reserveLocation(Location location) async {
    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => AddReservation(location)));
  }

  void releasLocation(Location location) async {
    var isSure = await UiHelper.showConfirmationDialog(
        context, 'هل أنت متأكد من الغاء الحجز');

    if (!isSure) return;

    await ReservationsApiService()
        .finishReservation(location.currentReservationId);
    await LocationsApiService().releaseLocation(location.id);
  }
}

class _LocationCard extends StatelessWidget {
  const _LocationCard({
    required this.location,
    this.onTraillingTap,
    this.locationReservation,
    Key? key,
  }) : super(key: key);

  final Location location;
  final Reservation? locationReservation;
  final VoidCallback? onTraillingTap;
  @override
  Widget build(BuildContext context) {
    var stateColor = Colors.red;
    if (location.isAvailable()) {
      stateColor = Colors.green;
    }
    return Container(
      color: Colors.blue[50],
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Container(
          margin: const EdgeInsets.only(top: 8),
          height: 12,
          width: 12,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: stateColor,
          ),
        ),
        title: InkWell(
          child: Text(location.name ?? ''),
          onTap: showLocationReserveationInfo,
        ),
        subtitle: location.isReserved()
            ? LocationReservationInfo(location: location)
            : null,
        trailing: TextButton(
          onPressed: onTraillingTap,
          child: Text(
            location.isAvailable() ? 'حجز' : 'إنهاء الحجز',
            style: TextStyle(
              color:
                  location.isAvailable() ? Colors.green[300] : Colors.red[300],
            ),
          ),
        ),
      ),
    );
  }

  void showLocationReserveationInfo() {}
}

class LocationReservationInfo extends StatelessWidget {
  const LocationReservationInfo({required this.location, Key? key})
      : super(key: key);

  final Location location;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Reservation>>(
      stream: ReservationsApiService().getReservationsStream(),
      builder: (context1, snapshot1) {
        if (snapshot1.hasData) {
          var reservation = snapshot1.data!
              .where((r) => r.id == location.currentReservationId)
              .single;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                reservation.endDate!.substring(reservation.endDate!.length - 5),
              ),
              Text(reservation.userFullName!),
              Text(reservation.userPhoneNumber!)
            ],
          );
        }
        return Container();
      },
    );
  }
}
