import 'package:flutter/material.dart';
import 'package:pueblo_del_rio/models/post.dart'; // Import your Post model

class CommentWidget extends StatelessWidget {
  final String postId;
  final int commentsCount;

  const CommentWidget({Key? key, required this.postId, required this.commentsCount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the comment screen or open a comment dialog
        // You can implement your own logic here
        print('View comments for post with ID: $postId');
      },
      child: Row(
        children: [
          Icon(Icons.mode_comment_outlined),
          SizedBox(width: 5),
          Text(commentsCount.toString()),
        ],
      ),
    );
  }

  void _showCommentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Comments'),
          content: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Display existing comments here
                // You can use ListView.builder or any other widget to display comments
                // For example:
                // ListView.builder(
                //   itemCount: post.comments.length,
                //   itemBuilder: (context, index) {
                //     return ListTile(
                //       title: Text(post.comments[index]),
                //     );
                //   },
                // ),
                Text('Existing Comments will be displayed here'),
                SizedBox(height: 16),
                // Widget to post a new comment
                _buildCommentTextField(context),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCommentTextField(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Write a comment...',
                border: InputBorder.none,
              ),
              maxLines: null, // Allow multiline comments
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              // Implement logic to post comment here
              // You can use postComment method from your PostController
              // For example:
              // PostController().postComment(postId, commentText);
              // postId is post.id and commentText is the text entered by the user
              // After posting the comment, you may want to refresh the comments list
              Navigator.pop(context); // Close comment dialog after posting
            },
          ),
        ],
      ),
    );
  }
}
