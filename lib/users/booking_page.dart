import 'package:flutter/material.dart';
import 'package:parking_graduation_app_1/core/Helpers/constants_helper.dart';
import 'package:parking_graduation_app_1/core/models/location.dart';
import 'package:parking_graduation_app_1/core/services/application_users_api_service.dart';
import 'package:parking_graduation_app_1/core/services/current_application_user_service.dart';
import 'package:parking_graduation_app_1/core/services/locations_api_service.dart';
import 'package:parking_graduation_app_1/core/services/reservations_api_service.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({Key? key, required this.location}) : super(key: key);

  final Location location;

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: ListView(
          children: [
            const _Header(),
            const SizedBox(height: 30),
            _TimeLine(selectedReservation['text']),
            const SizedBox(height: 10),
            SizedBox(
              height: 100,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                scrollDirection: Axis.horizontal,
                itemCount: ConstantsHelper.reservationCategories.length,
                itemBuilder: (context, i) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedReservation =
                            ConstantsHelper.reservationCategories[i];
                      });
                    },
                    child: ResravationCard(
                      duration: ConstantsHelper.reservationCategories[i]['text']
                          as String,
                      price: ConstantsHelper.reservationCategories[i]['price']
                          as double,
                      isSelected: selectedReservation ==
                          ConstantsHelper.reservationCategories[i],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 40),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Select Payment',
                style: TextStyle(
                  color: Color(0xFF909294),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Expanded(
                    child: _PaymentCard(
                      icon: Icons.money,
                      text: 'Wallet',
                      isSelected: true,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _PaymentCard(
                      icon: Icons.credit_card,
                      isSelected: false,
                      text: 'Credit Card',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            _ConfirmButton(onPressed: () {}, showLoading: false),
            const SizedBox(height: 12)
          ],
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
    var user = await CurrentApplicationUserService().getCurrentUser();
    var startDate = DateTime.now();
    var endDate = startDate.add(const Duration(hours: 1));

    var worker =
        await ApplicationUsersApiService().getWorker(widget.location.workerId);

    form = {
      'workerId': worker.id,
      'workerName': worker.name,
      'locationId': widget.location.id,
      'locationName': widget.location.name,
      'startDate': startDate.toString().substring(0, 16),
      'endDate': endDate.toString().substring(0, 16),
      'isFinished': false,
      'cost': selectedReservation['price'],
      'userId': user.id,
      'userFullName': user.name,
      'hours': selectedReservation['hours']
    };
  }
}

class _Header extends StatelessWidget {
  const _Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      padding: EdgeInsets.only(top: 60, bottom: 40, left: 12, right: 12),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text(
            'Parking App',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.only(left: 14),
            child: Text(
              'Easy, Fast, Effecient',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ResravationCard extends StatelessWidget {
  final bool isSelected;
  final String duration;
  final double price;
  const ResravationCard(
      {Key? key, this.isSelected = false, this.duration = '', this.price = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            decoration: isSelected
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
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
                  )
                : null,
            color: !isSelected ? const Color(0xFFF0F4F7) : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    duration,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${price.toString()} SYP',
                    style: TextStyle(
                      fontSize: 12,
                      color:
                          isSelected ? Colors.white : const Color(0xFF909294),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TimeLine extends StatelessWidget {
  const _TimeLine(this.reservationDuration, {Key? key}) : super(key: key);

  final String reservationDuration;

  String getFinishTime() {
    DateTime now = DateTime.now();
    Duration duration;
    if (reservationDuration == '30 min') {
      duration = Duration(minutes: 30);
    } else {
      duration = Duration(hours: int.parse(reservationDuration[0]));
    }
    DateTime finishTime = now.add(duration);
    int finishHour = finishTime.hour;
    String dayTime = 'AM';
    if (finishHour > 12) {
      dayTime = 'PM';
      finishHour -= 12;
    }
    return '$finishHour:${finishTime.minute} $dayTime';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'فئة الحجز',
            style: TextStyle(
              color: Color(0xFF909294),
              fontSize: 18,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.timelapse,
                color: Color(0xFF398AE5),
              ),
              const SizedBox(width: 10),
              Text(
                'Now  -  ${getFinishTime()}',
                style: const TextStyle(
                  color: Color(0xFF398AE5),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class _PaymentCard extends StatelessWidget {
  const _PaymentCard(
      {Key? key,
      this.isSelected = false,
      this.icon = Icons.wallet_membership,
      this.text = 'Wallet'})
      : super(key: key);

  final bool isSelected;
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xFFF0F4F7),
        gradient: isSelected
            ? const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF73AEF5),
                  Color(0xFF61A4F1),
                  Color(0xFF478DE0),
                  Color(0xFF398AE5),
                ],
                stops: [0.1, 0.4, 0.7, 0.9],
              )
            : null,
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.white : Colors.black,
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(color: isSelected ? Colors.white : Colors.black),
          )
        ],
      ),
    );
  }
}

class _ConfirmButton extends StatelessWidget {
  const _ConfirmButton({Key? key, this.showLoading = false, this.onPressed})
      : super(key: key);

  final bool showLoading;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        height: 50,
        width: MediaQuery.of(context).size.width * 0.8,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: const Color(0xFF61A4F1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: onPressed,
          child: const Text(
            'Book Now',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
