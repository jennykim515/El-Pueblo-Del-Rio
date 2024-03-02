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
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/assets/Background2.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: _user != null ? Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
              SizedBox(height: 50,),

              ElevatedButton(
                  onPressed: (){_saveChanges();}, child: Text("Save Changes"))
            ],
          ),
        )
            : Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Future<void> _saveChanges() async {
    _showLoadingDialog(); // Show the loading dialog

    String newName = _nameController.text;
    String newEmail = _emailController.text;
    String newBio = _bioController.text;

    // Assume _authService.updateUserDetails does the actual saving work
    // Update the user object locally
    try {
      await _authService.updateUserDetails(name: newName, email: newEmail, aboutMe: newBio);
      // Success, update local user object and UI
      setState(() {
        _user?.name = newName;
        _user?.email = newEmail;
        _user?.userBio = newBio;
      });
    } catch (error) {
      // Handle errors, e.g., show an error dialog
      print("Error saving changes: $error");
    }

    Navigator.of(context).pop(); // Dismiss the loading dialog
  }


  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // User must not dismiss the dialog by tapping outside of it.
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text("Saving..."),
              ],
            ),
          ),
        );
      },
    );
  }

}
