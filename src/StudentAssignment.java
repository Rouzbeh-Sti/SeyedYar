import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class StudentAssignment {
    public static List<StudentAssignment> allStudentAssignments = new ArrayList<>();
    private String assignmentName;

    private int assignmentID;
    private int studentID;
    private String estimatedTime;
    private boolean isActive;
    private String description;
    private String givingDescription;
    private double score;

    public StudentAssignment(int assignmentID, int studentID, String estimatedTime, boolean isActive, String description, String givingDescription, double score, boolean addToFile) {
        this.assignmentID = assignmentID;
        this.studentID = studentID;
        this.assignmentName = Assignment.getAssignmentById(assignmentID).name;
        this.estimatedTime = estimatedTime;
        this.isActive = isActive;
        this.description = description;
        this.givingDescription = givingDescription;
        this.score = score;
        allStudentAssignments.add(this);
        if (addToFile) {
            String output = assignmentID + "," + studentID + "," + estimatedTime + "," + isActive + "," + description + "," + givingDescription + "," + score + "," + assignmentName;
            FileController.AddToFile(output, "src\\database\\studentAssignmentList.txt");
        }
    }
    public int getAssignmentID() {
        return assignmentID;
    }

    public String getAssignmentName() {
        Assignment assignment = Assignment.getAssignmentById(this.assignmentID);
        return assignment != null ? assignment.name : "";
    }

    public String getCourseName() {
        Assignment assignment = Assignment.getAssignmentById(this.assignmentID);
        return assignment != null ? assignment.course.name : "";
    }

    public String getDueDate() {
        Assignment assignment = Assignment.getAssignmentById(this.assignmentID);
        return assignment != null ? assignment.dueDate : "";
    }

    public String getDueTime() {
        Assignment assignment = Assignment.getAssignmentById(this.assignmentID);
        return assignment != null ? assignment.dueTime : "";
    }

    public String getEstimatedTime() {
        return estimatedTime;
    }

    public boolean getIsActive() {
        return isActive;
    }

    public String getDescription() {
        return description;
    }

    public String getGivingDescription() {
        return givingDescription;
    }

    public double getScore() {
        return score;
    }
    public static StudentAssignment getStudentAssignment(int studentID, int assignmentID) {
        for (StudentAssignment sa : allStudentAssignments) {
            if (sa.studentID == studentID && sa.assignmentID == assignmentID) {
                return sa;
            }
        }
        return null;
    }
    public static List<StudentAssignment> getAssignmentsForStudent(int studentID) {
        List<StudentAssignment> studentAssignments = new ArrayList<>();
        try (BufferedReader reader = new BufferedReader(new FileReader("src/database/studentAssignmentList.txt"))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] parts = line.split(",");
                if (Integer.parseInt(parts[1]) == studentID) {
                    studentAssignments.add(new StudentAssignment(
                            Integer.parseInt(parts[0]),
                            studentID,
                            parts[2],
                            Boolean.parseBoolean(parts[3]),
                            parts[4],
                            parts[5],
                            Double.parseDouble(parts[6]),false
                    ));
                }
            }
        } catch (IOException e) {
            System.out.println("Error reading student assignments: " + e.getMessage());
        }
        return studentAssignments;
    }

    public void setEstimatedTime(String estimatedTime) {
        this.estimatedTime = estimatedTime;
        FileController.changeStudentAssignmentField(this.assignmentID, this.studentID, 2, estimatedTime);
    }

    public void setActive(boolean isActive) {
        this.isActive = isActive;
        FileController.changeStudentAssignmentField(this.assignmentID, this.studentID, 3, String.valueOf(isActive));
    }

    public void setDescription(String description) {
        this.description = description;
        FileController.changeStudentAssignmentField(this.assignmentID, this.studentID, 4, description);
    }

    public void setGivingDescription(String givingDescription) {
        this.givingDescription = givingDescription;
        FileController.changeStudentAssignmentField(this.assignmentID, this.studentID, 5, givingDescription);
    }

    public void setScore(double score) {
        this.score = score;
        FileController.changeStudentAssignmentField(this.assignmentID, this.studentID, 6, String.valueOf(score));
    }}
