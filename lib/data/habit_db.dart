import 'package:flutter/material.dart';
import 'package:habit_tracker/utils/date_time_format.dart';
import 'package:hive/hive.dart';

final _appBox = Hive.box('habits');

enum StorageKey {
  CURRENT_HABIT_LIST,
  START_DATE,
}

class HabitDB {
  List todayHabits = [];
  Map<DateTime, int> heatMapData = {};
  // default
  void createDefault() {
    todayHabits = [
      ['Drink Water', false],
      ['Exercise', false],
      ['Read', false],
      ['Meditate', false],
      ['Sleep', false],
    ];
    _appBox.put(StorageKey.START_DATE.name, todaysDateFormatted());
  }

  // load data if existed
  void load() {
    // we want the habit loop every day so every time the new day come, we need to reset the day before list
    // check if it's a new date, get the old list and reset the list
    if (_appBox.get(todaysDateFormatted()) == null) {
      todayHabits = _appBox.get(StorageKey.CURRENT_HABIT_LIST.name);
      // reset the list
      for (var element in todayHabits) {
        element[1] = false;
      }
    } else {
      // get today list
      todayHabits = _appBox.get(todaysDateFormatted());
    }
  }

  // update
  void update() {
    // update today entries
    _appBox.put(todaysDateFormatted(), todayHabits);

    // update universal habit list in case it is changed (new, delete, edit)
    _appBox.put(StorageKey.CURRENT_HABIT_LIST.name, todayHabits);

    // calculate habit complete percentage for each day
    calculateHabitPercentages();

    // load heat map
    loadHeatMap();
  }

  void calculateHabitPercentages() {
    int countComplete = 0;
    for (var element in todayHabits) {
      if (element[1] == true) {
        countComplete++;
      }
    }
    String percent = todayHabits.isEmpty
        ? '0.0'
        : (countComplete / todayHabits.length).toStringAsFixed(1);
    // key:"PERCENTAGE_SUMMARY_$todaysDateFormatted"
    // value: string of 1 dp number between 0 and 1.0 inclusive
    _appBox.put('PERCENTAGE_SUMMARY_${todaysDateFormatted()}', percent);
  }

  void loadHeatMap() {
    DateTime startDate =
        createDateObject(_appBox.get(StorageKey.START_DATE.name));

    // count the date to load
    int daysBetween = DateTime.now().difference(startDate).inDays;

    // go from start date to today and add each percent
    for (int i = 0; i <= daysBetween; i++) {
      String dateStr = convertDateTimeToString(
        startDate.add(Duration(days: i)),
      );

      double strengthPercentage =
          double.parse(_appBox.get('PERCENTAGE_SUMMARY_$dateStr') ?? "0.0");
      int year = startDate.add(Duration(days: i)).year;
      int month = startDate.add(Duration(days: i)).month;
      int day = startDate.add(Duration(days: i)).day;

      debugPrint(dateStr);
      final percentageEachDay = <DateTime, int>{
        DateTime(year, month, day): (strengthPercentage * 10).toInt()
      };

      heatMapData.addEntries(percentageEachDay.entries);
    }
  }
}
