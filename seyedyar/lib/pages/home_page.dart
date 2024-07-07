import 'package:flutter/material.dart';
import 'package:shamsi_date/shamsi_date.dart'; // برای تاریخ شمسی
import 'todo_work_page.dart';

class HomePage extends StatelessWidget {
  final String name;
  final int studentID;

  HomePage({required this.name, required this.studentID});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Summary',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Scaffold(
        backgroundColor: Color(0xFFD8F3DC),
        appBar: AppBar(
          backgroundColor: Color(0xFFD8F3DC),
          title: const Text(
            'Summary',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: greenCards[0]),
                  SizedBox(width: 10),
                  Expanded(child: greenCards[1]),
                  SizedBox(width: 10),
                  Expanded(child: greenCards[2]),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  greenCards[3],
                  SizedBox(width: 10),
                  greenCards[4],
                ],
              ),
              SizedBox(height: 20),
              // بخش Current Tasks
              CurrentTasks(),
              Expanded(
                child: TaskList(items: section1Items),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Done Assignment',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: completedExercises.length,
                  itemBuilder: (context, index) {
                    return CompletedExerciseCard(
                      exercise: completedExercises[index],
                    );
                  },
                ),
              ),
              SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}

final List<String> completedExercises = [
  'Exercise 1',
  'Exercise 2',
  'Exercise 3',
  'Exercise 4',
  'Exercise 5',
];

class CompletedExerciseCard extends StatelessWidget {
  final String exercise;

  CompletedExerciseCard({required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFa8e063),
            Color(0xFF56ab2f),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: Offset(0, 4),
          ),
        ],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.lightGreen[900]!,
          width: 2,
        ),
      ),
      padding: EdgeInsets.all(10),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topRight,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 8),
              Text(
                exercise,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Positioned(
            top: -18, // انحراف بالایی برای آیکون
            right: -18, // انحراف راستی برای آیکون
            child: Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.check,
                size: 7,
                color: Colors.lightGreen[400],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

List<GreenGradientCard> greenCards = [
  GreenGradientCard(
      icon: Icons.share_arrival_time,
      text: '۳ تا تمرین داری ',
      colorIcon: Colors.pink[400]!),
  GreenGradientCard(
      icon: Icons.heart_broken_outlined,
      text: '۳ تا تمرین داری ',
      colorIcon: Colors.red[700]!),
  GreenGradientCard(
      icon: Icons.star_border_outlined,
      text: '۳ تا تمرین داری ',
      colorIcon: Colors.yellowAccent),
  GreenGradientCard(
      icon: Icons.sentiment_dissatisfied_rounded,
      text: '۳ تا تمرین داری ',
      colorIcon: Color(0XFFF5487F)),
  GreenGradientCard(
      icon: Icons.timer_off_outlined,
      text: '۳ تا تمرین داری ',
      colorIcon: Colors.lightBlue)
];

class GreenGradientCard extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color colorIcon;
  GreenGradientCard(
      {required this.icon, required this.text, required this.colorIcon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 128,
      margin: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF008000),
            Color(0xFF32cd32),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: Offset(0, 4),
          ),
        ],
        borderRadius: BorderRadius.circular(15),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 30, 
            color: colorIcon,
          ),
          SizedBox(height: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 14, 
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class TaskList extends StatelessWidget {
  final List<ListItem> items;

  TaskList({required this.items});

  @override
  Widget build(BuildContext context) {
    var widthOfScreen = MediaQuery.of(context).size.width;
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            shape: BoxShape.rectangle,
            gradient: LinearGradient(
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
                colors: [
                  Color(0xFFD8F3DC),
                  Color(0xFFb7e4c7),
                  Color(0xFF95d5b2),
                  Color(0xFF74c69d),
                  Color(0xFF52b788),
                ]),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 5.0,
                offset: Offset(0, 5),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(horizontal: widthOfScreen * 0.04),
          child: listItem(items[index], context),
        );
      },
    );
  }

  Widget listItem(ListItem item, BuildContext context) {
    return GestureDetector(
        child: ListTile(
      title: Text(
        item.title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: item.isActive ? Colors.black : Colors.black54,
        ),
      ),
    ));
  }
}

class CurrentTasks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var widthOfScreen = MediaQuery.of(context).size.width;
    final Jalali jDate = Jalali.now();
    final String formattedDate = '${jDate.year}/${jDate.month}/${jDate.day}';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Current Tasks',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: widthOfScreen * 0.46),
          Text(
            formattedDate,
            style: TextStyle(
                fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

void showAddItemDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Add New Task"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(hintText: "Enter task name"),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text("Add"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
