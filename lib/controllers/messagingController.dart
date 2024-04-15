import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pueblo_del_rio/models/comment.dart';
import 'package:pueblo_del_rio/models/post.dart';
import 'package:pueblo_del_rio/models/user.dart';

import '../views/Chats.dart';

class MessagingController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, List<Post>> searchCache = {};

  Future<List<AppUser>> getAllUsers() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('users').get();
      List<AppUser> users = snapshot.docs.map((doc) => AppUser.fromFirestore(doc))
          .toList();
      print(users);

      return users;
    } catch (e) {
      print('Error fetching posts: $e');
      return [];
    }
  }

  String getChatRoomID(String userID1, String userID2) {
    List<String> ids = [userID1, userID2];
    ids.sort();
    return ids.join('_');
  }


  Future<void> createChatRoomsForCurrentUser(String currentUserID) async {
    try {
      List<AppUser> users = await getAllUsers();
      for (AppUser user in users) {
        if (user.id != currentUserID) {
          String chatRoomID = getChatRoomID(currentUserID, user.id!);
          ChatRoom chatRoom = ChatRoom(roomId: chatRoomID, participants: [user]);
          print(chatRoom);
        }
      }
    } catch (e) {
      print('Error creating chat rooms: $e');
    }
  }

}