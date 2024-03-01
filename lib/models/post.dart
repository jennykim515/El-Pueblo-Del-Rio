import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Post {
  final String id;
  final String author;
  final String title;
  final String body;
  final int commentsCount;
  final int likesCount;
  final DateTime? date;
  final String? imageUrl;

  Post({
    required this.id,
    required this.author,
    required this.title,
    required this.body,
    required this.commentsCount,
    required this.likesCount,
    this.date,
    this.imageUrl
  });

  String getDateAsString() {
    if (date == null) {
      return "";
    }
    DateTime now = DateTime.now();
    Duration difference = now.difference(date!);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return DateFormat.MMMd().format(date!);
    }
  }

  factory Post.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Post(
      id: doc.id,
      title: data['title'] ?? '',
      body: data['body'] ?? '',
      author: data['author'] ?? '',
      commentsCount: data['commentsCount'] ?? 0,
      likesCount: data['likesCount'] ?? 0,
      date: data['date']?.toDate(),
      imageUrl: data['imageUrl'] ?? '',
    );
  }
}
