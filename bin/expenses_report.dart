import 'package:expenses_report/api/expense.dart';

import 'package:expenses_report/models/expense.dart';
import 'package:expenses_report/utils/date_converter.dart';

import 'package:expenses_report/utils/input.dart';
import 'package:expenses_report/utils/money_formatter.dart';

void main(List<String> arguments) async {
  while (true) {
    print("======================");
    print("-- Financial Report --");
    print("======================");
    print("1. Input Expense");
    print("2. Expenses List");
    print("3. Total Expenses (1 Month)");

    String menu = input("Menu: ", String);

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

        final Expense expense = Expense(0, inputExpense, inputCategory, inputNotes, inputDate);

        try {
          final int response = await postExpense(expense);

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
          final List<Expense> expenses = await getExpenses();
          print("ID | Category | Amount | Date | Notes");
          if (expenses.isEmpty) {
            print('--------------- empty ---------------');
            break;
          }

          for (var expense in expenses) {
            final String id = expense.id.toString().length == 1 ? '0${expense.id.toString()}' : expense.id.toString();
            final String category = expense.category;
            final String amount = moneyFomatter(expense.amount);
            final String date = dateToString(expense.date);
            final String? notes = expense.notes == '' ? '-' : expense.notes;

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
          final int totalExpenses = await getTotalExpenses();
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
