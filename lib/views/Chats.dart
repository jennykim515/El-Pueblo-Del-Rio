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
  AppUser? user;

  Future<void> _fetchUserDetails() async {
    user = await FirebaseAuthService().fetchUserDetails();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
    initializeChatRooms();
  }

  void initializeChatRooms() async {
    List<AppUser> users = await controller.getAllUsers();
    for (var u in users) {
      if (u.id != user?.id) {
        createChatRoomWithUser(u);
      }
    }
  }

  //commutative way to combine strings
  String combineStrings(String str1, String str2) {
    String combinedString = str1 + str2;
    List<String> charList = combinedString.split('');
    charList.sort();

    String result = charList.join('');
    return result;
  }

  void createChatRoomWithUser(AppUser otherUser) {
    setState(() {
      chatRooms.add(ChatRoom(roomId: combineStrings(otherUser.id!, user!.id!), participants: [user!,otherUser])); // Asserting that user.id is not null
    });
  }
  //TODO: add timestamps
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
            title: Text('${chatRooms[index].participants[1].name}'),
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
