import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final bool obscureText;
  final String hinttext;
  final Icon icon;
  MyTextField(
      {super.key,
      required this.controller,
      required this.hinttext,
      required this.obscureText,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
      child: TextFormField(
        
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          prefixIcon: icon,
          prefixIconColor: const Color.fromARGB(255, 121, 121, 121),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 37, 37, 37)),
              borderRadius: BorderRadius.circular(10.5)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(10.5)),
          fillColor: Color.fromARGB(237, 234, 222, 222),
          filled: true,
          hintText: hinttext,
          hintStyle: TextStyle(color: Colors.black38),
        ),
      ),
    );
  }
}
