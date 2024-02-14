
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../controllers/firebaseAuthService.dart';
import '../models/user.dart';

class UserProfileScreen extends StatelessWidget {
  final FirebaseAuth auth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Profile')),
      body: Column(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage("User Image"),
          ),
          SizedBox(height: 10),
          Text("User Name"),
          Text("User Information"),
          // Display user's posts using ListView or GridView
        ],
      ),
    );
  }
}