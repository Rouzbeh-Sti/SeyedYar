import 'Assignment.dart';
import 'Student.dart';
import 'Teacher.dart';
class Course {
  String name;
  int courseID;
  Teacher teacher;
  static List<Course> allCourses = [];
  int units;
  bool isActive;
  int assignmentCount = 0;
  int studentsCount = 0;
  Map<Student, double> students = {};
  List<Assignment> assignments = [];

  Course({
    required this.name,
    required this.courseID,
    required this.teacher,
    required this.units,
    required this.isActive,
    });
}