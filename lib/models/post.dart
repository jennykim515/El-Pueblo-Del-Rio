import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pueblo_del_rio/models/user.dart';


class Post {
  final String id;
  final DocumentReference authorRef;
  final String title;
  final String body;
  final int commentsCount;
  final List<dynamic> comments;
  final int likesCount;
  final DateTime? date;
  final String? imageUrl;

  Post({
    required this.id,
    required this.authorRef,
    required this.title,
    required this.body,
    required this.commentsCount,
    required this.comments,
    required this.likesCount,
    this.date,
    this.imageUrl,
  });

  factory Post.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    List<dynamic> commentList = [];
    return Post(
      id: doc.id,
      authorRef: data['authorRef'] as DocumentReference,
      title: data['title'] ?? '',
      body: data['body'] ?? '',
      commentsCount: data['commentsCount'] ?? 0,
      comments: data['comments'] ?? commentList,
      likesCount: data['likesCount'] ?? 0,
      date: data['date']?.toDate(),
      imageUrl: data['imageUrl'] ?? 'https://picsum.photos/id/1004/960/540',
    );
  }

  Future<AppUser> getAuthor() async {
    DocumentSnapshot authorDoc = await authorRef.get();
    // Assuming you have adjusted AppUser.fromJson to include an optional 'id' parameter
    return AppUser.fromJson(authorDoc.data() as Map<String, dynamic>, id: authorDoc.id);
  }


}
