class ConstantsHelper {
  static const List<String> locationStates = [
    "Available",
    "Reserved",
  ];

  static const List<Map<String, dynamic>> reservationCategories = [
    {'text': '30 min', 'price': 300, 'hours': 0.5},
    {'text': '1 hour', 'price': 500, 'hours': 1.0},
    {'text': '2 hours', 'price': 1000, 'hours': 2.0},
    {'text': '3 hours', 'price': 1500, 'hours': 3.0},
    {'text': '4 hours', 'price': 2000, 'hours': 4.0},
    {'text': '5 hours', 'price': 2500, 'hours': 5.0},
    {'text': '6 hours', 'price': 3000, 'hours': 6.0}
  ];
}
