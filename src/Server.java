import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;

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
                break;        }

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
