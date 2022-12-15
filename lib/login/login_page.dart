import 'package:flutter/material.dart';
import 'package:grp_6_bicycle/all_routes.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:grp_6_bicycle/login/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String loginMessage = "";
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final brown = const Color.fromARGB(255, 80, 62, 33);
  final orange = const Color.fromARGB(255, 212, 134, 34);

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
                obscureText: false,
                style: TextStyle(
                  color: brown,
                ),
                cursorColor: orange,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: orange,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: brown,
                      ),
                    ),
                    labelText: 'Email',
                    labelStyle:
                        TextStyle(color: brown, fontWeight: FontWeight.w500)),
              ),
            ),
            FractionallySizedBox(
              widthFactor: 0.7,
              child: TextField(
                controller: passwordTextController,
                obscureText: true,
                style: TextStyle(
                  color: brown,
                ),
                cursorColor: orange,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: orange,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: brown,
                      ),
                    ),
                    labelText: 'Password',
                    labelStyle:
                        TextStyle(color: brown, fontWeight: FontWeight.w500)),
              ),
            ),
            SizedBox(
              width: queryData.size.width * 0.3,
              height: queryData.size.width * 0.08,
              child: OutlinedButton(
                  onPressed: login,
                  style:
                      OutlinedButton.styleFrom(side: BorderSide(color: brown)),
                  child: textCreator('Login', orange)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Need an account ? ', style: TextStyle(color: brown)),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return const RegisterPage();
                        },
                      ),
                    );
                  },
                  child: const Text(
                    'Register',
                    style: TextStyle(
                      color: Color.fromARGB(255, 212, 134, 34),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
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
