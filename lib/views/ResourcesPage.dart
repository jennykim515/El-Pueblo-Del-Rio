import 'package:flutter/material.dart';

import '../nav/navigationBar.dart';

class ResourcesPage extends StatelessWidget {
  const ResourcesPage({Key? key}) : super(key: key);


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
    );
  }
}