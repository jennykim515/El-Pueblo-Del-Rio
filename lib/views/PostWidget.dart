import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package
import 'package:pueblo_del_rio/models/post.dart';
import 'package:pueblo_del_rio/models/user.dart';
import 'package:pueblo_del_rio/nav/commentWidget.dart';
import '../controllers/firebaseAuthService.dart';
import '../controllers/postController.dart';
import 'homePage.dart';
import '../nav/likeButton.dart';

class PostWidget extends StatefulWidget {
  final Post post;
  final AppUser? user;
  final VoidCallback? reloadHomePage;

  const PostWidget({super.key, required this.post, required this.user, this.reloadHomePage});

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  final _postController = PostController();
  AppUser? user;

  @override
  void initState() {
    super.initState();
    user = widget.user;
  }

  String getDateAsString(DateTime dateTime) {
    if (widget.post.date == null) {
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
    } else if (dateTime.year == now.year) {
      return DateFormat.MMMd().format(widget.post.date!);
    } else {
      return DateFormat.yMMMd().format(widget.post.date!);
    }
  }

  void deletePost(String postId) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: const Text('Delete Post'),
                content:
                    const Text('Are you sure you want to delete this post?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      _postController.deletePost(postId);
                      Navigator.pop(context);
                      if (widget.reloadHomePage != null) {
                        widget.reloadHomePage!();
                      }
                    },
                    child: const Text('Delete'),
                  ),
                ]));
  }

  void errorPopup(){
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Denied'),
        content: const Text('You do not have permission to delete this post.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0),
      child: Container(
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Colors.grey[100],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _AvatarImage("https://picsum.photos/id/1072/80/80"),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder<AppUser>(
                    future: widget.post.getAuthor(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return const Text("Error fetching author details");
                      } else if (snapshot.hasData) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: RichText(
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: snapshot.data!.name ?? "Unknown",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: Colors.black),
                                    ),
                                    TextSpan(
                                      text: " ${snapshot.data!.userType}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Tooltip(
                              message: DateFormat.yMMMMEEEEd()
                                  .addPattern("'at'")
                                  .add_jm()
                                  .format(widget.post.date!),
                              child: Text(
                                  getDateAsString(widget.post.date!) ?? '',
                                  style: Theme.of(context).textTheme.bodyLarge),
                            ),
                            PopupMenuButton<String>(
                              child: const Icon(
                                Icons.more_horiz,
                              ),
                              onSelected: (value) async {
                                if (value == 'delete') {
                                  AppUser? author =
                                      await widget.post.getAuthor();
                                  if (author.id == user?.id ||
                                      user?.userType == "Officer") {
                                    deletePost(widget.post.id);
                                  } else {
                                    errorPopup();
                                  }
                                }
                              },
                              itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry<String>>[
                                const PopupMenuItem<String>(
                                  value: 'delete',
                                  child: Text('Delete'),
                                ),
                              ],
                            ),
                          ],
                        );
                      } else {
                        return const Text("Author not found");
                      }
                    },
                  ),
                  Text(
                    widget.post.title, // Display the post's title
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8), // Space between title and body
                  Text(widget.post.body),
                  if (widget.post.imageUrl != null)
                    Container(
                      height: 200,
                      margin: const EdgeInsets.only(top: 8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(widget.post.imageUrl!),
                        ),
                      ),
                    ),
                  _ActionsRow(item: widget.post),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    // return Container(
    //   decoration: BoxDecoration(
    //     border: Border.all(color: Colors.grey),
    //     borderRadius: BorderRadius.circular(8.0),
    //   ),
    //   padding: const EdgeInsets.all(8.0),
    //   margin: const EdgeInsets.symmetric(vertical: 8.0),
    //   child: ListTile(
    //     title: Text(post.title),
    //     subtitle: Text(bodyPreview),
    //     trailing: const Icon(Icons.keyboard_arrow_right),
    //   ),
    // );
  }
}

class _AvatarImage extends StatelessWidget {
  final String url;

  const _AvatarImage(this.url);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(image: NetworkImage(url))),
    );
  }
}

class _ActionsRow extends StatelessWidget {
  final Post item;

  const _ActionsRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
          iconTheme: const IconThemeData(color: Colors.grey, size: 18),
          textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.grey),
          ))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => CommentWidget(postID: item.id),
              );
            },
            icon: const Icon(Icons.mode_comment_outlined),
            label: Text(
                item.commentsCount == 0 ? '' : item.commentsCount.toString()),
          ),
          LikeButtonWidget(postId: item.id),
          IconButton(
            onPressed: () {},
            icon: const Tooltip(
              message: 'Share', // Tooltip message to display
              child: Icon(CupertinoIcons.share_up),
            ),
          ),
        ],
      ),
    );
  }
}
