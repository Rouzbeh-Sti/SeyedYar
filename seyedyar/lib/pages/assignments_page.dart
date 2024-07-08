import 'dart:io';
import 'package:flutter/material.dart';
import 'package:seyedyar/StudentAssignment.dart';
import 'package:file_picker/file_picker.dart';

class AssignmentPage extends StatefulWidget {
  final int studentID;

  AssignmentPage({required this.studentID});

  @override
  _AssignmentPageState createState() => _AssignmentPageState();
}

class _AssignmentPageState extends State<AssignmentPage> {
  List<StudentAssignment> assignments = [];
  String? selectedFileName;
  @override
  void initState() {
    super.initState();
    fetchAssignments();
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        selectedFileName = result.files.single.name;
      });
    }
  }

  Future<void> fetchAssignments() async {
    try {
      final socket = await Socket.connect('192.168.1.199', 8080);
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
            assignments = [];
          });
        } else {
          List<String> assignmentsData = data.split(";");
          List<StudentAssignment> fetchedAssignments = assignmentsData
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
            assignments = fetchedAssignments;
            sortAssignments();
          });
        }
      } else {
        throw Exception(response.split('~')[1]);
      }
    } catch (e) {
      throw Exception('Failed to load assignments: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Color(0xFFD8F3DC),
        body: assignments.isEmpty
            ? Center(child: Text('No assignments available'))
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
          color: Color.fromARGB(255, 168, 223, 171),
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
                  buildDetailRow('Title:', assignment.name),
                  buildDetailRow('Course:', assignment.courseName),
                  buildDetailRow('Due Date:', assignment.dueDate),
                  buildDetailRow('Due Time:', assignment.dueTime),
                  buildDetailRow(
                      'Status:', assignment.isActive ? "Active" : "Inactive"),
                  buildDetailRow('Score:', assignment.score.toString()),
                  buildEditableRow(
                      context,
                      'Estimated Time:',
                      estimatedTimeController,
                      assignment.estimatedTime, (value) {
                    updateEstimatedTime(context, assignment, value);
                  }),
                  buildEditableRow(context, 'Description:',
                      descriptionController, assignment.description, (value) {
                    updateDescription(context, assignment, value);
                  }),
                  buildEditableRow(
                      context,
                      'Giving Description:',
                      givingDescriptionController,
                      assignment.givingDescription, (value) {
                    updateGivingDescription(context, assignment, value);
                  }),
                  SizedBox(height: 20),
                  buildUploadButton(),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: Text(value, style: TextStyle(fontSize: 16)),
        ),
      ],
    );
  }

  Widget buildEditableRow(
      BuildContext context,
      String label,
      TextEditingController controller,
      String initialValue,
      Function(String) onSave) {
    return Row(
      children: [
        Expanded(
          child: Text(label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: Container(
            width: 120,
            child: TextFormField(
              controller: controller,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                errorStyle: TextStyle(height: 0),
                contentPadding: EdgeInsets.symmetric(vertical: 10),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.check),
                      onPressed: () {
                        onSave(controller.text);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        setState(() {
                          controller.text = initialValue;
                        });
                      },
                    ),
                  ],
                ),
              ),
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Cannot be empty';
                }
                return null;
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget buildUploadButton() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                pickFile();
              },
              child: Text(
                'Upload File',
                style: TextStyle(color: Colors.black),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
        if (selectedFileName != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Selected file: $selectedFileName',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ),
      ],
    );
  }

  Future<void> updateEstimatedTime(BuildContext context,
      StudentAssignment assignment, String estimatedTime) async {
    await sendUpdate(context, assignment, 'estimatedTime', estimatedTime);
  }

  Future<void> updateDescription(BuildContext context,
      StudentAssignment assignment, String description) async {
    await sendUpdate(context, assignment, 'description', description);
  }

  Future<void> updateGivingDescription(BuildContext context,
      StudentAssignment assignment, String givingDescription) async {
    await sendUpdate(
        context, assignment, 'givingDescription', givingDescription);
  }

  void updateAssignmentStatus(
      BuildContext context, StudentAssignment assignment, bool isActive) async {
    try {
      final socket = await Socket.connect('192.168.1.199', 8080);
      socket.write(
          "UPDATE: studentAssignment~${widget.studentID}~${assignment.assignmentID}~isActive~$isActive\u0000");

      await socket.flush();

      List<int> responseBytes = [];
      await socket.listen((data) {
        responseBytes.addAll(data);
      }).asFuture();
      String response = String.fromCharCodes(responseBytes).trim();

      if (response.startsWith("200~")) {
        setState(() {
          assignment.isActive = isActive;
          sortAssignments();
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Assignment status updated successfully')));
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

  Future<void> sendUpdate(BuildContext context, StudentAssignment assignment,
      String field, String value) async {
    try {
      final socket = await Socket.connect('192.168.1.199', 8080);
      socket.write(
          "UPDATE: studentAssignment~${widget.studentID}~${assignment.assignmentID}~$field~$value\u0000");
      await socket.flush();

      List<int> responseBytes = [];
      await socket.listen((data) {
        responseBytes.addAll(data);
      }).asFuture();
      String response = String.fromCharCodes(responseBytes).trim();

      if (response.startsWith("200~")) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$field updated successfully')));
        setState(() {
          switch (field) {
            case 'estimatedTime':
              assignment.setEstimatedTime(value);
              break;
            case 'description':
              assignment.setDescription(value);
              break;
            case 'givingDescription':
              assignment.setGivingDescription(value);
              break;
          }
          sortAssignments();
        });
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response.split("~")[1])));
      }
      socket.close();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to update $field: $e')));
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
