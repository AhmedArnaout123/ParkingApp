import 'package:flutter/material.dart';
import 'package:parking_graduation_app_1/admin/pages/add_new_location.dart';
import 'package:parking_graduation_app_1/admin/pages/update_location.dart';
import 'package:parking_graduation_app_1/admin/widgets/admin_drawer.dart';
import 'package:parking_graduation_app_1/core/Helpers/constants_helper.dart';
import 'package:parking_graduation_app_1/core/Helpers/ui_helper.dart';
import 'package:parking_graduation_app_1/core/models/location.dart';
import 'package:parking_graduation_app_1/core/services/locations_api_service.dart';

class ViewLocations extends StatefulWidget {
  const ViewLocations({Key? key}) : super(key: key);

  @override
  _ViewLocationsState createState() => _ViewLocationsState();
}

class _ViewLocationsState extends State<ViewLocations> {
  List<Location> locations = [];

  final _locationsApiService = LocationsApiService();

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
            title: const Text('المواقع'),
          ),
          drawer: const AdminDrawer(),
          body: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: onAddPress,
                    child: const Text(
                      'موقع جديد +',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
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
                          onDelete: () => deleteLocation(location.id),
                          onTap: () => onTap(location),
                        )
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

  void onAddPress() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const AddNewLocation()),
    );
  }

  void onTap(Location location) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => UpdateLocation(location)),
    );
  }

  void deleteLocation(id) async {
    var isSure = await UiHelper.showDeleteConfirmationDialog(context);

    if (!isSure) return;

    await _locationsApiService.deleteLocation(id);
    setState(() {
      locations.removeWhere((l) => l.id == id);
    });
  }
}

class _LocationCard extends StatelessWidget {
  const _LocationCard({
    required this.location,
    this.onDelete,
    this.onTap,
    Key? key,
  }) : super(key: key);

  final Location location;
  final VoidCallback? onDelete;
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
        trailing: IconButton(
          icon: const Icon(
            Icons.delete,
            color: Colors.red,
            size: 20,
          ),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
