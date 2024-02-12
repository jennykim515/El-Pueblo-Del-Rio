import 'package:flutter/material.dart';

import '../nav/navigationBar.dart';

class ResourcesPage extends StatelessWidget {
  const ResourcesPage({Key? key}) : super(key: key);
  final int _selectedIndex = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resources Page'),
      ),
      body: const Center(
        child: Text(
          'Replace later with resources page.',
          style: TextStyle(fontSize: 20.0),
        ),

      ),
      bottomNavigationBar: ReusableBottomNavigationBar(
        selectedIndex: _selectedIndex,
      ),
    );
  }
}

class _selectedIndex {
}
