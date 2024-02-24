import 'package:cloud_firestore/cloud_firestore.dart';

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

  factory Post.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Post(
      id: doc.id,
      title: data['title'] ?? '',
      body: data['body'] ?? '',
      author: '',
      commentsCount: data['commentsCount'] ?? 0,
      likesCount: data['likesCount'] ?? 0,
      date: data['date']?.toDate(),
      imageUrl: data['imageUrl'] ?? '',
    );
  }
}
