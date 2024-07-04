import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListItem {
  String title;
  bool isActive;
  IconData icon;

  ListItem(this.title, this.isActive)
      : icon = isActive ? Icons.done_outline : Icons.close;
}

class TodoWorkPage extends StatelessWidget {
  final String name;
  final int studentID;

  TodoWorkPage({required this.name, required this.studentID});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(studentID: studentID),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final int  studentID;

  MyHomePage({required this.studentID});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ListItem> section1Items = [];
  List<ListItem> section2Items = [];

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  void fetchTasks() async {
    try {
      final serverSocket = await Socket.connect('192.168.1.13', 8080);
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
          return ListItem(parts[0], parts[1] == 'true');
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

  void addTask(String title) async {
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
      final serverSocket = await Socket.connect('192.168.1.13', 8080);
      serverSocket.write("ADD: task~${widget.studentID}~$title\u0000");

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
      final serverSocket = await Socket.connect('192.168.1.13', 8080);
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
      final serverSocket = await Socket.connect('192.168.1.13', 8080);
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

  void showDeleteConfirmationDialog(BuildContext context, ListItem item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Item'),
          content: Text('Are you sure you want to delete "${item.title}"?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
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
  }

  void showAddItemDialog(BuildContext context) {
    TextEditingController titleController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Task'),
          content: TextField(
            controller: titleController,
            decoration: InputDecoration(
              hintText: 'Enter task title',
            ),
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
                  addTask(title);
                }
                titleController.clear(); // Clear the text field
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget listItem(ListItem item) {
    return GestureDetector(
      onLongPress: () {
        showDeleteConfirmationDialog(context, item);
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
