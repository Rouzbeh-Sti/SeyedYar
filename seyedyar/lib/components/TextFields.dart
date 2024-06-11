import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final TextEditingController controller;
  final bool obscureText;
  final String hinttext;
  final Icon icon;
  final TextInputType keyboardtypeInput;
  final String? Function(String?)? validatorInput;

  MyTextField({
    super.key,
    required this.controller,
    required this.hinttext,
    required this.obscureText,
    required this.icon,
    this.keyboardtypeInput = TextInputType.name,
    this.validatorInput,
  });

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: widget.validatorInput,
        controller: widget.controller,
        keyboardType: widget.keyboardtypeInput,
        obscureText: _obscureText,
        decoration: InputDecoration(
          hintText: widget.hinttext,
          hintStyle: TextStyle(color: Colors.black38, fontSize: 16),
          prefixIcon: widget.icon,
          prefixIconColor: const Color.fromARGB(255, 121, 121, 121),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 37, 37, 37)),
            borderRadius: BorderRadius.circular(10.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(10.5),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(10.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(10.5),
          ),
          fillColor: Color.fromARGB(237, 234, 222, 222),
          filled: true,
          contentPadding:
              EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
          errorMaxLines: 3,
          suffixIcon: widget.obscureText
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                    color: Color.fromARGB(255, 121, 121, 121),
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}
