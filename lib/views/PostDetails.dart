import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pueblo_del_rio/models/post.dart';
import 'package:pueblo_del_rio/models/user.dart';

class PostDetails extends StatelessWidget {
  final Post post;

  const PostDetails({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<AppUser>(
              future: post.getAuthor(), // Pass the authorRef to getAuthor),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("Loading author...", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
                } else if (snapshot.hasError) {
                  return Text("Error loading author", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
                } else if (snapshot.hasData) {
                  return Text(
                    'Author: ${snapshot.data!.name}', // Assuming AppUser has a name field
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  );
                } else {
                  return Text("Author not found", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
                }
              },
            ),
            SizedBox(height: 8),
            Text(
              'Title: ${post.title}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Body: ${post.body}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Date: ${post.date != null ? DateFormat('yyyy-MM-dd – kk:mm').format(post.date!) : 'N/A'}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
