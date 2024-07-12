import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListItem {
  String title;
  bool isActive;
  IconData icon;
  String date;
  String time;

  ListItem(this.title, this.isActive, this.date, this.time)
      : icon = isActive ? Icons.done_outline : Icons.close;
}

class TodoWorkPage extends StatefulWidget {
  final String name;
  final int studentID;

  TodoWorkPage({required this.name, required this.studentID});

  @override
  State<TodoWorkPage> createState() => _TodoWorkPageState();
}

class _TodoWorkPageState extends State<TodoWorkPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(studentID: widget.studentID),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final int studentID;

  MyHomePage({required this.studentID});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ListItem> section1Items = [];
  List<ListItem> section2Items = [];
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  void fetchTasks() async {
    try {
      final serverSocket = await Socket.connect('192.168.30.145', 8080);
      serverSocket.write("GET: studentTasks~${widget.studentID}\u0000");

      List<int> responseBytes = [];
      await serverSocket.listen((data) {
        responseBytes.addAll(data);
      }).asFuture();
      String response = String.fromCharCodes(responseBytes).trim();

      if (response.startsWith("200~")) {
        String data = response.split('~')[1];
        List<String> tasksData = data.split(";");
        List<ListItem> fetchedTasks =
            tasksData.where((taskData) => taskData.isNotEmpty).map((taskData) {
          List<String> parts = taskData.split(",");
          String dateTime = parts[2];
          DateTime parsedDateTime = DateTime.parse(dateTime);
          String date =
              "${parsedDateTime.year}-${parsedDateTime.month.toString().padLeft(2, '0')}-${parsedDateTime.day.toString().padLeft(2, '0')}";
          String time =
              "${parsedDateTime.hour.toString().padLeft(2, '0')}:${parsedDateTime.minute.toString().padLeft(2, '0')}";
          return ListItem(parts[0], parts[1] == 'true', date, time);
        }).toList();
        setState(() {
          section1Items = fetchedTasks.where((item) => item.isActive).toList();
          section2Items = fetchedTasks.where((item) => !item.isActive).toList();
        });
      } else {
        print("ERROR: ${response.split('~')[1]}");
      }

      serverSocket.close();
    } catch (e) {
      print("ERROR: $e");
    }
  }

  void addTask(String title, String dateTime) async {
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Task title cannot be empty")),
      );
      return;
    }

    for (var task in section1Items) {
      if (task.title == title) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Task already exists")),
        );
        return;
      }
    }

    for (var task in section2Items) {
      if (task.title == title) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Task already exists")),
        );
        return;
      }
    }

    try {
      final serverSocket = await Socket.connect('192.168.30.145', 8080);
      serverSocket
          .write("ADD: task~${widget.studentID}~$title~$dateTime\u0000");

      List<int> responseBytes = [];
      await serverSocket.listen((data) {
        responseBytes.addAll(data);
      }).asFuture();
      String response = String.fromCharCodes(responseBytes).trim();

      if (response.startsWith("200~")) {
        setState(() {
          fetchTasks();
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Task added successfully")));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response.split("~")[1])));
      }

      serverSocket.close();
    } catch (e) {
      print("ERROR: $e");
    }
  }

  void updateTaskStatus(ListItem item, bool isActive) async {
    try {
      final serverSocket = await Socket.connect('192.168.30.145', 8080);
      serverSocket.write(
          "UPDATE: task~${widget.studentID}~${item.title}~$isActive\u0000");

      List<int> responseBytes = [];
      await serverSocket.listen((data) {
        responseBytes.addAll(data);
      }).asFuture();
      String response = String.fromCharCodes(responseBytes).trim();

      if (response.startsWith("200~")) {
        fetchTasks();
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response.split("~")[1])));
      }

      serverSocket.close();
    } catch (e) {
      print("ERROR: $e");
    }
  }

  void deleteTask(ListItem item) async {
    try {
      final serverSocket = await Socket.connect('192.168.30.145', 8080);
      serverSocket
          .write("DELETE: task~${widget.studentID}~${item.title}\u0000");

      List<int> responseBytes = [];
      await serverSocket.listen((data) {
        responseBytes.addAll(data);
      }).asFuture();
      String response = String.fromCharCodes(responseBytes).trim();

      if (response.startsWith("200~")) {
        fetchTasks();
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response.split("~")[1])));
      }

      serverSocket.close();
    } catch (e) {
      print("ERROR: $e");
    }
  }

  void showAddItemDialog(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    TimeOfDay selectedTime = TimeOfDay.now();

    Future<void> _selectDate(BuildContext context, StateSetter setState) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );
      if (picked != null && picked != selectedDate) {
        setState(() {
          selectedDate = picked;
        });
      }
    }

    Future<void> _selectTime(BuildContext context, StateSetter setState) async {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: selectedTime,
      );
      if (picked != null && picked != selectedTime) {
        setState(() {
          selectedTime = picked;
        });
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Add New Task'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      hintText: 'Enter task title',
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => _selectDate(context, setState),
                        child: Text("${selectedDate.toLocal()}".split(' ')[0]),
                      ),
                      ElevatedButton(
                        onPressed: () => _selectTime(context, setState),
                        child: Text("${selectedTime.format(context)}"),
                      ),
                    ],
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Add'),
                  onPressed: () {
                    String title = titleController.text.trim();
                    if (title.isNotEmpty) {
                      String dateTime =
                          "${selectedDate.toLocal().toIso8601String().split('T')[0]} ${selectedTime.format(context)}";
                      addTask(title, dateTime);
                    }
                    titleController.clear();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  void updateTaskDateTime(ListItem item, String dateTime) async {
    try {
      final serverSocket = await Socket.connect('192.168.30.145', 8080);
      serverSocket.write(
          "UPDATE: taskDateTime~${widget.studentID}~${item.title}~$dateTime\u0000");

      List<int> responseBytes = [];
      await serverSocket.listen((data) {
        responseBytes.addAll(data);
      }).asFuture();
      String response = String.fromCharCodes(responseBytes).trim();

      if (response.startsWith("200~")) {
        fetchTasks();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Task date and time updated successfully")));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response.split("~")[1])));
      }

      serverSocket.close();
    } catch (e) {
      print("ERROR: $e");
    }
  }

  void showTaskOptionsDialog(BuildContext context, ListItem item) {
    DateTime selectedDate = DateTime.now();
    TimeOfDay selectedTime = TimeOfDay.now();

    Future<void> _selectDate(BuildContext context, StateSetter setState) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );
      if (picked != null && picked != selectedDate) {
        setState(() {
          selectedDate = picked;
        });
      }
    }

    Future<void> _selectTime(BuildContext context, StateSetter setState) async {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: selectedTime,
      );
      if (picked != null && picked != selectedTime) {
        setState(() {
          selectedTime = picked;
        });
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Task Options'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () => _selectDate(context, setState),
                    child: Text("${selectedDate.toLocal()}".split(' ')[0]),
                  ),
                  ElevatedButton(
                    onPressed: () => _selectTime(context, setState),
                    child: Text("${selectedTime.format(context)}"),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Update'),
                  onPressed: () {
                    String newDateTime =
                        "${selectedDate.toLocal().toIso8601String().split('T')[0]} ${selectedTime.format(context)}";
                    updateTaskDateTime(item, newDateTime);
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Delete'),
                  onPressed: () {
                    deleteTask(item);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void showEditDateTimeDialog(BuildContext context, ListItem item) {
    DateTime selectedDate = DateTime.now();
    TimeOfDay selectedTime = TimeOfDay.now();

    Future<void> _selectDate(BuildContext context, StateSetter setState) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );
      if (picked != null && picked != selectedDate) {
        setState(() {
          selectedDate = picked;
        });
      }
    }

    Future<void> _selectTime(BuildContext context, StateSetter setState) async {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: selectedTime,
      );
      if (picked != null && picked != selectedTime) {
        setState(() {
          selectedTime = picked;
        });
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Edit Date and Time'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () => _selectDate(context, setState),
                    child: Text("${selectedDate.toLocal()}".split(' ')[0]),
                  ),
                  ElevatedButton(
                    onPressed: () => _selectTime(context, setState),
                    child: Text("${selectedTime.format(context)}"),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Save'),
                  onPressed: () {
                    String date =
                        "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
                    String time =
                        "${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}";
                    String dateTime = "$date $time";
                    updateTaskDateTime(item, dateTime);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget listItem(ListItem item) {
    return GestureDetector(
      onLongPress: () {
        showTaskOptionsDialog(context, item);
      },
      child: ListTile(
        title: Text(
          item.title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: item.isActive ? Colors.black : Colors.black54,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.date,
              style: TextStyle(
                fontSize: 14,
                color: item.isActive ? Colors.black87 : Colors.black54,
              ),
            ),
            Text(
              item.time,
              style: TextStyle(
                fontSize: 14,
                color: item.isActive ? Colors.black87 : Colors.black54,
              ),
            ),
          ],
        ),
        trailing: Checkbox(
          value: !item.isActive,
          onChanged: (bool? value) {
            if (value != null) {
              updateTaskStatus(item, !value);
            }
          },
          activeColor: Colors.green,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var widthOfScreen = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFD8F3DC),
        title: const Center(
          child: Text(
            'All Tasks',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Container(
        color: Color(0xFFD8F3DC),
        child: ListView(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Remaining tasks',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: section1Items.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    shape: BoxShape.rectangle,
                    gradient: LinearGradient(
                      begin: Alignment.bottomRight,
                      end: Alignment.topLeft,
                      colors: section1Items[index].isActive
                          ? [
                              Color(0xFFD8F3DC),
                              Color(0xFFb7e4c7),
                              Color(0xFF95d5b2),
                              Color(0xFF74c69d),
                              Color(0xFF52b788),
                            ]
                          : [
                              Color(0xFFf8edeb),
                              Color(0xFFfae1dd),
                              Color(0xFFfbb1bd),
                              Color(0xFFf29491),
                              Color(0xFFf28482),
                            ],
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5.0,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: widthOfScreen * 0.04),
                  child: listItem(section1Items[index]),
                );
              },
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Completed tasks',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: section2Items.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    shape: BoxShape.rectangle,
                    gradient: LinearGradient(
                      begin: Alignment.bottomRight,
                      end: Alignment.topLeft,
                      colors: section2Items[index].isActive
                          ? [
                              Color(0xFFD8F3DC),
                              Color(0xFFb7e4c7),
                              Color(0xFF95d5b2),
                              Color(0xFF74c69d),
                              Color(0xFF52b788),
                            ]
                          : [
                              Color(0xFFf8edeb),
                              Color(0xFFfae1dd),
                              Color(0xFFfbb1bd),
                              Color(0xFFf29491),
                              Color(0xFFf28482),
                            ],
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5.0,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: widthOfScreen * 0.04),
                  child: listItem(section2Items[index]),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddItemDialog(context);
        },
        backgroundColor: Color(0xFF74C69D),
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }
}
