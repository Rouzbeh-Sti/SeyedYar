import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;

public class FileController {
    public static void loadObjects(){
        readTeacherList();
        readCourseList();
        readAssignmentList();
        readStudentList();
    }

    public static void readStudentList() {
        checkFileExists(".\\studentList.txt");
            try(BufferedReader reader=new BufferedReader(new FileReader("studentList.txt"))){
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
        checkFileExists(".\\teacherList.txt");
        try(BufferedReader reader=new BufferedReader(new FileReader("teacherList.txt"))){
            String line;
            String[] info;
            while ((line=reader.readLine())!=null){
                info=line.split(",");
                new Teacher(info[1],Integer.parseInt(info[0]),false);
            }
        }catch (Exception e){
            System.out.println("Errorteacher: "+e.getMessage());
        }
    }
    public static void readCourseList(){
        checkFileExists(".\\courseList.txt");

        try(BufferedReader reader=new BufferedReader(new FileReader("courseList.txt"))){
            String line;
            String[] info;
            while ((line= reader.readLine())!=null){
                info=line.split(",");
                new Course(info[1],Integer.parseInt(info[0]),Teacher.getTeacherById(Integer.parseInt(info[2])),false);
            }
        }catch (Exception e){
            System.out.println("Errorcourse: "+e.getStackTrace());
        }
    }
    public static void readAssignmentList(){
        checkFileExists(".\\assignmentList.txt");
        try(BufferedReader reader=new BufferedReader(new FileReader("assignmentList.txt"))){
            String line;
            String[] info;
            while ((line= reader.readLine())!=null){
                info=line.split(",");
                new Assignment(info[1],Integer.parseInt(info[3]),Course.getCourseById(Integer.parseInt(info[2])),Integer.parseInt(info[0]),false);
            }
        }catch (Exception e){
            System.out.println("Errorassign: "+e.getStackTrace());
        }
    }

    private static void checkFileExists(String filepath) {
        File file=new File(filepath);
        if (!file.exists()){
            try {
                file.createNewFile();
            }catch (Exception e){
                System.out.println("Error: "+e.getStackTrace());
            }
        }
    }

    public static void AddToFile(String input,String fileName){
        try(FileWriter fileWriter=new FileWriter(fileName,true)) {
        fileWriter.write(input+"\n");
        fileWriter.flush();
        }catch (Exception e){
            System.out.println("Error: "+ e.getStackTrace());
        }
    }
    public static void deleteSpecifiedIDFromFile(int ID,String fileName){
        try(BufferedReader reader=new BufferedReader(new FileReader(fileName))){
            FileWriter fr=new FileWriter("temp.txt",false);
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
            BufferedReader reader2=new BufferedReader(new FileReader("temp.txt"));
            FileWriter fr2=new FileWriter(fileName);
            while ((line=reader2.readLine())!=null){
                fr2.write(line+"\n");
                fr2.flush();
            }
            reader2.close();
            new File("temp.txt").delete();
        }catch (Exception e){
            System.out.println("Error: "+ e.getStackTrace());
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
}
