import 'package:flutter/material.dart';
import 'package:grp_6_bicycle/Map/route_list.dart';

import '../DB/RouteDB.dart';
import '../DB/UserDB.dart';
import '../DTO/RouteDTO.dart';
import '../DTO/UserDTO.dart';

class CreatedRoutes extends StatefulWidget {
  const CreatedRoutes({super.key});

  @override
  State<CreatedRoutes> createState() => _CreatedRoutesState();
}

class _CreatedRoutesState extends State<CreatedRoutes> {
  //before the build to avoid reset at every render
  List<RouteDTO> routes = [];
  UserDTO? user;

  @override
  Widget build(BuildContext context) {
    getCreatedRoutes();
    return RoutesList(routes: routes, listTitle: "Created routes");
  }

  getCreatedRoutes() async {
    // condition to only access the db once
    if (user != null) return;
    debugPrint("DATABASE ACCESS");

    // access user
    UserDB udb = UserDB();
    UserDTO? userTemp = await udb.getConnectedUser();
    if (userTemp == null) return;

    // access user's routes
    RouteDB routeDB = RouteDB();
    List<RouteDTO> routesList = await routeDB.getCreatedRoutesByUser(userTemp);
    setState(() {
      user = userTemp;
      routes = routesList;
    });
  }
}
