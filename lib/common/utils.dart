import 'package:mybudgetdiary/common/sharedpreference.dart';

class Utils {
  static String returnGreetings() {
    String name = UserPreference.getFirstName();

    DateTime now = DateTime.now();
    String greeting = "";
    int hours = now.hour;

    if (hours >= 0 && hours <= 12) {
      greeting = "Good Morning";
    } else if (hours >= 12 && hours <= 16) {
      greeting = "Good Afternoon";
    } else if (hours >= 16 && hours <= 24) {
      greeting = "Good Evening";
    }

    return "$greeting, $name!";
  }
}
