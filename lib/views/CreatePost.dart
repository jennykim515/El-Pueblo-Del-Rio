import 'package:flutter/material.dart';
import '../models/user.dart';
import 'package:pueblo_del_rio/controllers/firebaseAuthService.dart';
import 'package:pueblo_del_rio/controllers/postController.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({Key? key}) : super(key: key);

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();
  final PostController _postController = PostController();
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
                maxLines: null,
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
    final String title = _titleController.text.trim();
    final String body = _bodyController.text.trim();

    if (title.isEmpty || body.isEmpty) {
      // Show error dialog if title or body is empty
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Error'),
          content: Text(title.isEmpty ? 'Please enter a title.' : 'Please enter a body for your post.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    if (user != null && user!.id != null) {
      try {
        print(user!.id!); // Use user ID
        await _postController.createNewPost(title, body, user!.id!); // Use user ID
        // Success: Clear the input fields and maybe show a success message or navigate
        setState(() {
          _titleController.clear();
          _bodyController.clear();
        });
      } catch (e) {
        // Error handling: Show an error message
        print('Error creating post: $e');
      }
    } else {
      // Error handling: User ID is null
      print('User ID is null');
    }
  }
}
