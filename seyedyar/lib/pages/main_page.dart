import 'package:flutter/material.dart';
import 'package:seyedyar/components/custom_app_bar.dart';
import 'package:seyedyar/pages/home_page.dart';
import 'package:seyedyar/pages/courses_page.dart';
import 'package:seyedyar/pages/news_page.dart';
import 'package:seyedyar/pages/assignments_page.dart';
import 'package:seyedyar/pages/todo_work_page.dart';
import 'package:seyedyar/pages/profile_page.dart';

class MainPage extends StatefulWidget {
  final String name;
  final String studentID;

  MainPage({required this.name, required this.studentID});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages = <Widget>[
      HomePage(name: widget.name, studentID: widget.studentID),
      TodoWorkPage(name: widget.name, studentID: widget.studentID),
      CoursesPage(studentId: int.parse(widget.studentID)),
      NewsPage(name: widget.name, studentID: widget.studentID),
      AssignmentsPage(name: widget.name, studentID: widget.studentID),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: _selectedIndex == 0
            ? 'Home'
            : _selectedIndex == 1
                ? 'To Do'
                : _selectedIndex == 2
                    ? 'Courses'
                    : _selectedIndex == 3
                        ? 'News'
                        : 'Assignments',
        name: widget.name,
        studentID: widget.studentID,
        showProfileButton: true,
        onProfileTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfilePage(
                name: widget.name,
                studentID: widget.studentID,
              ),
            ),
          );
        },
      ),
      body: _pages.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color.fromARGB(255, 28, 135, 83),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'To Do',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Courses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Assignments',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
