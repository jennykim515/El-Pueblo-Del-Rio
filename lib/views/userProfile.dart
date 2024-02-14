import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../controllers/firebaseAuthService.dart';
import '../models/user.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  FirebaseAuthService _authService = FirebaseAuthService();
  AppUser? _user;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _bioController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  void _fetchUserDetails() async {
    AppUser? user = await _authService.fetchUserDetails();
    setState(() {
      _user = user;
      _nameController.text = _user?.name ?? '';
      _emailController.text = _user?.email ?? '';
      _bioController.text = _user?.userBio ?? '';

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              _saveChanges();
            },
          ),
        ],
      ),
      body: _user != null
          ? Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage("User Image"), // You need to replace this with the actual user image
            ),
            SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _bioController,
              decoration: InputDecoration(labelText: 'About me'),
            ),
          ],
        ),
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Future<void> _saveChanges() async {
    // Update user information in Firestore
    String newName = _nameController.text;
    String newEmail = _emailController.text;
    String newBio = _bioController.text;

    // You can add more fields to update here

    // Update the user object locally
    setState(() {
      _user?.name = newName;
      _user?.email = newEmail;
      _user?.userBio = newBio;

      // Update other fields as needed
    });

    //Update user information in Firestore using your authentication service
    await _authService.updateUserDetails(name: newName, aboutMe: newBio);

  }
}
