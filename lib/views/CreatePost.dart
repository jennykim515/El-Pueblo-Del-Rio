import 'package:flutter/material.dart';
import '../models/user.dart';
import 'package:pueblo_del_rio/controllers/firebaseAuthService.dart';
import 'package:pueblo_del_rio/controllers/postController.dart'; // Import the PostController

class CreatePost extends StatefulWidget {
  const CreatePost({Key? key}) : super(key: key);

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();
  final PostController _postController = PostController(); // Declare postController as an instance variable
  AppUser? user;

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: _bodyController,
                maxLines: null, // Allows for multiline input
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  labelText: 'Body',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _createPost() async {
    final String title = _titleController.text;
    final String body = _bodyController.text;

    // Check if the title is empty
    if (title.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please enter a title.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return; // Exit the method without creating the post
    }

    // Check if the body is empty
    if (body.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please enter a body for your post.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return; // Exit the method without creating the post
    }

    print('Title: $title');
    print('Body: $body');
    if (user != null) {
      print('Author: ${user!.username}');
      try {
        await _postController.createNewPost(title, body, user!.username!);
        print('Post created successfully');

        // Clear the input fields after posting and trigger a rebuild
        setState(() {
          _titleController.clear();
          _bodyController.clear();
        });

        //navigate to home screen to show the post

      } catch (e) {
        print('Error creating post: $e');
        // Handle error
      }
    }
  }

}
