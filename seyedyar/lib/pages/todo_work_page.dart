import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListItem {
  String title;
  bool isActive;
  IconData icon;

  ListItem(this.title, this.isActive, this.icon);
}

class TodoWorkPage extends StatelessWidget {
  final String name;
  final String studentID;

  TodoWorkPage({required this.name, required this.studentID});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ListItem> section1Items = [
    ListItem('Item 1', true, Icons.done_outline),
    ListItem('Item 2', true, Icons.done_outline),
    ListItem('Item 3', true, Icons.done_outline),
  ];

  List<ListItem> section2Items = [
    ListItem('Item A', false, Icons.close),
    ListItem('Item B', false, Icons.close),
    ListItem('Item C', false, Icons.close),
  ];

  void addItem(String title) {
    setState(() {
      section1Items.add(ListItem(title, true, Icons.done_outline));
    });
  }

  void toggleItemStatus(ListItem item) {
    setState(() {
      if (section1Items.contains(item)) {
        section1Items.remove(item);
        item.isActive = false;
        item.icon = Icons.close;
        section2Items.add(item);
      } else if (section2Items.contains(item)) {
        section2Items.remove(item);
        item.isActive = true;
        item.icon = Icons.done_outline;
        section1Items.add(item);
      }
    });
  }

  void deleteItem(ListItem item) {
    setState(() {
      if (section1Items.contains(item)) {
        section1Items.remove(item);
      } else if (section2Items.contains(item)) {
        section2Items.remove(item);
      }
    });
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
                deleteItem(item);
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
          title: Text('Add New Item'),
          content: TextField(
            controller: titleController,
            decoration: InputDecoration(
              hintText: 'Enter item title',
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
                  addItem(title);
                }
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
        trailing: IconButton(
          icon: Icon(item.icon),
          color: item.isActive ? Colors.green : Colors.red,
          onPressed: () {
            toggleItemStatus(item);
          },
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
              physics: NeverScrollableScrollPhysics(),
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
