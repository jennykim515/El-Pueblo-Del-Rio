import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pueblo_del_rio/views/MessagingPage.dart';
import 'package:pueblo_del_rio/views/ResourcesPage.dart';
import 'package:pueblo_del_rio/views/authPage.dart';
import 'package:pueblo_del_rio/views/homePage.dart';
import 'package:pueblo_del_rio/views/login.dart';
import 'package:pueblo_del_rio/views/splash.dart';
import 'firebase_options.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  final Color darkBlue = Color(0xFF2F3A69);
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pueblo Del Rio',
      theme: ThemeData(

        primaryColor: Colors.blue[900],
        primaryColorDark: Colors.black,
        secondaryHeaderColor: Colors.orange,
        appBarTheme: AppBarTheme(
          color: darkBlue, // Change this to the color you desire for the app bar

        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.blue[900]), // for body text
          titleLarge: TextStyle(color: Colors.orange), // for app bar title
          titleMedium: TextStyle(color: Colors.orange),
          // You can add more styles as needed for various text elements
        ),

        useMaterial3: true,
      ),
      home: const AuthPage(),
    );
  }
}
