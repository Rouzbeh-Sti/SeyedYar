import java.io.*;
import java.util.ArrayList;
import java.util.List;

public class FileController {
    public static void loadObjects() {
        File file = new File("src\\database");
        if (!file.exists())
            file.mkdir();
        readTeacherList();
        readCourseList();
        readAssignmentList();
        readStudentAssignmentList();
        readStudentList();
        readTaskList();
    }

    private static void readTaskList() {
        checkFileExists("src\\database\\taskList.txt");
        try (BufferedReader reader = new BufferedReader(new FileReader("C:\\Users\\smmah\\OneDrive\\Desktop\\Ap_project\\AP-Flutter-Project\\src\\database\\taskList.txt"))) {
            String line;
            String[] info;
            while ((line = reader.readLine()) != null) {
                info = line.split(",");
                new Task(info[0], Boolean.parseBoolean(info[1]), Integer.parseInt(info[2]), info[3], false); // include dateTime
            }
        } catch (Exception e) {
            System.out.println("Error: " + e.getMessage());
            e.printStackTrace();
        }
    }


    public static void readStudentList() {
        checkFileExists("src\\database\\studentList.txt");
            try(BufferedReader reader=new BufferedReader(new FileReader("src\\database\\studentList.txt"))){
                String line;
                String[] info;
                String[] coursesAndScores;
                while ((line= reader.readLine())!=null){
                    info=line.split(",");
                    Student student=new Student(info[2],info[1],Integer.parseInt(info[0]),false);
                    coursesAndScores=info[3].split("#");
                    for (int i = 0; i < coursesAndScores.length; i+=2) {
                        int courseID=Integer.parseInt(coursesAndScores[i]);
                        double score=Double.parseDouble(coursesAndScores[i+1]);
                        Admin.addStudentToCourse(student,Course.getCourseById(courseID));
                        Admin.setStudentScore(student,Course.getCourseById(courseID),score);
                    }
                }
            }catch (Exception e){
                System.out.println("Error: student "+e.getMessage());
            }
    }

    public static void readTeacherList(){
        checkFileExists("src\\database\\teacherList.txt");
        try(BufferedReader reader=new BufferedReader(new FileReader("src\\database\\teacherList.txt"))){
            String line;
            String[] info;
            while ((line=reader.readLine())!=null){
                info=line.split(",");
                new Teacher(info[1],Integer.parseInt(info[0]),false);
            }
        }catch (Exception e){
            System.out.println("Errorteacher: "+e.getStackTrace());
        }
    }
    public static void readCourseList(){
        checkFileExists("src\\database\\courseList.txt");

        try(BufferedReader reader=new BufferedReader(new FileReader("src\\database\\courseList.txt"))){
            String line;
            String[] info;
            while ((line= reader.readLine())!=null){
                info=line.split(",");
                new Course(info[1],Integer.parseInt(info[0]),Teacher.getTeacherById(Integer.parseInt(info[2])),0,false);
            }
        }catch (Exception e){
            System.out.println("Errorcourse: "+e.getStackTrace());
        }
    }
    public static void readAssignmentList() {
        checkFileExists("src\\database\\assignmentList.txt");
        try (BufferedReader reader = new BufferedReader(new FileReader("src\\database\\assignmentList.txt"))) {
            String line;
            String[] info;
            while ((line = reader.readLine()) != null) {
                info = line.split(",");
                String name = info[1];
                int assignmentID = Integer.parseInt(info[0]);
                Course course = Course.getCourseById(Integer.parseInt(info[2]));
                String dueDate = info[3];
                String dueTime = info[4];
                String estimatedTime = info[5];
                boolean isActive = Boolean.parseBoolean(info[6]);
                String description = info.length > 7 ? info[7] : "";
                String givingDescription = info.length > 8 ? info[8] : "";
                double score = info.length > 9 ? Double.parseDouble(info[9]) : 0.0;

                Assignment assignment = new Assignment(name, assignmentID, course, dueDate, dueTime, estimatedTime, false);
                assignment.description = description;
                assignment.givingDescription = givingDescription;
                assignment.score = score;
                assignment.isActive = isActive;
            }
        } catch (Exception e) {
            System.out.println("Errorassignment: " + e.getStackTrace());
        }
    }
    public static void readStudentAssignmentList() {
        checkFileExists("src\\database\\studentAssignmentList.txt");
        try (BufferedReader reader = new BufferedReader(new FileReader("src\\database\\studentAssignmentList.txt"))) {
            String line;
            String[] info;
            while ((line = reader.readLine()) != null) {
                info = line.split(",");
                new StudentAssignment(
                        Integer.parseInt(info[0]),
                        Integer.parseInt(info[1]),
                        info[2],
                        Boolean.parseBoolean(info[3]),
                        info[4],
                        info[5],
                        Double.parseDouble(info[6]),
                        false
                );
            }
        } catch (Exception e) {
            System.out.println("Error reading student assignments: " + e.getMessage());
        }
    }

