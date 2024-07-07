import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

public class Task {
    String title;
    boolean isActive;
    int forStudentID;
    String dateTime;
    public static List<Task> allTasks = new ArrayList<>();

    public Task(String title, boolean isActive, int forStudentID, String dateTime, boolean addToFile) {
        this.forStudentID = forStudentID;
        this.title = title;
        this.isActive = isActive;
        this.dateTime = dateTime;
        allTasks.add(this);
        if (addToFile) {
            String output = title + "," + isActive + "," + forStudentID + "," + dateTime;
            FileController.AddToFile(output, "src\\database\\taskList.txt");
        }
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Task task = (Task) o;
        return forStudentID == task.forStudentID && Objects.equals(title, task.title);
    }

    @Override
    public int hashCode() {
        return Objects.hash(title, forStudentID);
    }

    public static Task getTaskByNameAndID(String taskName, int studentID) {
        for (Task task : Task.allTasks) {
            if (task.title.equals(taskName) && task.forStudentID == studentID) {
                return task;
            }
        }
        return null;
    }

    public static boolean checkValidName(String taskName, int studentID) {
        return getTaskByNameAndID(taskName, studentID) != null;
    }
    public void updateDateTime(String newDateTime) {
        this.dateTime = newDateTime;
        FileController.updateTaskDateTime(this);
    }



    public static void deleteTask(Task task) {
        allTasks.remove(task);
        FileController.deleteSpecifiedTask(task.title, task.forStudentID);
    }

    public static void updateTask(Task task, boolean isActive) {
        task.isActive = isActive;
        FileController.updateTask(task, isActive);
    }
}
