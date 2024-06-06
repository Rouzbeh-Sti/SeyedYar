import 'package:flutter/material.dart';
import 'package:seyedyar/components/MyButton.dart';
import 'package:seyedyar/components/TextFields.dart';
import 'package:seyedyar/pages/Login_page.dart';
import 'package:seyedyar/pages/Profile_page.dart';
import 'package:seyedyar/pages/Welcome_page.dart';

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

  final _formKey = GlobalKey<FormState>();

  void signUserUp() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(
            name: nameController.text,
            studentID: studentIDController.text,
          ),
        ),
      );
    } else {
      _showErrorDialog("Please fix the errors in the form.");
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
    // ignore: deprecated_member_use
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
                          icon: Icon(Icons.person),
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
                          onTap: signUserUp,
                          name: "Sign Up",
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

  SignUserUp() {}
}
