import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
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


    public Student(String name, String password, int studentID,boolean addToFile) {
        this.name = name;
        this.password = password;
        this.studentID = studentID;
        allStudents.add(this);
        if (addToFile){
            String output=studentID+","+password+","+name+","+"#";
            FileController.AddToFile(output,"src\\database\\studentList.txt");
        }
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
    public void addCourse(Course crs){
        if (!courses.keySet().contains(crs)) {
            courseCount++;
            signedUnits += crs.units;
            courses.put(crs, 0.0);
            String coursesToList="";
            for (Course course: courses.keySet()) {
                coursesToList+=course.courseID+"#"+course.students.get(this)+"#";
             }
            FileController.changeSpecifiedField("src\\database\\studentList.txt",this.getStudentID(),3,coursesToList);
          }
        }
        public void addCourse(Course crs,double score){
        if (courses.keySet().contains(crs)) {
            courseCount++;
            signedUnits += crs.units;
            crs.students.put(this,score);
            courses.put(crs, score);
            String coursesToList="";
            for (Course course: courses.keySet()) {
                coursesToList+=course.courseID+"#"+course.students.get(this)+"#";
             }
            FileController.changeSpecifiedField("src\\database\\studentList.txt",this.getStudentID(),3,coursesToList);
          }
        }
    public void removeCourse(Course crs){
        if (courses.keySet().contains(crs)){
            courseCount--;
            signedUnits-= crs.units;
            courses.remove(crs);
            String coursesToList="";
            for (Course course: courses.keySet()) {
                coursesToList+=course.courseID+"#"+course.students.get(this)+"#";
            }
            FileController.changeSpecifiedField("src\\database\\studentList.txt",this.getStudentID(),3,coursesToList);
            if (courses.size()==0){
                String line;
                String[] info;
                try(BufferedReader reader=new BufferedReader(new FileReader("src\\database\\studentList.txt"))){
                    while ((line=reader.readLine())!=null){
                        ;
                        info=line.split(",");
                        int findID=Integer.parseInt(info[0]);
                        if (findID==this.studentID){
                            break;
                        }
                    }
                    FileController.deleteSpecifiedIDFromFile(studentID,"src\\database\\studentList.txt");
                    FileController.AddToFile(line+"#","src\\database\\studentList.txt");
                }catch (Exception e){
                    System.out.println("ERROR: "+e.getStackTrace());
                }
            }
        }
    }
    public static void deleteStudent(Student student){
        for (Course course :student.courses.keySet()) {
            course.students.remove(student);
        }
        allStudents.remove(student);
        FileController.deleteSpecifiedIDFromFile(student.studentID,"src\\database\\studentList.txt");
    }
    public static boolean checkValidID(int studentID){
        for (Student student:allStudents) {
            if (student.studentID==studentID)
                return true;
        }
        return false;
    }
    public static Student getStudentById(int Id){
        if(checkValidID(Id)){
            for(Student student : Student.allStudents){
                if(student.getStudentID() == Id){
                    return student;
                }
            }
        }
        return null;
    }

    public Map<Course, Double> getCourses() {
        return courses;
    }
    public static void studentSingUp(int studentID,String password,String name){
        new Student(name,password,studentID,true);
    }
    public static int studentLogin(int studentID,String password){
        FileController.readStudentList();
        if (!allStudents.contains(getStudentById(studentID))){
            //invalid id
            return 1;
        } else if (getStudentById(studentID).password.equals(password)) {
            // login successfull
            return 2;
        }else {
            return 3;
            // invalid password
        }
    }

}

