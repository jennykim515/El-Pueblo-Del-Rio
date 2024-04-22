import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../controllers/firebaseAuthService.dart';
import '../models/message.dart';
import 'package:pueblo_del_rio/models/user.dart';
import 'Chats.dart'; // Import the ChatRoom model

class MessagingPage extends StatefulWidget {
  final ChatRoom chatRoom; // Define a field to store the chat room

  const MessagingPage({super.key, required this.chatRoom}); // Update constructor to accept chatRoom

  @override
  _MessagingPageState createState() => _MessagingPageState();
}

class _MessagingPageState extends State<MessagingPage> {
  final List<Message> _messages = []; // List to hold chat messages
  final TextEditingController _textController = TextEditingController();
  final _firebaseAuthService = FirebaseAuthService();
  AppUser? user;

  Future<void> _fetchUserDetails() async {
    user = await _firebaseAuthService.fetchUserDetails();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
    // Listen for new messages in the specified chat room
    listenForMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatRoom.participants[1].name ?? 'Unknown'),
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
      alignment: message.senderId == user?.id ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: message.senderId == user?.id ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: message.senderId == user?.id ? Colors.white : Colors.black,
            fontSize: 18, // Adjust the font size here
          ),
        ),
      ),
    );
  }

  void _sendMessage(String text) {
    if (text.isNotEmpty) {
      _textController.clear(); // Clear the text input field

      // Store the message in the specific chat room in Firebase Database
      DatabaseReference messagesRef = FirebaseDatabase.instance.ref().child('chatRooms').child(widget.chatRoom.roomId).child('messages');
      messagesRef.push().set({
        'senderId': user?.id,
        'text': text,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
    }
  }


  void listenForMessages() {
    DatabaseReference messagesRef = FirebaseDatabase.instance.ref().child('chatRooms').child(widget.chatRoom.roomId).child('messages');
    messagesRef.onChildAdded.listen((event) {
      Map<String, dynamic> messageData = event.snapshot.value as Map<String, dynamic>;
      setState(() {
        // Add the received message to the list of messages
        _messages.add(Message.fromJson(messageData));
      });
    });
  }

}
