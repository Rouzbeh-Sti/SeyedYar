import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shamsi_date/shamsi_date.dart';

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
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _pageController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
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

  List<String> descriptions = [
    'Description for news 1',
    'Description for news 2',
    'Description for news 3',
  ];

  @override
  Widget build(BuildContext context) {
    final jDate = Jalali.now();
    String formattedDate = "${jDate.day} ${jDate.formatter.mN} ${jDate.year}";

    return Scaffold(
      backgroundColor: Color(0xFFD8F3DC),
      body: Column(
        children: [
          SizedBox(height: 20),
          Container(
            height: 40,
            margin: EdgeInsets.only(bottom: 10),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: List.generate(3, (index) {
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
              children: List.generate(5, (index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: ListView.builder(
                      itemCount: newsTitles.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: CustomCardWidget(
                            title: newsTitles[index],
                            description: descriptions[index],
                            imageUrl: 'lib/images/image4.png',
                            URL: 'https://www.golestan.ir',
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return Container(
                    color: Colors.green[50],
                    child: Center(
                      child: Text(
                        'Page $index',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  );
                }
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomCardWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('sdw');
        if (URL != null && URL!.isNotEmpty) {
          launchURL(URL!);
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
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      SizedBox(height: 4),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                      SizedBox(height: 4),
                      if (URL != null && URL!.isNotEmpty)
                        GestureDetector(
                          onTap: () {
                            launchURL(URL!);
                          },
                          child: Text(
                            'بیشتر بخوانید...',
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
                SizedBox(width: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.asset(
                    imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  void launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication, // این خط برای باز کردن URL در مرورگر خارجی است
      );
    } else {
      print('Could not launch $url');
      throw 'Could not launch $url';
    }
  }

}

