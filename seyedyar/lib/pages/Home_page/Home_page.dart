import 'package:flutter/material.dart';
import 'package:seyedyar/pages/Home_page/Assignment_page.dart';
import 'package:seyedyar/pages/Home_page/Class_page.dart';
import 'package:seyedyar/pages/Home_page/Home1_page.dart';
import 'package:seyedyar/pages/Home_page/News_page.dart';
import 'package:seyedyar/pages/Home_page/Task_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Container(
              //   padding: EdgeInsets.all(16.0),
              //   alignment: Alignment.topCenter,
              //   child: const Text(
              //     'sdaSD',
              //     style: TextStyle(
              //       fontSize: 30,
              //       color: Colors.lightBlue,
              //     ),
              //   ),
              // ),
              SizedBox(
                height: MediaQuery.of(context).size.height - kToolbarHeight - kBottomNavigationBarHeight - 16.0, // Adjusted height
                child: const TabBarView(
                  children: [
                    AssignmentPage(),
                    NewsPage(),
                    ClassPage(),
                    TaskPage(),
                    Home1Page()
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: TabBar(
          tabs: [
            Tab(
              icon: Image.asset('lib/images/Assignment.png'),
              text: "تمرین ها",
            ),
            Tab(
              icon: Image.asset('lib/images/News.png'),
              text: "اخبار",
            ),
            Tab(
              icon: Image.asset('lib/images/Class.png'),
              text: "کلاس ها",
            ),
            Tab(
              icon: Image.asset('lib/images/Task.png'),
              text: "کار ها",
            ),
            Tab(
              icon: Image.asset('lib/images/Home.png'),
              text: "خانه",
            )
          ],
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          indicatorSize: TabBarIndicatorSize.label,
          indicatorColor: Colors.blue,
        ),
      ),
    );
  }
}
