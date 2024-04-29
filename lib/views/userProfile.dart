import 'package:universal_html/html.dart' as html;

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../controllers/firebaseAuthService.dart';
import '../models/user.dart';
import 'package:uuid/uuid.dart'; // For generating unique file names

class UserProfileScreen extends StatefulWidget {
  final bool viewOnly;
  final AppUser? user;

  const UserProfileScreen({super.key, required this.viewOnly, this.user});

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final FirebaseAuthService _authService = FirebaseAuthService();
  AppUser? _user;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  String? imageUrl; //will be set in "getImage"
  html.File? _selectedFile; // Add this line to store the selected file

  @override
  void initState() {
    super.initState();
    if (widget.user == null) {
      _fetchUserDetails();
    } else {
      _user = widget.user;
      _nameController.text = _user?.name ?? '';
      _emailController.text = _user?.email ?? '';
      _bioController.text = _user?.aboutMe ?? '';
    }
  }

  void _fetchUserDetails() async {
    AppUser? user = await _authService.fetchUserDetails();
    setState(() {
      _user = user;
      _nameController.text = _user?.name ?? '';
      _emailController.text = _user?.email ?? '';
      _bioController.text = _user?.aboutMe ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        actions: [
          if (!widget.viewOnly)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveChanges,
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
        child: _user != null
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(imageUrl ??
                          "https://picsum.photos/id/1004/960/540"), // You need to replace this with the actual user image
                    ),
                    const SizedBox(height: 10),
                    if (!widget.viewOnly) // Only render the button if not in view-only mode
                      ElevatedButton(
                        onPressed: _getImage,
                        child: const Text('Upload Image'),
                      ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                      enabled: !widget.viewOnly,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      enabled: !widget.viewOnly,
                    ),
                    TextField(
                      controller: _bioController,
                      decoration: const InputDecoration(labelText: 'About me'),
                      enabled: !widget.viewOnly,
                    ),
                    const SizedBox(height: 20),
                    if (!widget.viewOnly)
                      ElevatedButton(
                        onPressed: _saveChanges,
                        child: const Text("Save Changes"),
                      ),
                  ],
                ),
              )
            : const Center(
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
      //UPDATING user details in firebase
      String filePath = 'uploads/${const Uuid().v4()}.png';
      final ref = FirebaseStorage.instance.ref().child(filePath);
      final task = await ref.putBlob(_selectedFile!);
      final downloadUrl = await task.ref.getDownloadURL();

      await _authService.updateUserDetails(
          name: newName,
          email: newEmail,
          aboutMe: newBio,
          imageUrl: downloadUrl);
      // Success, update local user object and UI
      setState(() {
        _user?.name = newName;
        _user?.email = newEmail;
        _user?.aboutMe = newBio;
        _user?.imageUrl = imageUrl;
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
      barrierDismissible: false,
      // User must not dismiss the dialog by tapping outside of it.
      builder: (BuildContext context) {
        return const Dialog(
          child: Padding(
            padding: EdgeInsets.all(20.0),
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

  //Pick image to upload
  void _getImage() {
    final html.FileUploadInputElement input = html.FileUploadInputElement()
      ..accept = 'image/*';
    input.click();
    input.onChange.listen((event) async {
      final List<html.File>? files = input.files;
      if (files != null && files.isNotEmpty) {
        final html.File file = files.first;
        _selectedFile = file; // Store the selected file
        final reader = html.FileReader();
        reader.readAsDataUrl(file);
        reader.onLoadEnd.listen((event) {
          setState(() {
            imageUrl = reader.result as String?; // Display the local image
          });
        });
      }
    });
  }
}
