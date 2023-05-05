import 'package:flutter/material.dart';

class MyActionButton extends StatelessWidget {
  final String actionName;
  final Function() action;
  const MyActionButton(
      {super.key, required this.actionName, required this.action});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: action,
      child: Text(actionName),
    );
  }
}
