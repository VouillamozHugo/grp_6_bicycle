import 'package:flutter/material.dart';
import 'package:grp_6_bicycle/Map/all_routes.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:grp_6_bicycle/generic_widgets/FormInput.dart';
import 'package:grp_6_bicycle/login/register_page.dart';
import 'package:grp_6_bicycle/navigation/route_names.dart';

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
            FormInput(
                textController: emailTextController,
                labelText: "Email",
                obscureText: false,
                errorText: null),
            FormInput(
                textController: passwordTextController,
                labelText: "Password",
                obscureText: true,
                errorText: null),
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
                    Navigator.pushNamed(context, RouteNames.register);
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
    Navigator.pushNamed(context, RouteNames.allRoutes);
  }

  bool validateInputs() {
    if (emailTextController.text.isEmpty &&
        passwordTextController.text.isEmpty) {
      setState(() {
        loginMessage = "Fill in email and password fields.";
      });
      return false;
    }

    if (emailTextController.text.isEmpty) {
      setState(() {
        loginMessage = "Fill in mail address.";
      });
      return false;
    }
    if (passwordTextController.text.isEmpty) {
      setState(() {
        loginMessage = "Fill in password.";
      });
      return false;
    }
    //reset error message if everything is ok
    setState(() {
      loginMessage = "";
    });
    return true;
  }
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
