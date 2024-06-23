import 'package:flutter/material.dart';

class NewsPage extends StatelessWidget {
  final String name;
  final String studentID;

  NewsPage({required this.name, required this.studentID});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Welcome to the News Page, $name ($studentID)'),
    );
  }
}
