import 'package:flutter/material.dart';
import 'package:pueblo_del_rio/controllers/firebaseAuthService.dart';
import 'package:pueblo_del_rio/controllers/postController.dart';
import 'package:pueblo_del_rio/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pueblo_del_rio/models/post.dart';
import 'CreatePost.dart';
import 'postWidget.dart'; // Import the PostWidget

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _firebaseAuthService = FirebaseAuthService();
  final _postController = PostController();
  AppUser? user;
  String _searchQuery = ''; // current search query

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    user = await _firebaseAuthService.fetchUserDetails();
    setState(() {});
  }

  void signUserOut() {
    FirebaseAuth.instance.signOut();
    print("signedOut");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],

      body: Container(
        // decoration: const BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage("lib/assets/Background2.png"),
        //     fit: BoxFit.cover,
        //   ),
        // ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FloatingActionButton(
                    onPressed: signUserOut,
                    child: const Tooltip(
                      message: 'Sign Out', // Tooltip message to display
                      child: Icon(Icons.logout),
                    ),
                  ),

                  user != null
                      ? Text(
                    'Hi, ${user!.name}',
                    style: Theme.of(context).textTheme.titleLarge,
                  )
                      : const SizedBox(),



                  FloatingActionButton(
                    onPressed: () {
                      // Navigate to new post creation page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CreatePost()),
                      ).then((_) {
                        // Force a rebuild to refresh the posts.
                        setState(() {});
                      });
                    },
                    child: const Icon(Icons.add, color: Colors.white,), // Plus icon

                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildSearchBar(),
              const SizedBox(height: 20),
              Text(
                'Recent News',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              Expanded(
                child: FutureBuilder<List<Post>>(
                  future: _searchQuery.isEmpty
                      ? _postController.getAllPostsSortedByDate()
                      : _postController.searchPosts(_searchQuery),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          Post post = snapshot.data![index];
                          return Column(
                            children: [
                              PostWidget(post: post),
                              const SizedBox(height: 20), // Adjust the height as needed
                            ],
                          );
                        },
                      );
                    } else {
                      return const Center(child: Text('No posts available.'));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0), // Adjust horizontal padding from the screen edges
      child: TextField(
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        style: const TextStyle(fontSize: 14), // Set the font size of the text
        decoration: InputDecoration(
          hintText: 'Search...',
          hintStyle: const TextStyle(fontSize: 14), // Set the font size of the hint text
          prefixIcon: const Icon(Icons.search),
          prefixIconColor: Colors.grey,
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0), // Adjust the border radius
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }


}
