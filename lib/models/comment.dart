import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pueblo_del_rio/models/user.dart';
import '../controllers/firebaseAuthService.dart';
import '../controllers/postController.dart';

class Comment{
  final String id; //post id
  final String commentStr;
  final String authorRef;

  Comment({
    required this.id,
    required this.commentStr,
    required this.authorRef,
  });

  Future<AppUser?> getAuthor() async {
    try {
      FirebaseAuthService firebaseAuthService = FirebaseAuthService();
      return firebaseAuthService.fetchUserDetailsByID(authorRef);
    } catch (e) {
      print('Error fetching author details: $e');
      return null;
    }
  }

  Future<String> getAuthorName() async {
    try {
      final authorName = await PostController().getNameFromRef(authorRef);
      print("author name : $authorName");
      return authorName;
        } catch (e) {
      // Handle any errors if necessary
      print('Error getting author name: $e');
      rethrow; // Rethrow the error to propagate it further if needed
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'commentStr': commentStr,
      'authorRef': authorRef,
    };
  }

  factory Comment.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    List<dynamic> commentList = [];
    return Comment(
      id: doc.id,
      commentStr: data['commentStr'] ?? '',
      authorRef: data['authorRef'] ?? '',

    );
  }


}
