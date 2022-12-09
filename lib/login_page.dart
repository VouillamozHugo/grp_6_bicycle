import 'dart:html';

import 'package:flutter/material.dart';
import 'package:grp_6_bicycle/all_routes.dart';

import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String loginMessage = "";
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              'images/logo6.png',
              height: 120,
              width: queryData.size.width * 0.7,
            ),
            Text(loginMessage, style: const TextStyle(color: Colors.red)),
            FractionallySizedBox(
              widthFactor: 0.7,
              child: TextField(
                controller: emailTextController,
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 80, 62, 33),
                    ),
                  ),
                  labelText: 'Login',
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: 0.7,
              child: TextField(
                controller: passwordTextController,
                obscureText: true,
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 80, 62, 33),
                    ),
                  ),
                  labelText: 'Password',
                ),
              ),
            ),
            OutlinedButton(
              onPressed: login,
              child: const Text('login'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return const AllRoutes();
                    },
                  ),
                );
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }

  void login() async {
    try {
      //input validation before login attempt
      if (!validateInputs()) return;
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailTextController.text,
              password: passwordTextController.text);
      //redirect user after signing in
      if (userCredential.user != null) {
        navigateToAllRoutes();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        setState(() {
          loginMessage = "Incorrect email or password.";
        });
      }
    }
  }

  void navigateToAllRoutes() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return const AllRoutes();
        },
      ),
    );
  }

  bool validateInputs() {
    bool areAllFieldsValid = true;
    if (emailTextController.text.isEmpty) {
      setState(() {
        loginMessage = "Fill in mail address.";
      });
      areAllFieldsValid = false;
    }
    if (passwordTextController.text.isEmpty) {
      setState(() {
        loginMessage = "Fill in password.";
      });
      areAllFieldsValid = false;
    }
    return areAllFieldsValid;
  }
}
