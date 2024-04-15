// Add this import statement at the top of your file
import 'package:flutter/material.dart';

import 'login.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.deepPurple, // Customize the background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add your splash screen content here
            FlutterLogo(
              size: 100.0, // Adjust the size as needed
              textColor: Colors.white, // Customize the text color
              style: FlutterLogoStyle.stacked, // Choose the logo style
            ),
            SizedBox(height: 16.0),
            Text(
              'El Pueblo Del Rio & Community Safety Partnership',
              style: TextStyle(
                color: Colors.white, // Customize the text color
                fontSize: 24.0, // Adjust the font size as needed
              ),
            ),
          ],
        ),
      ),
    );
  }
}
