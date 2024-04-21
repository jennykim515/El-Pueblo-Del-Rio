import 'package:flutter/material.dart';
import 'package:pueblo_del_rio/controllers/firebaseAuthService.dart';
import '../controllers/messagingController.dart';
import '../models/user.dart';
import 'MessagingPage.dart'; // Import the MessagingPage

class ChatRoom {
  final String roomId;
  final List<AppUser> participants;

  ChatRoom({required this.roomId, required this.participants});
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<ChatRoom> chatRooms = [];
  final MessagingController controller = MessagingController();

  @override
  void initState() {
    super.initState();
    initializeChatRooms();
  }

  void initializeChatRooms() async {
    String? currentUserId = await FirebaseAuthService().getCurrentUserId();
    List<AppUser> users = await controller.getAllUsers();
    for (var user in users) {
      if (user.id != currentUserId) {
        createChatRoomWithUser(user);
      }
    }
  }

  void createChatRoomWithUser(AppUser user) {
    setState(() {
      chatRooms.add(ChatRoom(roomId: user.id!, participants: [user])); // Asserting that user.id is not null
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Rooms'),
      ),
      body: ListView.builder(
        itemCount: chatRooms.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('${chatRooms[index].participants[0].name}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MessagingPage(chatRoom: chatRooms[index])), // Ensure MessagingPage constructor accepts a ChatRoom parameter
              );
            },
          );
        },
      ),
    );
  }
}
