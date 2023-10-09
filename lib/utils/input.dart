import 'dart:io';

import 'package:financial_report/utils/date_converter.dart';

dynamic input(String label, Type type) {
  switch (type) {
    case String:
      stdout.write(label);
      return stdin.readLineSync()!;
    case int:
      stdout.write("Input: ");
      return int.parse(stdin.readLineSync()!);
    case DateTime:
      stdout.write("Date (dd-mm-yyyy): ");
      return stringToDate(stdin.readLineSync()!);
  }
}
