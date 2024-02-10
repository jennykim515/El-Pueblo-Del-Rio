import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'homePage.dart';
import 'login.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Loading state while checking authentication state
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            // User is logged in
            return HomePage();
          } else {
            // User is NOT logged in
            return LoginPage();
          }
        },
      ),
    );
  }
}
