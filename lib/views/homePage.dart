import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pueblo_del_rio/views/signOutButton.dart';// Import the SignOutButton widget if it's defined in a separate file
// import 'path_to_your_sign_out_button_widget.dart';

//CODE AUGMENTED FROM MITCH KOKO @ github @mitchkoko

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final user = FirebaseAuth.instance.currentUser!;

  // sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: Icon(Icons.logout),
          )
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center the column
          children: <Widget>[
            Text("Logged IN"),
            SizedBox(height: 20), // Provide some spacing between the text and the button
            SignOutButton(), // Assuming SignOutButton is your custom sign-out button widget
          ],
        ),
      ),
    );
  }
}
