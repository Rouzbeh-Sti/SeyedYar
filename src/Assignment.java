import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

public class Assignment {
    public String name;
    public String dueDate;
    public String dueTime;
    public Course course;
    public String estimatedTime;
    public int assignmentID;
    public boolean isActive = true;
    public String description;
    public String givingDescription;
    public double score = 0.0;
    public static List<Assignment> allAssignments = new ArrayList<>();

    public Assignment(String name, int assignmentID, Course course, String dueDate, String dueTime, String estimatedTime, boolean addToFile) {
        this.name = name;
        this.assignmentID = assignmentID;
        this.course = course;
        this.dueDate = dueDate;
        this.dueTime = dueTime;
        this.estimatedTime = estimatedTime;
        this.description = "";
        this.givingDescription = "";
        allAssignments.add(this);
        course.addAssignment(this);
        if (addToFile) {
            String output = assignmentID + "," + name + "," + course.courseID + "," + dueDate + "," + dueTime + "," + estimatedTime + "," + isActive + "," + description + "," + givingDescription + "," + score;
            FileController.AddToFile(output, "src\\database\\assignmentList.txt");
        }
        for (Student student : course.students.keySet()) {
            new StudentAssignment(assignmentID, student.getStudentID(), estimatedTime, true, "", "", 0,true);
        }
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Assignment that = (Assignment) o;
        return assignmentID == that.assignmentID;
    }

    @Override
    public int hashCode() {
        return Objects.hash(assignmentID);
    }

    public void changeDeadline(String newDueDate, String newDueTime) {
        this.dueDate = newDueDate;
        this.dueTime = newDueTime;
        FileController.changeSpecifiedField("src\\database\\assignmentList.txt", this.assignmentID, 3, newDueDate);
        FileController.changeSpecifiedField("src\\database\\assignmentList.txt", this.assignmentID, 4, newDueTime);
    }

    public static void deleteAssignment(Assignment assignment) {
        assignment.course.removeAssignment(assignment);
        allAssignments.remove(assignment);
        FileController.deleteSpecifiedIDFromFile(assignment.assignmentID, "src\\database\\assignmentList.txt");
    }

    public static boolean checkValidID(int assignmentID) {
        for (Assignment assignment : allAssignments) {
            if (assignment.assignmentID == assignmentID)
                return true;
        }
        return false;
    }

    public int getAssignmentID() {
        return assignmentID;
    }

    public static Assignment getAssignmentById(int Id) {
        if (checkValidID(Id)) {
            for (Assignment assignment : Assignment.allAssignments) {
                if (assignment.getAssignmentID() == Id) {
                    return assignment;
                }
            }
        }
        return null;
    }

    public void setEstimatedTime(String estimatedTime) {
        this.estimatedTime = estimatedTime;
    }


    public void setDescription(String description) {
        this.description = description;
        FileController.changeSpecifiedField("src\\database\\assignmentList.txt", this.assignmentID, 7, description);
    }



    public static List<Assignment> getAssignmentsByCourse(int courseID) {
        List<Assignment> courseAssignments = new ArrayList<>();
        for (Assignment assignment : allAssignments) {
            if (assignment.course.getCourseID() == courseID) {
                courseAssignments.add(assignment);
            }
        }
        return courseAssignments;
    }
}