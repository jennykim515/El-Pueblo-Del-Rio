import 'package:flutter/material.dart';
import 'package:pueblo_del_rio/controllers/postController.dart';
import 'package:pueblo_del_rio/models/comment.dart';
import 'package:pueblo_del_rio/views/CreateComment.dart';
import 'package:intl/intl.dart';

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
          print("these are the comments: $comments");
          return _showCommentDialog(context, comments);
        }
      },
    );
  }

  Widget _showCommentDialog(BuildContext context, List<Comment> comments) {
    return AlertDialog(
      title: const Text('Comments'),
      content: SizedBox(
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
                        //If the comment has a date attached
                        if (comments[index].date != null) {
                          String getDateAsString(DateTime dateTime) {
                            if (comments[index].date == null) {
                              return "";
                            }
                            DateTime now = DateTime.now();
                            Duration difference = now.difference(dateTime);

                            if (difference.inSeconds < 60) {
                              return '${difference.inSeconds}s';
                            } else if (difference.inMinutes < 60) {
                              return '${difference.inMinutes}m';
                            } else if (difference.inHours < 24) {
                              return '${difference.inHours}h';
                            } else if (difference.inDays < 7) {
                              return '${difference.inDays}d';
                            } else {
                              return '${difference.inDays ~/ 7}w';
                            }
                          }

                          return ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Tooltip(
                                  message: DateFormat.yMMMMEEEEd().addPattern("'at'").add_jm().format(comments[index].date!),
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: '${snapshot.data}',
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(
                                          text: ' • ${getDateAsString(comments[index].date!)}',
                                          style: const TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8), // Add vertical space between title and subtitle
                                Text(comments[index].commentStr),
                              ],
                            ),
                          );
                        }
                        //If the comment doesn't have a date attached
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

            const SizedBox(height: 16),
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
