import 'dart:io';
import 'package:flutter/material.dart';
import 'package:seyedyar/StudentAssignment.dart';

class AssignmentPage extends StatefulWidget {
  final int studentID;

  AssignmentPage({required this.studentID});

  @override
  _AssignmentPageState createState() => _AssignmentPageState();
}

class _AssignmentPageState extends State<AssignmentPage> {
  List<StudentAssignment> assignments = [];

  @override
  void initState() {
    super.initState();
    fetchAssignments();
  }

  Future<void> fetchAssignments() async {
    try {
      final socket = await Socket.connect('192.168.1.13', 8080);
      socket.write("GET: studentAssignments~${widget.studentID}\u0000");

      List<int> responseBytes = [];
      await socket.listen((data) {
        responseBytes.addAll(data);
      }).asFuture();
      String response = String.fromCharCodes(responseBytes).trim();

      if (response.startsWith("200~")) {
        String data = response.split('~')[1];
        List<String> assignmentsData = data.split(";");
        List<StudentAssignment> fetchedAssignments = assignmentsData
            .where((assignmentData) => assignmentData.isNotEmpty)
            .map((assignmentData) {
          List<String> parts = assignmentData.split(",");
          return StudentAssignment(
            assignmentID: int.parse(parts[0]),
            studentID: widget.studentID,
            name: parts[1], // Read assignmentName
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
          assignments = fetchedAssignments;
          sortAssignments();
        });
      } else {
        throw Exception(response.split('~')[1]);
      }
    } catch (e) {
      throw Exception('Failed to load assignments: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD8F3DC),
      body: assignments.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: assignments.length,
              itemBuilder: (context, index) {
                StudentAssignment assignment = assignments[index];
                Duration timeRemaining = calculateTimeRemaining(
                    assignment.dueDate, assignment.dueTime);
                return GestureDetector(
                  onTap: () {
                    showAssignmentDetails(context, assignment);
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                        colors: assignment.isActive
                            ? [Color(0xFFD8F3DC), Color(0xFF74C69D)]
                            : [Color(0xFFF8D7DA), Color(0xFFF5C6CB)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${assignment.name} (${formatDuration(timeRemaining)})',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Course: ${assignment.courseName}',
                                style: TextStyle(color: Colors.black54),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Due: ${assignment.dueDate} at ${assignment.dueTime}',
                                style: TextStyle(color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                        Checkbox(
                          value: !assignment.isActive,
                          onChanged: (bool? value) {
                            updateAssignmentStatus(
                                context, assignment, !value!);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  void showAssignmentDetails(
      BuildContext context, StudentAssignment assignment) {
    TextEditingController estimatedTimeController =
        TextEditingController(text: assignment.estimatedTime);
    TextEditingController descriptionController =
        TextEditingController(text: assignment.description);
    TextEditingController givingDescriptionController =
        TextEditingController(text: assignment.givingDescription);

    final _formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Container(
          color:
              Color.fromARGB(255, 168, 223, 171), // Set a new background color
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Assignment Details',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text('Title:',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        child: Text(assignment.name,
                            style: TextStyle(fontSize: 18)),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text('Course:',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        child: Text(assignment.courseName,
                            style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text('Due Date:',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        child: Text(assignment.dueDate,
                            style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text('Due Time:',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        child: Text(assignment.dueTime,
                            style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text('Status:',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        child: Text(assignment.isActive ? "Active" : "Inactive",
                            style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Text('Estimated Time:',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        width: 80,
                        child: TextFormField(
                          controller: estimatedTimeController,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            errorStyle: TextStyle(height: 0),
                            contentPadding: EdgeInsets.symmetric(vertical: 10),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      Text("hours", style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  SizedBox(height: 5),
                  TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  SizedBox(height: 5),
                  TextFormField(
                    controller: givingDescriptionController,
                    decoration: InputDecoration(
                      labelText: 'Giving Description',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  SizedBox(height: 20),
                  if (_formKey.currentState?.validate() == false)
                    Padding(
                      padding: EdgeInsets.only(top: 5, left: 200),
                      child: Text(
                        'Cannot be empty',
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState?.validate() == true) {
                              updateAssignmentDetails(
                                  context,
                                  assignment,
                                  estimatedTimeController.text,
                                  descriptionController.text,
                                  givingDescriptionController.text);
                              setState(() {
                                assignment.estimatedTime =
                                    estimatedTimeController.text;
                                assignment.description =
                                    descriptionController.text;
                                assignment.givingDescription =
                                    givingDescriptionController.text;
                              });
                              Navigator.pop(context);
                            }
                          },
                          child: Text(
                            'Update',
                            style: TextStyle(color: Colors.black),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: Colors.black),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(169, 244, 73, 73),
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        child: Text(
                          'Upload File',
                          style: TextStyle(color: Colors.black),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              vertical: 16, horizontal: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void updateAssignmentDetails(
      BuildContext context,
      StudentAssignment assignment,
      String estimatedTime,
      String description,
      String givingDescription) async {
    try {
      final socket = await Socket.connect('192.168.1.13', 8080);
      socket.write(
          "UPDATE: studentAssignment~${widget.studentID}~${assignment.assignmentID}~estimatedTime~$estimatedTime\u0000");
      socket.write(
          "UPDATE: studentAssignment~${widget.studentID}~${assignment.assignmentID}~description~$description\u0000");
      socket.write(
          "UPDATE: studentAssignment~${widget.studentID}~${assignment.assignmentID}~givingDescription~$givingDescription\u0000");

      List<int> responseBytes = [];
      await socket.listen((data) {
        responseBytes.addAll(data);
      }).asFuture();
      String response = String.fromCharCodes(responseBytes).trim();

      if (response.startsWith("200~")) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Assignment details updated successfully')));
        setState(() {
          assignment.estimatedTime = estimatedTime;
          assignment.description = description;
          assignment.givingDescription = givingDescription;
          sortAssignments();
        });
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response.split("~")[1])));
      }
      socket.close();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update assignment details: $e')));
    }
  }

  void updateAssignmentStatus(
      BuildContext context, StudentAssignment assignment, bool isActive) async {
    try {
      final socket = await Socket.connect('192.168.1.13', 8080);
      socket.write(
          "UPDATE: studentAssignment~${widget.studentID}~${assignment.assignmentID}~isActive~$isActive\u0000");

      List<int> responseBytes = [];
      await socket.listen((data) {
        responseBytes.addAll(data);
      }).asFuture();
      String response = String.fromCharCodes(responseBytes).trim();

      if (response.startsWith("200~")) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Assignment status updated successfully')));
        setState(() {
          assignment.isActive = isActive;
          sortAssignments();
        });
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response.split("~")[1])));
      }
      socket.close();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update assignment status: $e')));
    }
  }

  void sortAssignments() {
    assignments.sort((a, b) {
      if (a.isActive && !b.isActive) return -1;
      if (!a.isActive && b.isActive) return 1;
      return a.estimatedTime.compareTo(b.estimatedTime);
    });
  }

  Duration calculateTimeRemaining(String dueDate, String dueTime) {
    DateTime now = DateTime.now();
    DateTime dueDateTime = DateTime.parse('$dueDate $dueTime');
    return dueDateTime.difference(now);
  }

  String formatDuration(Duration duration) {
    if (duration.isNegative) {
      return "Overdue";
    } else {
      int days = duration.inDays;
      int hours = duration.inHours % 24;
      int minutes = duration.inMinutes % 60;
      return '${days}d ${hours}h ${minutes}m';
    }
  }
}
