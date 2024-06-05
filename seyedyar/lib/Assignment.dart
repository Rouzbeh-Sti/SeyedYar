import 'Course.dart';

class Assignment {
  String name;
  int deadLineDays;
  Course course;
  int assignmentID;
  bool isActive = true;
  static List<Assignment> allAssignments = [];

  Assignment({
    required this.name,
    required this.deadLineDays,
    required this.course,
    required this.assignmentID,
  });
}