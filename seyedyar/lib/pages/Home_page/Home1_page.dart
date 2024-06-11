import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home1Page extends StatelessWidget {
  const Home1Page({super.key});

  @override
  Widget build(BuildContext context) {
    var widthOfScreen = MediaQuery.of(context).size.width;
    var heightOfScreen = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: Container(
          alignment: Alignment.bottomCenter,
          height: heightOfScreen * 0.75,
          width: widthOfScreen * 0.9,
          child: Column(
            children: [
              Container(
                  alignment: Alignment.centerLeft,
                  child: Image.asset('lib/images/profile2.png')),
              Container(
                alignment: Alignment.centerRight,
                child: const Text('خلاصه',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    )),
              ),
              const CardWidget(address: 'lib/images/icon5.png', text: 'تا تمرین داری ۳')
            ],
          ),
        ),
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final String address;
  final String text;

  const CardWidget({super.key, required this.address, required this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.3,
        height: MediaQuery.of(context).size.height * 0.07,
        padding: EdgeInsets.all(7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(address),
            Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
            )
          ],
        ),
      ),
    );
  }
}
