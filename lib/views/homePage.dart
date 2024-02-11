import 'package:flutter/material.dart';
import 'package:pueblo_del_rio/controllers/firebaseAuthService.dart';
import 'package:pueblo_del_rio/controllers/postController.dart'; // Import the PostController
import 'package:pueblo_del_rio/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pueblo_del_rio/models/post.dart'; // Import the Post model

import 'navigationBar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _firebaseAuthService = FirebaseAuthService();
  final _postController = PostController(); // Create an instance of PostController
  AppUser? user;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    user = await _firebaseAuthService.fetchUserDetails();
    setState(() {}); // Update the UI with the fetched user details
  }

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: Icon(Icons.logout),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            user != null
                ? Text(
              'Hi, ${user!.name}',
              style: TextStyle(fontSize: 16),
            )
                : SizedBox(), // If user is null, show an empty SizedBox
            SizedBox(height: 20), // Add vertical spacing
            _buildSearchBar(), // Add search bar widget
            SizedBox(height: 20), // Add vertical spacing
            Text(
              'Recent News', // Text before the navigation bar
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10), // Add vertical spacing
            FutureBuilder<List<Post>>(
              future: _postController.getAllPostsSortedByDate(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  // Only build ListView.builder when data is available and not empty
                  List<Post> posts = snapshot.data!;
                  return ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      Post post = posts[index];
                      return ListTile(
                        title: Text(post.title),
                        subtitle: Text(post.body),
                      );
                    },
                  );
                } else {
                  // Handle case when snapshot has no data or empty data
                  return Text('No posts available.');
                }
              },
            ),

          ],
        ),
      ),

      bottomNavigationBar: ReusableBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildSearchBar() {
    return const TextField(
      decoration: InputDecoration(
        hintText: 'Search...',
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(),
      ),
    );
  }
}
