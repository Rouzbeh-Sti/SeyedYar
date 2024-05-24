import java.util.Scanner;

public class CLI {
    public static void main(String[] args) throws Exception {
        FileController.loadObjects();
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
            System.out.println("please enter your ID or press '0' to back to main menu:");
            ID = scanner.nextInt();
            if(ID == 0){
                clearScreen();
                printAdminOrTeacher();
                return;
            }
            if (Teacher.checkValidID(ID)) {
                Teacher thisTeacher = null;
                for (Teacher teacher : Teacher.allTeachers) {
                    if (teacher.getTeacherID() == ID)
                        thisTeacher = teacher;
                }
                condition = false;
                System.out.println("Login Successful !");
                System.out.println("Welcome dear "+thisTeacher.name);
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
    }
    public static void printWelcome()throws Exception{
        System.out.println("Welcome!");
        Thread.sleep(700);
        clearScreen();
    }
    public static void clearScreen(){
        System.out.print("\033[H\033[2J");
        System.out.flush();
    }
    public static void adminMenu()throws Exception{
        Scanner scanner=new Scanner(System.in);
        boolean check=true;
        int input=0;
        do {
            System.out.println("Choose an operation : ");
            System.out.println("1 - Create a Teacher");
            System.out.println("2 - Delete a Teacher");
            System.out.println("3 - Create a Student");
            System.out.println("4 - Delete a Student");
            System.out.println("5 - Create a Course");
            System.out.println("6 - Delete a Course");
            System.out.println("7 - Create a Assignment");
            System.out.println("8 - Delete a Assignment");
            System.out.println("9 - Change a Assignment's Deadline");
            System.out.println("10 - Add a student to a course");
            System.out.println("11 - Remove a student from a course");
            System.out.println("12 - Set a student score in a course");
            System.out.println("13 - Back to main menu");
            input=scanner.nextInt();
            if (input>=1 && input<=13)
                check=false;
            clearScreen();
        }while (check);
        boolean checkValidID=true;
        switch (input){
            case 1:
                checkValidID=true;
                do {
                System.out.println("Create a Teacher. \n");
                System.out.println("Enter Teacher's name or press '0' button to back to admin menu : ");
                scanner.nextLine();
                String name = scanner.nextLine();
                try{
                if(Integer.parseInt(name) == 0){
                    clearScreen();
                    adminMenu();
                    break;
                }
                }catch (NumberFormatException e){}
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
                do{
                    System.out.println("Delete a Teacher. \n");
                    System.out.println("Enter Teacher's ID or press '0' button to back to admin menu : ");
                    int teacherId = scanner.nextInt();
                    if(teacherId == 0){
                        clearScreen();
                        adminMenu();
                        break;
                    }
                    if(Teacher.checkValidID(teacherId)){
                        Admin.deleteTeacher(Teacher.getTeacherById(teacherId));
                        System.out.println("Teacher Deleted !");
                        checkValidID=false;
                        Thread.sleep(1500);
                    }else {
                        System.out.println("This teacher1 doesn't exist !");
                        Thread.sleep(1500);
                        adminMenu();
                        break;
                    }
                    clearScreen();
                }while (checkValidID);
                adminMenu();
            case 3:
                 checkValidID=true;
                do {
                    System.out.println("Create a Student. \n");
                    System.out.println("Enter Student's name or press '0' button to back to admin menu : ");
                    scanner.nextLine();
                    String name=scanner.nextLine();
                    try{
                        if(Integer.parseInt(name) == 0){
                            clearScreen();
                            adminMenu();
                            break;
                        }
                    }catch (NumberFormatException e){}
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
            case 4:
                checkValidID=true;
                do{
                    System.out.println("Delete a Student. \n");
                    System.out.println("Enter Student's ID or press '0' button to back to admin menu : ");
                    int studentId = scanner.nextInt();
                    if(studentId == 0){
                        clearScreen();
                        adminMenu();
                        break;
                    }
                    if(Student.checkValidID(studentId)){
                        Admin.deleteStudent(Student.getStudentById(studentId));
                        System.out.println("Student Deleted !");
                        checkValidID=false;
                        Thread.sleep(1500);
                    }else {
                        System.out.println("This student doesn't exist !");
                        Thread.sleep(1500);
                        adminMenu();
                        break;
                    }
                    clearScreen();
                }while (checkValidID);
                adminMenu();
            case 5:
                checkValidID=true;
                do {
                    System.out.println("Create a Course. \n");
                    System.out.println("Enter Course's name or press '0' button to back to admin menu : ");
                    scanner.nextLine();
                    String name=scanner.nextLine();
                    try{
                        if(Integer.parseInt(name) == 0){
                            clearScreen();
                            adminMenu();
                            break;
                        }
                    }catch (NumberFormatException e){}
                    System.out.println("Enter Course's ID : ");
                    int courseID= scanner.nextInt();
                    System.out.println("Enter Course's TeacherID : ");
                    int teacherID= scanner.nextInt();
                    if (Course.checkValidID(courseID)){
                        clearScreen();
                        System.out.println("ERROR: CourseID Already Exist.");
                        Thread.sleep(1500);
                    } else if (!Teacher.checkValidID(teacherID)) {
                        clearScreen();
                        System.out.println("ERROR: TeacherID doesn't Exist.");
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
            case 6:
                checkValidID=true;
                do {
                    System.out.println("Delete a Course. \n");
                    System.out.println("Enter Course's ID or press '0' button to back to admin menu : ");
                    int courseID= scanner.nextInt();
                    if(courseID == 0){
                        clearScreen();
                        adminMenu();
                        break;
                    }
                    if (Course.checkValidID(courseID)==false){
                        System.out.println("Course's ID not valid");
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
            case 7:
                checkValidID=true;
                do {
                    System.out.println("Create a Assignment. \n");
                    System.out.println("Enter Assignment's name or press '0' button to back to admin menu : ");
                    scanner.nextLine();
                    String name=scanner.nextLine();
                    try{
                        if(Integer.parseInt(name) == 0){
                            clearScreen();
                            adminMenu();
                            break;
                        }
                    }catch (NumberFormatException e){}
                    System.out.println("Enter Assignment's ID : ");
                    int assignmentID= scanner.nextInt();
                    System.out.println("Enter Assignment's CourseID or press '0' button to back to admin menu : ");
                    int courseID= scanner.nextInt();
                    if(courseID == 0){
                        clearScreen();
                        adminMenu();
                        break;
                    }
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
            case 8:
                checkValidID=true;
                do {
                    System.out.println("Delete a Assignment. \n");
                    System.out.println("Enter Assignment's ID or press '0' button to back to admin menu : ");
                    int assignmentID= scanner.nextInt();
                    if(assignmentID == 0){
                        clearScreen();
                        adminMenu();
                        break;
                    }
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
            case 9:
                checkValidID=true;
                do {
                    System.out.println("Change a Assignment's Deadline : \n");
                    System.out.println("Enter assignment's ID or press '0' button to back to admin menu : ");
                    int assignmentID= scanner.nextInt();
                    if(assignmentID == 0){
                        clearScreen();
                        adminMenu();
                        break;
                    }
                    System.out.println("Enter New Deadline :");
                    int newDeadline=scanner.nextInt();
                    if (!Assignment.checkValidID(assignmentID)){
                        clearScreen();
                        System.out.println("AssignmentID is not valid.");
                        Thread.sleep(1500);
                    }else {
                        clearScreen();
                        Admin.changeAssignmentDeadline(Assignment.getAssignmentById(assignmentID),newDeadline);
                        System.out.println("Assignment deadline has been changed successfully");
                        checkValidID=false;
                        Thread.sleep(1000);
                    }
                    clearScreen();
                }while (checkValidID);
                adminMenu();
                break;
            case 10:
                checkValidID=true;
                do {
                    System.out.println("Add a student to a course \n");
                    System.out.println("Enter Student's ID or press '0' button to back to admin menu : ");
                    int studentID= scanner.nextInt();
                    if(studentID == 0){
                        clearScreen();
                        adminMenu();
                        break;
                    }
                    System.out.println("Enter Course's ID or press '0' button to back to admin menu : ");
                    int courseID= scanner.nextInt();
                    if(courseID == 0){
                        clearScreen();
                        adminMenu();
                        break;
                    }
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
            case 11:
                checkValidID=true;
                do {
                    System.out.println("Remove a student from a course \n");
                    System.out.println("Enter Student's ID or press '0' button to back to admin menu : ");
                    int studentID= scanner.nextInt();
                    if(studentID == 0){
                        clearScreen();
                        adminMenu();
                        break;
                    }
                    System.out.println("Enter Course's ID or press '0' button to back to admin menu : ");
                    int courseID= scanner.nextInt();
                    if(courseID == 0){
                        clearScreen();
                        adminMenu();
                        break;
                    }
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
            case 12:
                checkValidID=true;
                do {
                    System.out.println("Set a student score in a course \n");
                    System.out.println("Enter Student's ID or press '0' button to back to admin menu : ");
                    scanner.nextLine();
                    int studentID=scanner.nextInt();
                    if(studentID == 0){
                        clearScreen();
                        adminMenu();
                        break;
                    }
                    System.out.println("Enter Courses ID or press '0' button to back to admin menu : ");
                    int courseID= scanner.nextInt();
                    if(courseID == 0){
                        clearScreen();
                        adminMenu();
                        break;
                    }
                    System.out.println("Enter Score : ");
                    double score=scanner.nextDouble();
                    if (!Student.checkValidID(studentID)){
                        clearScreen();
                        System.out.println("ERROR: StudentID is not valid !");
                        Thread.sleep(1500);
                    } else if (!Course.checkValidID(courseID)) {
                        clearScreen();
                        System.out.println("ERROR: CourseID is not valid !");
                        Thread.sleep(1500);
                    } else if (!(Student.getStudentById(studentID).courses.keySet().contains(Course.getCourseById(courseID)) && Course.getCourseById(courseID).students.keySet().contains(Student.getStudentById(studentID)))) {
                        clearScreen();
                        System.out.println("This Student doesn't have this Course");
                        Thread.sleep(1500);
                    } else if (score < 0 || score > 20) {
                        clearScreen();
                        System.out.println("ERROR: Score is not valid !");
                        Thread.sleep(1500);
                    } else {
                        clearScreen();
                        Admin.setStudentScore(Student.getStudentById(studentID),Course.getCourseById(courseID),score);
                        System.out.println("Score has been set successfully !");
                        checkValidID=false;
                        Thread.sleep(1000);
                    }
                    clearScreen();
                }while (checkValidID);
                adminMenu();
                break;
            case 13:
                clearScreen();
                printAdminOrTeacher();
                break;
        }
    }

    public static void teacherMenu(Teacher teacher) throws Exception {
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
            System.out.println("6 - Change a Assignment's Deadline");
            System.out.println("7 - back to main menu");
            input = Integer.parseInt(scanner.next());
            if (input>=1 && input<=7)
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
                    System.out.println("Please enter your desired courseId or '0' to back to teacher menu :");
                    courseId = scanner.nextInt();
                    if (courseId == 0){
                        clearScreen();
                        teacherMenu(teacher);
                        break;
                    }
                    if (Course.getCourseById(courseId) == null){
                        System.out.println("Invalid course ID!");
                        clearScreen();
                    }
                    else if (Course.getCourseById(courseId).getTeacher().equals(teacher)){
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
                    System.out.println("Please enter your desired studentId :");
                    studentId = scanner.nextInt();
                    if (Student.checkValidID(studentId)){
                        condition = false;
                        teacher.addStudent(Course.getCourseById(courseId), Student.getStudentById(studentId));
                        System.out.println("Student added to course successfully !");
                        clearScreen();
                        teacherMenu(teacher);
                    }
                    else {
                        System.out.println("This Student Doesn't exist !");
                        Thread.sleep(1500);
                        clearScreen();
                    }
                }while (condition);
                break;
            case 2:
                condition = true;
                do {
                    System.out.println("Please enter your desired courseId or '0' to back to teacher menu :");
                    courseId = scanner.nextInt();
                    if (courseId == 0){
                        clearScreen();
                        teacherMenu(teacher);
                        break;
                    }
                    if (Course.getCourseById(courseId) == null){
                        System.out.println("Invalid course ID !");
                        clearScreen();
                    }
                    else if (Course.getCourseById(courseId).getTeacher().equals(teacher)){
                        condition = false;
                    }
                    else{
                        System.out.println("You don't have this course !");
                        Thread.sleep(1500);
                    }
                    clearScreen();
                }while (condition);
                condition = true;
                do {
                    System.out.println("Please enter your desired studentId : ");
                    studentId = scanner.nextInt();
                    if (Student.getStudentById(studentId) == null){
                        System.out.println("This Student Doesn't exist !");
                    }
                    else if (Student.getStudentById(studentId).getCourses().containsKey(Course.getCourseById(courseId))){
                        condition = false;
                        teacher.removeStudent(Course.getCourseById(courseId), Student.getStudentById(studentId));

                        System.out.println("Student removed successfully !");
                        clearScreen();
                        teacherMenu(teacher);
                    }
                    else{
                        System.out.println("this student doesn't have this course !");
                        condition = false;
                    }
                }while (condition);
                Thread.sleep(1500);
                clearScreen();
                break;
            case 3:
                condition = true;
                do {
                    System.out.println("Please enter your desired courseId or '0' to back to teacher menu :");
                    courseId = scanner.nextInt();
                    if (courseId == 0){
                        clearScreen();
                        teacherMenu(teacher);
                        break;
                    }
                    if(Course.getCourseById(courseId) == null){
                        System.out.println("Invalid course ID !");
                        clearScreen();
                    }
                    else if (Course.getCourseById(courseId).getTeacher().equals(teacher)){
                        condition = false;
                    }
                    else{
                        System.out.println("You don't have this course !");
                        Thread.sleep(1500);
                    }
                }while (condition);
                condition = true;
                do {
                    System.out.println("Please enter your desired studentId or '0' to back to teacher menu :");
                    studentId = scanner.nextInt();
                    if (studentId == 0){
                        clearScreen();
                        teacherMenu(teacher);
                        break;
                    }
                    if (Student.getStudentById(studentId) == null){
                        System.out.println("This Student Doesn't exist !");
                        clearScreen();
                    }
                    else if (Student.getStudentById(studentId).getCourses().containsKey(Course.getCourseById(courseId))){
                        condition = false;
                    }
                    else {
                        System.out.println("This student doesn't have this course !");
                        clearScreen();
                        teacherMenu(teacher);
                        break;
                    }
                }while (condition);
                condition = true;
                do{
                    System.out.println("Please enter your desired score : ");
                    int score = scanner.nextInt();
                    if (score <= 20 && score >= 0){
                        condition = false;
                        teacher.setScore(Course.getCourseById(courseId), Student.getStudentById(studentId), score);
                        System.out.println("This score applied !");
                    }
                }while(condition);
                Thread.sleep(1500);
                clearScreen();
                teacherMenu(teacher);
                break;
            case 4:
                condition = true;
                do{
                    System.out.println("Please enter your desired courseId for assignment or '0' to back to teacher menu : ");
                    courseId = scanner.nextInt();
                    if (courseId == 0){
                        clearScreen();
                        teacherMenu(teacher);
                        break;
                    }
                    if(Course.getCourseById(courseId) == null){
                        System.out.println("Invalid course ID !");
                        Thread.sleep(1500);
                        clearScreen();
                    }
                    else if (Course.getCourseById(courseId).getTeacher().equals(teacher)){
                        condition = false;
                    }
                    else{
                        clearScreen();
                        System.out.println("You don't have this course !");
                        Thread.sleep(1500);
                    }
                }while (condition);
                condition = true;
                int assignmentId;
                do{
                    System.out.println("please enter assignmentId or '0' to back to teacher menu : ");
                    assignmentId = scanner.nextInt();
                    if (assignmentId == 0){
                        clearScreen();
                        teacherMenu(teacher);
                        break;
                    }
                    if(!Assignment.checkValidID(assignmentId)){
                        condition = false;
                    }
                    else {
                        System.out.println("This Assignment already exist !");
                        Thread.sleep(1500);
                        clearScreen();
                    }
                }while (condition);
                System.out.println("please enter a name for assignment :");
                scanner.nextLine();
                String assignmentName = scanner.nextLine();
                clearScreen();
                System.out.println("please enter a deadLine for assignment :");
                int deadLine = scanner.nextInt();
                clearScreen();
                teacher.createAssignment(assignmentName,deadLine,Course.getCourseById(courseId),assignmentId);
                System.out.println("Assignment Created Successfully !");
                teacherMenu(teacher);
                break;
            case 5:
                condition = true;
                do{
                    System.out.println("please enter assignmentId or '0' to back to teacher menu : ");
                    assignmentId = scanner.nextInt();
                    if (assignmentId == 0){
                        clearScreen();
                        teacherMenu(teacher);
                        break;
                    }
                    if(!Assignment.checkValidID(assignmentId)){
                        clearScreen();
                        System.out.println("this assignment doesn't exist !");
                        Thread.sleep(1500);
                    } else if (!Assignment.getAssignmentById(assignmentId).course.teacher.equals(teacher)) {
                        clearScreen();
                        System.out.println("ERROR: You Don't have this course !");
                        Thread.sleep(1500);
                    } else {
                        clearScreen();
                        Assignment.deleteAssignment(Assignment.getAssignmentById(assignmentId));
                        System.out.println("Assignment removed successfully !");
                        condition=false;
                        Thread.sleep(1500);
                    }
                    clearScreen();
                }while (condition);
                teacherMenu(teacher);
                break;
            case 6:
                condition = true;
                do{
                    System.out.println("please enter your assignment ID or '0' to back to teacher menu : ");
                    assignmentId = scanner.nextInt();
                    if (assignmentId == 0){
                        clearScreen();
                        teacherMenu(teacher);
                        break;
                    }
                    //error
                    if (Assignment.allAssignments.contains(Assignment.getAssignmentById(assignmentId))){
                        System.out.println("Please enter a newDeadLine :");
                        int deadLineAssignment = scanner.nextInt();
                        Assignment.getAssignmentById(assignmentId).changeDeadLine(deadLineAssignment);
                        System.out.println("Deadline changed successfully !");
                        condition = false;
                    }else {
                        clearScreen();
                        System.out.println("You don't have access to this assignment !");
                        Thread.sleep(1500);
                    }
                    clearScreen();
                }while (condition);
                teacherMenu(teacher);
                break;
            case 7:
                printAdminOrTeacher();
                break;
        }
    }
}