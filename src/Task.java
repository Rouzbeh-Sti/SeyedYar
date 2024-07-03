import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

public class Task {
    String title;
    boolean isDone;
    int forStudentID;
    public static List<Task> allTasks=new ArrayList<>();

    public Task(String title, boolean isDone,int forStudentID,boolean addToFile) {
        this.forStudentID=forStudentID;
        this.title = title;
        this.isDone = isDone;
        allTasks.add(this);
        if (addToFile){
            String output=title+","+isDone;
            FileController.AddToFile(output,"src\\database\\taskList.txt");
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

    public static Task getTaskByName(String taskName){
        if(checkValidName(taskName)){
            for(Task task : Task.allTasks){
                if(task.title.equals(taskName)){
                    return task;
                }
            }
        }
        return null;
    }

    public static boolean checkValidName(String taskName) {
        for (Task task :allTasks) {
            if (task.equals(getTaskByName(taskName)))
                return true;
        }
        return false;
    }
    public static void deleteTask(Task task){
        allTasks.remove(task);
        FileController.deleteSpecifiedTask(task.title);
    }
}
