import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

public class Teacher {
    private String name=null;
    private int teacherID;
    private int coursesCount=0;
    List<Course> courses=new ArrayList<>();
    public static List<Teacher> allTeachers=new ArrayList<>();

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Teacher teacher = (Teacher) o;
        return teacherID == teacher.teacherID;
    }

    @Override
    public int hashCode() {
        return Objects.hash(teacherID);
    }

    public Teacher(String name, int teacherID) {
        this.name = name;
        this.teacherID=teacherID;
        allTeachers.add(this);
    }

    public void addStudent(Course crs, Student stu){
        if (courses.contains(crs))
            crs.addStudent(stu);
    }
    public void removeStudent(Course crs, Student stu){
        if (courses.contains(crs))
            crs.removeStudent(stu);
    }
    public void createAssignment(String name, int deadLineDays, Course course,int assignmentID){
        if (courses.contains(course) && Assignment.checkValidID(assignmentID))
            course.addAssignment(new Assignment(name,deadLineDays,course,assignmentID));
    }
    public void removeAssignment(Course crs, Assignment asg){
        if (courses.contains(crs))
            crs.removeAssignment(asg);
    }
    public void setScore(Course crs,Student stu,double score){
        if (courses.contains(crs) && crs.students.keySet().contains(stu)){
            stu.courses.put(crs,score);
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
    public static boolean checkValidID(int teacherID){
        for (Teacher teacher :allTeachers) {
            if (teacher.teacherID==teacherID)
                return true;
        }
        return false;
    }

    public int getTeacherID() {
        return teacherID;
    }
    public static Teacher getTeacherById(int Id){
        if(checkValidID(Id)){
            for(Teacher teacher : Teacher.allTeachers){
                if(teacher.getTeacherID() == Id){
                    return teacher;
                }
            }
        }
        return null;
    }

}
