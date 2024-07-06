import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.List;

public class Server {
    public static void main(String[] args) throws Exception {
        System.out.println("Welcome to the server");
        FileController.loadObjects();
        ServerSocket serverSocket = new ServerSocket(8080);
        while (true) {
            System.out.println("waiting for client");
            new ClientHandler(serverSocket.accept()).start();
        }
    }
}

class ClientHandler extends Thread {
    Socket socket;
    DataOutputStream dos;
    DataInputStream dis;

    public ClientHandler(Socket socket) throws IOException {
        this.socket = socket;
        dos = new DataOutputStream(socket.getOutputStream());
        dis = new DataInputStream(socket.getInputStream());
        System.out.println("Server connected");
    }

    public String listener() throws IOException {
        System.out.println("Listener connected");
        StringBuilder stringBuilder = new StringBuilder();
        int index = dis.read();
        while (index != 0) {
            stringBuilder.append((char) index);
            index = dis.read();
        }
        System.out.println("listen finished");
        return stringBuilder.toString();
    }

    public void writer(String message) throws IOException {
        dos.writeBytes(message);
        dos.flush();
        System.out.println("message sent to front: " + message);
    }

    @Override
    public void run() {
        super.run();
        String command;
        try {
            command = listener();
            System.out.println("command received: " + command);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
        String[] split = command.split("~");
        switch (split[0]) {
            case "GET: loginChecker":
                int studentId = Integer.parseInt(split[1]);
                String password = split[2];
                int response = Student.studentLogin(studentId, password);

                if (response == 2) {
                    System.out.println("Login successful: 200");
                    try {
                        String userData = getUserData(studentId);
                        writer("200~" + userData);
                    } catch (IOException e) {
                        throw new RuntimeException(e);
                    }
                } else if (response == 1) {
                    System.out.println("Incorrect password: 401");
                    try {
                        writer("401");
                    } catch (IOException e) {
                        throw new RuntimeException(e);
                    }
                } else if (response == 0) {
                    System.out.println("Incorrect studentID: 404");
                    try {
                        writer("404");
                    } catch (IOException e) {
                        throw new RuntimeException(e);
                    }
                }
                break;
            case "GET: signup":
                studentId = Integer.parseInt(split[1]);
                String newPassword = split[2];
                String name = split[3];

                if (Student.checkValidID(studentId)) {
                    System.out.println("Student ID already exists: 380");
                    try {
                        writer("380");
                    } catch (IOException e) {
                        throw new RuntimeException(e);
                    }
                } else {
                    Admin.createStudent(studentId, newPassword, name);
                    System.out.println("Student created: student id: " + studentId + " password: " + newPassword + " named: " + name);
                    try {
                        writer("201~" + getUserData(studentId));  // 201 indicates created
                    } catch (IOException e) {
                        throw new RuntimeException(e);
                    }
                }
                break;
            case "DELETE: deleteStudent":
                studentId = Integer.parseInt(split[1]);
                Student student = Student.getStudentById(studentId);
                if (Student.checkValidID(studentId)) {
                    Admin.deleteStudent(student);
                    System.out.println("Student deleted: " + studentId);
                    try {
                        writer("200");
                    } catch (IOException e) {
                        throw new RuntimeException(e);
                    }
                } else {
                    System.out.println("Student not found: 404");
                    try {
                        writer("404");
                    } catch (IOException e) {
                        throw new RuntimeException(e);
                    }
                }
                break;
            case "GET: studentCourses":
                studentId = Integer.parseInt(split[1]);
                Student studentById = Student.getStudentById(studentId);
                if (studentById != null) {
                    StringBuilder coursesData = new StringBuilder();
                    for (Course course : studentById.getCourses().keySet()) {
                        coursesData.append(course.getCourseID()).append(",")
                                .append(course.name).append(",")
                                .append(course.getTeacher().getName()).append(";");
                    }
                    try {
                        writer("200~" + coursesData.toString());
                    } catch (IOException e) {
                        throw new RuntimeException(e);
                    }
                } else {
                    try {
                        writer("404");
                    } catch (IOException e) {
                        throw new RuntimeException(e);
                    }
                }
                break;
            case "ADD: course":
                if (split.length < 3) {
                    System.out.println("Invalid ADD: course command format.");
                    try {
                        writer("400~Invalid command format");
                    } catch (IOException e) {
                        throw new RuntimeException(e);
                    }
                    break;
                }
                int studentId1 = Integer.parseInt(split[1]);
                int courseId = Integer.parseInt(split[2]);
                Student student1 = Student.getStudentById(studentId1);
                Course course = Course.getCourseById(courseId);
                try {
                    if (course == null) {
                        writer("404~Course not found");
                    } else if (student1 == null) {
                        writer("404~Student not found");
                    } else if (student1.getCourses().containsKey(course)) {
                        writer("400~Student already enrolled in this course");
                    } else {
                        Admin.addStudentToCourse(student1, course);
                        writer("200~Course added successfully");
                        List<Assignment> assignments = Assignment.getAssignmentsByCourse(courseId);
                        for (Assignment assignment : assignments) {
                            new StudentAssignment(assignment.getAssignmentID(), studentId1, "", true, "", "", 0.0, true);
                        }
                    }

                } catch (IOException e) {
                    throw new RuntimeException(e);
                }
                break;
            case "GET: studentTasks":
                studentId = Integer.parseInt(split[1]);
                Student studentById1 = Student.getStudentById(studentId);
                if (studentById1 != null) {
                    StringBuilder tasksData = new StringBuilder();
                    for (Task task : Task.allTasks) {
                        if (task.forStudentID == studentId) {
                            tasksData.append(task.title).append(",")
                                    .append(task.isActive).append(",")
                                    .append(task.dateTime).append(";");
                        }
                    }
                    try {
                        writer("200~" + tasksData.toString());
                    } catch (IOException e) {
                        throw new RuntimeException(e);
                    }
                } else {
                    try {
                        writer("404~Student not found");
                    } catch (IOException e) {
                        throw new RuntimeException(e);
                    }
                }
                break;
                case "ADD: task":
                studentId = Integer.parseInt(split[1]);
                String taskTitle = split[2];
                String dateTime = split[3];
                studentById1 = Student.getStudentById(studentId);
                if (studentById1 != null) {
                    Task newTask = new Task(taskTitle, true, studentId, dateTime, true); // include dateTime
                    try {
                        writer("200~Task added successfully");
                    } catch (IOException e) {
                        throw new RuntimeException(e);
                    }
                } else {
                    try {
                        writer("404~Student not found");
                    } catch (IOException e) {
                        throw new RuntimeException(e);
                    }
                }
                break;
            case "UPDATE: task":
                studentId = Integer.parseInt(split[1]);
                taskTitle = split[2];
                boolean isDone = Boolean.parseBoolean(split[3]);
                Task taskToUpdate = Task.getTaskByNameAndID(taskTitle,studentId);
                if (taskToUpdate != null && taskToUpdate.forStudentID == studentId) {
                    Task.updateTask(taskToUpdate,isDone);
                    try {
                        writer("200~Task updated successfully");
                    } catch (IOException e) {
                        throw new RuntimeException(e);
                    }
                } else {
                    try {
                        writer("404~Task not found");
                    } catch (IOException e) {
                        throw new RuntimeException(e);
                    }
                }
                break;
            case "UPDATE: taskDateTime":
                studentId = Integer.parseInt(split[1]);
                 taskTitle = split[2];
                String newDateTime = split[3];
                studentById1 = Student.getStudentById(studentId);
                if (studentById1 != null) {
                     taskToUpdate = Task.getTaskByNameAndID(taskTitle, studentId);
                    if (taskToUpdate != null) {
                        taskToUpdate.updateDateTime(newDateTime);
                        try {
                            writer("200~Task date and time updated successfully");
                        } catch (IOException e) {
                            throw new RuntimeException(e);
                        }
                    } else {
                        try {
                            writer("404~Task not found");
                        } catch (IOException e) {
                            throw new RuntimeException(e);
                        }
                    }
                } else {
                    try {
                        writer("404~Student not found");
                    } catch (IOException e) {
                        throw new RuntimeException(e);
                    }
                }
                break;
            case "DELETE: task":
                studentId = Integer.parseInt(split[1]);
                taskTitle = split[2];
                Task taskToDelete = Task.getTaskByNameAndID(taskTitle,studentId);
                if (taskToDelete != null && taskToDelete.forStudentID == studentId) {
                    Task.deleteTask(taskToDelete);
                    try {
                        writer("200~Task deleted successfully");
                    } catch (IOException e) {
                        throw new RuntimeException(e);
                    }
                } else {
                    try {
                        writer("404~Task not found");
                    } catch (IOException e) {
                        throw new RuntimeException(e);
                    }
                }
                break;
            case "UPDATE: studentAssignment":
                int studentID = Integer.parseInt(split[1]);
                int assignmentID = Integer.parseInt(split[2]);
                String fieldToUpdate = split[3];
                String newValue = split[4];

                StudentAssignment studentAssignment = StudentAssignment.getStudentAssignment(studentID, assignmentID);
                if (studentAssignment != null) {
                    switch (fieldToUpdate) {
                        case "estimatedTime":
                            studentAssignment.setEstimatedTime(newValue);
                            break;
                        case "description":
                            studentAssignment.setDescription(newValue);
                            break;
                        case "givingDescription":
                            studentAssignment.setGivingDescription(newValue);
                            break;
                        case "isActive":
                            studentAssignment.setActive(Boolean.parseBoolean(newValue));
                            break;
                        default:
                            try {
                                writer("400~Invalid field to update");
                            } catch (IOException e) {
                                throw new RuntimeException(e);
                            }
                            return;
                    }
                    try {
                        writer("200~Field updated successfully");
                    } catch (IOException e) {
                        throw new RuntimeException(e);
                    }
                } else {
                    try {
                        writer("404~Student assignment not found");
                    } catch (IOException e) {
                        throw new RuntimeException(e);
                    }
                }
                break;

            case "GET: studentAssignments":
                studentID = Integer.parseInt(split[1]);
                List<StudentAssignment> studentAssignments = StudentAssignment.getAssignmentsForStudent(studentID);
                if (studentAssignments != null && !studentAssignments.isEmpty()) {
                    StringBuilder responseBuilder = new StringBuilder("200~");
                    for (StudentAssignment sa : studentAssignments) {
                        responseBuilder.append(sa.getAssignmentID()).append(",")
                                .append(sa.getAssignmentName()).append(",")
                                .append(sa.getCourseName()).append(",")
                                .append(sa.getDueDate()).append(",")
                                .append(sa.getDueTime()).append(",")
                                .append(sa.getEstimatedTime()).append(",")
                                .append(sa.getIsActive()).append(",")
                                .append(sa.getDescription()).append(",")
                                .append(sa.getGivingDescription()).append(",")
                                .append(sa.getScore()).append(";");
                    }
                    try {
                        writer(responseBuilder.toString());
                    } catch (IOException e) {
                        throw new RuntimeException(e);
                    }
                } else {
                    // No assignments found, send an empty response with 200 status
                    try {
                        writer("200~");
                    } catch (IOException e) {
                        throw new RuntimeException(e);
                    }
                }
                break;
            case "GET: studentProfile":
                 studentID = Integer.parseInt(split[1]);
                Student studentProfile = Student.getStudentById(studentID);
                if (studentProfile != null) {
                    String profileData = studentProfile.getTotalUnits() + "," + studentProfile.calculateOverallScore();
                    try {
                        writer("200~" + profileData);
                    } catch (IOException e) {
                        throw new RuntimeException(e);
                    }
                } else {
                    try {
                        writer("404~Student not found");
                    } catch (IOException e) {
                        throw new RuntimeException(e);
                    }
                }
                break;
            case "UPDATE: changeName":
                studentID = Integer.parseInt(split[1]);
                String newName = split[2];
                student = Student.getStudentById(studentID);
                if (student != null) {
                    student.setName(newName);
                    FileController.changeSpecifiedField("src/database/studentList.txt", studentID, 2, newName);
                    try {
                        writer("200~Name updated successfully");
                    } catch (IOException e) {
                        throw new RuntimeException(e);
                    }
                } else {
                    try {
                        writer("404~Student not found");
                    } catch (IOException e) {
                        throw new RuntimeException(e);
                    }
                }
                break;
            case "UPDATE: password":
                studentID = Integer.parseInt(split[1]);
                String currentPassword = split[2];
                 newPassword = split[3];
                student = Student.getStudentById(studentID);
                if (student != null && student.getPassword().equals(currentPassword)) {
                    student.setPassword(newPassword);
                    FileController.changeSpecifiedField("src/database/studentList.txt", studentID, 1, newPassword);
                    try {
                        writer("200~Password updated successfully");
                    } catch (IOException e) {
                        throw new RuntimeException(e);
                    }
                } else {
                    try {
                        writer("401~Invalid current password");
                    } catch (IOException e) {
                        throw new RuntimeException(e);
                    }
                }
                break;
        }
        try {
            dis.close();
            dos.close();
            socket.close();
        } catch (IOException e) {
            System.out.println("Error closing resources: " + e.getMessage());
        }
    }

    private String getUserData(int studentId) {
        Student student = Student.getStudentById(studentId);
        return student.getDataAsString();
    }
}
