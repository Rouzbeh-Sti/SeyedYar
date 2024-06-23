import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final String name;
  final String studentID;

  HomePage({required this.name, required this.studentID});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Welcome to the Home Page, $name ($studentID)'),
    );
  }
}