    private static void checkFileExists(String filepath) {
        File file=new File(filepath);
        if (!file.exists()){
            try {
                file.createNewFile();
            }catch (Exception e){
                System.out.println("Error check file exist: "+e.getMessage());
            }
        }
    }

    public static void AddToFile(String input,String fileName){
        try(FileWriter fileWriter = new FileWriter(fileName,true)) {
        fileWriter.write(input+"\n");
        fileWriter.flush();
        }catch (Exception e){
            System.out.println("Error: "+ e.getStackTrace());
            e.printStackTrace();
        }
    }
    public static void deleteSpecifiedIDFromFile(int ID,String fileName){
        try(BufferedReader reader=new BufferedReader(new FileReader(fileName))){
            FileWriter fr=new FileWriter("src\\database\\temp.txt",false);
            String line;
            while ((line= reader.readLine())!=null){
                int lineID= Integer.parseInt(line.split(",")[0]);
                if (lineID!=ID){
                    fr.write(line+"\n");
                    fr.flush();
                }
            }
            fr.close();
            deleteFileContent(fileName);
            BufferedReader reader2=new BufferedReader(new FileReader("src\\database\\temp.txt"));
            FileWriter fr2=new FileWriter(fileName);
            while ((line=reader2.readLine())!=null){
                fr2.write(line+"\n");
                fr2.flush();
            }
            reader2.close();
            new File("src\\database\\temp.txt").delete();
        }catch (Exception e){
            System.out.println("Error: "+ e.getStackTrace());
        }
    }
    public static void updateTaskDateTime(Task task) {
        List<String> fileContent = new ArrayList<>();
        try (BufferedReader reader = new BufferedReader(new FileReader("src\\database\\taskList.txt"))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] info = line.split(",");
                if (info[0].equals(task.title) && Integer.parseInt(info[2]) == task.forStudentID) {
                    info[3] = task.dateTime;
                    fileContent.add(String.join(",", info));
                } else {
                    fileContent.add(line);
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        try (BufferedWriter writer = new BufferedWriter(new FileWriter("src\\database\\taskList.txt"))) {
            for (String line : fileContent) {
                writer.write(line);
                writer.newLine();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public static void deleteFileContent(String fileName){
        try(FileWriter fileWriter=new FileWriter(fileName,false)){
            fileWriter.write("");
            fileWriter.flush();
        }catch (Exception e){
            System.out.println("Error: "+ e.getMessage());
        }
    }
    public static void changeSpecifiedField(String filename,int ID,int fieldNum,String newField) {
        try (BufferedReader reader = new BufferedReader(new FileReader(filename))) {
            String line;
            String[] info;
            String specifiedLine="";
            while ((line = reader.readLine()) != null) {
                info = line.split(",");
                if (Integer.parseInt(info[0]) == ID)
                    specifiedLine = line;
            }
            info = specifiedLine.split(",");
            info[fieldNum]=newField;
            deleteSpecifiedIDFromFile(ID,filename);
            String output="";
            for (int i = 0; i < info.length; i++) {
                output+=info[i];
                if (i!=info.length-1){
                    output+=",";
                }
            }
            AddToFile(output,filename);
        } catch (Exception e) {
            System.out.println("Error: " + e.getMessage());
        }
    }
    public synchronized static void changeStudentAssignmentField(int assignmentID, int studentID, int fieldNum, String newField) {
        try (BufferedReader reader = new BufferedReader(new FileReader("src\\database\\studentAssignmentList.txt"))) {
            List<String> lines = new ArrayList<>();
            String line;
            while ((line = reader.readLine()) != null) {
                String[] info = line.split(",");
                if (Integer.parseInt(info[0]) == assignmentID && Integer.parseInt(info[1]) == studentID) {
                    info[fieldNum] = newField;
                    line = String.join(",", info);
                }
                lines.add(line);
            }
            try (FileWriter writer = new FileWriter("src\\database\\studentAssignmentList.txt", false)) {
                for (String ln : lines) {
                    writer.write(ln + "\n");
                }
            }
        } catch (Exception e) {
            System.out.println("Error: " + e.getMessage());
        }
    }
    public static void deleteStudentAssignmentFromFile(int studentID, int assignmentID, String fileName) {
        try (BufferedReader reader = new BufferedReader(new FileReader(fileName))) {
            FileWriter fr = new FileWriter("src\\database\\temp.txt", false);
            String line;
            while ((line = reader.readLine()) != null) {
                String[] info = line.split(",");
                int fileStudentID = Integer.parseInt(info[0]);
                int fileAssignmentID = Integer.parseInt(info[1]);
                if (fileStudentID != studentID || fileAssignmentID != assignmentID) {
                    fr.write(line + "\n");
                    fr.flush();
                }
            }
            fr.close();
            deleteFileContent(fileName);
            BufferedReader reader2 = new BufferedReader(new FileReader("src\\database\\temp.txt"));
            FileWriter fr2 = new FileWriter(fileName);
            while ((line = reader2.readLine()) != null) {
                fr2.write(line + "\n");
                fr2.flush();
            }
            reader2.close();
            new File("src\\database\\temp.txt").delete();
        } catch (Exception e) {
            System.out.println("Error: " + e.getMessage());
        }
    }
    public static void deleteSpecifiedTask(String taskName,int studentID){
        try(BufferedReader reader=new BufferedReader(new FileReader("src\\database\\taskList.txt"))){
            FileWriter fr=new FileWriter("src\\database\\temp.txt",false);
            String line;
            while ((line= reader.readLine())!=null){
                String lineName= line.split(",")[0];
                int taskStudentID=Integer.parseInt(line.split(",")[2]);
                if (!(lineName.equals(taskName) && taskStudentID==studentID)){
                    fr.write(line+"\n");
                    fr.flush();
                }
            }
            fr.close();
            deleteFileContent("src\\database\\taskList.txt");
            BufferedReader reader2=new BufferedReader(new FileReader("src\\database\\temp.txt"));
            FileWriter fr2=new FileWriter("src\\database\\taskList.txt");
            while ((line=reader2.readLine())!=null){
                fr2.write(line+"\n");
                fr2.flush();
            }
            reader2.close();
            new File("src\\database\\temp.txt").delete();
        }catch (Exception e){
            System.out.println("Error: "+ e.getStackTrace());
        }
    }
    public static void updateTask(Task task,boolean isActive){
        String taskTitle= task.title;
        int studentID= task.forStudentID;
        try (BufferedReader reader = new BufferedReader(new FileReader("src\\database\\taskList.txt"))) {
            String line;
            String[] info;
            String specifiedLine="";
            while ((line = reader.readLine()) != null) {
                info = line.split(",");
                if (info[0].equals(taskTitle) && Integer.parseInt(info[2])==studentID)
                    specifiedLine = line;
            }
            info = specifiedLine.split(",");
            info[1]=String.valueOf(isActive);
            deleteSpecifiedTask(taskTitle,studentID);
            String output="";
            for (int i = 0; i < info.length; i++) {
                output+=info[i];
                if (i!=info.length-1){
                    output+=",";
                }
            }
            AddToFile(output,"src\\database\\taskList.txt");
        } catch (Exception e) {
            System.out.println("Error: " + e.getMessage());
        }
    }

}
