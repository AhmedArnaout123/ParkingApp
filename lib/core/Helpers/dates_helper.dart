class DatesHelper {
  static getDateFromString(String s) {
    int year = int.parse(s.substring(0, 4));
    int month = int.parse(s.substring(5, 7));
    int day = int.parse(s.substring(8, 10));
    int hour = int.parse(s.substring(11, 13));
    int min = int.parse(s.substring(14));
    return DateTime(year, month, day, hour, min);
  }
}
