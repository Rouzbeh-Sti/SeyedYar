import java.util.*;

public class Student {
    private String name;

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

    private int courseCount=0; // dars ha
    private int signedUnits=0; //vahed ha
    private double totalAverage=0;
    private int currentAverage=0;
    private int studentID;
    Map<Course,Double> scores=new HashMap<>();
    List<Course> signedCourses =new ArrayList<>();
    public void printCourses(){
        for (int i = 0; i < signedCourses.size(); i++) {
            System.out.println((i+1) + "- "+ signedCourses.get(i).name);
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
        for (double score:scores.values()) {
            sum+=score;
        }
        totalAverage=sum/scores.size();
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
    public void addCourse(Course crs){
        courseCount++;
        signedUnits+= crs.units;
        signedCourses.add(crs);
        scores.put(crs, 0d);
    }
    public void removeCourse(Course crs){
        if (signedCourses.contains(crs)){
            courseCount--;
            signedUnits-= crs.units;
            signedCourses.remove(crs);
            scores.remove(crs);
            System.out.println("Course removed successfully");
        }
        else {
            System.out.println("Unavailable Course");
        }
    }
}
