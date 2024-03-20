import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pueblo_del_rio/models/user.dart';
import '../controllers/firebaseAuthService.dart';

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
      FirebaseAuthService _firebaseAuthService = FirebaseAuthService();
      return _firebaseAuthService.fetchUserDetailsByID(authorRef);
    } catch (e) {
      print('Error fetching author details: $e');
      return null;
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
