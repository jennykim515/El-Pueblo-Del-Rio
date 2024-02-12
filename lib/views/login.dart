import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pueblo_del_rio/views/register.dart';

import '../controllers/firebaseAuthService.dart';
import '../models/user.dart';
import '../nav/mainButton.dart';
import '../nav/MyTextField.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuthService _auth = FirebaseAuthService();

  // text editing controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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
                  const SizedBox(height: 50),

                  // logo
                  Image.asset(
                    "lib/assets/logo.png",
                    width: 150, // Set width or height as per your design requirements
                    height: 150,
                  ),

                  const SizedBox(height: 50),

                  // welcome back, you've been missed!
                  const Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 25),

                  // username textfield
                  MyTextField(
                    controller: _emailController,
                    hintText: 'Email',
                    obscureText: false,
                  ),

                  const SizedBox(height: 10),

                  // password textfield
                  MyTextField(
                    controller: _passwordController,
                    hintText: 'Password',
                    obscureText: true,
                  ),

                  const SizedBox(height: 10),

                  //forgot password?
                  TextButton(
                    onPressed: () {
                      // Implement forgot password functionality here
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // sign in button
                  MyButton(
                    onTap: _login,
                    buttonText: 'Login', // Assuming MyButton supports buttonText
                  ),

                  const SizedBox(height: 50),

                  // or continue with
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'Or continue with',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 50),

                  // Register link
                  TextButton(
                    onPressed: () {
                      // Navigate to the register page
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => RegisterPage()));
                    },
                    child: const Text(
                      "Don't have an account? Register here",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _login() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    AppUser? user = await _auth.signInWithEmailAndPassword(email, password);

    if (user != null) {
      print("User is successfully created");
      // navigate
      Navigator.pushNamed(context, "home");
    } else {
      print("Some error happened in login");
    }
  }
}
