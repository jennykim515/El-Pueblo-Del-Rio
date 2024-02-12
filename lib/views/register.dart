import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../controllers/firebaseAuthService.dart';
import '../models/user.dart';
import '../nav/mainButton.dart';
import '../nav/MyTextField.dart';
import 'login.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseAuthService _auth = FirebaseAuthService();

  // text editing controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:Container(
          decoration:const BoxDecoration(
              image:DecorationImage(
                image: AssetImage("lib/assets/Background.png"),
                fit:BoxFit.cover,
              )
          ),
          child: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 25),

                  // logo
                  Image.asset(
                    "lib/assets/logo.png",
                    width: 150,  // Set width or height as per your design requirements
                    height: 150,
                  ),

                  const SizedBox(height: 20),

                  // welcome back, you've been missed!
                  const Text(
                    'Register',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  // username textfield
                  MyTextField(
                    controller: _emailController,
                    hintText: 'Email',
                    obscureText: false,
                  ),

                  const SizedBox(height: 10),

                  MyTextField(
                    controller: _nameController,
                    hintText: 'Name',
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
                  const Text(
                    'Forgot Password?',
                    style: TextStyle(color: Colors.white),
                  ),

                  const SizedBox(height: 20),

                  // sign in button
                  MyButton(
                    onTap: _register,
                    buttonText: 'Register', // Assuming MyButton supports buttonText
                  ),

                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      // Navigate to the register page
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    child: const Text(
                      "Already have an account? Login here ",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),

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

                  // // google + apple sign in buttons
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: const [
                  //     // google button
                  //     SquareTile(imagePath: 'lib/images/google.png'),
                  //
                  //     SizedBox(width: 25),
                  //
                  //     // apple button
                  //     SquareTile(imagePath: 'lib/images/apple.png')
                  //   ],
                  // ),
                  //
                  // const SizedBox(height: 50),
                  //
                  // // not a member? register now
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Text(
                  //       'Not a member?',
                  //       style: TextStyle(color: Colors.grey[700]),
                  //     ),
                  //     const SizedBox(width: 4),
                  //     const Text(
                  //       'Register now',
                  //       style: TextStyle(
                  //         color: Colors.blue,
                  //         fontWeight: FontWeight.bold,
                  //       ),
                  //     ),
                  //   ],
                  // )
                ],
              ),
            ),
          ),


        )

    );
  }

  void _register() async {
    String email = _emailController.text;
    String password = _passwordController.text;
    String name = _nameController.text;

    AppUser? user = await _auth.signUpWithEmailAndPassword(email, password, name);

    if(user != null) {
      print("User is successfully created");
      // navigate
      Navigator.pushNamed(context, "home");
    } else {
      print("Some error happened in register");
    }
  }
}