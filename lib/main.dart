import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pueblo_del_rio/views/MessagingPage.dart';
import 'package:pueblo_del_rio/views/ResourcesPage.dart';
import 'package:pueblo_del_rio/views/authPage.dart';
import 'package:pueblo_del_rio/views/homePage.dart';
import 'package:pueblo_del_rio/views/login.dart';
import 'package:pueblo_del_rio/views/splash.dart';
import 'package:pueblo_del_rio/controllers/firebaseAuthService.dart';
import 'firebase_options.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  final Color policeBlue = Color(0xFF2F3A69);
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
          color: policeBlue, // Change this to the color you desire for the app bar

        ),
        textTheme: TextTheme(
          titleMedium: GoogleFonts.alice(color: policeBlue,fontSize: 20, ), // for body text
          titleLarge: GoogleFonts.alice(color: Colors.orange, fontSize:23, fontWeight: FontWeight.normal),
          bodyLarge: TextStyle(color: Colors.orange, fontSize:15, fontWeight: FontWeight.normal), // for app bar title
          labelSmall: TextStyle(color: Colors.orange, fontSize:12, fontWeight: FontWeight.normal), // for app bar title
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(policeBlue),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
        ),
        iconTheme: IconThemeData(
          color: policeBlue,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.grey[300],
          selectedIconTheme: IconThemeData(color: policeBlue),
          unselectedIconTheme: IconThemeData(color: Colors.grey[600]),
          selectedLabelStyle: TextStyle(color: policeBlue),


        ),
        useMaterial3: true,
      ),
      home: const AuthPage(),
    );
  }
}
