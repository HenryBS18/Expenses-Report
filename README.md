<h1 align="center">Expenses Report CLI App</h1>

## About The App
Expenses Report is a CLI application that helps you to note your expenses and you can track it up to the 1 last month.

### Build with:
- Dart
- json-server

## Setup & Installation

### 1. Install Dart

<p>First install Dart SDK, follow the instructions in the link below:</p>
<a href="https://dart.dev/get-dart" target="_blank">https://dart.dev/get-dart</a>

### 2. Install json-server

Copy and paste the code below in the terminal.

```sh
$ npm install -g json-server
```

## Run The Application

### 1. Open terminal and run the Dart Application

```sh
$ dart run
```

### 2. Open new terminal and run the json-server
```sh
$ json-server --watch db/db.json
```

## Code Documentation

### Models
- #### Expense
  A Expense class that used to instantiate Expense instance. It has 5 fields id, amount, category, notes and date. the notes field is optional so it can be empty or null.

  ```dart
  class Expense {
    int id;
    int amount;
    String category;
    String? notes;
    DateTime date;

    Expense(this.id, this.amount, this.category, this.notes, this.date);
  }
  ```

### API Functions
- #### Save Expense Information
  A function that returns a status code.
  
  ```dart
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
  ```

- #### Get The Expenses History
  A function that  returns a list of Expense.

  ```dart
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
  ```

- #### Get Total Expenses
  A function that returns the total amount of the expense for the last 1 month.

  ```dart
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
  ```

### Utility Functions
- #### String To Date Converter
  A function that converts a String into DateTime. This function has 1 parameter, that is date: String.

  ```dart
  DateTime stringToDate(String date) {
    DateFormat dateFormat = DateFormat('dd-MM-yyyy');

    return dateFormat.parseStrict(date);
  }
  ```

- #### Date To String Converter
  A function that converts a DateTime into String. this function has 1 parameter, that is date: DateTime.

  ```dart
  String dateToString(DateTime date) {
    DateFormat dateFormat = DateFormat('dd-MM-yyyy');

    return dateFormat.format(date);
  }
  ```

- #### Input
  A function that is used to get the user's input in the CLI. This function has 2 parameters, that is label: String and type: Type.

  ```dart
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
  ```

- #### Last Month Checker
  A function that returns a boolean value indicating whether the Expense is within last month. This function has 2 parameters, that is expenseDate: DateTime and today: DateTime.

  ```dart
  bool isWithinLastMonth(DateTime expenseDate, DateTime today) {
    DateTime lastMonthStart = DateTime(today.year, today.month - 1, today.day);

    return expenseDate.isAfter(lastMonthStart) || expenseDate.isAtSameMomentAs(lastMonthStart);
  }
  ```

- #### Money Fomatter
  A function that format the amount of money with Rupiah currency format. This function has 1 parameter, that is amount: int.

  ```dart
  String moneyFomatter(int amount) {
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 2).format(amount);
  }
  ```