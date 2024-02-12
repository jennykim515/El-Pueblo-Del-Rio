import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignOutButton extends StatefulWidget {
  const SignOutButton({super.key});

  @override
  _SignOutButtonState createState() => _SignOutButtonState();
}

class _SignOutButtonState extends State<SignOutButton> {
  bool _isSigningOut = false;

  Future<void> _signOut() async {
    setState(() {
      _isSigningOut = true;
    });

    // Sign out from Firebase
    await FirebaseAuth.instance.signOut();

    // Clear local cache/data here (e.g., SharedPreferences)
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // This clears all data in SharedPreferences

    // Navigate to login screen
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);

    setState(() {
      _isSigningOut = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _isSigningOut ? null : _signOut,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: Colors.red, // Text color
      ),
      child: _isSigningOut
          ? const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
          : const Text('Sign Out'),
    );
  }
}
