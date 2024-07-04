public class Admin {
    public static void createTeacher(String name, int teacherID){
        Teacher teacher=new Teacher(name,teacherID,true);
        //TODO
    }
    public static void deleteTeacher(Teacher teacher){
            Teacher.deleteTeacher(teacher);
            FileController.deleteSpecifiedIDFromFile(teacher.getTeacherID(), "src\\database\\teacherList.txt");
    }
    public static void createStudent(int studentID,String password,String name){
        new Student(name,password,studentID,true);
    }
    public static void deleteStudent(Student student){
            Student.deleteStudent(student);
            FileController.deleteSpecifiedIDFromFile(student.getStudentID(), "src\\database\\studentList.txt");
    }
    public static void createCourse(String name,Teacher teacher,int courseID){
        Course course=new Course(name,courseID,teacher,true);
    }
    public static void deleteCourse(Course course){
        if (Course.allCourses.contains(course)){
            Course.deleteCourse(course);
        }
    }
    public static void createAssignment(String name, int assignmentID, Course course, String dueDate, String dueTime, String estimatedTime) {
        if (!Assignment.checkValidID(assignmentID)) {
            new Assignment(name, assignmentID, course, dueDate, dueTime, estimatedTime, true);
        }
    }


    public static void deleteAssignment(Assignment assignment){
        if (Assignment.allAssignments.contains(assignment)){
            Assignment.deleteAssignment(assignment);
        }
    }
    public static void addStudentToCourse(Student student,Course course){
        course.addStudent(student);
    }
    public static void setStudentScore(Student student,Course course,Double score){
        if (student.courses.keySet().contains(course)){
            course.students.put(student,score);
            student.addCourse(course,score);
        }
    }
    public static void removeStudentFromCourse(Student student,Course course){
        course.removeStudent(student);
    }
    public static void changeAssignmentDeadline(Assignment assignment, String newDueDate, String newDueTime) {
        assignment.changeDeadline(newDueDate, newDueTime);
    }
    public static void changeAssignmentEstimatedTime(Assignment assignment, String newEstimatedTime) {
        assignment.setEstimatedTime(newEstimatedTime);
        FileController.changeSpecifiedField("src\\database\\assignmentList.txt", assignment.getAssignmentID(), 5, newEstimatedTime);
    }
}
