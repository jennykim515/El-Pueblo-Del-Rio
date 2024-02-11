import 'package:flutter/material.dart';

class ResourcesPage extends StatelessWidget {
  const ResourcesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resources Page'),
      ),
      body: const Center(
        child: Text(
          'Replace later with messaging page.',
          style: TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }
}
