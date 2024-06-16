import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClassPage extends StatelessWidget {
  const ClassPage({super.key});

  @override
  Widget build(BuildContext context) {
    var widthOfScreen = MediaQuery.of(context).size.width;
    var heightOfScreen = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: Container(
          height: heightOfScreen * 0.75,
          width: widthOfScreen * 0.9,
          child: const Column(
            children: [
              Row(
                children: [
                  Column(
                    children: [
                      Text(
                        'کلاس ها ',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800
                        ),
                      ),
                      Text(
                        'ترم بهار ۱۴۰۳',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(0, 0, 0, 0.4)
                        ),
                      )
                    ],
                  ),

                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
