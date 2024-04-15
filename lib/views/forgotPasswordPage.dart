import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pueblo_del_rio/views/login.dart';

import '../nav/mainButton.dart';
import '../nav/MyTextField.dart'; // Your custom text field widget

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ForgotPasswordPageState createState() => ForgotPasswordPageState();
}

class ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();

  Future<void> sendPasswordResetEmail() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      showDialog(
        context: context, 
        builder: (context) => AlertDialog(
          title: const Text('Email Invalid'),
          content: const Text('The email provided is empty. Please enter a valid email.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (!mounted) return; 
      
      // Show success dialog
      showDialog(
        context: context, 
        builder: (context) => AlertDialog(
          title: const Text('Email Sent'),
          content: const Text('A password reset link has been sent to your email.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;

      showDialog(
        context: context, 
        builder: (context) => AlertDialog(
          title: const Text('Email Invalid'),
          content: const Text('The email provided is invalid. Please enter a valid email.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/assets/Background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  Image.asset(
                    "lib/assets/logo.png",
                    width: 150,
                    height: 150,
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Reset Password',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 25),
                  MyTextField(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false,
                  ),
                  const SizedBox(height: 20),
                  MyButton(
                    onTap: sendPasswordResetEmail,
                    buttonText: 'Send Reset Link', // Assuming MyButton supports buttonText
                  ),
                  const SizedBox(height: 20),
                  MyButton(
                    onTap: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginPage()))
, // Assuming you pushed ForgotPasswordPage onto the stack
                    buttonText: 'Return to Login', // Update as per your MyButton widget's parameters
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
