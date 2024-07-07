import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsPage extends StatelessWidget {
  final String name;
  final int studentID;

  NewsPage({required this.name, required this.studentID});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Color(0xFFD8F3DC),
      title: 'News',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomeScreen(studentID: studentID),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final int studentID;

  HomeScreen({required this.studentID});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _pageController;
  int _selectedIndex = 0;
  List<Map<String, String>> newsList = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    fetchNews();
  }

  Future<void> fetchNews() async {
    try {
      final socket = await Socket.connect('192.168.1.199', 8080);
      socket.write("GET: news\u0000");

      List<int> responseBytes = [];
      await socket.listen((data) {
        responseBytes.addAll(data);
      }).asFuture();

      String response = String.fromCharCodes(responseBytes).trim();

      if (response.startsWith("200~")) {
        String data = response.split('~')[1];
        List<String> newsData = data.split(";");
        List<Map<String, String>> fetchedNews =
            newsData.where((newsItem) => newsItem.isNotEmpty).map((newsItem) {
          List<String> parts = newsItem.split(",");
          return {
            "id": parts[0],
            "title": parts[1],
            "content": parts[2],
            "url": parts[3]
          };
        }).toList();

        setState(() {
          newsList = fetchedNews;
        });
      } else {
        print("ERROR: ${response.split('~')[1]}");
      }

      socket.close();
    } catch (e) {
      print("ERROR: $e");
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<String> newsTitles = [
    'News',
    'Events',
    'Remind',
  ];

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateTime.now().toLocal().toString().split(' ')[0];

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Color(0xFFD8F3DC),
        body: Column(
          children: [
            SizedBox(height: 20),
            Container(
              height: 40,
              margin: EdgeInsets.only(bottom: 10),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: List.generate(newsTitles.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                        _pageController.jumpToPage(index);
                      });
                    },
                    child: Container(
                      width: 100,
                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        border: Border.all(width: 1),
                        color: _selectedIndex == index
                            ? Colors.green[700]
                            : Colors.green[300],
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          newsTitles[index],
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: Colors.green[800],
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      formattedDate,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.green[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: ListView.builder(
                      itemCount: newsList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: CustomCardWidget(
                            title: newsList[index]['title']!,
                            description: newsList[index]['content']!,
                            imageUrl: 'lib/images/image4.png',
                            URL: newsList[index]['url']!,
                          ),
                        );
                      },
                    ),
                  ),
                  // Add other pages here if necessary
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomCardWidget extends StatefulWidget {
  final String title;
  final String description;
  final String imageUrl;
  final String? URL;

  CustomCardWidget({
    required this.title,
    required this.description,
    required this.imageUrl,
    this.URL,
  });

  @override
  _CustomCardWidgetState createState() => _CustomCardWidgetState();
}

class _CustomCardWidgetState extends State<CustomCardWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.URL != null && widget.URL!.isNotEmpty) {
          _launchInWebViewOrVC(Uri.parse(widget.URL!));
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 8,
        shadowColor: Colors.green.shade200,
        margin: EdgeInsets.all(20),
        child: SizedBox(
          height: 150,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              gradient: LinearGradient(
                colors: [
                  Colors.green.shade400,
                  Colors.green.shade300,
                  Colors.green.shade200
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: EdgeInsets.all(8),
            child: Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.asset(
                    widget.imageUrl,
                    width: 100,
                    height: 130,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 4),
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        widget.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                      SizedBox(height: 4),
                      if (widget.URL != null && widget.URL!.isNotEmpty)
                        GestureDetector(
                          onTap: () =>
                              _launchInWebViewOrVC(Uri.parse(widget.URL!)),
                          child: Text(
                            'Read more...',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchInWebViewOrVC(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.inAppWebView)) {
      throw Exception('Could not launch $url');
    }
  }
}
