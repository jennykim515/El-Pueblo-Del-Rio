import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pueblo_del_rio/models/post.dart';
import 'package:pueblo_del_rio/models/user.dart';
import 'package:pueblo_del_rio/views/userProfile.dart';

class PostDetails extends StatelessWidget {
  final Post post;

  const PostDetails({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Details'),
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
                  return const Text("Loading author...",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
                } else if (snapshot.hasError) {
                  return const Text("Error loading author",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
                } else if (snapshot.hasData) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UserProfileScreen(viewOnly: true),
                        ),
                      );
                    },
                    child: Text(
                      'Author: ${snapshot.data!.name}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                  );
                } else {
                  return const Text("Author not found",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
                }
              },
            ),
            const SizedBox(height: 8),
            Text(
              'Title: ${post.title}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Body: ${post.body}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Date: ${post.date != null ? DateFormat('yyyy-MM-dd – kk:mm').format(post.date!) : 'N/A'}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
