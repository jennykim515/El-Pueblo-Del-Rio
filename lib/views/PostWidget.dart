import 'package:flutter/material.dart';
import 'package:pueblo_del_rio/models/post.dart';

class PostWidget extends StatelessWidget {
  final Post post;

  const PostWidget({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String bodyPreview = post.body.length > 150 ? '${post.body.substring(0, 150)}...' : post.body;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(post.title),
        subtitle: Text(bodyPreview),
        trailing: const Icon(Icons.keyboard_arrow_right),
      ),
    );
  }
}
