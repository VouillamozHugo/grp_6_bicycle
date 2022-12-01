import 'package:flutter/foundation.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:grp_6_bicycle/DB/RouteDB.dart';
import 'package:grp_6_bicycle/DTO/RouteDTO.dart';
import 'package:grp_6_bicycle/adminAddRoute.dart';
import 'package:grp_6_bicycle/all_routes.dart';
import 'package:grp_6_bicycle/details_route.dart';
import 'package:latlong2/latlong.dart';

import 'mapUtils.dart';
import 'networkin.dart';

import 'DB/UserDB.dart';
import 'DTO/UserDTO.dart';
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
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));
}

void readDB() async {
  RouteDB routeDB = RouteDB();
  RouteDTO? route = await routeDB.getRouteByName("Cycleway favorite");
  debugPrint("Height up diff: " + route!.heightDiffUpMeters.toString());
}

/* //ADD ROUTE
  Map<String, double> coordinates = Map();
  coordinates['startLatitude'] = 46.22;
  coordinates['endLatitude'] = 45.99;
  coordinates['startLongitude'] = 7.4;
  coordinates['endLongitude'] = 7.184;
  RouteDTO route = RouteDTO(
      routeName: "Cycleway favorite",
      startPoint: "Bramois",
      endPoint: "Liddes",
      coordinates: coordinates,
      distanceKm: 59,
      durationMinutes: 240,
      heightDiffUpMeters: 800,
      heightDiffDownMeters: 200);
  bool success = await routeDB.addRoute(route);
  debugPrint("Start point " + success.toString());
*/

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My map"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return const AdminMap();
                  },
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: const Center(child: AllRoutes()),
    );
  }
}
