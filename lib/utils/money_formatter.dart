import 'package:intl/intl.dart';

String moneyFomatter(int amount) {
  return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 2).format(amount);
}
