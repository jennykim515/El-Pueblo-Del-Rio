import 'package:flutter/material.dart';
import '../controllers/firebaseAuthService.dart';
import '../models/user.dart';
import '../nav/avatarImage.dart';

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
            onPressed: _saveChanges,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/assets/Background2.png"),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: _user != null
            ? SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AvatarImage("https://picsum.photos/id/1072/80/80"),
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveChanges,
                child: Text("Save Changes"),
              ),
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
    // Update user information in Firestore
    String newName = _nameController.text;
    String newEmail = _emailController.text;
    String newBio = _bioController.text;

    // Update the user object locally
    setState(() {
      _user?.name = newName;
      _user?.email = newEmail;
      _user?.userBio = newBio;
    });

    // Update user information in Firestore using your authentication service
    await _authService.updateUserDetails(name: newName, aboutMe: newBio);
  }
}
