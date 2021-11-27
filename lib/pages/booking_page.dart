import 'package:flutter/material.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({Key? key}) : super(key: key);

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  var reservationCategories = [
    {'duration': '30 min', 'price': 300},
    {'duration': '1 hour', 'price': 500},
    {'duration': '2 hours', 'price': 1000},
    {'duration': '3 hours', 'price': 1500},
    {'duration': '4 hours', 'price': 2000},
    {'duration': '5 hours', 'price': 2500},
    {'duration': '6 hours', 'price': 3000}
  ];

  bool payFromWallet = true;
  Map<String, dynamic> selectedReservation = {};

  @override
  void initState() {
    super.initState();
    selectedReservation = reservationCategories[1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const _Header(),
          const SizedBox(height: 30),
          _TimeLine(selectedReservation['duration']),
          const SizedBox(height: 10),
          SizedBox(
            height: 100,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              scrollDirection: Axis.horizontal,
              itemCount: reservationCategories.length,
              itemBuilder: (context, i) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedReservation = reservationCategories[i];
                    });
                  },
                  child: ResravationCard(
                    duration: reservationCategories[i]['duration'] as String,
                    price: reservationCategories[i]['price'] as int,
                    isSelected: selectedReservation == reservationCategories[i],
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
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        payFromWallet = true;
                      });
                    },
                    child: _PaymentCard(
                      icon: Icons.wallet_membership,
                      text: 'Wallet',
                      isSelected: payFromWallet,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        payFromWallet = false;
                      });
                    },
                    child: _PaymentCard(
                      icon: Icons.credit_card,
                      isSelected: !payFromWallet,
                      text: 'Credit Card',
                    ),
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
    );
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
  final int price;
  const ResravationCard(
      {Key? key, this.isSelected = false, this.duration = '', this.price = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
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
                    color: isSelected ? Colors.white : const Color(0xFF909294),
                  ),
                ),
              ],
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
            'Select hours',
            style: TextStyle(
              color: Color(0xFF909294),
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
