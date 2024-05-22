import java.util.*;

public class Course {
    public String name;
    public int courseID;
    public Teacher teacher;
    public static List<Course> allCourses=new ArrayList<>();
    public int units;
    public boolean isActive;
    public int assignmentCount=0;
    public String quizDate;
    public int studentsCount=0;
    Map<Student,Double> students=new HashMap<>();
    List<Assignment> assignments=new ArrayList<>();

    public Course(String name,int courseID) {
        this.name = name;
        this.courseID=courseID;
        allCourses.add(this);
    }

    public Course(String name, int courseID, Teacher teacher) {
        this.name = name;
        this.courseID = courseID;
        this.teacher = teacher;
        allCourses.add(this);
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

    public void printStudents(){
        List<Student> temp=students.keySet().stream().toList();
        for (int i = 0; i < temp.size(); i++) {
            System.out.println((i+1)+"- "+temp.get(i).getName());
        }
    }
    public void addStudent(Student stu){
        if (!students.keySet().contains(stu)) {
            students.put(stu, 0.0);
            stu.addCourse(this);
            System.out.println("Student added successfully");
        }
    }
    public void removeStudent(Student stu){
        if (students.keySet().contains(stu)){
            students.remove(stu);
            stu.removeCourse(this);
            System.out.println("Student removed from the course.");
        }
        else {
            System.out.println("this student doesn't have the course");
        }
    }
    public Double topScore(){
        List<Student> temp=students.keySet().stream().toList();
        Double topScore=temp.get(0).courses.get(this);
        for (Student student : temp) {
            if (topScore < student.courses.get(this))
                topScore = student.courses.get(this);
        }
        return topScore;
    }
    public void addAssignment(Assignment asg){
        assignments.add(asg);
    }
    public void removeAssignment(Assignment asg){
        if (assignments.contains(asg)) {
            assignments.remove(asg);
            System.out.println("Assignment Removed.");
        }
        else {
            System.out.println("Assignment not valid in this course");
        }
    }
    public void changeDeadLine(Assignment as,int day){
        int index=0;
        for (int i = 0; i < assignments.size(); i++) {
            if (assignments.get(i).equals(as))
                index=i;
        }
        assignments.get(index).changeDeadLine(day);
    }
    public static void deleteCourse(Course course){
        allCourses.remove(course);
        //TODO
    }
}
