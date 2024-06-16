import 'package:flutter/material.dart';

class DoneTask extends StatelessWidget {
  final String text;

  const DoneTask({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Stack(
        clipBehavior: Clip.none,
        children: [
      Container(
          height: 90,
          width: 180,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 1,
                  offset: Offset(0, 1),
                )
              ]),
          child: Center(
            child: Text(
              text,
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
          )),
      Positioned(
          bottom: 75 ,left: 165, child: Image.asset('lib/images/tik2.png'))
    ]);
  }
}
