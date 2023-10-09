import 'package:intl/intl.dart';

DateTime stringToDate(String date) {
  DateFormat dateFormat = DateFormat('dd-MM-yyyy');

  return dateFormat.parseStrict(date);
}

String dateToString(DateTime date) {
  DateFormat dateFormat = DateFormat('dd-MM-yyyy');

  return dateFormat.format(date);
}
