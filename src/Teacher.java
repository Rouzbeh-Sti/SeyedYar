import java.util.ArrayList;
import java.util.List;

public class Teacher {
    private String name=null;

    public Teacher(String name) {
        this.name = name;
    }

    private int coursesCount=0;
    List<Course> courses=new ArrayList<>();
    public void addStudent(Course crs, Student stu){
        if (courses.contains(crs))
            crs.addStudent(stu);
    }
    public void removeStudent(Course crs, Student stu){
        if (courses.contains(crs))
            crs.removeStudent(stu);
    }
    public void addAssignment(Course crs,Assignment asg){
        if (courses.contains(crs))
            crs.addAssignment(asg);
    }
    public void removeAssignment(Course crs, Assignment asg){
        if (courses.contains(crs))
            crs.removeAssignment(asg);
    }
    public void setScore(Course crs,Student stu,double score){
        if (courses.contains(crs) && crs.students.contains(stu)){
            stu.scores.put(crs,score);
        }
        else System.out.println("Error !");
    }
    public void addCourse(Course crs){
        crs.teacher=this;
        courses.add(crs);
        coursesCount++;
    }
    public void removeCourse(Course crs){
        crs.teacher=null;
        courses.remove(crs);
        coursesCount--;
    }
    public void changeDeadLine(Course crs, Assignment as1, int day){
        if (courses.contains(crs) && crs.assignments.contains(as1)){
            crs.changeDeadLine(as1,day);
        }
    }
}
