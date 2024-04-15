import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/message.dart';

class MessagingPage extends StatefulWidget {
  const MessagingPage({super.key});

  @override
  _MessagingPageState createState() => _MessagingPageState();
}

class _MessagingPageState extends State<MessagingPage> {
  final List<Message> _messages = []; // List to hold chat messages
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // listen for new messages
    listenForMessages((messageData) {
      setState(() {
        _messages.add(Message.fromJson(messageData));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messaging Page'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/assets/Background2.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (BuildContext context, int index) {
                  return _buildMessageBubble(_messages[index]);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        hintText: 'Type your message...',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      _sendMessage(_textController.text);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(Message message) {
    return Align(
      alignment: message.senderId == 'user' ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: message.senderId == 'user' ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: message.senderId == 'user' ? Colors.white : Colors.black,
            fontSize: 18, // Adjust the font size here
          ),
        ),
      ),
    );
  }

  // FIXME: not uploading correctly
  void _sendMessage(String text) {
    if (text.isNotEmpty) {
      setState(() {
        _messages.add(Message(senderId: 'user', text: text, timestamp: DateTime.now().millisecondsSinceEpoch)); // Add the user's message to the list of messages
        _textController.clear(); // clear the text input field
      });

      DatabaseReference messagesRef = FirebaseDatabase.instance.ref().child('messages').child('conversationId'); // Replace 'conversationId' with the actual conversation ID
      messagesRef.push().set({
        'senderId': 'user', // Assuming the sender is always the current user
        'text': text,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
    }
  }

  // FIXME: not receiving correctly
  void listenForMessages(void Function(Map<String, dynamic>) onNewMessage) {
    DatabaseReference messagesRef = FirebaseDatabase.instance.ref().child('messages').child('conversationId'); // Replace 'conversationId' with the actual conversation ID
    messagesRef.onChildAdded.listen((event) {
      Map<String, dynamic> messageData = event.snapshot.value as Map<String, dynamic>;
      onNewMessage(messageData);
    });
  }
}
