import java.util.*;

public class Student {
    public static List<Student> allStudents=new ArrayList<>();
    private String name;
    private String password;
    private int studentID;
    private int courseCount=0; // dars ha
    private int signedUnits=0; //vahed ha
    private double totalAverage=0;
    private int currentAverage=0;

    public Student(String name, String password, int studentID) {
        this.name = name;
        this.password = password;
        this.studentID = studentID;
        allStudents.add(this);
    }

    Map<Course,Double> courses =new HashMap<>();

    public Student(String name, int studentID) {
        this.name = name;
        this.studentID = studentID;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Student student = (Student) o;
        return studentID == student.studentID && Objects.equals(name, student.name);
    }

    @Override
    public int hashCode() {
        return Objects.hash(name, studentID);
    }

    public void printCourses(){
        int number=1;
        for (Course c : courses.keySet()) {
            System.out.println(number+"- "+c.name);
            number++;
        }
    }

    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
    public void printTotalAverage(){
        System.out.println("Student's total Average : "+totalAverage);
    }
    public void printSignedUnits(){
        System.out.println("Studen't Signed Units : "+signedUnits);
    }

    public int getCourseCount() {
        return courseCount;
    }

    public void setCourseCount(int courseCount) {
        this.courseCount = courseCount;
    }

    public int getSignedUnits() {
        return signedUnits;
    }

    public void setSignedUnits(int signedUnits) {
        this.signedUnits = signedUnits;
    }

    public double getTotalAverage() {
        int sum=0;
        for (double score: courses.values()) {
            sum+=score;
        }
        totalAverage=sum/ courses.size();
        return totalAverage;
    }

    public void setTotalAverage(int totalAverage) {
        this.totalAverage = totalAverage;
    }

    public int getCurrentAverage() {
        return currentAverage;
    }

    public void setCurrentAverage(int currentAverage) {
        this.currentAverage = currentAverage;
    }

    public int getStudentID() {
        return studentID;
    }

    public void setStudentID(int studentID) {
        this.studentID = studentID;
    }
    public void addCourse(Course crs){ //add course to Student.
        if (!courses.keySet().contains(crs)) {
            courseCount++;
            signedUnits += crs.units;
            courses.put(crs, 0.0);
        }
    }
    public void removeCourse(Course crs){
        if (courses.keySet().contains(crs)){
            courseCount--;
            signedUnits-= crs.units;
            courses.remove(crs);
            System.out.println("Course removed successfully");
        }
        else {
            System.out.println("Unavailable Course");
        }
    }
    public static void deleteStudent(Student student){
        allStudents.remove(student);
        //TODO
    }
    public static boolean checkValidID(int studentID){
        for (Student student:allStudents) {
            if (student.studentID==studentID)
                return true;
        }
        return false;
    }
}
