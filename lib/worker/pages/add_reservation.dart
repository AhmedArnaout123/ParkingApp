import 'package:flutter/material.dart';
import 'package:parking_graduation_app_1/core/Helpers/constants_helper.dart';
import 'package:parking_graduation_app_1/core/Helpers/ui_helper.dart';
import 'package:parking_graduation_app_1/core/Providers/current_worker_provider.dart';
import 'package:parking_graduation_app_1/core/models/location.dart';
import 'package:parking_graduation_app_1/core/services/Api/locations_api_service.dart';
import 'package:parking_graduation_app_1/core/services/Api/reservations_api_service.dart';

class AddReservation extends StatefulWidget {
  const AddReservation(this.location, {Key? key}) : super(key: key);
  final Location location;
  @override
  _AddReservationState createState() => _AddReservationState();
}

class _AddReservationState extends State<AddReservation> {
  Map<String, dynamic> form = {};
  Map<String, dynamic> selectedReservation = {};

  var isLoading = false;

  @override
  void initState() {
    super.initState();
    selectedReservation = ConstantsHelper.reservationCategories[1];
    initializeForm();
  }

  @override
  Widget build(BuildContext context) {
    const customTextStyle = TextStyle(fontSize: 18);
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('إضافة حجز'),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'الموقع:',
                    style: customTextStyle,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      widget.location.name!,
                      style: customTextStyle,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text(
                    'المدة الزمنية:',
                    style: customTextStyle,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: DropdownButtonFormField<double>(
                        value: selectedReservation['hours'],
                        onChanged: onTimeSelect,
                        items: [
                          for (var re in ConstantsHelper.reservationCategories)
                            DropdownMenuItem(
                              child: Text(re['text']),
                              value: re['hours'],
                            )
                        ],
                      ),
                    ),
                  ),
                  const Spacer()
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text(
                    'المبلغ:',
                    style: customTextStyle,
                  ),
                  const SizedBox(width: 10),
                  Text(selectedReservation['price'].toString())
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'الاسم',
                ),
                onChanged: (value) {
                  form['userFullName'] = value;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'رقم الهاتف',
                ),
                onChanged: (value) {
                  form['userPhoneNumber'] = value;
                },
              ),
              const SizedBox(height: 80),
              _AddButton(
                onPressed: () => addReservation(),
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

  void initializeForm() async {
    var worker = CurrentWorkerProvider().worker;
    var startDate = DateTime.now();
    var endDate = startDate.add(const Duration(hours: 1));

    form = {
      'workerId': worker.id,
      'workerFullName': worker.fullName,
      'locationId': widget.location.id,
      'locationName': widget.location.name,
      'startDate': startDate.toString().substring(0, 16),
      'endDate': endDate.toString().substring(0, 16),
      'isFinished': false,
      'cost': selectedReservation['price'],
      'userId': null,
    };
  }

  void onTimeSelect(double? hours) {
    selectedReservation = ConstantsHelper.reservationCategories
        .firstWhere((e) => e['hours'] == hours);

    form['cost'] = selectedReservation['price'];
    var startDate = DateTime.now();
    var endDate = startDate.add(
      hours == 0.5
          ? const Duration(minutes: 30)
          : Duration(hours: hours?.toInt() ?? 0),
    );
    form['startDate'] = startDate.toString().substring(0, 16);
    form['endDate'] = endDate.toString().substring(0, 16);

    setState(() {});
  }

  void addReservation() async {
    changeLoadingState();
    var reservationId = await ReservationsApiService().addReservation(form);
    await LocationsApiService().reserveLocation(
      widget.location.id!,
      reservationId,
    );
    changeLoadingState();
    UiHelper.showDialogWithOkButton(
      context,
      'تمت الإضافة بنجاح',
      (_) => Navigator.of(context).pop(),
    );
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
            ))
          : const Text(
              'إضافة',
              style: TextStyle(fontSize: 18),
            ),
    );
  }
}
