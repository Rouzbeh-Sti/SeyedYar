import 'package:flutter/material.dart';
import 'package:seyedyar/pages/Login_page.dart';
import 'package:seyedyar/pages/SignUp_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
