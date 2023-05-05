import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HabitTile extends StatelessWidget {
  final String title;
  final bool isCompleted;
  final Function(bool?) onComplete;
  final Function(BuildContext) onDelete;
  final Function(BuildContext) onEdit;

  const HabitTile({
    super.key,
    required this.title,
    required this.isCompleted,
    required this.onComplete,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 22.0, right: 22.0, top: 22.0),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: onEdit,
              backgroundColor: Colors.green,
              foregroundColor: Colors.green[100],
              icon: Icons.settings,
            ),
            SlidableAction(
              onPressed: onDelete,
              backgroundColor: Colors.red,
              icon: Icons.delete,
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, 2),
                blurRadius: 4.0,
              ),
            ],
            color: Colors.green[100],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  decoration: isCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  fontSize: 20.0,
                  fontWeight: FontWeight.normal,
                ),
              ),
              Checkbox(
                value: isCompleted,
                onChanged: onComplete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
