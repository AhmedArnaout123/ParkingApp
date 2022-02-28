import 'package:flutter/material.dart';
import 'package:parking_graduation_app_1/admin/widgets/admin_drawer.dart';
import 'package:parking_graduation_app_1/core/Helpers/constants_helper.dart';
import 'package:parking_graduation_app_1/core/Helpers/ui_helper.dart';
import 'package:parking_graduation_app_1/core/models/application_users/worker.dart';
import 'package:parking_graduation_app_1/core/services/locations_api_service.dart';
import 'package:parking_graduation_app_1/core/services/application_users_api_service.dart';

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
    'state': ConstantsHelper.locationStates[0],
    'workerId': '',
    'workerFullName': '',
    'currentReservationId': null
  };

  List<Worker> workers = [];

  var locationsApiService = LocationsApiService();
  var applicationUsersApiService = ApplicationUsersApiService();

  @override
  void initState() {
    super.initState();

    getWorkers();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("موقع جديد"),
          ),
          drawer: const AdminDrawer(),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            children: [
              const SizedBox(height: 40),
              TextFormField(
                decoration: const InputDecoration(hintText: 'اسم الموقع'),
                onChanged: (value) {
                  form['name'] = value;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'lat',
                ),
                onChanged: (value) {
                  form['lat'] = double.parse(value);
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'long',
                ),
                onChanged: (value) {
                  form['long'] = double.parse(value);
                },
              ),
              const SizedBox(height: 30),
              DropdownButtonFormField<String>(
                hint: const Text("العامل المسؤول"),
                onChanged: (id) {
                  form['workerId'] = id;
                  form['workerFullName'] =
                      workers.firstWhere((w) => w.id == id).name;
                },
                items: [
                  for (var worker in workers)
                    DropdownMenuItem(
                        child: Text(worker.name ?? ''), value: worker.id)
                ],
              ),
              const SizedBox(height: 60),
              _AddButton(
                onPressed: addLocation,
                showLoading: isLoading,
              )
            ],
          ),
        ),
      ),
    );
  }

  void changeLoadingState() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  void addLocation() async {
    changeLoadingState();
    await locationsApiService.addLocation(form);
    changeLoadingState();
    UiHelper.showDialogWithOkButton(
      context,
      'تمت الإضافة بنجاح',
      (_) => Navigator.of(context).pop(),
    );
  }

  void getWorkers() async {
    workers = await applicationUsersApiService.getWorkers();
    setState(() {});
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({Key? key, this.showLoading = false, this.onPressed})
      : super(key: key);

  final bool showLoading;
  final VoidCallback? onPressed;
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
      child: showLoading
          ? const Center(
              child: SizedBox(
                height: 25,
                width: 25,
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            )
          : const Text(
              'إضافة',
              style: TextStyle(fontSize: 18),
            ),
    );
  }
}
