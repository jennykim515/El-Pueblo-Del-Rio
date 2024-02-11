import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String author;
  final String title;
  final String body;
  final DateTime? date;

  Post({
    required this.id,
    required this.author,
    required this.title,
    required this.body,
    this.date,
  });

  factory Post.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Post(
      id: doc.id,
      title: data['title'] ?? '',
      body: data['body'] ?? '',
      author: '',
      date: null,
    );
  }
}
