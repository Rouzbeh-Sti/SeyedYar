import java.util.*;

public class Course {
    public String name;
    public int courseID;
    public Teacher teacher;
    public static List<Course> allCourses = new ArrayList<>();
    public int units;
    public boolean isActive;
    public int assignmentCount = 0;
    public String quizDate;
    public int studentsCount = 0;
    Map<Student, Double> students = new HashMap<>();
    List<Assignment> assignments = new ArrayList<>();

    public Course(String name, int courseID, Teacher teacher, int units, boolean addToList) {
        this.name = name;
        this.courseID = courseID;
        this.teacher = teacher;
        this.units = units;
        allCourses.add(this);
        teacher.courses.add(this);
        if (addToList) {
            String output = courseID + "," + name + "," + teacher.getTeacherID() + "," + units;
            FileController.AddToFile(output, "src\\database\\courseList.txt");
        }
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Course course = (Course) o;
        return courseID == course.courseID;
    }

    @Override
    public int hashCode() {
        return Objects.hash(courseID);
    }


    public void addStudent(Student stu) {
        if (!students.keySet().contains(stu)) {
            students.put(stu, 0.0);
            stu.addCourse(this);
        }
    }

    public void removeStudent(Student stu) {
        students.remove(stu);
        stu.removeCourse(this);
    }
    public void addAssignment(Assignment asg) {
        assignments.add(asg);
    }

    public void removeAssignment(Assignment asg) {
        if (assignments.contains(asg)) {
            assignments.remove(asg);
            Assignment.allAssignments.remove(asg);
        }
    }

    public void changeDeadline(Assignment as, String newDate, String newTime) {
        for (int i = 0; i < assignments.size(); i++) {
            if (assignments.get(i).equals(as)) {
                assignments.get(i).changeDeadline(newDate, newTime);
                break;
            }
        }
    }

    public static void deleteCourse(Course course) {
        for (Assignment assignment : course.assignments) {
            Assignment.allAssignments.remove(assignment);
            FileController.deleteSpecifiedIDFromFile(assignment.assignmentID, "src\\database\\assignmentList.txt");
        }
        for (Student student : course.students.keySet()) {
            student.courses.remove(course);
        }
        course.teacher.courses.remove(course);
        allCourses.remove(course);
        FileController.deleteSpecifiedIDFromFile(course.courseID, "src\\database\\courseList.txt");
    }

    public static boolean checkValidID(int courseID) {
        for (Course course : allCourses) {
            if (course.courseID == courseID)
                return true;
        }
        return false;
    }

    public int getCourseID() {
        return courseID;
    }

    public static Course getCourseById(int Id) {
        if (checkValidID(Id)) {
            for (Course course : Course.allCourses) {
                if (course.getCourseID() == Id) {
                    return course;
                }
            }
        }
        return null;
    }

    public Teacher getTeacher() {
        return teacher;
    }

    public List<Assignment> getAssignments() {
        return assignments;
    }
}
