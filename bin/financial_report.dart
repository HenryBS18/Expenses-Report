import 'package:financial_report/api/expense.dart';

import 'package:financial_report/models/expense_model.dart';

import 'package:financial_report/utils/input.dart';
import 'package:financial_report/utils/money_formatter.dart';

void main(List<String> arguments) async {
  while (true) {
    String menu;

    print("======================");
    print("-- Financial Report --");
    print("======================");
    print("1. Input Expense");
    print("2. Expenses List");
    print("3. Total Expenses (1 Month)");

    menu = input("Menu: ", String);

    print('');

    switch (menu) {
      case "1":
        print("===================");
        print("-- Input Expense --");
        print("===================");

        final int inputExpense = input("Input Amount: : ", int);
        final String inputCategory = input("Category: ", String);
        final String inputNotes = input("Notes: ", String);
        final DateTime inputDate = input("Date (dd-mm-yyyy): ", DateTime);

        Expense expense = Expense(inputExpense, inputCategory, inputNotes, inputDate);

        try {
          int response = await postExpense(expense);

          if (response == 201) {
            print("Success to add expense!");
            break;
          }
          print("Failed to add expense!");
        } catch (e) {
          print("Failed to add expense!");
        }
        break;
      case "2":
        print("===================");
        print("-- Expenses List --");
        print("===================");

        try {
          final expenses = await getExpenses();
          print("ID | Category | Amount | Date | Notes");

          for (var expense in expenses) {
            final String id = expense['id'].toString().length == 1 ? '0${expense['id'].toString()}' : expense['id'].toString();
            final String category = expense['category'];
            final String amount = moneyFomatter(expense['amount']);
            final String date = '${expense['date']['day']}-${expense['date']['month']}-${expense['date']['year']}';
            final String notes = expense['notes'] == '' ? '-' : expense['notes'];

            print("$id | $category | $amount | $date | $notes");
          }
        } catch (e) {
          print('falsed to get Expenses List');
        }

        break;
      case "3":
        print("==============================");
        print("-- Total Expenses (1 Month) --");
        print("==============================");

        try {
          int totalExpenses = await getTotalExpenses();
          print("Total Expenses: ${moneyFomatter(totalExpenses)}");
        } catch (e) {
          print('failed to count total Expenses');
        }
        break;
      default:
        print("Menu Not Found!");
        return;
    }

    print("");
  }
}
