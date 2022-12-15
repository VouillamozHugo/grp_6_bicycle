import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grp_6_bicycle/all_routes.dart';
import 'package:grp_6_bicycle/login_page.dart';

class LoginWrapper extends StatefulWidget {
  const LoginWrapper({Key? key}) : super(key: key);

  @override
  _LoginWrapperState createState() => _LoginWrapperState();
}

class _LoginWrapperState extends State<LoginWrapper> {
  User? user;
  @override
  void initState() {
    super.initState();
    //Listen to Auth State changes
    FirebaseAuth.instance
        .authStateChanges()
        .listen((event) => updateUserState(event));
  }

  //Updates state when user state changes in the app
  updateUserState(event) {
    setState(() {
      user = event;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const LoginPage();
    } else {
      return const AllRoutes();
    }
  }
}
