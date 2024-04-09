import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pueblo_del_rio/models/comment.dart';
import 'package:pueblo_del_rio/models/post.dart';

class PostController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, List<Post>> searchCache = {};

  Future<List<Post>> getAllPostsSortedByDate() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore.collection('posts').orderBy('date', descending: true).get();
      List<Post> posts = snapshot.docs.map((doc) => Post.fromFirestore(doc)).toList();
      print(posts);

      return posts;
    } catch (e) {
      print('Error fetching posts: $e');
      return [];
    }
  }

  Future<String> getNameFromRef (String UserID) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> postSnapshot = await _firestore.collection('users').doc(UserID).get();

      if (postSnapshot.exists) {
        return postSnapshot.data()?['name'];

      } else {
        throw Exception('Post with ID $UserID does not exist.');
      }
    } catch (e) {
      print('Error getting name for ref: $e');
      throw e;
    }
  }


  Future<List<Comment>> getAllComments(String postID) async {
    try {
      print(postID);
      DocumentSnapshot<Map<String, dynamic>> postSnapshot = await _firestore.collection('posts').doc(postID).get();
      // Check if the post exists
      if (postSnapshot.exists) {
        // Access the comments array from the post document
        List<dynamic> commentsData = postSnapshot.data()?['comments'] ?? [];
        print(commentsData.toString());
        // Convert the comments data into Comment objects
        List<Comment> comments = commentsData.map((comment) {
          return Comment(
            authorRef: comment['authorRef'],
            commentStr: comment['commentStr'],
            id: comment['id'],
          );
        }).toList();

        print("comments in post Controller: $comments");

        return comments;
      } else {
        // Post does not exist, return an empty list
        print("Post with ID $postID does not exist");
        return [];
      }
    } catch (e) {
      print('Error fetching comments: $e');
      return [];
    }
  }

  Future<List<Post>> searchPosts(String query) async {
    final queryLowercase = query.toLowerCase();

    // Check if the cache contains the query results
    if (searchCache.containsKey(queryLowercase)) {
      return searchCache[queryLowercase]!;
    }

    try {
      QuerySnapshot querySnapshot = await _firestore.collection('posts').get();

      List<Post> posts = querySnapshot.docs.map((doc) => Post.fromFirestore(doc))
        .where((post) => post.title.toLowerCase().contains(queryLowercase))
        .toList();

      // Cache the search results
      searchCache[queryLowercase] = posts;

      return posts;
    } catch (e) {
      print('Error searching posts: $e');
      return [];
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      print('Error deleting post: $e');
      throw e;
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
        'comments': <Comment>[],
        'likesCount': 0,
        'imageUrl': "https://picsum.photos/id/1004/960/540", // Example image URL, adjust as needed
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
  Future<void> createNewComment(Comment newComment, String postID) async {
    try {
      // Directly use the UID to create a reference to the user's document in the 'users' collection
      DocumentReference userRef = _firestore.collection('users').doc(newComment.authorRef); // Assuming currUser is an AppUser object

      await _firestore.collection('posts').doc(postID).update({
        'comments': FieldValue.arrayUnion([newComment.toJson()]), // Add the new comment to the 'comments' array
        'commentsCount': FieldValue.increment(1), // Increment the comments count
      });
    } catch (e) {
      print('Error creating comment: $e');
      throw e;
    }
  }



  Future<int> getLikesCountForPost(String postId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> postSnapshot =
      await _firestore.collection('posts').doc(postId).get();

      if (postSnapshot.exists) {
        print("getLikesCountForPost");
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

