import 'dart:js';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:seyedyar/components/TextFields.dart';
import 'package:seyedyar/pages/SignUp_page.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final studentIDController = TextEditingController();
  final passwordController = TextEditingController();

  void _SignUserIn() {
    Navigator.of(context as BuildContext)
        .push(MaterialPageRoute(builder: (context) => SignUpPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 28, 135, 83),
        title: const Center(
          heightFactor: 100,
          child: Text(
            "Login Page",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      backgroundColor: Color.fromARGB(255, 158, 218, 189),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(18),
          margin: EdgeInsets.all(20),
          height: 700,
          decoration: const BoxDecoration(
              color: Color.fromARGB(255, 22, 99, 59),
              borderRadius: BorderRadius.all(Radius.circular(30))),
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
                icon: Icon(Icons.person),
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
                icon: Icon(Icons.lock),
              ),
              GestureDetector(
                onTap: _SignUserIn,
                child: Container(
                    margin: EdgeInsets.only(top: 20),
                    padding: EdgeInsets.all(15),
                    width: 150,
                    height: 70,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(199, 4, 207, 48),
                        borderRadius: BorderRadius.circular(30.0)),
                    child: const Text(
                      "Login",
                      style: TextStyle(fontSize: 26),
                      textAlign: TextAlign.center,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
