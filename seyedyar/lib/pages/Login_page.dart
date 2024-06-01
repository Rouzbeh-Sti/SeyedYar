import 'package:flutter/material.dart';
import 'package:seyedyar/components/MyButton.dart';
import 'package:seyedyar/components/TextFields.dart';
import 'package:seyedyar/pages/SignUp_page.dart';
import 'package:seyedyar/pages/Welcome_page.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final studentIDController = TextEditingController();
  final passwordController = TextEditingController();

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
              Expanded(
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
                icon: Icon(Icons.arrow_back),
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
          child: Column(
            children: [
              Center(
                child: Container(
                  padding: EdgeInsets.all(18),
                  margin:
                      EdgeInsets.only(bottom: 50, left: 20, right: 20, top: 80),
                  height: 400,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 22, 99, 59),
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
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
                        height: 15,
                      ),
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
                      const SizedBox(
                        height: 30,
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
                        height: 10,
                      ),
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
                      MyButton(
                        name: "Login",
                        onTap: LogUserIn,
                      )
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account?!    ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
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

  void LogUserIn() {}
}
