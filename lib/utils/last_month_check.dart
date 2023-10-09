bool isWithinLastMonth(DateTime expenseDate, DateTime today) {
  DateTime lastMonthStart = DateTime(today.year, today.month - 1, today.day);

  return expenseDate.isAfter(lastMonthStart) || expenseDate.isAtSameMomentAs(lastMonthStart);
}
