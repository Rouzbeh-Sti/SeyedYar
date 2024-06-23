import 'package:flutter/material.dart';

class TodoWorkPage extends StatelessWidget {
  final String name;
  final String studentID;

  TodoWorkPage({required this.name, required this.studentID});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Welcome to the To Do Work Page, $name ($studentID)'),
    );
  }
}
