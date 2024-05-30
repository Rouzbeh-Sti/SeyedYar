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


    public Assignment(String name, int deadLineDays, Course course,int assignmentID,boolean addToFile) {
        this.name = name;
        this.deadLineDays = deadLineDays;
        this.course=course;
        this.assignmentID=assignmentID;
        course.addAssignment(this);
        if (deadLineDays<=0)
            isActive=false;
        allAssignments.add(this);
        if (addToFile){
            String output=assignmentID+","+name+","+course.courseID+","+deadLineDays;
            FileController.AddToFile(output,"src\\database\\assignmentList.txt");
        }
    }
    public void changeDeadLine(int newDays){
        FileController.changeSpecifiedField("src\\database\\assignmentList.txt",this.assignmentID,3,String.valueOf(newDays));
        deadLineDays=newDays;
        if (newDays<=0)
            isActive=false;
        if (!isActive && newDays>0)
            isActive=true;
    }
    public static void deleteAssignment(Assignment assignment){
        assignment.course.removeAssignment(assignment);
        allAssignments.remove(assignment);
        FileController.deleteSpecifiedIDFromFile(assignment.assignmentID,"src\\database\\assignmentList.txt");
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
}
