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
            System.out.println("6 - Delete a Assignment");
            System.out.println("7 - Add a student to a course");
            System.out.println("8 - Remove a student from a course");
            System.out.println("9 - Set a student score in a course");
            System.out.println("10 - Back to main menu");
            input=scanner.nextInt();
            if (input>=1 && input<=10)
                check=false;
            clearScreen();
        }while (check);
        boolean checkValidID=true;
        switch (input){
            case 1:
                 checkValidID=true;
                do {
                System.out.println("Create a Teacher. \n");
                System.out.println("Enter Teacher's name : ");
                scanner.nextLine();
                String name=scanner.nextLine();
                System.out.println("Enter Teacher's ID : ");
                int teacherID= scanner.nextInt();
                if (Teacher.checkValidID(teacherID)){
                    clearScreen();
                    System.out.println("ERROR: ID Already Exist.");
                    Thread.sleep(1500);
                   }else {
                    clearScreen();
                    Admin.createTeacher(name,teacherID);
                    System.out.println("Teacher Created !");
                    checkValidID=false;
                    Thread.sleep(1000);
                }
                clearScreen();
                }while (checkValidID);
                adminMenu();
                break;
            case 2:
                 checkValidID=true;
                do {
                    System.out.println("Create a Student. \n");
                    System.out.println("Enter Student's name : ");
                    scanner.nextLine();
                    String name=scanner.nextLine();
                    System.out.println("Enter Student's ID : ");
                    int studentID= scanner.nextInt();
                    System.out.println("Enter Student's Password : ");
                    String studentPassword= scanner.next();
                    if (Student.checkValidID(studentID)){
                        System.out.println("ERROR: ID Already Exist.");
                        Thread.sleep(1500);
                    }else {
                        clearScreen();
                        Admin.createStudent(studentID,studentPassword,name);
                        System.out.println("Student Created !");
                        checkValidID=false;
                        Thread.sleep(1000);
                    }
                    clearScreen();
                }while (checkValidID);
                adminMenu();
                break;
            case 3:
                checkValidID=true;
                do {
                    System.out.println("Create a Course. \n");
                    System.out.println("Enter Course's name : ");
                    scanner.nextLine();
                    String name=scanner.nextLine();
                    System.out.println("Enter Course's ID : ");
                    int courseID= scanner.nextInt();
                    System.out.println("Enter Course's TeacherID : ");
                    int teacherID= scanner.nextInt();
                    if (Course.checkValidID(courseID)){
                        clearScreen();
                        System.out.println("ERROR: CourseID Already Exist.");
                        Thread.sleep(1500);
                    } else if (Teacher.checkValidID(teacherID)) {
                        clearScreen();
                        System.out.println("ERROR: TeacherID Already Exist.");
                        Thread.sleep(1500);
                    } else {
                        clearScreen();
                        Admin.createCourse(name,Teacher.getTeacherById(teacherID),courseID);
                        System.out.println("Course Created !");
                        checkValidID=false;
                        Thread.sleep(1000);
                    }
                    clearScreen();
                }while (checkValidID);
                adminMenu();
                break;
            case 4:
                checkValidID=true;
                do {
                    System.out.println("Delete a Course \n");
                    System.out.println("Enter Course's ID : ");
                    int courseID= scanner.nextInt();
                    if (Course.checkValidID(courseID)==false){
                        System.out.println("CourseID not valid");
                    }else {
                        clearScreen();
                        Admin.deleteCourse(Course.getCourseById(courseID));
                        System.out.println("Course Deleted !");
                        checkValidID=false;
                        Thread.sleep(1000);
                    }
                    clearScreen();
                }while (checkValidID);
                adminMenu();
                break;
            case 5:
                checkValidID=true;
                do {
                    System.out.println("Create a Assignment. \n");
                    System.out.println("Enter Assignment's name : ");
                    scanner.nextLine();
                    String name=scanner.nextLine();
                    System.out.println("Enter Assignment's ID : ");
                    int assignmentID= scanner.nextInt();
                    System.out.println("Enter Assignment's CourseID : ");
                    int courseID= scanner.nextInt();
                    System.out.println("Enter Assignment's Deadline : ");
                    int deadline= scanner.nextInt();
                    if (Assignment.checkValidID(assignmentID)){
                        clearScreen();
                        System.out.println("ERROR: Assignment ID Already Exist.");
                        Thread.sleep(1500);
                    } else if (!Course.checkValidID(courseID)) {
                        clearScreen();
                        System.out.println("ERROR: Course ID is not valid.");
                        Thread.sleep(1500);
                    } else if (deadline<=0) {
                        clearScreen();
                        System.out.println("Deadline invalid");
                        Thread.sleep(1500);
                    } else {
                        clearScreen();
                        Admin.createAssignment(name,deadline,Course.getCourseById(courseID),assignmentID);
                        System.out.println("Assignment Created !");
                        checkValidID=false;
                        Thread.sleep(1000);
                    }
                    clearScreen();
                }while (checkValidID);
                adminMenu();
                break;
            case 6:
                checkValidID=true;
                do {
                    System.out.println("Delete a Assignment. \n");
                    System.out.println("Enter Assignment's ID : ");
                    int assignmentID= scanner.nextInt();
                    if (!Assignment.checkValidID(assignmentID)){
                        clearScreen();
                        System.out.println("ERROR: Assignment ID not valid.");
                        Thread.sleep(1500);
                    } else {
                        clearScreen();
                        Admin.deleteAssignment(Assignment.getAssignmentById(assignmentID));
                        System.out.println("Assignment Deleted !");
                        checkValidID=false;
                        Thread.sleep(1000);
                    }
                    clearScreen();
                }while (checkValidID);
                adminMenu();
                break;
            case 7:
                checkValidID=true;
                do {
                    System.out.println("Add a student to a course \n");
                    System.out.println("Enter Student's ID : ");
                    int studentID= scanner.nextInt();
                    System.out.println("Enter Course's ID : ");
                    int courseID= scanner.nextInt();
                    if (!Student.checkValidID(studentID)){
                        System.out.println("StudentID is not valid");
                    } else if (!Course.checkValidID(courseID)) {
                        System.out.println("CourseID is not valid");
                    } else {
                        clearScreen();
                        Admin.addStudentToCourse(Student.getStudentById(studentID),Course.getCourseById(courseID));
                        System.out.println("Student added to course !");
                        checkValidID=false;
                        Thread.sleep(1000);
                    }
                    clearScreen();
                }while (checkValidID);
                adminMenu();
                break;
            case 8:
                checkValidID=true;
                do {
                    System.out.println("Remove a student from a course \n");
                    System.out.println("Enter Student's ID : ");
                    int studentID= scanner.nextInt();
                    System.out.println("Enter Course's ID : ");
                    int courseID= scanner.nextInt();
                    if (!Student.checkValidID(studentID)){
                        clearScreen();
                        System.out.println("StudentID is not valid");
                        Thread.sleep(1500);
                    } else if (!Course.checkValidID(courseID)) {
                        System.out.println("CourseID is not valid");
                        Thread.sleep(1500);
                    } else if (!(Student.getStudentById(studentID).courses.keySet().contains(Course.getCourseById(courseID)) && Course.getCourseById(courseID).students.keySet().contains(Student.getStudentById(studentID)))) {
                        clearScreen();
                        System.out.println("This Student doesn't have this Course");
                        Thread.sleep(1500);
                    } else {
                        clearScreen();
                        Admin.removeStudentFromCourse(Student.getStudentById(studentID),Course.getCourseById(courseID));
                        System.out.println("Student removed from course !");
                        checkValidID=false;
                        Thread.sleep(1000);
                    }
                    clearScreen();
                }while (checkValidID);
                adminMenu();
                break;
            case 9:
                
                break;
            case 10:
                clearScreen();
                printAdminOrTeacher();
                break;
        }
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
            System.out.println("4 - Create a Assignment");
            System.out.println("5 - Remove a Assignment");
            System.out.println("6 - Change a Deadline Assignment");
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
                    System.out.println("Please enter your desired courseId");
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
