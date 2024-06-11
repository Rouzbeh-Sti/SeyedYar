import 'package:flutter/material.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    var widthOfScreen = MediaQuery.of(context).size.width;
    var heightOfScreen = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: widthOfScreen * 0.9,
          height: heightOfScreen * 0.9,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 60),
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "کار ها",
                      style: TextStyle(
                        fontSize: 26,
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: Image.asset('lib/images/Calendar.png'),
                      ),
                      const Text(
                        'کار ها',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 10,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  const CardWidget(title: 'ریز آز - تمرین ۱', time: '4:00 عصر'),
                  SizedBox(height: 10),
                  const CardWidget(title: 'ریز آز - تمرین ۱', time: '4:00 عصر'),
                  SizedBox(height: 10),
                  const CardWidget(title: 'ریز آز - تمرین ۱', time: '4:00 عصر'),
                  SizedBox(height: 10),
                  const CardWidget(title: 'ریز آز - تمرین ۱', time: '4:00 عصر'),
                ],
              ),
              // دکمه افزودن کار جدید بدون بک‌گراند
              Positioned(
                bottom: 5, // فاصله از پایین
                right: 5, // فاصله از راست
                child: IconButton(
                  icon: Image.asset('lib/images/add.png'), // تصویر دکمه
                  onPressed: () {
                    _showAddTaskDialog(context);
                  },
                  iconSize: 50,
                  tooltip: 'افزودن کار جدید',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final String title;
  final String time;

  const CardWidget({
    Key? key,
    required this.title,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var widthOfScreen = MediaQuery.of(context).size.width;
    var heightOfScreen = MediaQuery.of(context).size.height;

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(9),
      ),
      child: Container(
        padding: const EdgeInsets.all(3),
        width: widthOfScreen * 0.8,
        height: heightOfScreen * 0.055,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              time,
              style: const TextStyle(
                color: Color.fromARGB(212, 212, 212, 1),
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset('lib/images/tik.png', width: 24, height: 24),
                    const SizedBox(width: 20),
                    Image.asset('lib/images/delete.png', width: 24, height: 24),
                  ],
                ),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void _showAddTaskDialog(BuildContext context) {
  TextEditingController titleController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('افزودن کار جدید'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'عنوان',
              ),
            ),
            TextField(
              controller: timeController,
              decoration: const InputDecoration(
                labelText: 'زمان',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('لغو'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            child: const Text('افزودن'),
            onPressed: () {
              String newTitle = titleController.text;
              String newTime = timeController.text;
              print('کار جدید: $newTitle در زمان: $newTime');
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
