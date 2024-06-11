import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.File;
import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;

public class Server {
    public static void main(String[] args) throws Exception{
        System.out.println("Welcome to the server");
        FileController.loadObjects();
        ServerSocket serverSocket=new ServerSocket(8080);
        while (true){
            System.out.println("waiting for client");
            new ClientHandler(serverSocket.accept()).start();
        }
    }
}
class ClientHandler extends Thread{
    Socket socket;
    DataOutputStream dos;
    DataInputStream dis;
    public ClientHandler(Socket socket) throws IOException {
        this.socket=socket;
        dos=new DataOutputStream(socket.getOutputStream());
        dis=new DataInputStream(socket.getInputStream());
        System.out.println("Server connected");
    }

    public String listener() throws IOException {
        System.out.println("Listener connected");
        StringBuilder stringBuilder=new StringBuilder();
        int index=dis.read();
        while (index!=0){
            stringBuilder.append((char) index);
            index=dis.read();
        }
        System.out.println("listen finished");
        return stringBuilder.toString();
    }
    public void writer(String message) throws IOException {
        dos.writeBytes(message);
        dos.flush();
        dos.close();
        dis.close();
        socket.close();
        System.out.println("message sent to front: "+message);
    }
    @Override
    public void run() {
        super.run();
        int response;
        String command;
        try {
            command=listener();
            System.out.println("command recieved: "+command);
        }catch (IOException e) {
            throw new RuntimeException(e);
        }
        String[] split=command.split("~");
            switch (split[0]){
                case "GET: loginChecker" :
                    int studentId= Integer.parseInt(split[1]);
                    String password=split[2];
                    response=Student.studentLogin(studentId,password);

                    if (response==2){
                        System.out.println("Login successful: 200");
                        try {
                            writer("200");
                        } catch (IOException e) {
                            throw new RuntimeException(e);
                        }
                    }else if (response==1) {
                        System.out.println("incorrect password: 401");
                        try {
                            writer("401");
                        } catch (IOException e) {
                            throw new RuntimeException(e);
                        }
                    } else if (response==0) {
                        System.out.println("incorrect studentID: 404");
                        try {
                            writer("404");
                        } catch (IOException e) {
                            throw new RuntimeException(e);
                        }
                    }
                    break;
                case "GET: signup":
                    if (Student.checkValidID(Integer.parseInt(split[1]))){
                        System.out.println("student id already exist");
                        try {
                            writer("380");
                        } catch (IOException e) {
                            throw new RuntimeException(e);
                        }
                    }
                    else {
                        Admin.createStudent(Integer.parseInt(split[1]),split[2],split[3]);
                        System.out.println("student created: studen id:  "+ split[1]+" password: "+ split[2]+" named:"+ split[3]);
                    }
            }
    }

}
