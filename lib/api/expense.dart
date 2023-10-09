import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:expenses_report/utils/date_converter.dart';
import 'package:expenses_report/utils/last_month_check.dart';

import 'package:expenses_report/models/expense.dart';

import 'package:http/http.dart';

Future<List<Expense>> getExpenses() async {
  final Response response = await http.get(Uri.parse("http://localhost:3000/expenses"));
  final List<dynamic> data = jsonDecode(response.body);

  final List<Expense> expenseList = [];

  for (Map<String, dynamic> expense in data) {
    String dateString = '${expense['date']['day']}-${expense['date']['month']}-${expense['date']['year']}';
    DateTime date = stringToDate(dateString);

    expenseList.add(Expense(expense['id'], expense['amount'], expense['category'], expense['notes'], date));
  }

  return expenseList;
}

Future<int> getTotalExpenses() async {
  final List<Expense> expenses = await getExpenses();

  num totalExpenses = 0;

  for (Expense expense in expenses) {
    DateTime today = DateTime.now();
    DateTime expenseDate = expense.date;

    if (isWithinLastMonth(expenseDate, today)) {
      totalExpenses += expense.amount;
    }
  }

  return totalExpenses.toInt();
}

Future<int> postExpense(Expense expense) async {
  final List<String> date = dateToString(expense.date).split('-');

  final Response response = await http.post(Uri.parse("http://localhost:3000/expenses"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'amount': expense.amount,
        'category': expense.category,
        'notes': expense.notes,
        'date': {'day': date[0], 'month': date[1], 'year': date[2]}
      }));

  return response.statusCode;
}
