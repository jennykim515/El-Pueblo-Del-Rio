import 'package:flutter/material.dart';
import 'package:pueblo_del_rio/controllers/postController.dart';
import 'package:pueblo_del_rio/models/comment.dart';
import 'package:pueblo_del_rio/views/CreateComment.dart';

class CommentWidget extends StatefulWidget {
  final String postID;

  const CommentWidget({
    Key? key,
    required this.postID,
  }) : super(key: key);

  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  late Future<List<Comment>> _commentsFuture;

  @override
  void initState() {
    _commentsFuture = PostController().getAllComments(widget.postID);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Comment>>(
      future: _commentsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final comments = snapshot.data ?? [];
          print("these are the comments: " + comments.toString());
          return _showCommentDialog(context, comments);
        }
      },
    );
  }

  Widget _showCommentDialog(BuildContext context, List<Comment> comments) {
    return AlertDialog(
      title: Text('Comments'),
      content: Container(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(comments[index].commentStr),
                    subtitle: Text('By: ${comments[index].getAuthor().toString()}'),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            CreateComment(postID: widget.postID),
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
  }
}
