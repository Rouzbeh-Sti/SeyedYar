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
  TextEditingController courseIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCourses();
  }

  void fetchCourses() async {
    try {
      final serverSocket = await Socket.connect('192.168.1.52', 8080);
      serverSocket.write("GET: studentCourses~${widget.studentId}\u0000");

      List<int> responseBytes = [];
      await serverSocket.listen((data) {
        responseBytes.addAll(data);
      }).asFuture();
      response = String.fromCharCodes(responseBytes).trim();

      if (response.startsWith("200~")) {
        String data = response.split('~')[1];
        print("Data: $data");
        List<String> coursesData = data.split(";");
        List<Course> fetchedCourses = coursesData
            .where((courseData) => courseData.isNotEmpty)
            .map((courseData) {
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
        print("ERROR: ${response.split('~')[1]}");
      }

      serverSocket.close();
    } catch (e) {
      print("ERROR: $e");
    }
  }

  void addCourse(String courseId) async {
    try {
      final serverSocket = await Socket.connect('192.168.1.13', 8080);
      String message = "ADD: course~${widget.studentId}~$courseId\u0000";
      print(
          "Sending message: $message"); // Add this line to debug the message being sent
      serverSocket.write(message);

      List<int> responseBytes = [];
      await serverSocket.listen((data) {
        responseBytes.addAll(data);
      }).asFuture();
      String response = String.fromCharCodes(responseBytes).trim();

      if (response.startsWith("200~")) {
        setState(() {
          fetchCourses(); // Refresh the course list after adding
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Course added successfully")));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response.split("~")[1])));
      }

      serverSocket.close();
    } catch (e) {
      print("ERROR: $e");
    }
  }

  void showAddCourseDialog() {
    TextEditingController courseIdController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Course'),
          content: TextField(
            controller: courseIdController,
            decoration: InputDecoration(labelText: 'Enter Course ID'),
            keyboardType: TextInputType.number,
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                courseIdController.clear();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                String courseId = courseIdController.text.trim();
                if (courseId.isNotEmpty) {
                  addCourse(courseId);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Course ID cannot be empty")));
                }
                courseIdController.clear();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget courseCard(Course course) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        shape: BoxShape.rectangle,
        gradient: LinearGradient(
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
          colors: [
            Color(0xFFD8F3DC),
            Color(0xFFb7e4c7),
            Color(0xFF95d5b2),
            Color(0xFF74c69d),
            Color(0xFF52b788),
          ],
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5.0,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          course.name,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          'Teacher: ${course.teacherName}',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFFD8F3DC),
        child: courses.isEmpty
            ? Center(child: Text('No courses available'))
            : ListView.builder(
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  return courseCard(courses[index]);
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddCourseDialog,
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
        backgroundColor: Color(0xFF74C69D),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
