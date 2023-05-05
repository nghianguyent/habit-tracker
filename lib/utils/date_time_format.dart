String todaysDateFormatted() {
  final DateTime now = DateTime.now();
  final String day = now.day.toString().padLeft(2, '0');
  final String month = now.month.toString().padLeft(2, '0');
  final String year = now.year.toString();
  return '$day-$month-$year';
}

DateTime createDateObject(String? dateStr) {
  if (dateStr == null) {
    return DateTime.now();
  }
  final List<String> dateList = dateStr.split('-');
  final int day = int.parse(dateList[0]);
  final int month = int.parse(dateList[1]);
  final int year = int.parse(dateList[2]);
  return DateTime(year, month, day);
}

String convertDateTimeToString(DateTime date) {
  final String year = date.year.toString().padLeft(2, '0');
  final String month = date.month.toString().padLeft(2, '0');
  final String day = date.day.toString().padLeft(2, '0');
  return '$day-$month-$year';
}
