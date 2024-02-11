import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // sign up method
  Future<AppUser?> signUpWithEmailAndPassword(String email, String password, String name) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      // Create a user document in Firestore
      await _firestore.collection('users').doc(credential.user!.uid).set({
        'username': email, // You can use email as username or create one separately
        'passwordHash': password, // WARNING: Storing passwords in plaintext is not recommended for production apps
        'name': name,
        'email': email,
        'userType': 0, // Default user type (0: community member)
        // Add other user information fields as needed
      });

      // Return an AppUser instance
      return AppUser(
        username: email,
        passwordHash: password,
        name: name,
        email: email,
        userType: 0,
      );
    } catch(e) {
      print(e);
      return null;
    }
  }

  Future<AppUser?> fetchUserDetails() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        DocumentSnapshot<Map<String, dynamic>> userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();

        if (userSnapshot.exists) {
          return AppUser.fromJson(userSnapshot.data()!);
        } else {
          // User document does not exist
          print('User document does not exist');
          return null;
        }
      } else {
        // Current user is null
        print('Current user is null');
        return null;
      }
    } catch (e) {
      // Error occurred while fetching user details
      print('Error fetching user details: $e');
      return null;
    }
  }

  // sign in method
  Future<AppUser?> signInWithEmailAndPassword(String email, String password) async {
    try {
      // Sign in with email and password using FirebaseAuth
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return fetchUserDetails();
    } catch(e) {
      print(e);
    }
    return null;
  }
}
