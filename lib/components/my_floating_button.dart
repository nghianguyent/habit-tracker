import 'package:flutter/material.dart';

class MyFloatingButton extends StatelessWidget {
  final Function() action;
  const MyFloatingButton({super.key, required this.action});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: action,
      backgroundColor: Colors.green,
      child: const Icon(Icons.add),
    );
  }
}
