public class Admin {
    public static void createTeacher(String name, int teacherID){
        Teacher teacher=new Teacher(name,teacherID,true);
        //TODO
    }
    public static void deleteTeacher(Teacher teacher){
            Teacher.deleteTeacher(teacher);
    }
    public static void createStudent(int studentID,String password,String name){
        new Student(name,password,studentID,true);
        //TODO
    }
    public static void deleteStudent(Student student){
            Student.deleteStudent(student);
        //TODO
    }
    public static void createCourse(String name,Teacher teacher,int courseID){
        Course course=new Course(name,courseID,teacher,true);
        //TODO
    }
    public static void deleteCourse(Course course){
        if (Course.allCourses.contains(course)){
            Course.deleteCourse(course);
        }
        //TODO
    }
    public static void createAssignment(String name, int deadLineDays, Course course,int assignmentID){
        if (!Assignment.checkValidID(assignmentID)) {
            Assignment assignment = new Assignment(name, deadLineDays, course, assignmentID,true);
        }
        //TODO
    }
    public static void deleteAssignment(Assignment assignment){
        if (Assignment.allAssignments.contains(assignment)){
            Assignment.deleteAssignment(assignment);
        }
        //TODO
    }
    public static void addStudentToCourse(Student student,Course course){
        course.addStudent(student);
    }
    public static void setStudentScore(Student student,Course course,Double score){
        if (student.courses.keySet().contains(course)){
            student.addCourse(course,score);
            course.students.put(student,score);
        }
    }
    public static void removeStudentFromCourse(Student student,Course course){
        course.removeStudent(student);
    }
    public static void changeAssignmentDeadline(Assignment assignment,int newDeadline){
        assignment.changeDeadLine(newDeadline);
    }
}
