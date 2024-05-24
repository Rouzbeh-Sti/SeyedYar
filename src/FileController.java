import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;

public class FileController {
    public static void loadObjects(){
        readTeacherList();
        readCourseList();
    }
    public static void readTeacherList(){
        try(BufferedReader reader=new BufferedReader(new FileReader("teacherList.txt"))){
            String line;
            String[] info;
            while ((line= reader.readLine())!=null){
                info=line.split(",");
                Teacher teacher=new Teacher(info[1],Integer.parseInt(info[0]),false);
            }
        }catch (Exception e){
            System.out.println("Error: "+e.getMessage());
        }
    }    public static void readCourseList(){
        try(BufferedReader reader=new BufferedReader(new FileReader("courseList.txt"))){
            String line;
            String[] info;
            while ((line= reader.readLine())!=null){
                info=line.split(",");
                Course course=new Course(info[1],Integer.parseInt(info[0]),Teacher.getTeacherById(Integer.parseInt(info[2])),false);
            }
        }catch (Exception e){
            System.out.println("Error: "+e.getStackTrace());
        }
    }
    public static void AddToFile(String input,String fileName){
        try(FileWriter fileWriter=new FileWriter(fileName,true)) {
        fileWriter.write(input+"\n");
        fileWriter.flush();
        }catch (Exception e){
            System.out.println("Error: "+ e.getMessage());
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
            System.out.println("Error: "+ e.getMessage());
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
}
