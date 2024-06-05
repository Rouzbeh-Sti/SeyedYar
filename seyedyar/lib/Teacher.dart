import 'Course.dart';

class Teacher {
  String? name;
  int teacherID;
  int coursesCount = 0;
  List<Course> courses = [];
  static List<Teacher> allTeachers = [];

  Teacher({
    this.name,
    required this.teacherID,
  });
}
