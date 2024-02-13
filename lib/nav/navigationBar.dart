import 'package:flutter/material.dart';

class ReusableBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  ReusableBottomNavigationBar({Key? key, required this.selectedIndex, required this.onItemTapped}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Badge(
              label: Text('2'), // Show number of unread messages
              child: Icon(Icons.messenger_sharp),
            ), label: 'Messages'),
        BottomNavigationBarItem(icon: Icon(Icons.folder), label: 'Resources'),
      ],
      currentIndex: selectedIndex,
      onTap: onItemTapped,
    );
  }
}