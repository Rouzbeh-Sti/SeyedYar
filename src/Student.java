import com.google.gson.Gson;

import java.io.BufferedReader;
import java.io.FileReader;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

public class Student {
    public static List<Student> allStudents = new ArrayList<>();
    private String name;
    private String password;
    private int studentID;
    private int courseCount = 0; // dars ha
    private int signedUnits = 0; // vahed ha
    private double totalAverage = 0;
    private int currentAverage = 0;

    public Student(String name, String password, int studentID, boolean addToFile) {
        this.name = name;
        this.password = password;
        this.studentID = studentID;
        allStudents.add(this);
        if (addToFile) {
            String output = studentID + "," + password + "," + name + "," + "#";
            FileController.AddToFile(output, "src\\database\\studentList.txt");
        }
    }

    Map<Course, Double> courses = new HashMap<>();

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

    public void printCourses() {
        int number = 1;
        for (Course c : courses.keySet()) {
            System.out.println(number + "- " + c.name);
            number++;
        }
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void printTotalAverage() {
        System.out.println("Student's total Average : " + totalAverage);
    }

    public void printSignedUnits() {
        System.out.println("Studen't Signed Units : " + signedUnits);
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
        int sum = 0;
        for (double score : courses.values()) {
            sum += score;
        }
        totalAverage = sum / courses.size();
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

    public void addCourse(Course crs) {
        if (!courses.keySet().contains(crs)) {
            courseCount++;
            signedUnits += crs.units;
            courses.put(crs, 0.0);
            String coursesToList = "";
            for (Course course : courses.keySet()) {
                coursesToList += course.courseID + "#" + course.students.get(this) + "#";
            }
            FileController.changeSpecifiedField("src\\database\\studentList.txt", this.getStudentID(), 3, coursesToList);
        }
    }

    public void addCourse(Course crs, double score) {
        if (courses.keySet().contains(crs)) {
            courseCount++;
            signedUnits += crs.units;
            crs.students.put(this, score);
            courses.put(crs, score);
            String coursesToList = "";
            for (Course course : courses.keySet()) {
                coursesToList += course.courseID + "#" + course.students.get(this) + "#";
            }
            FileController.changeSpecifiedField("src\\database\\studentList.txt", this.getStudentID(), 3, coursesToList);
        }
    }

    public void removeCourse(Course crs) {
        if (courses.keySet().contains(crs)) {
            courseCount--;
            signedUnits -= crs.units;
            courses.remove(crs);
            String coursesToList = "";
            for (Course course : courses.keySet()) {
                coursesToList += course.courseID + "#" + course.students.get(this) + "#";
            }
            FileController.changeSpecifiedField("src\\database\\studentList.txt", this.getStudentID(), 3, coursesToList);
            if (courses.size() == 0) {
                String line;
                String[] info;
                try (BufferedReader reader = new BufferedReader(new FileReader("src\\database\\studentList.txt"))) {
                    while ((line = reader.readLine()) != null) {
                        info = line.split(",");
                        int findID = Integer.parseInt(info[0]);
                        if (findID == this.studentID) {
                            break;
                        }
                    }
                    FileController.deleteSpecifiedIDFromFile(studentID, "src\\database\\studentList.txt");
                    FileController.AddToFile(line + "#", "src\\database\\studentList.txt");
                } catch (Exception e) {
                    System.out.println("ERROR: " + e.getStackTrace());
                }
            }
        }
    }

    public static void deleteStudent(Student student) {
        for (Course course : student.courses.keySet()) {
            course.students.remove(student);
        }
        allStudents.remove(student);
        FileController.deleteSpecifiedIDFromFile(student.studentID, "src\\database\\studentList.txt");
    }

    public static boolean checkValidID(int studentID) {
        for (Student student : allStudents) {
            if (student.studentID == studentID)
                return true;
        }
        return false;
    }

    public static Student getStudentById(int Id) {
        if (checkValidID(Id)) {
            for (Student student : Student.allStudents) {
                if (student.getStudentID() == Id) {
                    return student;
                }
            }
        }
        return null;
    }

    public Map<Course, Double> getCourses() {
        return courses;
    }

    public static void studentSingUp(int studentID, String password, String name) {
        new Student(name, password, studentID, true);
    }

    public static int studentLogin(int studentID, String password) {
        if (!allStudents.contains(getStudentById(studentID))) {
            return 0; // invalid id
        } else if (getStudentById(studentID).password.equals(password)) {
            // login successful
            return 2;
        } else {
            return 1;
            // invalid password
        }
    }

    public static String toJson(Student student) {
        Gson gson = new Gson();
        return gson.toJson(student);
    }

    public static Student fromJson(String jsonString) {
        Gson gson = new Gson();
        return gson.fromJson(jsonString, Student.class);
    }

    public String getDataAsString() {
        return toJson(this);
    }

    public int getTotalUnits() {
        int totalUnits = 0;
        for (Course course : courses.keySet()) {
            totalUnits += course.units;
        }
        return totalUnits;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public double calculateOverallScore() {
        double totalScore = 0;
        int totalUnits = 0;
        for (Course course : courses.keySet()) {
            totalScore += courses.get(course) * course.units;
            totalUnits += course.units;
        }
        return totalUnits == 0 ? 0 : totalScore / totalUnits;
    }
    public double getHighestScore() {
        return courses.values().stream().max(Double::compareTo).orElse(0.0);
    }

    public double getLowestScore() {
        return courses.values().stream().min(Double::compareTo).orElse(0.0);
    }

    public int getNumberOfAssignments() {
        int numberOfAssignments = 0;
        for (Course course : courses.keySet()) {
            numberOfAssignments += Assignment.getAssignmentsByCourse(course.getCourseID()).size();
        }
        return numberOfAssignments;
    }

    public int getNumberOfTasks() {
        int numberOfTasks = 0;
        for (Task task : Task.allTasks) {
            if (task.forStudentID == this.studentID) {
                numberOfTasks++;
            }
        }
        return numberOfTasks;
    }

    public int getNumberOfCourses() {
        return courses.size();
    }

    public int getNumberOfAssignmentsPastDue() {
        int numberOfPastDueAssignments = 0;
        Date now = new Date();
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        for (Course course : courses.keySet()) {
            for (Assignment assignment : Assignment.getAssignmentsByCourse(course.getCourseID())) {
                try {
                    Date dueDate = dateFormat.parse(assignment.dueDate + " " + assignment.dueTime);
                    if (dueDate.before(now)) {
                        numberOfPastDueAssignments++;
                    }
                } catch (ParseException e) {
                    e.printStackTrace();
                }
            }
        }
        return numberOfPastDueAssignments;
    }
}
