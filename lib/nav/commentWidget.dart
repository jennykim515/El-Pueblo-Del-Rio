import 'package:flutter/material.dart';
import 'package:pueblo_del_rio/controllers/postController.dart';
import 'package:pueblo_del_rio/models/comment.dart';
import 'package:pueblo_del_rio/views/CreateComment.dart';

class CommentWidget extends StatefulWidget {
  final String postID;

  const CommentWidget({
    super.key,
    required this.postID,
  });

  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  late Future<List<Comment>> _commentsFuture;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  void _loadComments() {
    setState(() {
      _commentsFuture = PostController().getAllComments(widget.postID);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Comment>>(
      future: _commentsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
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
                  return FutureBuilder<String>(
                    future: comments[index].getAuthorName(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return ListTile(
                          title: Text(comments[index].commentStr),
                          subtitle: const Text('By: Loading...'),
                        );
                      } else if (snapshot.hasError) {
                        return ListTile(
                          title: Text(comments[index].commentStr),
                          subtitle: Text('By: Error: ${snapshot.error}'),
                        );
                      } else {
                        return ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '${snapshot.data}',
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8), // Add vertical space between title and subtitle
                              Text(comments[index].commentStr),
                            ],
                          ),
                        );

                      }
                    },
                  );
                },
              ),
            ),

            SizedBox(height: 16),
            CreateComment(
              postID: widget.postID,
              onCommentAdded: _loadComments,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
