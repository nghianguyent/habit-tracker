import 'package:flutter/material.dart';
import 'package:habit_tracker/components/habit_title.dart';
import 'package:habit_tracker/components/monthly_summary.dart';
import 'package:habit_tracker/components/my_dialog.dart';
import 'package:habit_tracker/components/my_floating_button.dart';
import 'package:habit_tracker/data/habit_db.dart';
import 'package:habit_tracker/utils/date_time_format.dart';
import 'package:hive/hive.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _appBox = Hive.box('habits');
  HabitDB db = HabitDB();
  @override
  void initState() {
    if (_appBox.get(StorageKey.CURRENT_HABIT_LIST.name) == null) {
      db.createDefault();
    } else {
      db.load();
    }

    db.update();

    super.initState();
  }

  TextEditingController _controller = TextEditingController();

  void onComplete(bool? value, int index) {
    setState(() {
      db.todayHabits[index][1] = value!;
    });
    db.update();
  }

  void addNewHabit() {
    setState(
      () {
        final String value = _controller.text;
        db.todayHabits.add([value, false]);
        _controller.clear();
      },
    );
    db.update();
    Navigator.pop(context);
  }

  void openAddNewHabitDialog() {
    showDialog(
      context: context,
      builder: (context) => MyDialog(
        title: 'Add new habit',
        controller: _controller,
        onSave: addNewHabit,
        onCancel: () => Navigator.pop(context),
      ),
    );
  }

  void onDelete(BuildContext context, int? index) {
    setState(() {
      db.todayHabits.removeAt(index ?? db.todayHabits.length - 1);
    });
    db.update();
  }

  void updateExistingHabit(int index) {
    setState(() {
      final String value = _controller.text;
      db.todayHabits[index][0] = value;
      _controller.clear();
    });
    db.update();
    Navigator.pop(context);
  }

  void onEdit(context, index) {
    showDialog(
      context: context,
      builder: (context) => MyDialog(
        title: 'Update habit',
        controller: _controller =
            TextEditingController(text: db.todayHabits[index][0]),
        onSave: () => updateExistingHabit(index),
      ),
    );
    db.update();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: const Text('Habit Tracker'),
      ),
      body: ListView(
        children: [
          MonthlySummary(
            datasets: db.heatMapData,
            startDate: _appBox.get(StorageKey.START_DATE.name),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: db.todayHabits.length,
            itemBuilder: (context, index) => HabitTile(
              key: ValueKey(index),
              title: db.todayHabits[index][0],
              isCompleted: db.todayHabits[index][1],
              onComplete: (value) => onComplete(value, index),
              onDelete: (context) => onDelete(context, index),
              onEdit: (context) => onEdit(context, index),
            ),
          ),
        ],
      ),
      floatingActionButton: MyFloatingButton(action: openAddNewHabitDialog),
    );
  }
}
