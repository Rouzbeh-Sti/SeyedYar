import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

public class Course {
    public String name;
    public Teacher teacher;
    public int units;

    public Course(String name) {
        this.name = name;
    }

    public boolean isActive;
    public int assignmentCount=0;
    public String quizDate;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Course course = (Course) o;
        return Objects.equals(name, course.name);
    }

    @Override
    public int hashCode() {
        return Objects.hash(name);
    }

    public int studentsCount=0;
    List<Student> students=new ArrayList<>();
    List<Assignment> assignments=new ArrayList<>();
    public void printStudents(){
        for (int i = 0; i < students.size(); i++) {
            System.out.println((i+1)+"- "+students.get(i).getName());
        }
    }
    public void addStudent(Student stu){
        students.add(stu);
        stu.addCourse(this);
        System.out.println("Student added successfully");
    }
    public void removeStudent(Student stu){
        if (students.contains(stu)){
            students.remove(stu);
            stu.removeCourse(this);
            System.out.println("Student removed from the course.");
        }
        else {
            System.out.println("this student doesn't have the course");
        }
    }
    public Double topScore(){
        Double topScore=students.get(0).scores.get(this);
        for (int i = 0; i < students.size(); i++) {
            if (topScore<students.get(i).scores.get(this))
                topScore=students.get(i).scores.get(this);
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
        assignments.get(index).deadLineDays=day;
    }
}
