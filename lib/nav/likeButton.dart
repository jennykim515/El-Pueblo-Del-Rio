import 'package:flutter/material.dart';
import 'package:pueblo_del_rio/controllers/postController.dart';

// Import your controller

class LikeButtonWidget extends StatefulWidget {
  final String postId;

  const LikeButtonWidget({super.key, required this.postId});

  @override
  _LikeButtonWidgetState createState() => _LikeButtonWidgetState();
}

class _LikeButtonWidgetState extends State<LikeButtonWidget> {
  final PostController _postController = PostController(); // Instantiate your controller

  int _likeCount = 0;
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    // Retrieve the initial like count
    _postController.getLikesCountForPost(widget.postId).then((likesCount) {
      setState(() {
        _likeCount = likesCount;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          icon: Icon(
            _isLiked ? Icons.favorite : Icons.favorite_border,
            color: _isLiked ? Colors.red : null,
          ),
          onPressed: () {
            setState(() {
              _isLiked = !_isLiked;
              if (_isLiked) {
                _likeCount++;
              } else {
                _likeCount--;
              }
            });

            // Update like count in the database
            _postController.updateLikesCountForPost(widget.postId, _likeCount);
          },
        ),
        Text('$_likeCount'),
      ],
    );
  }
}
