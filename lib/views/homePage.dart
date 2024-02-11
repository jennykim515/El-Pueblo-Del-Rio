import 'package:flutter/material.dart';
import 'package:pueblo_del_rio/controllers/firebaseAuthService.dart';
import 'package:pueblo_del_rio/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'navigationBar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _firebaseAuthService = FirebaseAuthService();
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
            // Add any other widgets or functionalities you want to include on the home page
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
