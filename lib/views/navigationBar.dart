import 'package:flutter/material.dart';

class ReusableBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;

  const ReusableBottomNavigationBar({
    Key? key,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: (index) {
        // Define the routes for each item
        List<String> routes = [
          '/home',
          '/messaging',
          '/resources',
        ];

        // Navigate to the corresponding route
        Navigator.pushReplacementNamed(context, routes[index]);
      },
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
