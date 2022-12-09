import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:grp_6_bicycle/DB/RouteDB.dart';
import 'package:grp_6_bicycle/DTO/RouteDTO.dart';
import 'package:grp_6_bicycle/all_routes.dart';
import 'firebase_options.dart';

import 'package:firebase_auth/firebase_auth.dart';

//LINK TO API MAP => `https://wmts.geo.admin.ch/1.0.0/ch.swisstopo.pixelkarte-farbe/default/current/3857/{z}/{x}/{y}.jpeg`
// carte the base Flutter => https://tile.openstreetmap.org/{z}/{x}/{y}.png
// https://ch.swisstopo.swisstlm3d-strassen/{z}/{x}/{y}.png
// TERRAIN : https://wmts0.geo.admin.ch/1.0.0/ch.swisstopo.terrain.3d/default/2010,2010-01/3857/100/{x}/{y}.png
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  readDB();
  runApp(const MyApp());
}

void readDB() async {
  //sign up
  /*
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: "alex.moos@mail.com", password: "123456!");
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
    }
  } catch (e) {
    print(e);
  }*/

  //listen to changes
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user == null) {
      debugPrint('User is currently signed out!');
    } else {
      debugPrint('User is signed in!');
    }
  });
}

class MyApp extends StatelessWidget {
  final appTitle = 'CycleWay';
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appTitle,
      home: const AllRoutes(),
    ); // MaterialApp
  }
}
