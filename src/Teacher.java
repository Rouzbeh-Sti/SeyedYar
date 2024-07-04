import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

public class Teacher {

    public String name=null;
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
    public Teacher(String name, int teacherID,boolean addToFile) {
        this.name = name;
        this.teacherID=teacherID;
        allTeachers.add(this);
        if (addToFile){
        String output=teacherID+","+name;
        FileController.AddToFile(output,"src\\database\\teacherList.txt");
        }
    }
    public void addStudent(Course crs, Student stu){
        if (courses.contains(crs))
            crs.addStudent(stu);
    }
    public void removeStudent(Course crs, Student stu){
        if (courses.contains(crs))
            crs.removeStudent(stu);
    }
    public static void createAssignment(String name, int assignmentID, Course course, String dueDate, String dueTime, String estimatedTime) {
        if (!Assignment.checkValidID(assignmentID)) {
            new Assignment(name, assignmentID, course, dueDate, dueTime, estimatedTime, true);
        }
    }

    public void removeAssignment(Course crs, Assignment asg){
        if (courses.contains(crs))
            crs.removeAssignment(asg);
    }
    public void setScore(Course course,Student student,double score){
        if (courses.contains(course) && course.students.keySet().contains(student)){
            course.students.put(student,score);
            student.addCourse(course,score);

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
    public static void deleteTeacher(Teacher teacher){
        allTeachers.remove(teacher);
    }

    public String getName() {
        return name;
    }
}
