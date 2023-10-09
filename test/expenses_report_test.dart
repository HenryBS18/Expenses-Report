import 'package:test/test.dart';

import 'package:expenses_report/utils/date_converter.dart';
import 'package:expenses_report/utils/last_month_check.dart';
import 'package:expenses_report/utils/money_formatter.dart';

void main() {
  test('String to Date', () {
    expect(stringToDate('12-02-2023'), DateTime(2023, 2, 12));
    expect(stringToDate('24-01-2017'), DateTime(2017, 1, 24));
  });

  test('Date to String', () {
    expect(dateToString(DateTime(2023, 5, 18)), '18-05-2023');
    expect(dateToString(DateTime(2004, 2, 14)), '14-02-2004');
  });

  test('Last Month Checker', () {
    expect(isWithinLastMonth(DateTime(2023, 9, 23), DateTime(2023, 10, 5)), true);
    expect(isWithinLastMonth(DateTime(2023, 1, 5), DateTime(2023, 3, 30)), false);
  });

  test('Money Formatter', () {
    expect(moneyFomatter(50000), 'Rp. 50.000,00');
    expect(moneyFomatter(728500), 'Rp. 728.500,00');
  });
}
