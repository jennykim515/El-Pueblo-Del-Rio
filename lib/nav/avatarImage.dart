import 'package:flutter/cupertino.dart';

class AvatarImage extends StatelessWidget {
  final String url;
  const AvatarImage(this.url, {super.key});

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