import 'package:flutter/material.dart';

class ReusableBottomNavigationBar extends StatefulWidget {

  ReusableBottomNavigationBar({super.key, required int selectedIndex});

  @override
  State<ReusableBottomNavigationBar> createState() => NavBarState();

}

class NavBarState extends State<ReusableBottomNavigationBar> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
          print(_selectedIndex);

        });

        // Define the routes for each item
        List<String> routes = [
          '/home',
          '/messaging',
          '/resources',
        ];

        // Navigate to the corresponding route
        Navigator.pushReplacementNamed(context, routes[index]);
        // Update the selectedIndex using setState
      },
      selectedItemColor: Colors.blueAccent,


        items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.message),
          label: 'Messaging',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.push_pin),
          label: 'Resources',
        ),
      ],
    );
  }
}




