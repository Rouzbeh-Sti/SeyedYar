import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:seyedyar/StudentAssignment.dart';
import 'todo_work_page.dart';

class homePage extends StatefulWidget {
  final String name;
  final int studentID;
  homePage({required this.name, required this.studentID});

  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  Map<String, dynamic> summaryData = {
    'highestScore': 0.0,
    'lowestScore': 0.0,
    'numberOfAssignments': 0,
    'numberOfTasks': 0,
    'numberOfCourses': 0,
    'numberOfAssignmentsPastDue': 0,
  };

  @override
  void initState() {
    super.initState();
    fetchSummaryData();
    fetchTasks();
    fetchAssignments();
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    Duration totalRemainingTime = calculateTotalRemainingTime();
    String totalRemainingTimeString =
        formatTotalRemainingTime(totalRemainingTime);

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Color(0xFFD8F3DC),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'Summary',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: buildSummaryCard(
                        'Highest Score',
                        summaryData['highestScore'].toString(),
                        Icons.trending_up,
                        Colors.green,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: buildSummaryCard(
                        'Lowest Score',
                        summaryData['lowestScore'].toString(),
                        Icons.trending_down,
                        Colors.red,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: buildSummaryCard(
                        'Assignments',
                        summaryData['numberOfAssignments'].toString(),
                        Icons.assignment,
                        Colors.blue,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: buildSummaryCard(
                        'Tasks',
                        summaryData['numberOfTasks'].toString(),
                        Icons.task,
                        Colors.orange,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: buildSummaryCard(
                        'Courses',
                        summaryData['numberOfCourses'].toString(),
                        Icons.school,
                        Colors.purple,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: buildSummaryCard(
                        'Past Due',
                        summaryData['numberOfAssignmentsPastDue'].toString(),
                        Icons.assignment_late,
                        Colors.redAccent,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: buildSummaryCard(
                        "Time to Finish",
                        totalRemainingTimeString,
                        Icons.access_time,
                        Colors.lightBlue,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                CurrentTasks(formattedDate: formattedDate),
                Container(
                  height: section1Items.length * 80.0,
                  child: TaskList(items: section1Items),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'Done Assignments',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  height: completedAssignments.length * 150.0,
                  child: ListView.builder(
                    itemCount: completedAssignments.length,
                    itemBuilder: (context, index) {
                      final assignment = completedAssignments[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
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
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              assignment.name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Course: ${assignment.courseName}",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "Due: ${assignment.dueDate} ${assignment.dueTime}",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                            Text(
                              "Score: ${assignment.score}",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Duration calculateTotalRemainingTime() {
    DateTime now = DateTime.now();
    DateTime? latestTime;

    for (var item in section1Items) {
      DateTime taskDateTime = DateTime.parse("${item.date} ${item.time}");
      if (taskDateTime.isAfter(now)) {
        if (latestTime == null || taskDateTime.isAfter(latestTime)) {
          latestTime = taskDateTime;
        }
      }
    }

    for (var assignment in fetchedAssignments.where((a) => a.isActive)) {
      DateTime assignmentDateTime =
          DateTime.parse("${assignment.dueDate} ${assignment.dueTime}");
      if (assignmentDateTime.isAfter(now)) {
        if (latestTime == null || assignmentDateTime.isAfter(latestTime)) {
          latestTime = assignmentDateTime;
        }
      }
    }

    if (latestTime == null) {
      return Duration();
    }

    return latestTime.difference(now);
  }

  String formatTotalRemainingTime(Duration duration) {
    int days = duration.inDays;
    int hours = duration.inHours % 24;
    int minutes = duration.inMinutes % 60;
    return '${days}d ${hours}h ${minutes}m';
  }

  Future<void> fetchSummaryData() async {
    try {
      final socket = await Socket.connect('192.168.148.145', 8080);
      socket.write("GET: studentSummary~${widget.studentID}\u0000");

      List<int> responseBytes = [];
      await socket.listen((data) {
        responseBytes.addAll(data);
      }).asFuture();
      String response = String.fromCharCodes(responseBytes).trim();

      if (response.startsWith("200~")) {
        String data = response.split('~')[1];
        List<String> summaryParts = data.split(",");
        setState(() {
          summaryData = {
            'highestScore': double.parse(summaryParts[0]),
            'lowestScore': double.parse(summaryParts[1]),
            'numberOfAssignments': int.parse(summaryParts[2]),
            'numberOfTasks': int.parse(summaryParts[3]),
            'numberOfCourses': int.parse(summaryParts[4]),
            'numberOfAssignmentsPastDue': int.parse(summaryParts[5]),
          };
        });
      } else {
        throw Exception(response.split('~')[1]);
      }

      socket.close();
    } catch (e) {
      throw Exception('Failed to load summary data: $e');
    }
  }

  Future<void> fetchAssignments() async {
    try {
      final socket = await Socket.connect('192.168.148.145', 8080);
      socket.write("GET: studentAssignments~${widget.studentID}\u0000");

      List<int> responseBytes = [];
      await socket.listen((data) {
        responseBytes.addAll(data);
      }).asFuture();
      String response = String.fromCharCodes(responseBytes).trim();

      if (response.startsWith("200~")) {
        String data = response.split('~')[1];
        if (data.isEmpty) {
          setState(() {
            completedAssignments = [];
          });
        } else {
          List<String> assignmentsData = data.split(";");
          fetchedAssignments = assignmentsData
              .where((assignmentData) => assignmentData.isNotEmpty)
              .map((assignmentData) {
            List<String> parts = assignmentData.split(",");
            return StudentAssignment(
              assignmentID: int.parse(parts[0]),
              studentID: widget.studentID,
              name: parts[1],
              courseName: parts[2],
              dueDate: parts[3],
              dueTime: parts[4],
              estimatedTime: parts[5],
              isActive: parts[6] == 'true',
              description: parts[7],
              givingDescription: parts[8],
              score: double.parse(parts[9]),
            );
          }).toList();

          setState(() {
            completedAssignments =
                fetchedAssignments.where((item) => !item.isActive).toList();
          });
        }
      } else {
        throw Exception(response.split('~')[1]);
      }
      socket.close();
    } catch (e) {
      throw Exception('Failed to load assignments: $e');
    }
  }

  void fetchTasks() async {
    try {
      final serverSocket = await Socket.connect('192.168.148.145', 8080);
      serverSocket.write("GET: studentTasks~${widget.studentID}\u0000");

      List<int> responseBytes = [];
      await serverSocket.listen((data) {
        responseBytes.addAll(data);
      }).asFuture();
      String response = String.fromCharCodes(responseBytes).trim();

      if (response.startsWith("200~")) {
        String data = response.split('~')[1];
        List<String> tasksData = data.split(";");
        List<ListItem> fetchedTasks =
            tasksData.where((taskData) => taskData.isNotEmpty).map((taskData) {
          List<String> parts = taskData.split(",");
          String dateTime = parts[2];
          DateTime parsedDateTime = DateTime.parse(dateTime);
          String date =
              "${parsedDateTime.year}-${parsedDateTime.month.toString().padLeft(2, '0')}-${parsedDateTime.day.toString().padLeft(2, '0')}";
          String time =
              "${parsedDateTime.hour.toString().padLeft(2, '0')}:${parsedDateTime.minute.toString().padLeft(2, '0')}";
          return ListItem(parts[0], parts[1] == 'true', date, time);
        }).toList();
        setState(() {
          section1Items = fetchedTasks.where((item) => item.isActive).toList();
          section2Items = fetchedTasks.where((item) => !item.isActive).toList();
        });
      } else {
        print("ERROR: ${response.split('~')[1]}");
      }

      serverSocket.close();
    } catch (e) {
      print("ERROR: $e");
    }
  }

  Widget buildSummaryCard(
      String title, String value, IconData icon, Color iconColor) {
    return Container(
      width: 128,
      margin: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF74C69D),
            Color(0xFF52B788),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: Offset(0, 4),
          ),
        ],
        borderRadius: BorderRadius.circular(15),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 30,
            color: iconColor,
          ),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

List<StudentAssignment> completedAssignments = [];
List<StudentAssignment> fetchedAssignments = [];

class CompletedExerciseCard extends StatelessWidget {
  final String exercise;

  CompletedExerciseCard({required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFa8e063),
            Color(0xFF56ab2f),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: Offset(0, 4),
          ),
        ],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.lightGreen[900]!,
          width: 2,
        ),
      ),
      padding: EdgeInsets.all(10),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topRight,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 8),
              Text(
                exercise,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Positioned(
            top: -18,
            right: -18,
            child: Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.check,
                size: 7,
                color: Colors.lightGreen[400],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TaskList extends StatelessWidget {
  final List<ListItem> items;

  TaskList({required this.items});

  @override
  Widget build(BuildContext context) {
    var widthOfScreen = MediaQuery.of(context).size.width;
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
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
                ]),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 5.0,
                offset: Offset(0, 5),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(horizontal: widthOfScreen * 0.04),
          child: listItem(items[index], context),
        );
      },
    );
  }

  Widget listItem(ListItem item, BuildContext context) {
    return GestureDetector(
        child: ListTile(
      title: Text(
        item.title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: item.isActive ? Colors.black : Colors.black54,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    ));
  }
}

class CurrentTasks extends StatelessWidget {
  final String formattedDate;

  CurrentTasks({required this.formattedDate});

  @override
  Widget build(BuildContext context) {
    var widthOfScreen = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Current Tasks',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: widthOfScreen * 0.344),
          Text(
            formattedDate,
            style: TextStyle(
                fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
