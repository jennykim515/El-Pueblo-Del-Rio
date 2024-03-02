import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pueblo_del_rio/models/post.dart';

class PostController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Post>> getAllPostsSortedByDate() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore.collection('posts').orderBy('date', descending: true).get();
      List<Post> posts = snapshot.docs.map((doc) => Post.fromFirestore(doc)).toList();
      return posts;
    } catch (e) {
      print('Error fetching posts: $e');
      return [];
    }
  }

  Future<List<Post>> searchPosts(String query) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('posts')
          .where('title', isGreaterThanOrEqualTo: query, isLessThan: query + 'z')
          .get();
      List<Post> posts = querySnapshot.docs.map((doc) => Post.fromFirestore(doc)).toList();
      return posts;
    } catch (e) {
      print('Error searching posts: $e');
      return [];
    }
  }

  Future<void> createNewPost(String title, String body, String userId, {String? imageUrl}) async {
    try {
      // Directly use the UID to create a reference to the user's document in the 'users' collection
      DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(userId);

      Map<String, dynamic> postData = {
        'title': title,
        'body': body,
        'authorRef': userRef, // Use the user's UID to reference the author document
        'commentsCount': 0,
        'likesCount': 0,
        'date': Timestamp.now(), // Sets the current timestamp as the post creation date
      };

      if (imageUrl != null) {
        postData['imageUrl'] = imageUrl;
      }

      await _firestore.collection('posts').add(postData);
    } catch (e) {
      print('Error creating post: $e');
      throw e;
    }
  }

  Future<int> getLikesCountForPost(String postId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> postSnapshot =
      await _firestore.collection('posts').doc(postId).get();

      if (postSnapshot.exists) {
        return postSnapshot.data()?['likesCount'] ?? 0;
      } else {
        throw Exception('Post with ID $postId does not exist.');
      }
    } catch (e) {
      print('Error getting likes count for post: $e');
      throw e;
    }
  }

  Future<void> updateLikesCountForPost(String postId, int newLikesCount) async {
    try {
      await _firestore.collection('posts').doc(postId).update({
        'likesCount': newLikesCount,
      });
    } catch (e) {
      print('Error updating likes count for post: $e');
      throw e;
    }
  }

  Future<String> uploadImageToStorage(File image) async {
    try {
      // Here you would implement the logic to upload the image to Firebase Storage and get its URL
      // For demonstration purposes, we'll just return a placeholder URL
      return "https://example.com/image.jpg";
    } catch (e) {
      print('Error uploading image: $e');
      throw e;
    }
  }
}

