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

  var payOnSite = false;
  Map<String, dynamic>? selectedReservation;

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
          )
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
