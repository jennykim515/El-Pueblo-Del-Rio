import 'package:flutter/material.dart';
import 'package:pueblo_del_rio/nav/navigationBar.dart';
import 'package:pueblo_del_rio/views/Chats.dart';
import 'package:pueblo_del_rio/views/ResourcesPage.dart';
import 'package:pueblo_del_rio/views/homePage.dart';
import 'package:pueblo_del_rio/views/userProfile.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; 

  final List<Widget> _pages = [
    const HomePage(),
    const ChatPage(),
    ResourcesPage(),
    const UserProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: ReusableBottomNavigationBar(
        selectedIndex: _selectedIndex, // Pass the current index
        onItemTapped: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
