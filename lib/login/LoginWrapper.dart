import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grp_6_bicycle/navigation/route_names.dart';

class LoginWrapper extends StatefulWidget {
  const LoginWrapper({Key? key}) : super(key: key);

  @override
  _LoginWrapperState createState() => _LoginWrapperState();
}

class _LoginWrapperState extends State<LoginWrapper> {
  User? user;
  late StreamSubscription<User?> _sub;
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    //redirect user if the authentication changes
    _sub = FirebaseAuth.instance.userChanges().listen((event) {
      updateUserState(event);
      _navigatorKey.currentState!.pushReplacementNamed(
        event != null ? RouteNames.allRoutes : RouteNames.login,
      );
    });
  }

  updateUserState(event) {
    setState(() {
      user = event;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) debugPrint("User is null!");
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CycleWay',
      navigatorKey: _navigatorKey,
      initialRoute: user == null ? RouteNames.login : RouteNames.allRoutes,
      routes: RouteNames.routes,
    );
  }
}
