class ConstantsHelper {
  static const List<String> locationStates = [
    "Available",
    "Pended",
    "Reserved"
  ];

  static const List<Map<String, dynamic>> reservationCategories = [
    {'text': '30 min', 'price': 300.0, 'hours': 0.5},
    {'text': '1 hour', 'price': 500.0, 'hours': 1.0},
    {'text': '2 hours', 'price': 1000.0, 'hours': 2.0},
    {'text': '3 hours', 'price': 1500.0, 'hours': 3.0},
    {'text': '4 hours', 'price': 2000.0, 'hours': 4.0},
    {'text': '5 hours', 'price': 2500.0, 'hours': 5.0},
    {'text': '6 hours', 'price': 3000.0, 'hours': 6.0}
  ];
}
