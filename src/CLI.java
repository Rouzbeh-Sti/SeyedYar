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

    public static void teacherMenu(Teacher teacher) throws InterruptedException {
        Scanner scanner=new Scanner(System.in);
        boolean check = true;
        int input;
        do {
            System.out.println("Choose an operation : ");
            System.out.println("1 - Add a student to a course");
            System.out.println("2 - Remove a student from a course");
            System.out.println("3 - Set a student score in a course");
            System.out.println("4 - Create a Assignment");
            System.out.println("5 - Remove a Assignment");
            System.out.println("6 - Change a Deadline Assignment");
            input=scanner.nextInt();
            if (input>=1 && input<=8)
                check = false;
            clearScreen();
        }while (check);
        boolean condition;
        int courseId;
        int studentId;
        switch (input){
            case 1://Back to main menu button
                condition = true;
                //Duplicated code
                do {
                    System.out.println("Please enter your desired courseId or '0' to back to main menu :");
                    courseId = scanner.nextInt();
                    if (Course.getCourseById(courseId).getTeacher().equals(teacher)){
                        condition = false;
                    }
                    else{
                        System.out.println("You don't have this course");
                        Thread.sleep(1500);
                    }
                    clearScreen();
                }while (condition);
                condition = true;
                do {
                    System.out.println("Please enter your desired studentId");
                    studentId = scanner.nextInt();
                    if (Student.checkValidID(studentId)){
                        condition = false;
                        teacher.addStudent(Course.getCourseById(courseId), Student.getStudentById(studentId));
                    }
                    else {
                        System.out.println("This Student Doesn't exist");
                        Thread.sleep(1500);
                    }
                    clearScreen();
                }while (condition);
                break;
            case 2:
                condition = true;
                do {
                    System.out.println("Please enter your desired courseId");
                    courseId = scanner.nextInt();
                    if (Course.getCourseById(courseId).getTeacher().equals(teacher)){
                        condition = false;
                    }
                    else{
                        System.out.println("You don't have this course");
                        Thread.sleep(1500);
                    }
                    clearScreen();
                }while (condition);
                condition = true;
                do {
                    System.out.println("Please enter your desired studentId");
                    studentId = scanner.nextInt();
                    if (Student.getStudentById(studentId).getCourses().containsKey(Course.getCourseById(courseId))){
                        condition = false;
                        teacher.removeStudent(Course.getCourseById(courseId), Student.getStudentById(studentId));
                    }
                }while (condition);
                Thread.sleep(1500);
                clearScreen();
                break;
            case 3:
                condition = true;
                do {
                    System.out.println("Please enter your desired courseId");
                    courseId = scanner.nextInt();
                    if (Course.getCourseById(courseId).getTeacher().equals(teacher)){
                        condition = false;
                    }
                    else{
                        System.out.println("You don't have this course");
                        Thread.sleep(1500);
                    }
                }while (condition);
                condition = true;
                do {
                    System.out.println("Please enter your desired studentId");
                    studentId = scanner.nextInt();
                    if (Student.getStudentById(studentId).getCourses().containsKey(Course.getCourseById(courseId))){
                        condition = false;
                    }
                }while (condition);
                condition = true;
                do{
                    System.out.println("Please enter your desired score");
                    int score = scanner.nextInt();
                    if (score <= 20 && score >= 0){
                        condition = false;
                        teacher.setScore(Course.getCourseById(courseId), Student.getStudentById(studentId), score);
                    }
                }while(condition);
                Thread.sleep(1500);
                clearScreen();
                break;
            case 4:
                condition = true;
                do{
                    System.out.println("Please enter your desired courseId for assignment : ");
                    courseId = scanner.nextInt();
                    if (Course.getCourseById(courseId).getTeacher().equals(teacher)){
                        condition = false;
                    }
                    else{
                        System.out.println("You don't have this course");
                        Thread.sleep(1500);
                    }
                }while (condition);
                condition = true;
                int assignmentId;
                do{
                    System.out.println("please enter assignmentId :");
                    assignmentId = scanner.nextInt();
                    if(Assignment.checkValidID(assignmentId)){
                        System.out.println("This Assignment already exist");
                        condition = false;
                    }
                }while (condition);
                System.out.println("please enter a name for assignment :");
                String assignmentName = scanner.nextLine();
                System.out.println("please enter a deadLine for assignment :");
                int deadLine = scanner.nextInt();
                new Assignment(assignmentName, deadLine, Course.getCourseById(courseId), assignmentId);
                break;
            case 5:
                condition = true;
                do{
                    System.out.println("Please enter your desired courseId for assignment : ");
                    courseId = scanner.nextInt();
                    if (Course.getCourseById(courseId).getTeacher().equals(teacher)){
                        condition = false;
                    }
                    else{
                        System.out.println("You don't have this course");
                        Thread.sleep(1500);
                    }
                }while (condition);
                condition = true;
                do{
                    System.out.println("please enter assignmentId :");
                    assignmentId = scanner.nextInt();
                    if(Course.getCourseById(courseId).getAssignments().contains(Assignment.getAssignmentById(assignmentId))){
                        Course.getCourseById(courseId).removeAssignment(Assignment.getAssignmentById(assignmentId));
                        condition = false;
                    }
                }while (condition);
                break;
            case 6:
                condition = true;
                do{
                    System.out.println("please enter your assignment : ");
                    assignmentId = scanner.nextInt();
                    if (Assignment.allAssignments.contains(Assignment.getAssignmentById(assignmentId))){
                        System.out.println("Please enter a newDeadLine");
                        int deadLineAssignment = scanner.nextInt();
                        Assignment.getAssignmentById(assignmentId).setDeadLineDays(deadLineAssignment);
                    }
                }while (condition);
                break;
        }
        teacherMenu(teacher);
    }
}
