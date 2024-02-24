import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pueblo_del_rio/models/post.dart';

class PostController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Post>> getAllPostsSortedByDate() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('posts')
          .orderBy('date', descending: true)
          .get();

      List<Post> posts = snapshot.docs.map((doc) {
        Timestamp timestamp = doc['date'];
        DateTime dateTime = timestamp.toDate(); // convert to DateTime
        return Post(
          id: doc.id,
          author: doc['author'],
          title: doc['title'],
          body: doc['body'],
          date: dateTime,
          commentsCount: doc['commentsCount'] ?? 0,
          likesCount: doc['likesCount'] ?? 0,
          imageUrl: doc['imageUrl'] ?? '',
        );
      }).toList();

      return posts;
    } catch (e) {
      print('Error fetching posts: $e');
      return []; // Return an empty list if an error occurs
    }
  }

  Future<List<Post>> searchPosts(String query) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('posts')
          .where('title', isGreaterThanOrEqualTo: query, isLessThan: query + 'z')
          .get();

      List<Post> posts = querySnapshot.docs.map((doc) {
        return Post.fromFirestore(doc);
      }).toList();

      return posts;
    } catch (e) {
      print('Error searching posts: $e');
      // Return an empty list if there's an error
      return [];
    }
  }

  Future<void> createNewPost(String title, String body, String author) async {
    try {
      await _firestore.collection('posts').add({
        'title': title,
        'body': body,
        'author': author,
        'commentsCount': 0,
        'likesCount': 0,
        'imageUrl': "https://picsum.photos/id/1004/960/540", // default
        'date': Timestamp.now(),
      });
    } catch (e) {
      print('Error creating post: $e');
      throw e;
    }
  }
}
