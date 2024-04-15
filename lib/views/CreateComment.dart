import 'package:flutter/material.dart';
import '../models/comment.dart';
import '../models/user.dart';
import 'package:pueblo_del_rio/controllers/firebaseAuthService.dart';
import 'package:pueblo_del_rio/controllers/postController.dart';

class CreateComment extends StatefulWidget {
  final String postID; // Add postID as a required parameter
  final VoidCallback onCommentAdded;

  const CreateComment({Key? key, required this.postID, required this.onCommentAdded}) : super(key: key);

  @override
  _CreateCommentState createState() => _CreateCommentState();
}

class _CreateCommentState extends State<CreateComment> {
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

  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
  //create comment
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _commentController,
              decoration: const InputDecoration(
                hintText: 'Write a comment...',
                border: InputBorder.none,
              ),
              maxLines: null, // Allow multiline comments
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () async {
              if (_commentController.text.isNotEmpty && user != null) {
                Comment newComment = Comment(
                  commentStr: _commentController.text,
                  authorRef: user!.id!,
                  id: widget.postID,
                  date: DateTime.now(),
                );
                await _postController.createNewComment(newComment, widget.postID);
                setState(() {
                  _commentController.clear();
                });

                widget.onCommentAdded(); // Trigger callback
              }
            },
          ),
        ],
      ),
    );
  }
}
