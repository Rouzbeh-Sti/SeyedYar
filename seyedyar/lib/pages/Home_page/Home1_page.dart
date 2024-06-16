import 'package:flutter/material.dart';
import 'package:seyedyar/components/CardTask.dart';
import 'package:seyedyar/components/DoneTask.dart';

class Home1Page extends StatelessWidget {
  const Home1Page({super.key});

  @override
  Widget build(BuildContext context) {
    var widthOfScreen = MediaQuery
        .of(context)
        .size
        .width;
    var heightOfScreen = MediaQuery
        .of(context)
        .size
        .height;
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
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CardWidget(
                      address: 'lib/images/icon5.png', text: 'تا تمرین داری ۳'),
                  SizedBox(width: 8),
                  CardWidget(
                      address: 'lib/images/icon4.png',
                      text: '۲ تا امتحان داری'),
                  SizedBox(width: 8),
                  CardWidget(
                      address: 'lib/images/icon3.png',
                      text: 'بهترین نمرت ۱۰۰ عه')
                ],
              ),
              const SizedBox(height: 20),
              const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CardWidget(
                      address: 'lib/images/icon2.png',
                      text: 'بدترین نمرت ۱۰ عه'),
                  SizedBox(width: 8),
                  CardWidget(
                      address: 'lib/images/icon1.png', text: '۲ تا ددلاین پرید')
                ],
              ),
              SizedBox(height: heightOfScreen * 0.05),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '۱۷ فروردین ۱۴۰۳',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Color.fromARGB(151, 151, 151, 1)
                    ),
                  ),
                  Text(
                    'کار های جاری',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
              SizedBox(height: 40),
              const CardTask(title: 'آز ریز - تمرین ۱', time: ''),
              SizedBox(height: 23),
              const CardTask(title: 'تست - تمرین ۱', time: ''),
              SizedBox(height: heightOfScreen * 0.05),
              Container(
                alignment: Alignment.centerRight,
                child: const Text(
                  'تمرین های انجام شده',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800
                  ),
                ),
              ),
              SizedBox(height: 40),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DoneTask(text: 'AP  - تمرین ۲'),
                  DoneTask(text: 'تمرین ۱ معماری')
                ],
              )
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
          width: MediaQuery
              .of(context)
              .size
              .width * 0.27,
          height: MediaQuery
              .of(context)
              .size
              .height * 0.07,
          padding: EdgeInsets.all(7),
          decoration: BoxDecoration(color: Colors.white,
              borderRadius: BorderRadius.circular(10)),
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
    ),);
  }
}
