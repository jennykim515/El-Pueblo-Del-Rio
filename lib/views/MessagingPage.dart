import 'package:flutter/material.dart';

import '../nav/navigationBar.dart';

class MessagingPage extends StatefulWidget {
  const MessagingPage({Key? key}) : super(key: key);

  @override
  MessagePageState createState() => MessagePageState();

}

class MessagePageState extends State<MessagingPage>{

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


