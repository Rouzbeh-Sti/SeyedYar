import 'dart:io';

import 'package:flutter/material.dart';
import 'package:seyedyar/Course.dart';

class CoursesPage extends StatefulWidget {
  final int studentId;

  CoursesPage({required this.studentId});

  @override
  _CoursesPageState createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  List<Course> courses = [];
  String response = '';
  @override
  void initState() {
    super.initState();
    fetchCourses();
  }

  void fetchCourses() async {
    try {
      final serverSocket = await Socket.connect('192.168.1.13', 8080);
      serverSocket.write("GET: studentCourses~${widget.studentId}\u0000");

      List<int> responseBytes = [];
      await serverSocket.listen((data) {
        responseBytes.addAll(data);
      }).asFuture();
      response = String.fromCharCodes(responseBytes).trim();

      if (response.startsWith("200~")) {
        String data = response.split('~')[1];
        print(data);
        List<String> coursesData = data.split(";");
        List<Course> fetchedCourses = coursesData.map((courseData) {
          List<String> parts = courseData.split(",");
          return Course(
            id: int.parse(parts[0]),
            name: parts[1],
            teacherName: parts[2],
          );
        }).toList();
        setState(() {
          courses = fetchedCourses;
        });
      } else {
        print("ERROR");
      }

      serverSocket.close();
    } catch (e) {
      print("ERROR");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: courses.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(courses[index].name),
              subtitle: Text('Teacher: ${courses[index].teacherName}'),
            ),
          );
        },
      ),
    );
  }
}
