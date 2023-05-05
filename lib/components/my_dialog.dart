import 'package:flutter/material.dart';
import 'package:habit_tracker/components/my_action_button.dart';

class MyDialog extends StatelessWidget {
  VoidCallback onSave;
  VoidCallback? onCancel;
  final String title;
  final TextEditingController controller;
  MyDialog(
      {Key? key,
      required this.onSave,
      this.onCancel,
      required this.controller,
      required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.green[100],
      title: Text(title),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(
          hintText: 'Enter habit name',
        ),
      ),
      actions: [
        MyActionButton(
          actionName: 'Save',
          action: onSave,
        ),
        MyActionButton(
          actionName: 'Cancel',
          action: onCancel == null ? () => Navigator.pop(context) : onCancel!,
        ),
      ],
    );
  }
}
