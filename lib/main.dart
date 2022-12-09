import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:grp_6_bicycle/DB/RouteDB.dart';
import 'package:grp_6_bicycle/DTO/RouteDTO.dart';
import 'package:grp_6_bicycle/all_routes.dart';
import 'package:grp_6_bicycle/login_page.dart';
import 'firebase_options.dart';

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
  RouteDB routeDB = RouteDB();
  RouteDTO? route = await routeDB.getRouteByName("Cycleway favorite");
  debugPrint("Height up diff: " + route!.heightDiffUpMeters.toString());
}

class MyApp extends StatelessWidget {
  final appTitle = 'CycleWay';
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appTitle,
      home: const LoginPage(),
    ); // MaterialApp
  }
}
