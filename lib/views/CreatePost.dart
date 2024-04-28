import 'package:universal_html/html.dart' as html;

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Import Firebase Storage
// Import Cloud Firestore
import 'package:pueblo_del_rio/controllers/firebaseAuthService.dart';
import 'package:pueblo_del_rio/controllers/postController.dart';
import 'package:pueblo_del_rio/models/user.dart';
import 'package:uuid/uuid.dart'; // For generating unique file names

class CreatePost extends StatefulWidget {
  const CreatePost({super.key});

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();
  final PostController _postController = PostController();
  AppUser? user;
  String? imageUrl;
  html.File? _selectedFile; // Add this line to store the selected file


  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    AppUser? userDetails = await _firebaseAuthService.fetchUserDetails();
    setState(() {
      user = userDetails;
    });
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
        actions: [
          TextButton(
            onPressed: _createPost,
            child: const Text("Post"),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _bodyController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  labelText: 'Body',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _getImage,
                child: const Text('Upload Image'),
              ),
              const SizedBox(height: 16),
              imageUrl != null
                  ? Image.network(
                      imageUrl!,
                      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                        return const Icon(Icons.error); // Show an error icon or placeholder image
                      },
                    )// Display the uploaded image
                  : Container(), // Placeholder for the image
            ],
          ),
        ),
      ),
    );
  }

  void _showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // User must not dismiss the dialog by tapping outside of it.
    builder: (BuildContext context) {
      return const Dialog(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Posting..."),
            ],
          ),
        ),
      );
    },
  );
}

  void _getImage() {
    final html.FileUploadInputElement input = html.FileUploadInputElement()..accept = 'image/*';
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

  void _createPost() async {
    final String title = _titleController.text.trim();
    final String body = _bodyController.text.trim();

    if (title.isEmpty || body.isEmpty || _selectedFile == null) {
      // Show error dialog if title, body, or image is empty
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Error'),
          content: Text(title.isEmpty ? 'Please enter a title.' : body.isEmpty ? 'Please enter a body for your post.' : 'Please upload an image.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    _showLoadingDialog(context); // Show loading dialog

    if (user != null && user!.id != null) {
      try {
        // Upload the image to Firebase Storage
        String filePath = 'uploads/${const Uuid().v4()}.png';
        final ref = FirebaseStorage.instance.ref().child(filePath);
        final task = await ref.putBlob(_selectedFile!);
        final downloadUrl = await task.ref.getDownloadURL();

        // Create new Post object with imageURL
        await _postController.createNewPost(title, body, user!.id!, imageUrl: downloadUrl);

        Navigator.of(context).pop(); // Dismiss the loading dialog

        // Navigate back to the home page
        Navigator.of(context).pop();

        // Optionally, you can use a Snackbar to show a success message
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Post created successfully!")));
      } catch (e) {
        Navigator.of(context).pop(); // Ensure loading dialog is dismissed in case of error
        // Error handling: Show an error message
        print('Error creating post: $e');
        // Show an error dialog or Snackbar here if needed
      }
    } else {
      Navigator.of(context).pop(); // Dismiss loading dialog if user ID is null
      // Error handling: User ID is null
      print('User ID is null');
    }
  }

}
