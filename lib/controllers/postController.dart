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
        );
      }).toList();

      return posts;
    } catch (e) {
      print('Error fetching posts: $e');
      return []; // Return an empty list if an error occurs
    }
  }
}
