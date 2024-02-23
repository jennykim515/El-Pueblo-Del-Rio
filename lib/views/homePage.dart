import 'package:flutter/material.dart';
import 'package:pueblo_del_rio/controllers/firebaseAuthService.dart';
import 'package:pueblo_del_rio/controllers/postController.dart';
import 'package:pueblo_del_rio/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pueblo_del_rio/models/post.dart';
import '../nav/navigationBar.dart';
import 'PostDetails.dart';
import 'postWidget.dart'; // Import the PostWidget

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

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
    setState(() {

    });

  }

  void signUserOut() {
    FirebaseAuth.instance.signOut();
    print("signedOut");
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
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/assets/Background2.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              user != null
                  ? Text(
                'Hi, ${user!.name}',
                style: const TextStyle(fontSize: 16),
              )
                  : const SizedBox(),
              const SizedBox(height: 20),
              _buildSearchBar(),
              const SizedBox(height: 20),
              const Text(
                'Recent News',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: FutureBuilder<List<Post>>(
                  future: _searchQuery.isEmpty
                      ? _postController.getAllPostsSortedByDate()
                      : _postController.searchPosts(_searchQuery), // Use searchPosts if search query is not empty
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          Post post = snapshot.data![index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PostDetails(post: post),
                                ),
                              );
                            },
                            child: PostWidget(post: post),
                          );
                        },
                      )
                    ;
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
    return TextField(
      onChanged: (value) {
        setState(() {
          _searchQuery = value; // search query updated when text changes
        });
      },
      decoration: const InputDecoration(
        hintText: 'Search...',
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(),
      ),
    );
  }
}
