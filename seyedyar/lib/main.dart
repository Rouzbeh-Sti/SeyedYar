import 'package:flutter/material.dart';
import 'package:seyedyar/pages/Welcome_page.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  var initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  flutterLocalNotificationsPlugin.initialize(initializationSettings);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 28, 135, 83),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Color.fromARGB(255, 28, 135, 83),
          secondary: Color.fromARGB(255, 28, 135, 83),
          background: Color.fromARGB(255, 158, 218, 189),
        ),
        scaffoldBackgroundColor: Color.fromARGB(255, 158, 218, 189),
        appBarTheme: AppBarTheme(
          color: Color.fromARGB(255, 28, 135, 83),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Color.fromARGB(255, 28, 135, 83),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.black45,
        ),
      ),
      home: WelcomePage(),
    );
  }
}
