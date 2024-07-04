import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:seyedyar/components/MyButton.dart';
import 'package:seyedyar/components/TextFields.dart';
import 'package:seyedyar/pages/SignUp_page.dart';
import 'package:seyedyar/pages/Welcome_page.dart';
import 'package:seyedyar/pages/main_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final studentIDController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String response = '';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color.fromARGB(255, 28, 135, 83),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Image.asset(
                  'lib/images/Logo1.png',
                  height: 105,
                  width: 105,
                ),
              ),
              const Expanded(
                child: Center(
                  child: Text(
                    "Login        ",
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.arrow_right_alt_sharp),
                color: Colors.black,
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => WelcomePage()),
                  );
                },
              ),
            ],
          ),
        ),
        backgroundColor: Color.fromARGB(255, 158, 218, 189),
        body: SingleChildScrollView(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(18),
                    margin: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 22, 99, 59),
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        const Row(
                          children: [
                            SizedBox(width: 15),
                            Text(
                              "Student ID",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        MyTextField(
                          hinttext: "Enter your Student ID",
                          controller: studentIDController,
                          obscureText: false,
                          icon: const Icon(Icons.person),
                          keyboardtypeInput: TextInputType.number,
                          validatorInput: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your Student ID';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),
                        const Row(
                          children: [
                            SizedBox(width: 15),
                            Text(
                              "Password",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        MyTextField(
                          hinttext: "Enter your Password",
                          controller: passwordController,
                          obscureText: true,
                          icon: const Icon(Icons.lock),
                          validatorInput: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        MyButton(
                          name: "Login",
                          onTap: () async {
                            if (_formKey.currentState?.validate() ?? false) {
                              // No validation errors, proceed to connect to backend
                              String loginResponse = await logUserIn();
                              List<String> responseParts =
                                  loginResponse.split("~");
                              switch (responseParts[0]) {
                                case "200":
                                  Map<String, dynamic> userData =
                                      jsonDecode(responseParts[1]);
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MainPage(
                                        name: userData['name'],
                                        studentID:
                                            userData['studentID'],
                                      ),
                                    ),
                                  );
                                  break;
                                case "401":
                                  _showErrorDialog(
                                      "Incorrect password. Please try again.");
                                  break;
                                case "404":
                                  _showErrorDialog(
                                      "Invalid Student ID. Please try again.");
                                  break;
                                default:
                                  _showErrorDialog(
                                      "Login failed. Please check your credentials.");
                              }
                            } else {
                              // Show error dialog if there are validation errors
                              _showErrorDialog(
                                  "Please fix the errors in the form.");
                            }
                          },
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account?!    ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      TextButton(
                        onPressed: () => navigateSignUp(context),
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Color.fromARGB(255, 66, 99, 245),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  navigateSignUp(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SignUpPage(),
      ),
    );
  }

  Future<String> logUserIn() async {
    print("clicked");
    try {
      final serverSocket = await Socket.connect("192.168.1.13", 8080);
      print("Connected to server");
      serverSocket.write(
          "GET: loginChecker~${studentIDController.text}~${passwordController.text}\u0000");
      serverSocket.flush();

      List<int> responseBytes = [];
      await serverSocket.listen((data) {
        responseBytes.addAll(data);
      }).asFuture();
      response = String.fromCharCodes(responseBytes).trim();
      print("Response from server: $response");

      serverSocket.destroy();
    } catch (error) {
      print("Connection error: $error");
      response = "Connection error: $error";
    }
    print("******** server response : { $response } *********");
    return response;
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }
}
