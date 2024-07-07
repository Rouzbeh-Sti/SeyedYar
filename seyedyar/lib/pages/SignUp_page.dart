import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:seyedyar/components/MyButton.dart';
import 'package:seyedyar/components/TextFields.dart';
import 'package:seyedyar/pages/Login_page.dart';
import 'package:seyedyar/pages/Welcome_page.dart';
import 'package:seyedyar/pages/main_page.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final nameController = TextEditingController();
  final studentIDController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();
  String response = '';
  final _formKey = GlobalKey<FormState>();

  Future<String> signUserUp() async {
    print("clicked");
    try {
      final serverSocket = await Socket.connect("192.168.1.52", 8080);
      print("Connected to server");
      serverSocket.write(
          "GET: signup~${studentIDController.text}~${passwordController.text}~${nameController.text}\u0000");
      serverSocket.flush();

      List<int> responseBytes = [];
      await for (var data in serverSocket) {
        responseBytes.addAll(data);
        if (responseBytes.isNotEmpty && responseBytes.last == 0) {
          break;
        }
      }
      response = utf8.decode(responseBytes).trim();
      print("Response from server: $response");

      serverSocket.destroy();
      return response;
    } catch (error) {
      print("Connection error: $error");
      return "Connection error: $error";
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Error"),
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
                    "Sign Up         ",
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
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Center(
                  child: Container(
                    padding: EdgeInsets.all(18),
                    margin: EdgeInsets.only(
                        bottom: 10, left: 20, right: 20, top: 40),
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 22, 99, 59),
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 8,
                        ),
                        const Row(
                          children: [
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              "Name",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        MyTextField(
                          hinttext: "Enter your name",
                          controller: nameController,
                          obscureText: false,
                          icon: const Icon(Icons.person),
                          validatorInput: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Row(
                          children: [
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              "Student ID",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        MyTextField(
                          hinttext: "Enter your Student ID",
                          controller: studentIDController,
                          obscureText: false,
                          icon: Icon(Icons.school),
                          keyboardtypeInput: TextInputType.number,
                          validatorInput: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your Student ID';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Row(
                          children: [
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              "Password",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        MyTextField(
                          validatorInput: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            return validatePassword(
                                value, studentIDController.text);
                          },
                          hinttext: "Enter your Password",
                          controller: passwordController,
                          obscureText: true,
                          icon: Icon(Icons.lock),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Row(
                          children: [
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              "Re-enter Password",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        MyTextField(
                          validatorInput: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                          hinttext: "Confirm your Password",
                          controller: passwordConfirmController,
                          obscureText: true,
                          icon: Icon(Icons.lock_outline),
                        ),
                        MyButton(
                          name: "Sign Up",
                          onTap: () async {
                            if (_formKey.currentState?.validate() ?? false) {
                              String signUpResponse = await signUserUp();
                              if (signUpResponse == "380") {
                                _showErrorDialog(
                                    "Student ID already exists. Please try a different one.");
                              } else if (signUpResponse.startsWith("201~")) {
                                Map<String, dynamic> userData =
                                    jsonDecode(signUpResponse.split("~")[1]);
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
                              } else {
                                _showErrorDialog(
                                    "Sign Up failed. Please check your inputs.");
                              }
                            } else {
                              _showErrorDialog(
                                  "Please fix the errors in the form.");
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Have an account? ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                    TextButton(
                      onPressed: () => navigateLogin(context),
                      child: const Text(
                        "Login",
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
    );
  }

  navigateLogin(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }

  String? validatePassword(String password, String studentID) {
    if (password.length < 8) {
      return "Password should be at least 8 characters";
    }
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return "Password should contain at least an uppercase character";
    }
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      return "Password should contain at least a lowercase character";
    }
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return "Password should contain at least a number";
    }
    if (studentID.isNotEmpty &&
        RegExp(RegExp.escape(studentID), caseSensitive: false)
            .hasMatch(password)) {
      return "Password shouldn't contain your StudentID";
    }
    return null;
  }
}
