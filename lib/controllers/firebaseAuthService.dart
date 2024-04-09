import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign up method
  Future<AppUser?> signUpWithEmailAndPassword(String email, String password, String name, String userType, BuildContext context) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      // Create a user document in Firestore
      await _firestore.collection('users').doc(credential.user!.uid).set({
        'username': email, // Optionally use email as username or create a separate username
        'name': name,
        'email': email,
        'userType': userType, // Default user type (e.g., 0: community member)
        'aboutMe': "Get to know me here", // Optional initial value
        'imageUrl': "https://picsum.photos/id/1004/960/540"
      });

      if (!context.mounted) {
        return null;
      }

      void successfulRegisterMessage() {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Successfully registered your account'),
          ),
        );
      }

      successfulRegisterMessage();

      // Return the AppUser instance
      return AppUser(
        id: credential.user!.uid, // Use the UID as the id for AppUser
        username: email,
        name: name,
        email: email,
        userType: userType,
        aboutMe: "Get to know me here", // Assuming you meant 'aboutMe' as 'userBio'
        imageUrl: "https://picsum.photos/id/1004/960/540",
      );
    } catch (e) {
      print(e);

      //register pop-ups
      if (e.toString() == "[firebase_auth/email-already-in-use] The email address is already in use by another account.") {
        return showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(e.toString().substring(37)),
              actions: [
                TextButton(
                  child: Text("OK"),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            )
        );
      }
      else {
        return showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(e.toString().substring(30)),
              actions: [
                TextButton(
                  child: Text("OK"),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            )
        );
      }

      return null;
    }
  }

  // Sign in method
  Future<AppUser?> signInWithEmailAndPassword(String email, String password, BuildContext context) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (!context.mounted) {
        return null;
      }
      return fetchUserDetails(); // Directly fetch user details after successful sign-in
    } on FirebaseAuthException catch (e) {
      print('Error signing in: $e');

      void wrongPasswordMessage() {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Wrong Password'),
          ),
        );
      }

      void wrongEmailMessage() {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Wrong Email'),
          ),
        );
      }

      void invalidEmailMessage() {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Invalid Email'),
          ),
        );
      }

      // WRONG EMAIL
      if (e.code == 'user-not-found') {
        // show error to user
        wrongEmailMessage();
      }
      // INVALID EMAIL
      else if (e.code == 'invalid-email') {
        // show error to user
        invalidEmailMessage();
      }
      // WRONG PASSWORD
      else if (e.code == 'wrong-password') {
        // show error to user
        wrongPasswordMessage();
      }
      // WRONG PASSWORD
      else if (e.code == 'invalid-credential') {
        // show error to user
        wrongPasswordMessage();
      }
      return null;
    }
  }

  // Update user details
  Future<bool> updateUserDetails({String? name, String? email, String? userType, String? aboutMe, String? imageUrl}) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        print('Current user is null');
        return false;
      }

      Map<String, dynamic> updatedData = {};
      if (name != null) updatedData['name'] = name;
      if (email != null) updatedData['email'] = email;
      if (userType != null) updatedData['userType'] = userType.toString(); // Ensure userType is stored correctly
      if (aboutMe != null) updatedData['aboutMe'] = aboutMe;
      if (imageUrl!=null) updatedData['imageUrl'] = imageUrl;

      if (updatedData.isNotEmpty) {
        await _firestore.collection('users').doc(currentUser.uid).update(updatedData);
      }
      return true;
    } catch (e) {
      print('Error updating user details: $e');
      return false;
    }
  }



  // Fetch user details
  Future<AppUser?> fetchUserDetails() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        print('Current user is null');
        return null;
      }

      DocumentSnapshot<Map<String, dynamic>> userSnapshot = await _firestore.collection('users').doc(currentUser.uid).get();
      if (!userSnapshot.exists) {
        print('User document does not exist');
        return null;
      }

      return AppUser.fromJson(userSnapshot.data()!, id: userSnapshot.id);
    } catch (e) {
      print('Error fetching user details: $e');
      return null;
    }
  }
  Future<AppUser?> fetchUserDetailsByID(String userID) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
      await _firestore.collection('users').doc(userID).get();

      if (userSnapshot.exists) {
        return AppUser.fromJson(userSnapshot.data()!, id: userSnapshot.id);
      } else {
        print('User document with ID $userID does not exist');
        return null;
      }
    } catch (e) {
      print('Error fetching user details: $e');
      return null;
    }
  }

  Future<String?> getCurrentUserId() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        return currentUser.uid;
      } else {
        print('Current user is null');
        return null;
      }
    } catch (e) {
      print('Error fetching current user ID: $e');
      return null;
    }
  }
}
