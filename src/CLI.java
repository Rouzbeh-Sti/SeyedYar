import java.util.Scanner;

public class CLI {
    public static void main(String[] args) throws Exception {
        printWelcome();
        printAdminOrTeacher();
    }

    public static void printAdminOrTeacher() throws Exception {
        Scanner scanner = new Scanner(System.in);
        boolean check = true;
        int input;
        do {
            System.out.println("You are Admin or Teacher?");
            System.out.println("1 - Admin");
            System.out.println("2 - Teacher");
            input = scanner.nextInt();
            if (input == 1 || input == 2)
                check = false;
            clearScreen();

        }while (check);
        if (input==1)
            adminMenu();
        if (input == 2) {
            clearScreen();
        }
        int ID;
        boolean condition = true;
        do {
            System.out.println("please enter your ID:");
            ID = scanner.nextInt();
            if (Teacher.checkValidID(ID)) {
                condition = false;
                System.out.println("Login Successful !");
                Thread.sleep(1000);
            } else {
                System.out.println("ERROR: Invalid ID");
                Thread.sleep(1500);
            }
            clearScreen();
        } while (condition);
        Teacher thisTeacher = null;
        for (Teacher teacher : Teacher.allTeachers) {
            if (teacher.getTeacherID() == ID)
                thisTeacher = teacher;
        }
        teacherMenu(thisTeacher);
        scanner.close();
    }



    public static void printWelcome()throws Exception{
        System.out.println("Welcome!");
        Thread.sleep(1500);
        clearScreen();
    }
    public static void clearScreen(){
        System.out.print("\033[H\033[2J");
        System.out.flush();
    }
    public static void wrongInput()throws Exception{
        clearScreen();
        System.out.println("Wrong Input!");
        Thread.sleep(1000);
        clearScreen();
    }
    public static void adminMenu()throws Exception{
        Scanner scanner=new Scanner(System.in);
        boolean check=true;
        int input=0;
        do {
            System.out.println("Choose an operation : ");
            System.out.println("1 - Create a Teacher");
            System.out.println("2 - Create a Student");
            System.out.println("3 - Create a Course");
            System.out.println("4 - Delete a Course");
            System.out.println("5 - Create a Assignment");
            System.out.println("6 - Add a student to a course");
            System.out.println("7 - Remove a student from a course");
            System.out.println("8 - Set a student score in a course");
            input=scanner.nextInt();
            if (input>=1 && input<=8)
                check=false;
            clearScreen();
        }while (check);
        switch (input){
            case 1:
                boolean checkValidID=true;
                do {
                System.out.println("Create a Teacher : \n");
                System.out.println("Enter Teacher's name : ");
                scanner.nextLine();
                String name=scanner.nextLine();
                System.out.println("Enter Teacher's ID : ");
                int teacherID= scanner.nextInt();
                if (Teacher.checkValidID(teacherID)){
                    System.out.println("ERROR: ID Already Exist.");
                    Thread.sleep(1500);
                   }else {
                    clearScreen();
                    Admin.createTeacher(name,teacherID);
                    System.out.println("Teacher Created !");
                    checkValidID=false;
                    Thread.sleep(1000);
                    clearScreen();
                }
                }while (checkValidID);
                break;
            case 2:
                //2
                break;
            case 3:
                //3
                break;
            case 4:
                //4
                break;
            case 5:
                //5
                break;
            case 6:
                //6
                break;
            case 7:
                //7
                break;
            case 8:
                //8
                break;
        }
        adminMenu();
    }

    public static void teacherMenu(Teacher teacher){
        Scanner scanner=new Scanner(System.in);
        boolean check = true;
        int input;
        do {
            System.out.println("Choose an operation : ");
            System.out.println("1 - Add a student to a course");
            System.out.println("2 - Remove a student from a course");
            System.out.println("3 - Set a student score in a course");
            System.out.println("6 - Create a Assignment");
            System.out.println("7 - Remove a Assignment");
            System.out.println("8 - Change a Deadline Assignment");
            input=scanner.nextInt();
            if (input>=1 && input<=8)
                check = false;
            clearScreen();
        }while (check);
        switch (input){
            case 1:
                boolean condition = true;
                int courseId;
                do {
                    System.out.println("please enter your desired courseId");
                    courseId = scanner.nextInt();
                    if (Course.getCourseById(courseId).getTeacher().equals(teacher)){
                        condition = false;
                    }
                }while (condition);
                condition = true;
                do {
                    System.out.println("please enter your desired studentId");
                    int studentId = scanner.nextInt();
                    if (Student.getStudentById(studentId).getCourses().containsKey(Course.getCourseById(courseId))){
                        condition = false;
                        teacher.addStudent(Course.getCourseById(courseId), Student.getStudentById(studentId));
                    }
                }while (condition);
                break;
            case 2:

                break;
            case 3:
                //3
                break;
            case 4:
                //4
                break;
            case 5:
                //5
                break;
            case 6:
                //6
                break;
            case 7:
                //7
                break;
            case 8:
                //8
                break;
        }
        teacherMenu(teacher);
    }
}
