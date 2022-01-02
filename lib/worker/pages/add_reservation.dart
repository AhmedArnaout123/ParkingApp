import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:parking_graduation_app_1/core/models/location.dart';
import 'package:parking_graduation_app_1/core/models/application_users/user.dart';
import 'package:parking_graduation_app_1/core/services/application_users_api_service.dart';

class AddReservation extends StatefulWidget {
  const AddReservation(this.location, {Key? key}) : super(key: key);
  final Location location;
  @override
  _AddReservationState createState() => _AddReservationState();
}

class _AddReservationState extends State<AddReservation> {
  var reservationCategories = [
    <String, dynamic>{'text': '30 min', 'price': 300, 'duration': 0.5},
    {'text': '1 hour', 'price': 500, 'duration': 1.0},
    {'text': '2 hours', 'price': 1000, 'duration': 2.0},
    {'text': '3 hours', 'price': 1500, 'duration': 3.0},
    {'text': '4 hours', 'price': 2000, 'duration': 4.0},
    {'text': '5 hours', 'price': 2500, 'duration': 5.0},
    {'text': '6 hours', 'price': 3000, 'duration': 6.0}
  ];

  Map<String, dynamic> selectedReservation = {};

  var applicationUsersApiService = ApplicationUsersApiService();

  @override
  void initState() {
    super.initState();
    selectedReservation = reservationCategories[1];
  }

  @override
  Widget build(BuildContext context) {
    var customTextStyle = TextStyle(fontSize: 18);
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: Text('إضافة حجز'),
          ),
          body: ListView(
            padding: EdgeInsets.all(16),
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'الموقع:',
                    style: customTextStyle,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      widget.location.name ?? '',
                      style: customTextStyle,
                    ),
                  )
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    'المدة الزمنية:',
                    style: customTextStyle,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<double>(
                      value: selectedReservation['duration'],
                      onChanged: (value) {
                        selectedReservation = reservationCategories
                            .firstWhere((e) => e['duration'] == value);
                      },
                      items: [
                        for (var re in reservationCategories)
                          DropdownMenuItem(
                              child: Text(re['text']),
                              value: re['duration'] as double)
                      ],
                    ),
                  ),
                  Spacer()
                ],
              ),
              // DropdownSearch<User>(
              //   isFilteredOnline: true,
              //   onFind: ,
              // )
            ],
          ),
        ),
      ),
    );
  }
}
