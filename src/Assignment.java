import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

public class Assignment {
    public String name;
    public int deadLineDays;
    public Course course;


    public int assignmentID;
    public boolean isActive=true;
    public static List<Assignment> allAssignments=new ArrayList<>();
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

    public Assignment(String name, int deadLineDays, Course course,int assignmentID) {
        this.name = name;
        this.deadLineDays = deadLineDays;
        this.course=course;
        this.assignmentID=assignmentID;
        allAssignments.add(this);
    }
    public void setCourse(Course course) {
        this.course = course;
    }

    public void changeDeadLine(int newDays){
        deadLineDays=newDays;
        if (newDays<=0)
            isActive=false;
        if (!isActive && newDays>0)
            isActive=true;
    }
    public static void deleteAssignment(Assignment assignment){
        allAssignments.remove(assignment);
        //TODO
    }
    public static boolean checkValidID(int assignmentID){
        for (Assignment assignment :allAssignments) {
            if (assignment.assignmentID==assignmentID)
                return true;
        }
        return false;
    }

    public int getAssignmentID() {
        return assignmentID;
    }
    public static Assignment getAssignmentById(int Id){
        if(checkValidID(Id)){
            for(Assignment assignment : Assignment.allAssignments){
                if(assignment.getAssignmentID() == Id){
                    return assignment;
                }
            }
        }
        return null;
    }

    public void setDeadLineDays(int deadLineDays) {
        this.deadLineDays = deadLineDays;
    }
}
