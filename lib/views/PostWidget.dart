import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package
import 'package:pueblo_del_rio/models/post.dart';
import 'package:pueblo_del_rio/nav/comment.dart';
import 'package:pueblo_del_rio/nav/avatarImage.dart';


import '../nav/likeButton.dart';

class PostWidget extends StatelessWidget {
  final Post post;

  const PostWidget({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String bodyPreview = post.body.length > 150 ? '${post.body.substring(0, 150)}...' : post.body;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0),
      child: Container(
        padding: const EdgeInsets.all(15.0),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color:Colors.grey[100] ,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AvatarImage("https://picsum.photos/id/1072/80/80"),

            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: RichText(
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(children: [
                          TextSpan(
                            text: post.author,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black),
                          ),
                          TextSpan(
                            text: " Resident",
                            style:
                                Theme.of(context).textTheme.bodyLarge,
                          ),
                        ]),
                      )),
                      Text(post.getDateAsString(),
                          style: Theme.of(context).textTheme.bodyLarge),
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Icon(Icons.more_horiz),
                      )
                    ],
                  ),
                  if (post.body != null) Text(post.body!),
                  if (post.imageUrl != null)
                    Container(
                      height: 200,
                      margin: const EdgeInsets.only(top: 8.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(post.imageUrl!),
                          )),
                    ),
                  _ActionsRow(item: post)
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

class _ActionsRow extends StatelessWidget {
  final Post item;
  const _ActionsRow({Key? key, required this.item}) : super(key: key);

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
          // TextButton.icon(
          //   onPressed: () {},
          //   icon: const Icon(Icons.mode_comment_outlined),
          //   label: Text(
          //       item.commentsCount == 0 ? '' : item.commentsCount.toString()),
          // ),
          CommentWidget(postId: item.id, commentsCount: item.commentsCount,),
          LikeButtonWidget(postId: item.id), //like button
          IconButton(
            icon: const Icon(CupertinoIcons.share_up),
            onPressed: () {},
          )
        ],
      ),
    );
  }
}