import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:financial_report/utils/date_converter.dart';
import 'package:financial_report/utils/last_month_check.dart';

import 'package:financial_report/models/expense_model.dart';

Future<dynamic> getExpenses() async {
  final response = await http.get(Uri.parse("http://localhost:3000/expenses"));

  return jsonDecode(response.body);
}

Future<int> getTotalExpenses() async {
  final expenses = await getExpenses();

  num totalExpenses = 0;

  for (var expense in expenses) {
    DateTime today = DateTime.now();
    String expenseDateString = '${expense['date']['day']}-${expense['date']['month']}-${expense['date']['year']}';
    DateTime expenseDate = stringToDate(expenseDateString);

    if (isWithinLastMonth(expenseDate, today)) {
      totalExpenses += expense['amount'];
    }
  }

  return totalExpenses.toInt();
}

Future<int> postExpense(Expense expense) async {
  List<String> date = dateToString(expense.date).split('-');

  final response = await http.post(Uri.parse("http://localhost:3000/expenses"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'amount': expense.amount,
        'category': expense.category,
        'notes': expense.notes,
        'date': {'day': date[0], 'month': date[1], 'year': date[2]}
      }));

  return response.statusCode;
}
