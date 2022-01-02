import 'package:flutter/material.dart';
import 'package:parking_graduation_app_1/core/Helpers/ui_helper.dart';
import 'package:parking_graduation_app_1/core/models/location.dart';
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
  List<Location> locations = [];

  final _locationsApiService = LocationsApiService();
  final _reservationsApiService = ReservationsApiService();

  @override
  void initState() {
    super.initState();
    getLocations();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: RefreshIndicator(
          onRefresh: () async => getLocations(),
          child: Scaffold(
            appBar: AppBar(
              title: Text('المواقع'),
            ),
            drawer: const WorkerDrawer(),
            body: ListView(
              children: [
                for (var location in locations)
                  _LocationCard(
                    location: location,
                    onTraillingTap: (location.isReserved())
                        ? () => releasLocation(location.id)
                        : () => reserveLocation(location),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void getLocations() async {
    locations =
        await _locationsApiService.getWorkerLocations('g4tA3hW2h2Bl5NLRTJG8');
    setState(() {});
  }

  void reserveLocation(Location location) async {
    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => AddReservation(location)));
    getLocations();
    setState(() {});
  }

  void releasLocation(String? id) async {
    var isSure = await UiHelper.showConfirmationDialog(
        context, 'هل أنت متأكد من الغاء الحجز');

    if (!isSure) return;

    await _reservationsApiService.finishLocationReservation(id);
    await _locationsApiService.releaseLocation(id);
    getLocations();
    setState(() {});
  }
}

class _LocationCard extends StatelessWidget {
  const _LocationCard({
    required this.location,
    this.onTraillingTap,
    Key? key,
  }) : super(key: key);

  final Location location;
  final VoidCallback? onTraillingTap;
  @override
  Widget build(BuildContext context) {
    var stateColor = Colors.red;
    if (location.isAvailable()) {
      stateColor = Colors.green;
    } else if (location.isPended()) {
      stateColor = Colors.orange;
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
        title: Text(location.name ?? ''),
        trailing: !location.isPended()
            ? TextButton(
                onPressed: onTraillingTap,
                child: Text(
                  location.isAvailable() ? 'حجز' : 'إنهاء الحجز',
                  style: TextStyle(
                    color: location.isAvailable()
                        ? Colors.green[300]
                        : Colors.red[300],
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
