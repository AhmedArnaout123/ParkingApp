import 'package:flutter/material.dart';
import 'package:parking_graduation_app_1/admin/widgets/admin_drawer.dart';
import 'package:parking_graduation_app_1/core/Helpers/ui_helper.dart';
import 'package:parking_graduation_app_1/core/models/application_users/worker.dart';
import 'package:parking_graduation_app_1/core/models/location.dart';
import 'package:parking_graduation_app_1/core/services/locations_api_service.dart';
import 'package:parking_graduation_app_1/core/services/application_users_api_service.dart';

class UpdateLocation extends StatefulWidget {
  const UpdateLocation(this.location, {Key? key}) : super(key: key);

  final Location location;
  @override
  _UpdateLocationState createState() => _UpdateLocationState();
}

class _UpdateLocationState extends State<UpdateLocation> {
  bool isLoading = false;
  bool updateButtonisEnabled = false;

  List<Worker> workers = [];

  Map<String, dynamic> form = {};

  @override
  void initState() {
    super.initState();
    form = {
      'name': widget.location.name ?? '',
      'lat': widget.location.lat ?? 0.0,
      'long': widget.location.long ?? 0.0,
      'state': widget.location.state,
      'workerId': widget.location.workerId,
      'workerFullName': widget.location.workerFullName
    };
    getWorkers();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.location.name ?? ""),
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
                  enableUpdateButton();
                },
                initialValue: form['name'],
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'lat',
                ),
                onChanged: (value) {
                  form['lat'] = double.parse(value);
                  enableUpdateButton();
                },
                initialValue: form['lat'].toString(),
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'long',
                ),
                onChanged: (value) {
                  form['long'] = double.parse(value);
                  enableUpdateButton();
                },
                initialValue: form['long'].toString(),
              ),
              const SizedBox(height: 30),
              DropdownButtonFormField<String>(
                hint: const Text("العامل المسؤول"),
                value: form['workerId'],
                onChanged: (id) {
                  form['workerId'] = id;
                  form['workerFullName'] =
                      workers.firstWhere((w) => w.id == id).name;
                  enableUpdateButton();
                },
                items: [
                  for (var worker in workers)
                    DropdownMenuItem(
                      child: Text(worker.name ?? ''),
                      value: worker.id,
                    )
                ],
              ),
              const SizedBox(height: 60),
              _UpdateButton(
                onPressed: updateLocation,
                showLoading: isLoading,
                isEnabled: updateButtonisEnabled,
              )
            ],
          ),
        ),
      ),
    );
  }

  var locationsApiService = LocationsApiService();
  var applicationUsersApiService = ApplicationUsersApiService();

  void changeLoadingState() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  void enableUpdateButton() {
    if (!updateButtonisEnabled) {
      setState(() {
        updateButtonisEnabled = true;
      });
    }
  }

  void updateLocation() async {
    changeLoadingState();
    await locationsApiService.updateLocation(widget.location.id, form);
    changeLoadingState();
    UiHelper.showDialogWithOkButton(
      context,
      'تم التعديل بنجاح',
      (_) => Navigator.of(context).pop(),
    );
  }

  void getWorkers() async {
    workers = await applicationUsersApiService.getWorkers();
    setState(() {});
  }
}

class _UpdateButton extends StatelessWidget {
  const _UpdateButton({
    Key? key,
    this.showLoading = false,
    this.isEnabled = true,
    this.onPressed,
  }) : super(key: key);

  final bool showLoading;
  final bool isEnabled;
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
      onPressed: isEnabled ? onPressed : null,
      child: showLoading
          ? const Center(
              child: SizedBox(
              height: 25,
              width: 25,
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ))
          : const Text(
              'حفظ',
              style: TextStyle(fontSize: 18),
            ),
    );
  }
}
