class StudentAssignment {
  final int assignmentID;
  final int studentID;
  final String name;
  final String courseName;
  final String dueDate;
  final String dueTime;
  String estimatedTime;
  bool isActive;
  String description;
  String givingDescription;
  double score;

  StudentAssignment({
    required this.assignmentID,
    required this.studentID,
    required this.name,
    required this.courseName,
    required this.dueDate,
    required this.dueTime,
    required this.estimatedTime,
    required this.isActive,
    required this.description,
    required this.givingDescription,
    required this.score,
  });

  void setEstimatedTime(String value) {
    estimatedTime = value;
  }

  void setDescription(String value) {
    description = value;
  }

  void setGivingDescription(String value) {
    givingDescription = value;
  }
}
