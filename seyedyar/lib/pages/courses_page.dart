import 'package:flutter/material.dart';

class CoursesPage extends StatelessWidget {
  final String name;
  final String studentID;

  CoursesPage({required this.name, required this.studentID});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Welcome to the Courses Page, $name ($studentID)'),
    );
  }
}
