import 'package:flutter/material.dart';

class MessagingPage extends StatelessWidget {
  const MessagingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messaging Page'),
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
