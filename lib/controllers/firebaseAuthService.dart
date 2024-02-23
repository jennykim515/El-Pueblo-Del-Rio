import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bcrypt/bcrypt.dart';
import '../models/user.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // sign up method
  Future<AppUser?> signUpWithEmailAndPassword(String email, String password, String name, String userType) async {
    try {
      // Hash the password
      String passwordHash = await hashPassword(password);

      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: passwordHash);

      // Create a user document in Firestore with hashed password
      await _firestore.collection('users').doc(credential.user!.uid).set({
        'username': email, // You can use email as username or create one separately
        'passwordHash': passwordHash, // Store the hashed password
        'name': name,
        'email': email,
        'userType': userType, // Default user type (0: community member)
        'aboutMe': "Get to know me here",
      });

      return AppUser(
          username: email,
          passwordHash: passwordHash,
          name: name,
          email: email,
          userType: userType
      );
    } catch(e) {
      print(e);
      return null;
    }
  }

  // Hash password using bcrypt
  Future<String> hashPassword(String password) async {
    // Generate a salt and hash the password
    final salt = BCrypt.gensalt();
    final hash = BCrypt.hashpw(password, salt);

    return hash;
  }

  // Sign in method
  Future<AppUser?> signInWithEmailAndPassword(String email, String password) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore.collection('users').where('email', isEqualTo: email).get();

      if (querySnapshot.docs.isNotEmpty) {
        String userID = querySnapshot.docs.first.id;

        DocumentSnapshot<Map<String, dynamic>> userSnapshot = await _firestore.collection('users').doc(userID).get();

        if (userSnapshot.exists) {
          String storedPasswordHash = userSnapshot.data()!['passwordHash'];
          // String enteredPasswordHash = await hashPassword(password);

          bool passwordMatches = BCrypt.checkpw(password, storedPasswordHash);

          if (passwordMatches) {
            await _auth.signInWithEmailAndPassword(
              email: email,
              password: storedPasswordHash,
            );

            return fetchUserDetails();
          } else {
            print('Incorrect password');
            return null;
          }
        } else {
          print('User document does not exist');
          return null;
        }
      } else {
        print('User document with the provided email does not exist');
        return null;
      }
    } catch(e) {
      print(e);
      return null;
    }
  }


  // UPDATE USER DETAILS
  Future<bool> updateUserDetails({String? name, String? email, int? userType, String? aboutMe,}) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        Map<String, dynamic> updatedData = {};
        if (name != null) updatedData['name'] = name;
        if (email != null) updatedData['email'] = email;
        if (userType != null) updatedData['userType'] = userType;
        if (aboutMe != null) updatedData['aboutMe'] = aboutMe;

        if (updatedData.isNotEmpty) {
          await _firestore.collection('users').doc(currentUser.uid).update(updatedData);
        }
        return true; // Return true indicating successful update
      } else {
        print('Current user is null');
        return false; // Return false indicating failure to update
      }
    } catch (e) {
      print('Error updating user details: $e');
      return false; // Return false indicating failure to update
    }
  }

  // FETCH USER DETAILS
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
}
