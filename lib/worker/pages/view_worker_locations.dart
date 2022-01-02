import 'package:flutter/material.dart';
import 'package:parking_graduation_app_1/admin/pages/update_location.dart';
import 'package:parking_graduation_app_1/core/Helpers/constants_helper.dart';
import 'package:parking_graduation_app_1/core/Helpers/ui_helper.dart';
import 'package:parking_graduation_app_1/core/models/location.dart';
import 'package:parking_graduation_app_1/core/services/locations_api_service.dart';
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

  void getLocations() async {
    locations =
        await _locationsApiService.getWorkerLocations('g4tA3hW2h2Bl5NLRTJG8');
    setState(() {});
  }

  void onTap(Location location) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => UpdateLocation(location)),
    );
    getLocations();
  }

  void onReserve(Location location) async {
    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => AddReservation(location)));
  }

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
                    onTap: () => onTap(location),
                    onTraillingTap: (location.isReserved())
                        ? () {}
                        : () => onReserve(location),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LocationCard extends StatelessWidget {
  const _LocationCard({
    required this.location,
    this.onTraillingTap,
    this.onTap,
    Key? key,
  }) : super(key: key);

  final Location location;
  final VoidCallback? onTraillingTap;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    var stateColor = Colors.red;
    if (location.state == ConstantsHelper.locationStates[0]) {
      stateColor = Colors.green;
    } else if (location.state == ConstantsHelper.locationStates[1]) {
      stateColor = Colors.red;
    }
    return Container(
      color: Colors.blue[50],
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        onTap: onTap,
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
        subtitle: Text(location.workerFullName ?? ''),
        trailing: TextButton(
          onPressed: onTraillingTap,
          child: Text('Hi'
              // isReservedLocation ? 'الغاء الحجز' : 'حجز',
              // style: TextStyle(
              //   color: isReservedLocation ? Colors.red[300] : Colors.green[300],
              ),
        ),
      ),
    );
  }
}
