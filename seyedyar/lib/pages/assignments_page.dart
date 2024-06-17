import 'package:flutter/material.dart';
import 'package:seyedyar/components/custom_app_bar.dart';

class AssignmentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Assignments'),
      backgroundColor: Color.fromARGB(255, 158, 218, 189),
      body: Center(
        child: Text('Welcome to the Assignments Page'),
      ),
    );
  }
}