class Student {
  static List<Student> allStudents = [];
  String name;
  String password;
  int studentID;
  int courseCount = 0;
  int signedUnits = 0;
  double totalAverage = 0;
  int currentAverage = 0;

  Student({
    required this.name,
    required this.password,
    required this.studentID,
  });
}
