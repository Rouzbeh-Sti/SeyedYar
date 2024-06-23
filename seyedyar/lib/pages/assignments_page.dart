import 'package:flutter/material.dart';

class AssignmentsPage extends StatelessWidget {
  final String name;
  final String studentID;

  AssignmentsPage({required this.name, required this.studentID});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Welcome to the Assignments Page, $name ($studentID)'),
    );
  }
}
